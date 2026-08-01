#!/usr/bin/env bash

# Shared functions for the sanitized Minecraft automation examples.

CONFIG_FILE="${CONFIG_FILE:-$HOME/game-server/config/server.conf}"
SCRIPT_DIR="${SCRIPT_DIR:-$HOME/game-server/scripts}"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "ERROR: Missing configuration file: $CONFIG_FILE" >&2
    exit 1
fi

# shellcheck disable=SC1090
source "$CONFIG_FILE"

RCON_SCRIPT="$SCRIPT_DIR/rcon.sh"

mkdir -p "$LOG_DIR" "$BACKUP_DIR" "$RUN_DIR"

log_message() {
    printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

log_to_file() {
    local log_file="$1"
    shift
    log_message "$*" | tee -a "$log_file"
}

service_is_active() {
    systemctl is-active --quiet "$SERVICE_NAME"
}

playit_is_active() {
    systemctl is-active --quiet playit
}

minecraft_port_is_open() {
    ss -ltn | awk '{print $4}' | grep -Eq "(^|:)${MINECRAFT_PORT}$"
}

rcon_is_healthy() {
    "$RCON_SCRIPT" "list" >/dev/null 2>&1
}

wait_for_rcon() {
    local timeout="${1:-300}"
    local elapsed=0

    while (( elapsed < timeout )); do
        rcon_is_healthy && return 0
        sleep 1
        ((elapsed += 1))
    done

    return 1
}

wait_for_service_stop() {
    local timeout="${1:-300}"
    local elapsed=0

    while (( elapsed < timeout )); do
        service_is_active || return 0
        sleep 1
        ((elapsed += 1))
    done

    return 1
}

disk_usage_percent() {
    df -P "$SERVER_DIR" | awk 'NR==2 {gsub("%", "", $5); print $5}'
}

available_memory_mb() {
    awk '/MemAvailable:/ {printf "%.0f\n", $2 / 1024}' /proc/meminfo
}

world_size_human() {
    [[ -d "$SERVER_DIR/world" ]] && du -sh "$SERVER_DIR/world" 2>/dev/null | awk '{print $1}' || echo "N/A"
}

latest_backup_file() {
    find "$BACKUP_DIR" -type f -name '*.tar.gz' -printf '%T@ %p\n' 2>/dev/null |
        sort -nr |
        head -1 |
        cut -d' ' -f2-
}
