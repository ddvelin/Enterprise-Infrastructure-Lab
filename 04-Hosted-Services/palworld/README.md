# Palworld Dedicated Server Lab

## Overview

This project documents a private Palworld dedicated server running in an Ubuntu Server virtual machine on Proxmox VE.

The server was installed with SteamCMD, managed with systemd, exposed through Playit.gg, and administered remotely over SSH through Twingate. The work included service recovery, version updates, configuration changes, RCON enablement, gameplay tuning, and troubleshooting Playit agent behavior.

> All examples are sanitized. Administrative passwords, tunnel addresses, internal IP addresses, player information, world saves, and logs are excluded.

## Environment

| Component | Implementation |
|---|---|
| Hypervisor | Proxmox VE |
| Guest OS | Ubuntu Server |
| Game | Palworld Dedicated Server |
| Installation | SteamCMD, app ID `2394010` |
| Service management | systemd |
| Public connectivity | Playit.gg UDP tunnel |
| Remote administration | SSH through Twingate |
| Game administration | Palworld RCON |

## Server Layout

```text
/home/gameserver/Steam/steamapps/common/PalServer/
├── PalServer.sh
└── Pal/
    └── Saved/
        ├── Config/LinuxServer/PalWorldSettings.ini
        ├── Logs/
        └── SaveGames/
```

Paths in the public examples use a generic `gameserver` account rather than the real local account.

## What Was Built and Automated

- A systemd unit starts Palworld at boot and restarts it after unexpected failure.
- A SteamCMD update script safely stops, validates, updates, and restarts the server.
- RCON was enabled for remote administrative commands and reusable management scripts.
- Playit.gg was used for game traffic without router port forwarding.
- Twingate provided private SSH access while away from the local network.
- Configuration changes were made safely with service stop/start and verification commands.
- Day/night timing was tuned by editing `PalWorldSettings.ini` and validating the resulting values.
- Troubleshooting procedures were created for startup failures, segfaults, Playit agent status, and version verification.

## Architecture

```text
Players
  |
  v
Playit.gg UDP tunnel
  |
  v
Palworld Ubuntu VM on Proxmox
  |
  +-- palworld.service
  +-- SteamCMD installation and updates
  +-- RCON administration
  +-- Palworld configuration and saves

Administrator
  |
  v
Twingate private access -> SSH
```

## Problems Solved

### Startup crashes and segfaults

The server previously exited unexpectedly. systemd and journal logs were used to distinguish an actual server crash from Playit or networking problems. Successful startup was confirmed through Steam API initialization and Palworld engine logs.

### Multiple SteamCMD locations

SteamCMD existed in more than one location. The update workflow standardized the executable path rather than relying on an interactive shell alias.

### Playit CLI differences

Commands such as `status` or `attach` were not available in the installed Playit version. Service status and `journalctl` became the reliable operational checks.

### Configuration changes required exact formatting

`PalWorldSettings.ini` stores many values on one long line. Changes were applied with precise substitutions and verified with `grep` before restarting the service.

## Repository Contents

- [`scripts/update.sh`](scripts/update.sh) — sanitized SteamCMD update workflow.
- [`scripts/rcon.sh`](scripts/rcon.sh) — reusable RCON wrapper using environment variables.
- [`scripts/status.sh`](scripts/status.sh) — service, port, Playit, and version checks.
- [`systemd/palworld.service`](systemd/palworld.service) — sanitized service definition.
- [`config/server.conf.example`](config/server.conf.example) — placeholder configuration.
- [`OPERATIONS.md`](OPERATIONS.md) — common commands and troubleshooting.

## Skills Demonstrated

- Linux game-server administration
- SteamCMD deployment and updates
- systemd service management
- Bash scripting
- RCON administration
- Remote-access design
- Log-based troubleshooting
- Configuration management
- Service and network verification
