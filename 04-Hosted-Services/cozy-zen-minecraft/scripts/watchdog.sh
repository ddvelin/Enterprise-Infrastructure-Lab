#!/usr/bin/env bash
set -Eeuo pipefail

source "${COMMON_LIBRARY:-$HOME/game-server/scripts/lib/common.sh}"

HEALTHCHECK_SCRIPT="$SCRIPT_DIR/healthcheck.sh"
RESTART_SCRIPT="$SCRIPT_DIR/restart.sh"
LOG_FILE="$LOG_DIR/watchdog.log"
LOCK_FILE="$RUN_DIR/watchdog.lock"

exec 9>"$LOCK_FILE"
flock -n 9 || {
    log_to_file "$LOG_FILE" "Watchdog skipped because another run is active."
    exit 0
}

log_to_file "$LOG_FILE" "----- Watchdog started -----"

if "$HEALTHCHECK_SCRIPT" >/dev/null 2>&1; then
    log_to_file "$LOG_FILE" "Server is healthy. No action needed."
    log_to_file "$LOG_FILE" "----- Watchdog finished -----"
    exit 0
fi

log_to_file "$LOG_FILE" "Health check failed. Attempting one controlled recovery."
"$RESTART_SCRIPT" >>"$LOG_FILE" 2>&1 || true
sleep 30

if "$HEALTHCHECK_SCRIPT" >/dev/null 2>&1; then
    log_to_file "$LOG_FILE" "Recovery succeeded. Server is healthy again."
    log_to_file "$LOG_FILE" "----- Watchdog finished -----"
    exit 0
fi

log_to_file "$LOG_FILE" "CRITICAL: Recovery failed. Manual intervention is required."
log_to_file "$LOG_FILE" "----- Watchdog finished -----"
exit 1
