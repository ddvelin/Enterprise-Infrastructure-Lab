#!/usr/bin/env bash
set -Eeuo pipefail

source "${COMMON_LIBRARY:-$HOME/game-server/scripts/lib/common.sh}"

LOG_FILE="$LOG_DIR/backup.log"
LOCK_FILE="$RUN_DIR/backup.lock"
BACKUP_SUBDIR="$BACKUP_DIR/world"
TIMESTAMP="$(date '+%Y-%m-%d_%H-%M-%S')"
BACKUP_FILE="$BACKUP_SUBDIR/server-$TIMESTAMP.tar.gz"
SAVING_DISABLED=false
STARTED_AT="$(date +%s)"

mkdir -p "$BACKUP_SUBDIR"

restore_saving() {
    if [[ "$SAVING_DISABLED" == true ]]; then
        "$RCON_SCRIPT" "save-on" >/dev/null 2>&1 || true
        SAVING_DISABLED=false
        log_to_file "$LOG_FILE" "Minecraft autosaving was re-enabled."
    fi
}

handle_failure() {
    local exit_code=$?
    restore_saving
    rm -f -- "$BACKUP_FILE"
    log_to_file "$LOG_FILE" "ERROR: Backup failed with exit code $exit_code."
    exit "$exit_code"
}

trap handle_failure ERR
trap restore_saving EXIT

exec 9>"$LOCK_FILE"
flock -n 9 || {
    log_to_file "$LOG_FILE" "Backup skipped because another backup is running."
    exit 0
}

service_is_active || {
    log_to_file "$LOG_FILE" "ERROR: Minecraft service is not active."
    exit 1
}

rcon_is_healthy || {
    log_to_file "$LOG_FILE" "ERROR: RCON is not responding."
    exit 1
}

log_to_file "$LOG_FILE" "Starting backup: $BACKUP_FILE"
"$RCON_SCRIPT" "say Server backup starting in 10 seconds."
sleep 10
"$RCON_SCRIPT" "save-all flush"
sleep 3
"$RCON_SCRIPT" "save-off"
SAVING_DISABLED=true

backup_items=()
[[ -d "$SERVER_DIR/world" ]] && backup_items+=("world")

for item in server.properties whitelist.json ops.json banned-players.json banned-ips.json user_jvm_args.txt eula.txt; do
    [[ -e "$SERVER_DIR/$item" ]] && backup_items+=("$item")
done

(( ${#backup_items[@]} > 0 )) || {
    log_to_file "$LOG_FILE" "ERROR: No backup targets were found."
    exit 1
}

tar -czf "$BACKUP_FILE" -C "$SERVER_DIR" "${backup_items[@]}"
restore_saving

find "$BACKUP_SUBDIR" \
    -type f \
    -name 'server-*.tar.gz' \
    -mtime +"$BACKUP_RETENTION_DAYS" \
    -delete

size="$(du -h "$BACKUP_FILE" | awk '{print $1}')"
duration="$(( $(date +%s) - STARTED_AT ))"
"$RCON_SCRIPT" "say Backup complete in ${duration} seconds. Size: ${size}." >/dev/null 2>&1 || true
log_to_file "$LOG_FILE" "Backup completed. Size: $size; duration: ${duration}s."
