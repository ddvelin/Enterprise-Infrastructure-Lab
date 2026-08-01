#!/usr/bin/env bash
set -Eeuo pipefail

source "${COMMON_LIBRARY:-$HOME/game-server/scripts/lib/common.sh}"

LOG_FILE="$LOG_DIR/restore.log"
LOCK_FILE="$RUN_DIR/restore.lock"
STAGING_DIR="$BACKUP_DIR/restore-staging"

mkdir -p "$STAGING_DIR"

exec 9>"$LOCK_FILE"
flock -n 9 || {
    log_to_file "$LOG_FILE" "Restore refused because another restore is running."
    exit 1
}

mapfile -t backups < <(
    find "$BACKUP_DIR/world" \
        -maxdepth 1 \
        -type f \
        -name 'server-*.tar.gz' \
        -printf '%T@ %p\n' |
    sort -nr |
    cut -d' ' -f2-
)

(( ${#backups[@]} > 0 )) || {
    log_to_file "$LOG_FILE" "ERROR: No backups were found."
    exit 1
}

echo "Available backups:"
for index in "${!backups[@]}"; do
    file="${backups[$index]}"
    printf '%2d) %s | %s\n' \
        "$((index + 1))" \
        "$(basename "$file")" \
        "$(du -h "$file" | awk '{print $1}')"
done

read -r -p "Choose a backup number, or q to cancel: " choice
[[ "$choice" =~ ^[Qq]$ ]] && exit 0
[[ "$choice" =~ ^[0-9]+$ ]] || exit 1

selected_index=$((choice - 1))
(( selected_index >= 0 && selected_index < ${#backups[@]} )) || exit 1
selected_backup="${backups[$selected_index]}"

read -r -p "Type RESTORE to replace the current world: " confirm
[[ "$confirm" == "RESTORE" ]] || exit 0

tar -tzf "$selected_backup" >/dev/null || {
    log_to_file "$LOG_FILE" "ERROR: Archive validation failed."
    exit 1
}

if service_is_active && rcon_is_healthy; then
    "$RCON_SCRIPT" "say A server restore is beginning."
    "$RCON_SCRIPT" "save-all flush" || true
    "$RCON_SCRIPT" "stop" >/dev/null 2>&1 || true
    wait_for_service_stop 300 || systemctl stop "$SERVICE_NAME"
else
    systemctl stop "$SERVICE_NAME" || true
fi

rollback_dir="$BACKUP_DIR/pre-restore-$(date '+%Y-%m-%d_%H-%M-%S')"
mkdir -p "$rollback_dir"

[[ -d "$SERVER_DIR/world" ]] && mv "$SERVER_DIR/world" "$rollback_dir/world"

for item in server.properties whitelist.json ops.json banned-players.json banned-ips.json user_jvm_args.txt eula.txt; do
    [[ -e "$SERVER_DIR/$item" ]] && mv "$SERVER_DIR/$item" "$rollback_dir/$item"
done

rm -rf "$STAGING_DIR"/*
tar -xzf "$selected_backup" -C "$STAGING_DIR"

if [[ ! -d "$STAGING_DIR/world" ]]; then
    log_to_file "$LOG_FILE" "ERROR: Restored archive does not contain world/."
    [[ -d "$rollback_dir/world" ]] && mv "$rollback_dir/world" "$SERVER_DIR/world"
    exit 1
fi

cp -a "$STAGING_DIR"/. "$SERVER_DIR"/
chown -R "$(id -un):$(id -gn)" "$SERVER_DIR"
systemctl start "$SERVICE_NAME"

if wait_for_rcon 300; then
    log_to_file "$LOG_FILE" "Restore completed successfully. Rollback copy: $rollback_dir"
    exit 0
fi

log_to_file "$LOG_FILE" "CRITICAL: Restore completed, but Minecraft did not become ready."
echo "Previous data remains available at: $rollback_dir"
exit 1
