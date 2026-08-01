#!/usr/bin/env bash
set -Eeuo pipefail

source "${COMMON_LIBRARY:-$HOME/game-server/scripts/lib/common.sh}"

LOG_FILE="$LOG_DIR/restart.log"
LOCK_FILE="$RUN_DIR/restart.lock"

exec 9>"$LOCK_FILE"
flock -n 9 || {
    log_to_file "$LOG_FILE" "Restart skipped because another restart is running."
    exit 0
}

if ! service_is_active; then
    log_to_file "$LOG_FILE" "Service is inactive; attempting a normal start."
    systemctl start "$SERVICE_NAME"
    wait_for_rcon 300 && {
        log_to_file "$LOG_FILE" "Server started successfully."
        exit 0
    }

    log_to_file "$LOG_FILE" "ERROR: Server failed to become ready."
    exit 1
fi

log_to_file "$LOG_FILE" "Beginning graceful restart."

"$RCON_SCRIPT" "say Server restarting in 60 seconds."
sleep 30
"$RCON_SCRIPT" "say Server restarting in 30 seconds."
sleep 20
"$RCON_SCRIPT" "say Server restarting in 10 seconds."
sleep 5
"$RCON_SCRIPT" "say Server restarting in 5 seconds."
sleep 5
"$RCON_SCRIPT" "save-all flush"
sleep 3
"$RCON_SCRIPT" "say Server restarting now."
"$RCON_SCRIPT" "stop" >/dev/null 2>&1 || true

if ! wait_for_service_stop 300; then
    log_to_file "$LOG_FILE" "Minecraft did not stop through RCON; requesting systemd stop."
    systemctl stop "$SERVICE_NAME"
fi

sleep 10
systemctl start "$SERVICE_NAME"

if wait_for_rcon 300; then
    log_to_file "$LOG_FILE" "Restart completed successfully."
    exit 0
fi

log_to_file "$LOG_FILE" "ERROR: Minecraft did not become ready after restart."
exit 1
