# systemd Units and Timers

These examples use generic names and paths. Replace `gameserver`, `example-minecraft`, and `/home/gameserver/game-server` before deployment.

## Minecraft Service

`/etc/systemd/system/example-minecraft.service`

```ini
[Unit]
Description=Example Modded Minecraft Server
After=network.target
StartLimitIntervalSec=300
StartLimitBurst=3

[Service]
Type=simple
User=gameserver
WorkingDirectory=/home/gameserver/game-server/server
ExecStart=/home/gameserver/game-server/server/run.sh nogui
ExecStop=/bin/kill -SIGINT $MAINPID
Restart=on-failure
RestartSec=30
TimeoutStopSec=300
SuccessExitStatus=0 143

[Install]
WantedBy=multi-user.target
```

## Health and Watchdog

`/etc/systemd/system/example-health.service`

```ini
[Unit]
Description=Example Minecraft Health Check and Watchdog
After=network-online.target example-minecraft.service playit.service

[Service]
Type=oneshot
User=root
ExecStart=/home/gameserver/game-server/scripts/watchdog.sh
```

`/etc/systemd/system/example-health.timer`

```ini
[Unit]
Description=Run Example Minecraft Health Check Every Five Minutes

[Timer]
OnBootSec=5min
OnUnitActiveSec=5min
AccuracySec=30s
Persistent=true
Unit=example-health.service

[Install]
WantedBy=timers.target
```

## Daily Backup

`/etc/systemd/system/example-backup.service`

```ini
[Unit]
Description=Example Minecraft Backup
After=network-online.target example-minecraft.service
Requires=example-minecraft.service

[Service]
Type=oneshot
User=root
ExecStart=/home/gameserver/game-server/scripts/backup.sh
TimeoutStartSec=2h
```

`/etc/systemd/system/example-backup.timer`

```ini
[Unit]
Description=Daily Example Minecraft Backup

[Timer]
OnCalendar=*-*-* 04:00:00
AccuracySec=1min
Persistent=true
Unit=example-backup.service

[Install]
WantedBy=timers.target
```

## Daily Restart

`/etc/systemd/system/example-restart.service`

```ini
[Unit]
Description=Scheduled Example Minecraft Restart
After=network-online.target example-backup.service
Requires=example-minecraft.service

[Service]
Type=oneshot
User=root
ExecStart=/home/gameserver/game-server/scripts/restart.sh
TimeoutStartSec=15min
```

`/etc/systemd/system/example-restart.timer`

```ini
[Unit]
Description=Daily Example Minecraft Restart

[Timer]
OnCalendar=*-*-* 04:20:00
AccuracySec=1min
Persistent=true
Unit=example-restart.service

[Install]
WantedBy=timers.target
```

## Daily Cleanup

`/etc/systemd/system/example-cleanup.service`

```ini
[Unit]
Description=Example Minecraft File Cleanup
After=example-backup.service example-restart.service

[Service]
Type=oneshot
User=root
ExecStart=/home/gameserver/game-server/scripts/cleanup.sh
TimeoutStartSec=30min
```

`/etc/systemd/system/example-cleanup.timer`

```ini
[Unit]
Description=Daily Example Minecraft Cleanup

[Timer]
OnCalendar=*-*-* 04:45:00
AccuracySec=5min
Persistent=true
Unit=example-cleanup.service

[Install]
WantedBy=timers.target
```

## Enable Units

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now example-minecraft.service
sudo systemctl enable --now \
    example-health.timer \
    example-backup.timer \
    example-restart.timer \
    example-cleanup.timer
```

## Verify

```bash
systemctl list-timers --all | grep example
sudo systemctl status example-minecraft --no-pager -l
journalctl -u example-minecraft -n 100 --no-pager
```
