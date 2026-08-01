# ATM10 Operations Guide

## Common Commands

```bash
sudo systemctl status atm10 --no-pager -l
journalctl -u atm10 -f
journalctl -u atm10 -n 200 --no-pager
ss -ltnp | grep 25565
systemctl list-timers --all | grep atm10
```

## Service Management

```bash
sudo systemctl start atm10
sudo systemctl stop atm10
sudo systemctl restart atm10
```

## Watchdog

```bash
sudo systemctl start atm10-watchdog.service
sudo systemctl enable --now atm10-watchdog.timer
journalctl -u atm10-watchdog.service --since today
```

## Performance Investigation

The primary troubleshooting order was:

1. Confirm the systemd service was active.
2. Review the latest server log and crash report.
3. Verify the Minecraft TCP port was listening.
4. Review VM CPU and memory pressure in Proxmox.
5. Run Spark profiling during active lag.
6. Correlate lag with new-chunk exploration and world generation.
7. Increase VM resources only after validating the bottleneck.

## Backup Strategy

- In-guest world backups provide fast rollback.
- Proxmox Backup Server protects the full VM.
- Backup retention is intentionally short in the sanitized example.
- Real archives, player data, and world files are never committed.

## Update Workflow

1. Notify players.
2. Create a current backup.
3. Stop the service.
4. Update the modpack or server files manually.
5. Preserve the existing world and configuration.
6. Start the service and monitor logs.
7. Confirm the port and player connectivity.

## Excluded Private Data

- RCON password
- Discord webhook URL
- Internal IP address
- Playit tunnel hostname
- Whitelist and operator names
- Player UUIDs
- World files and backups
- Modpack archives and mod JAR files
