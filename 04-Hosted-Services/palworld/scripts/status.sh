#!/usr/bin/env bash
set -Eeuo pipefail

CONFIG_FILE="${CONFIG_FILE:-$HOME/palworld-management/server.conf}"
source "$CONFIG_FILE"

service_state="$(systemctl is-active "$SERVICE_NAME" 2>/dev/null || true)"
playit_state="$(systemctl is-active "$PLAYIT_SERVICE" 2>/dev/null || true)"
port_state="closed"
ss -lun | awk '{print $5}' | grep -Eq "(^|:)${GAME_PORT}$" && port_state="listening"

printf 'Palworld Service : %s\n' "$service_state"
printf 'UDP Port %s     : %s\n' "$GAME_PORT" "$port_state"
printf 'Playit Service  : %s\n' "$playit_state"
printf 'Server Path     : %s\n' "$SERVER_DIR"

latest_log="$SERVER_DIR/Pal/Saved/Logs/Pal.log"
if [[ -f "$latest_log" ]]; then
    printf 'Latest Log      : %s\n' "$latest_log"
    tail -n 5 "$latest_log"
fi
