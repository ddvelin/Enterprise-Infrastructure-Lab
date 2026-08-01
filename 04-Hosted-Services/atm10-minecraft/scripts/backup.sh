#!/usr/bin/env bash
set -Eeuo pipefail

CONFIG_FILE="${CONFIG_FILE:-$HOME/atm10-config/server.conf}"
source "$CONFIG_FILE"

mkdir -p "$BACKUP_DIR" "$LOG_DIR"
lock_file="/tmp/atm10-backup.lock"
backup_file="$BACKUP_DIR/atm10-$(date '+%Y-%m-%d_%H-%M-%S').tar.gz"
log_file="$LOG_DIR/atm10-backup.log"

exec 9>"$lock_file"
flock -n 9 || exit 0

log() {
    printf '[%s] %s\n' "$(date '+%F %T')" "$*" | tee -a "$log_file"
}

systemctl is-active --quiet "$SERVICE_NAME" || {
    log "Backup skipped because the service is not active."
    exit 1
}

# Production deployment used RCON/save commands before archiving.
# Credentials remain in the local, untracked configuration.
if command -v mcrcon >/dev/null 2>&1; then
    mcrcon -H "$RCON_HOST" -P "$RCON_PORT" -p "$RCON_PASSWORD" \
        "say Backup starting." "save-all flush" >/dev/null
fi

tar -czf "$backup_file" -C "$SERVER_DIR" world server.properties 2>/dev/null

find "$BACKUP_DIR" -type f -name 'atm10-*.tar.gz' \
    -mmin +$((BACKUP_RETENTION_HOURS * 60)) -delete

log "Backup completed: $(basename "$backup_file") ($(du -h "$backup_file" | awk '{print $1}'))"
