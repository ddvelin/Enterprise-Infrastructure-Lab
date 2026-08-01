#!/usr/bin/env bash
set -Eeuo pipefail

CONFIG_FILE="${CONFIG_FILE:-$HOME/atm10-config/server.conf}"
source "$CONFIG_FILE"

HEALTHCHECK="${HEALTHCHECK:-$HOME/atm10-scripts/healthcheck.sh}"
mkdir -p "$(dirname "$STATE_FILE")" "$LOG_DIR"
log_file="$LOG_DIR/atm10-watchdog.log"

previous_state="unknown"
[[ -f "$STATE_FILE" ]] && previous_state="$(cat "$STATE_FILE")"

log() {
    printf '[%s] %s\n' "$(date '+%F %T')" "$*" | tee -a "$log_file"
}

notify() {
    [[ -n "${DISCORD_WEBHOOK_URL:-}" ]] || return 0
    curl -fsS -H 'Content-Type: application/json' \
        -d "{\"content\":\"$1\"}" "$DISCORD_WEBHOOK_URL" >/dev/null || true
}

if "$HEALTHCHECK" >/dev/null 2>&1; then
    echo healthy > "$STATE_FILE"
    if [[ "$previous_state" != healthy ]]; then
        log "Server is healthy."
        notify "ATM10 server recovered and is healthy."
    fi
    exit 0
fi

log "Health check failed. Attempting one controlled restart."
[[ "$previous_state" != unhealthy ]] && notify "ATM10 health check failed; recovery started."
echo unhealthy > "$STATE_FILE"

systemctl restart "$SERVICE_NAME"
sleep "$RESTART_WAIT_SECONDS"

if "$HEALTHCHECK" >/dev/null 2>&1; then
    echo healthy > "$STATE_FILE"
    log "Automatic recovery succeeded."
    notify "ATM10 automatic recovery succeeded."
    exit 0
fi

log "Automatic recovery failed; manual intervention required."
notify "ATM10 recovery failed; manual intervention required."
exit 1
