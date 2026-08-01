# Operations Guide

## Common Commands

```bash
# Dashboard
~/game-server/scripts/status.sh

# Live Minecraft service logs
journalctl -u example-minecraft -f

# Recent logs
journalctl -u example-minecraft -n 200 --no-pager

# Forge log
 tail -f ~/game-server/server/logs/latest.log

# RCON player list
~/game-server/scripts/rcon.sh "list"

# Broadcast a message
~/game-server/scripts/rcon.sh "say Maintenance begins in five minutes."

# Manual backup
~/game-server/scripts/backup.sh

# Controlled restart
~/game-server/scripts/restart.sh

# Interactive restore
~/game-server/scripts/restore.sh
```

## systemd Management

```bash
sudo systemctl start example-minecraft
sudo systemctl stop example-minecraft
sudo systemctl restart example-minecraft
sudo systemctl status example-minecraft --no-pager -l
```

## Timer Management

```bash
systemctl list-timers --all | grep example

sudo systemctl enable --now example-health.timer
sudo systemctl enable --now example-backup.timer
sudo systemctl enable --now example-restart.timer
sudo systemctl enable --now example-cleanup.timer
```

## Expected Oneshot Behavior

The health, backup, restart, and cleanup services use `Type=oneshot`. After a successful run, their service state normally returns to `inactive (dead)` with `status=0/SUCCESS`. The associated timer remains active and waiting.

## Backup Contents

The example backup workflow archives the world directory plus key operational files when present:

- `world/`
- `server.properties`
- `whitelist.json`
- `ops.json`
- `banned-players.json`
- `banned-ips.json`
- `user_jvm_args.txt`
- `eula.txt`

World data includes the Overworld, Nether, End, custom mod dimensions, player data, entities, datapacks, and world-specific server configuration.

## Recovery Procedure

1. Confirm the archive exists and passes `tar -tzf` validation.
2. Notify players and flush world data.
3. Stop Minecraft gracefully.
4. Preserve the current world in a timestamped rollback directory.
5. Restore into a staging directory.
6. Confirm the restored archive contains `world/`.
7. Copy restored files into the live server directory.
8. Correct file ownership.
9. Start Minecraft and wait for RCON readiness.
10. Keep the rollback copy until the restored server is verified in-game.

## Troubleshooting Order

```bash
systemctl status example-minecraft --no-pager -l
journalctl -u example-minecraft -n 200 --no-pager
ss -ltnp | grep 25565
~/game-server/scripts/rcon.sh "list"
systemctl status playit --no-pager
journalctl -u playit --since "15 minutes ago" --no-pager
```

## Files Intentionally Excluded from Git

- Real `server.conf`
- RCON credentials
- SSH keys
- Playit claim data and tunnel hostnames
- Internal or public IP addresses
- Minecraft player UUIDs and names
- World data and backups
- Logs and crash reports
- Modpack ZIPs and copyrighted mod JAR files
