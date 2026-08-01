#!/usr/bin/env bash
set -Eeuo pipefail

SERVICE_NAME="${SERVICE_NAME:-enshrouded}"
GAME_PORT="${GAME_PORT:-15636}"
QUERY_PORT="${QUERY_PORT:-15637}"
PLAYIT_SERVICE="${PLAYIT_SERVICE:-playit}"

service_state="$(systemctl is-active "$SERVICE_NAME" 2>/dev/null || true)"
playit_state="$(systemctl is-active "$PLAYIT_SERVICE" 2>/dev/null || true)"
wine_process="not running"
pgrep -af 'enshrouded_server.exe' >/dev/null 2>&1 && wine_process="running"

port_state() {
    local port="$1"
    if ss -lun | awk '{print $5}' | grep -Eq "(^|:)${port}$"; then
        echo listening
    else
        echo closed
    fi
}

printf 'Enshrouded Service : %s\n' "$service_state"
printf 'Server Process     : %s\n' "$wine_process"
printf 'Game UDP Port      : %s\n' "$(port_state "$GAME_PORT")"
printf 'Query UDP Port     : %s\n' "$(port_state "$QUERY_PORT")"
printf 'Playit Service     : %s\n' "$playit_state"
