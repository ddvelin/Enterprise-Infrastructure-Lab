#!/usr/bin/env bash
set -Eeuo pipefail

CONFIG_FILE="${CONFIG_FILE:-$HOME/palworld-management/server.conf}"
source "$CONFIG_FILE"

[[ $# -gt 0 ]] || {
    echo "Usage: $0 \"Palworld RCON command\"" >&2
    exit 1
}

command -v mcrcon >/dev/null 2>&1 || {
    echo "mcrcon is not installed." >&2
    exit 1
}

mcrcon -H "$RCON_HOST" -P "$RCON_PORT" -p "$RCON_PASSWORD" "$@"
