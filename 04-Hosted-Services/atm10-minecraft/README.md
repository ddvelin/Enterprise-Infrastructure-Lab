# ATM10 Modded Minecraft Server Lab

## Overview

This project documents a private All The Mods 10 Minecraft server hosted in an Ubuntu Server virtual machine on Proxmox VE.

The server was built for a small group of players and used as a practical Linux administration project. The implementation focused on reliable service management, remote connectivity, backups, automated health checks, crash recovery, controlled resource allocation, and troubleshooting modded-server performance.

> All examples are sanitized. Passwords, player names, UUIDs, public tunnel addresses, internal IP addresses, world files, backup archives, logs, and copyrighted modpack files are intentionally excluded.

## Environment

| Component | Implementation |
|---|---|
| Hypervisor | Proxmox VE |
| Guest OS | Ubuntu Server |
| Workload | All The Mods 10 dedicated Minecraft server |
| Mod loader | NeoForge |
| Service management | systemd |
| Public connectivity | Playit.gg TCP tunnel |
| Administration | RCON and SSH |
| Monitoring | Bash health checks and Spark profiling |
| Backup platform | Proxmox Backup Server plus in-guest world backups |

## Resource Design

The VM was tuned for a small multiplayer group while leaving enough memory for the operating system:

- 6 virtual CPU cores
- 16 GB VM memory after expansion
- 14 GB Java heap target
- CPU type configured to `host`
- Persistent storage sized for modpack files, world growth, and backups

The server was initially smaller and expanded after exploration generated additional load and memory pressure.

## What Was Automated

- A systemd unit starts the server at boot and restarts it after unexpected failures.
- Daily backups are created with short retention for rapid rollback.
- A watchdog checks whether the service and game port are healthy.
- Recovery attempts are limited to avoid endless restart loops.
- Discord webhook notifications report state changes and recovery failures.
- Playit.gg provides external connectivity without direct router port forwarding.
- Administrative workflows include whitelist management, PvP configuration, spawn protection, and RCON preparation.

## Architecture

```text
Internet players
      |
      v
Playit.gg TCP tunnel
      |
      v
Ubuntu VM on Proxmox
      |
      +-- ATM10 NeoForge server
      +-- systemd service
      +-- health-check and watchdog scripts
      +-- local world backups
      +-- PBS VM-level backups
```

## Operational Lessons

### Exploration caused lag spikes

Modded world generation created noticeable load when multiple players explored new chunks. Resource allocation was increased, and pre-generation was considered as a way to trade disk usage for smoother play.

### Java memory must leave room for Linux

Giving Java all available VM memory can cause swapping or operating-system pressure. The final design reserved memory for Ubuntu while assigning most VM RAM to the server heap.

### A watchdog should report state changes, not spam

The health workflow was designed to notify only when the server transitions between healthy and unhealthy states. Repeated failures are rate-limited and automatic restart attempts are capped.

### Backups need two recovery layers

In-guest backups allow quick restoration of a damaged world, while Proxmox Backup Server protects the entire VM and configuration.

## Repository Contents

- [`scripts/`](scripts/) — sanitized backup, health-check, and watchdog examples.
- [`systemd/`](systemd/) — service and timer examples.
- [`config/server.conf.example`](config/server.conf.example) — placeholder configuration with no secrets.
- [`OPERATIONS.md`](OPERATIONS.md) — operating and troubleshooting commands.

## Skills Demonstrated

- Proxmox VM administration
- Ubuntu Server administration
- systemd services and timers
- Bash scripting
- Minecraft/NeoForge server administration
- JVM memory planning
- Backup and recovery design
- Health monitoring and controlled recovery
- Secure remote connectivity
- Performance troubleshooting
