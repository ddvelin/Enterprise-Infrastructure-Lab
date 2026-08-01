#!/usr/bin/env bash
set -Eeuo pipefail

source "${COMMON_LIBRARY:-$HOME/game-server/scripts/lib/common.sh}"

LOG_FILE="$LOG_DIR/healthcheck.log"
EXIT_CODE=0

ok()   { log_to_file "$LOG_FILE" "OK: $*"; }
warn() { log_to_file "$LOG_FILE" "WARNING: $*"; }
fail() { log_to_file "$LOG_FILE" "FAILED: $*"; EXIT_CODE=1; }

log_to_file "$LOG_FILE" "----- Health check started -----"

service_is_active       && ok "Minecraft service is active." || fail "Minecraft service is inactive."
minecraft_port_is_open  && ok "Minecraft port is listening." || fail "Minecraft port is not listening."
rcon_is_healthy         && ok "RCON responded successfully." || fail "RCON did not respond."
playit_is_active        && ok "Playit service is active." || fail "Playit service is inactive."

disk_usage="$(disk_usage_percent)"
if (( disk_usage >= DISK_CRITICAL_PERCENT )); then
    fail "Disk usage is critically high at ${disk_usage}%."
elif (( disk_usage >= DISK_WARNING_PERCENT )); then
    warn "Disk usage is high at ${disk_usage}%."
else
    ok "Disk usage is ${disk_usage}%."
fi

available_memory="$(available_memory_mb)"
if (( available_memory < MEMORY_CRITICAL_MB )); then
    fail "Available memory is critically low at ${available_memory} MB."
elif (( available_memory < MEMORY_WARNING_MB )); then
    warn "Available memory is low at ${available_memory} MB."
else
    ok "Available memory is ${available_memory} MB."
fi

latest_backup="$(latest_backup_file || true)"
if [[ -z "$latest_backup" ]]; then
    warn "No backup archive was found."
else
    age_hours="$(( ($(date +%s) - $(stat -c %Y "$latest_backup")) / 3600 ))"
    if (( age_hours >= 48 )); then
        fail "Latest backup is ${age_hours} hours old."
    elif (( age_hours >= 24 )); then
        warn "Latest backup is ${age_hours} hours old."
    else
        ok "Latest backup is ${age_hours} hours old."
    fi
fi

if (( EXIT_CODE == 0 )); then
    log_to_file "$LOG_FILE" "Health check passed."
else
    log_to_file "$LOG_FILE" "Health check failed."
fi

log_to_file "$LOG_FILE" "----- Health check finished -----"
exit "$EXIT_CODE"
