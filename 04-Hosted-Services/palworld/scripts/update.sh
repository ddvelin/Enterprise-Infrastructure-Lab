#!/usr/bin/env bash
set -Eeuo pipefail

CONFIG_FILE="${CONFIG_FILE:-$HOME/palworld-management/server.conf}"
source "$CONFIG_FILE"

mkdir -p "$LOG_DIR"
log_file="$LOG_DIR/update.log"
lock_file="/tmp/palworld-update.lock"

exec 9>"$lock_file"
flock -n 9 || exit 0

log() {
    printf '[%s] %s\n' "$(date '+%F %T')" "$*" | tee -a "$log_file"
}

log "Stopping $SERVICE_NAME before update."
systemctl stop "$SERVICE_NAME"

log "Updating Steam app $STEAM_APP_ID."
sudo -u "$SERVER_USER" "$STEAMCMD" \
    +force_install_dir "$SERVER_DIR" \
    +login anonymous \
    +app_update "$STEAM_APP_ID" validate \
    +quit | tee -a "$log_file"

log "Starting $SERVICE_NAME."
systemctl start "$SERVICE_NAME"

sleep 15
if systemctl is-active --quiet "$SERVICE_NAME"; then
    log "Update completed and service is active."
else
    log "Update finished, but the service failed to start."
    exit 1
fi
