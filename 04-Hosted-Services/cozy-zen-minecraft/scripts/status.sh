#!/usr/bin/env bash
set -Eeuo pipefail

source "${COMMON_LIBRARY:-$HOME/game-server/scripts/lib/common.sh}"

HEALTH_TIMER="${HEALTH_TIMER:-example-health.timer}"
BACKUP_TIMER="${BACKUP_TIMER:-example-backup.timer}"
RESTART_TIMER="${RESTART_TIMER:-example-restart.timer}"
CLEANUP_TIMER="${CLEANUP_TIMER:-example-cleanup.timer}"

service_state="$(systemctl is-active "$SERVICE_NAME" 2>/dev/null || true)"
playit_state="$(systemctl is-active playit 2>/dev/null || true)"
main_pid="$(systemctl show "$SERVICE_NAME" -p MainPID --value 2>/dev/null || echo 0)"
control_group="$(systemctl show "$SERVICE_NAME" -p ControlGroup --value 2>/dev/null || true)"
java_pid=""

if [[ "$main_pid" =~ ^[0-9]+$ ]] && (( main_pid > 0 )); then
    java_pid="$(pgrep -P "$main_pid" -x java 2>/dev/null | head -1 || true)"
fi

if [[ -z "$java_pid" && -n "$control_group" ]]; then
    cgroup_procs="/sys/fs/cgroup${control_group}/cgroup.procs"
    if [[ -r "$cgroup_procs" ]]; then
        while read -r pid; do
            [[ "$(ps -p "$pid" -o comm= 2>/dev/null | xargs || true)" == "java" ]] && {
                java_pid="$pid"
                break
            }
        done < "$cgroup_procs"
    fi
fi

player_output="Unavailable"
rcon_state="Not responding"
if rcon_is_healthy; then
    rcon_state="Healthy"
    player_output="$("$RCON_SCRIPT" "list" 2>/dev/null || true)"
fi

java_cpu="N/A"
java_memory="N/A"
if [[ "$java_pid" =~ ^[0-9]+$ ]] && kill -0 "$java_pid" 2>/dev/null; then
    java_cpu="$(ps -p "$java_pid" -o %cpu= | xargs)%"
    java_rss_kb="$(ps -p "$java_pid" -o rss= | xargs)"
    java_memory="$(awk -v kb="$java_rss_kb" 'BEGIN {printf "%.2f GB", kb / 1024 / 1024}')"
fi

latest_backup="$(latest_backup_file || true)"
backup_name="None"
backup_age="N/A"
backup_size="N/A"
if [[ -n "$latest_backup" && -f "$latest_backup" ]]; then
    backup_name="$(basename "$latest_backup")"
    backup_size="$(du -h "$latest_backup" | awk '{print $1}')"
    backup_age="$(( ($(date +%s) - $(stat -c %Y "$latest_backup")) / 3600 )) hours"
fi

next_timer() {
    systemctl list-timers "$1" --all --no-legend --no-pager 2>/dev/null |
        awk '{print $1, $2, $3, $4}' |
        head -1
}

printf '\n============================================================\n'
printf '              %s\n' "$SERVER_NAME"
printf '============================================================\n\n'
printf 'Service state       : %s\n' "$service_state"
printf 'Minecraft port      : %s\n' "$(minecraft_port_is_open && echo listening || echo closed)"
printf 'RCON                : %s\n' "$rcon_state"
printf 'Playit              : %s\n' "$playit_state"
printf 'Players             : %s\n' "$player_output"
printf 'Java PID            : %s\n' "${java_pid:-not found}"
printf 'Java CPU            : %s\n' "$java_cpu"
printf 'Java memory         : %s\n' "$java_memory"
printf 'Available VM memory : %s MB\n' "$(available_memory_mb)"
printf 'Disk usage          : %s%%\n' "$(disk_usage_percent)"
printf 'World size          : %s\n' "$(world_size_human)"
printf 'Latest backup       : %s\n' "$backup_name"
printf 'Backup age          : %s\n' "$backup_age"
printf 'Backup size         : %s\n' "$backup_size"
printf 'Next health check   : %s\n' "$(next_timer "$HEALTH_TIMER")"
printf 'Next backup         : %s\n' "$(next_timer "$BACKUP_TIMER")"
printf 'Next restart        : %s\n' "$(next_timer "$RESTART_TIMER")"
printf 'Next cleanup        : %s\n' "$(next_timer "$CLEANUP_TIMER")"
printf '============================================================\n\n'
