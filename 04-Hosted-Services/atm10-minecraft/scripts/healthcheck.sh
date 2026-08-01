#!/usr/bin/env bash
set -Eeuo pipefail

CONFIG_FILE="${CONFIG_FILE:-$HOME/atm10-config/server.conf}"
source "$CONFIG_FILE"

service_ok=false
port_ok=false
rcon_ok=false

systemctl is-active --quiet "$SERVICE_NAME" && service_ok=true
ss -ltn | awk '{print $4}' | grep -Eq "(^|:)${GAME_PORT}$" && port_ok=true

if command -v mcrcon >/dev/null 2>&1; then
    mcrcon -H "$RCON_HOST" -P "$RCON_PORT" -p "$RCON_PASSWORD" list \
        >/dev/null 2>&1 && rcon_ok=true
fi

if [[ "$service_ok" == true && "$port_ok" == true ]]; then
    printf 'healthy service=%s port=%s rcon=%s\n' \
        "$service_ok" "$port_ok" "$rcon_ok"
    exit 0
fi

printf 'unhealthy service=%s port=%s rcon=%s\n' \
    "$service_ok" "$port_ok" "$rcon_ok" >&2
exit 1
