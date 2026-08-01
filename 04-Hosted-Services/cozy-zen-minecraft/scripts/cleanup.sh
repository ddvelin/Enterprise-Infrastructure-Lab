#!/usr/bin/env bash
set -Eeuo pipefail

source "${COMMON_LIBRARY:-$HOME/game-server/scripts/lib/common.sh}"

LOG_FILE="$LOG_DIR/cleanup.log"
LOCK_FILE="$RUN_DIR/cleanup.lock"

exec 9>"$LOCK_FILE"
flock -n 9 || {
    log_to_file "$LOG_FILE" "Cleanup skipped because another cleanup is active."
    exit 0
}

log_to_file "$LOG_FILE" "----- Cleanup started -----"

find "$BACKUP_DIR/world" \
    -type f \
    -name 'server-*.tar.gz' \
    -mtime +"$BACKUP_RETENTION_DAYS" \
    -print \
    -delete 2>/dev/null | while read -r file; do
        log_to_file "$LOG_FILE" "Removed expired backup: $file"
    done

find "$BACKUP_DIR" \
    -maxdepth 1 \
    -type d \
    -name 'pre-restore-*' \
    -mtime +14 \
    -print 2>/dev/null | while read -r directory; do
        rm -rf -- "$directory"
        log_to_file "$LOG_FILE" "Removed old rollback copy: $directory"
    done

if [[ -d "$SERVER_DIR/crash-reports" ]]; then
    find "$SERVER_DIR/crash-reports" -type f -mtime +30 -delete
fi

find "$LOG_DIR" \
    -type f \
    \( -name '*.gz' -o -name '*.old' -o -name '*.1' \) \
    -mtime +30 \
    -delete 2>/dev/null || true

journalctl --vacuum-time=14d >/dev/null 2>&1 || true

log_to_file "$LOG_FILE" "Disk usage after cleanup: $(disk_usage_percent)%"
log_to_file "$LOG_FILE" "----- Cleanup finished -----"
