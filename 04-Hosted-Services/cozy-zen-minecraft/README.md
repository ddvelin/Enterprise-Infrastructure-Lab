# Cozy Zen Modded Minecraft Server Automation Lab

## Overview

This project documents a private, small-player modded Minecraft server deployed on an Ubuntu Server virtual machine hosted by Proxmox VE.

The goal was not simply to launch a game server. The project focused on building a reliable Linux service with repeatable operations, automated backups, health monitoring, controlled recovery, logging, and disaster-recovery procedures.

> All examples in this repository are sanitized. Passwords, public tunnel addresses, usernames, IP addresses, UUIDs, world data, and private configuration files are excluded.

## Environment

| Component | Implementation |
|---|---|
| Hypervisor | Proxmox VE |
| Guest OS | Ubuntu Server |
| Game | Minecraft Java 1.20.1 |
| Mod loader | Forge 47.4.10 |
| Modpack | Cozy Zen |
| Remote access | SSH key authentication |
| Public connectivity | Playit.gg TCP tunnel |
| Service management | systemd |
| Administration | RCON with `mcrcon` |
| Automation | Bash + systemd timers |
| Backup format | Compressed `tar.gz` archives |

## What Was Built

- A dedicated systemd unit for controlled startup, shutdown, crash recovery, and restart-loop protection.
- An RCON wrapper that keeps credentials out of individual scripts.
- Graceful backups using `save-all flush`, `save-off`, archive creation, and guaranteed `save-on` recovery.
- A controlled restart workflow with in-game countdown warnings and readiness verification.
- Health checks covering the service, port, RCON, Playit agent, disk usage, available memory, and backup age.
- A watchdog that attempts one recovery and then stops rather than creating an endless restart loop.
- An interactive restore workflow with archive validation and a pre-restore rollback copy.
- Cleanup automation for expired backups, crash reports, staging files, and old journals.
- A terminal status dashboard showing player count, Java resource usage, backup state, service health, and timer schedules.

## Architecture

```text
Internet players
      |
      v
Playit.gg TCP tunnel
      |
      v
Ubuntu Server VM on Proxmox
      |
      +-- Forge Minecraft service
      +-- RCON bound locally
      +-- Bash management scripts
      +-- systemd services and timers
      +-- compressed local backups
```

## Directory Layout

```text
~/game-server/
├── server/                 # Live server files and world data
├── scripts/
│   ├── lib/common.sh
│   ├── rcon.sh
│   ├── backup.sh
│   ├── restart.sh
│   ├── restore.sh
│   ├── healthcheck.sh
│   ├── watchdog.sh
│   ├── cleanup.sh
│   └── status.sh
├── config/
│   └── server.conf         # Local secret-bearing config; not committed
├── config.example/
│   └── server.conf.example
├── backups/
├── logs/
└── run/                    # Lock files used by flock
```

## Automation Schedule

| Task | Schedule |
|---|---|
| Health check and watchdog | Every 5 minutes |
| World and configuration backup | Daily at 4:00 AM |
| Graceful restart | Daily at 4:20 AM |
| Cleanup and retention | Daily at 4:45 AM |

The backup and restart are separated so compression has time to complete before the scheduled restart begins.

## Security Decisions

- SSH password authentication was disabled after verifying key-based login.
- RCON was bound to localhost and was never forwarded through Playit or the router.
- The RCON password lives in a permission-restricted local configuration file.
- The public repository contains only an example configuration with placeholder values.
- Public IPs, internal IPs, Playit hostnames, Minecraft UUIDs, player names, and world files are excluded.
- Scripts use lock files to prevent overlapping backup, restore, restart, cleanup, or watchdog runs.

## Recovery Design

The restore workflow:

1. Lists available backups by date and size.
2. Requires an explicit confirmation phrase.
3. Validates the archive before stopping the live service.
4. Stops Minecraft gracefully through RCON when possible.
5. Moves the current world and key configuration files into a timestamped rollback directory.
6. Restores the selected archive into a staging directory.
7. Verifies that a world directory exists.
8. Copies the restored data into the live server directory.
9. Starts the service and waits for RCON to respond.

## Problems Solved

### Client-only mods on a dedicated server

The original modpack client directory contained rendering and shader-related mods that attempted to load Minecraft client classes on the dedicated server. Startup logs were reviewed and incompatible client-only mods were isolated rather than deleting them permanently.

### systemd tracked the wrapper shell instead of Java

The Forge `run.sh` process remained the systemd `MainPID`, while Java ran as a child process. The dashboard was updated to locate the actual Java PID through the service process tree and systemd control group.

### `/tmp` lock ownership conflict

Scripts were first tested interactively and later executed as root through systemd oneshot services. Existing `/tmp` lock files caused permission conflicts. Lock files were moved to a project-owned `run/` directory so both manual and scheduled execution behaved consistently.

### Shutdown appeared stalled

The modpack saved all dimensions quickly but required additional time for mod configuration cleanup. The systemd stop timeout was increased to allow a graceful shutdown before escalation.

## Skills Demonstrated

- Linux administration
- Proxmox virtual machines
- systemd services and timers
- Bash scripting
- Process and signal management
- RCON administration
- Logging and troubleshooting
- Backup and restore design
- Locking and concurrency control
- Resource monitoring
- Secure secret handling
- Incident recovery planning

## Repository Contents

- [`config.example/server.conf.example`](config.example/server.conf.example) — sanitized central configuration.
- [`scripts/`](scripts/) — selected reusable automation scripts.
- [`systemd/`](systemd/) — service and timer examples.
- [`OPERATIONS.md`](OPERATIONS.md) — command reference and operating procedures.

## Scope

This was intentionally designed for a small private server used by a few trusted players. It demonstrates production-inspired practices without pretending that a family-and-friends game server requires enterprise complexity everywhere.
