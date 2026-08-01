#!/usr/bin/env bash
set -Eeuo pipefail

CONFIG_FILE="${CONFIG_FILE:-$HOME/game-server/config/server.conf}"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "ERROR: Missing configuration file: $CONFIG_FILE" >&2
    exit 1
fi

# shellcheck disable=SC1090
source "$CONFIG_FILE"

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 \"minecraft command\"" >&2
    exit 1
fi

command -v mcrcon >/dev/null 2>&1 || {
    echo "ERROR: mcrcon is not installed." >&2
    exit 1
}

exec mcrcon \
    -H "$RCON_HOST" \
    -P "$RCON_PORT" \
    -p "$RCON_PASS" \
    "$@"
