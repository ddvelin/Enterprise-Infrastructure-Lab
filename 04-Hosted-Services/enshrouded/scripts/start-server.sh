#!/usr/bin/env bash
set -Eeuo pipefail

SERVER_DIR="${SERVER_DIR:-/home/gameserver/enshrouded/server}"
WINE_BIN="${WINE_BIN:-/usr/bin/wine}"
DISPLAY_WRAPPER="${DISPLAY_WRAPPER:-/usr/bin/xvfb-run}"

cd "$SERVER_DIR"
exec "$DISPLAY_WRAPPER" -a "$WINE_BIN" enshrouded_server.exe
