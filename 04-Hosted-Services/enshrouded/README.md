# Enshrouded Dedicated Server Lab

## Overview

This project documents a private Enshrouded dedicated server running in an Ubuntu Server virtual machine on Proxmox VE.

Because the dedicated server executable is Windows-based, the workload was hosted on Linux using Wine and `xvfb-run`. The project focused on service reliability, UDP connectivity through Playit.gg, VM CPU tuning, resource monitoring, configuration management, and troubleshooting server-overload warnings.

> All examples are sanitized. Passwords, public tunnel addresses, internal IP addresses, player information, save files, and logs are excluded.

## Environment

| Component | Implementation |
|---|---|
| Hypervisor | Proxmox VE |
| Guest OS | Ubuntu Server |
| Game | Enshrouded Dedicated Server |
| Compatibility layer | Wine + Xvfb |
| Service management | systemd |
| Public connectivity | Playit.gg UDP tunnels |
| VM CPU | Host CPU type |
| Initial player count | Small private group |

## VM Tuning

The VM was initially configured with six virtual CPUs and later increased to eight virtual CPUs. The Proxmox CPU model was changed from a generic QEMU model to `host`, CPU units were increased, and the CPU limit remained unlimited.

These changes gave Wine and the game server better access to the host processor's instruction set and scheduling capacity.

## Server Configuration

The server configuration used a sanitized structure similar to:

```json
{
  "ip": "0.0.0.0",
  "queryPort": 15637,
  "slotCount": 16,
  "voiceChatMode": "Proximity",
  "enableVoiceChat": false,
  "enableTextChat": false,
  "gameSettingsPreset": "Default",
  "tombstoneMode": "AddBackpackMaterials",
  "saveDirectory": "./savegame",
  "logDirectory": "./logs"
}
```

Real passwords and instance-specific settings are not included.

## What Was Built

- A repeatable Wine/Xvfb launch wrapper.
- A systemd unit for automatic startup and controlled restart behavior.
- Playit.gg UDP tunnels for the Enshrouded game and query ports.
- Status checks for the systemd service, Wine process, listening UDP ports, and Playit agent.
- VM resource tuning in Proxmox.
- A troubleshooting workflow for server-overload messages and connection issues.
- Configuration management for server slots, chat settings, save paths, and gameplay options.

## Architecture

```text
Players
  |
  v
Playit.gg UDP tunnels
  |
  v
Ubuntu VM on Proxmox
  |
  +-- systemd service
  +-- xvfb-run
  +-- Wine
  +-- enshrouded_server.exe
  +-- savegame and log directories
```

## Problems Solved

### Playit required multiple UDP tunnels

The game and query traffic used separate UDP ports. Both local ports had to be mapped correctly before the server appeared and accepted connections reliably.

### Generic virtual CPU reduced performance

The VM initially exposed a generic QEMU CPU model. Changing the CPU type to `host` and increasing available vCPUs improved scheduling and reduced overload symptoms.

### Wine required a headless display wrapper

The Windows executable was launched with `xvfb-run` so it could operate in a headless Ubuntu VM without a desktop environment.

### Connection worked only after access settings were correct

The server became joinable after the friend/password configuration and tunnel mapping were aligned. A misleading full-server response was worked through during connection testing.

## Repository Contents

- [`scripts/start-server.sh`](scripts/start-server.sh) — sanitized Wine/Xvfb launch wrapper.
- [`scripts/status.sh`](scripts/status.sh) — service, process, UDP-port, and Playit checks.
- [`systemd/enshrouded.service`](systemd/enshrouded.service) — sanitized service definition.
- [`config/enshrouded_server.example.json`](config/enshrouded_server.example.json) — non-secret example configuration.
- [`OPERATIONS.md`](OPERATIONS.md) — common commands and troubleshooting workflow.

## Skills Demonstrated

- Proxmox VM tuning
- Ubuntu Server administration
- Wine-based server hosting
- systemd service management
- UDP network troubleshooting
- Playit.gg tunneling
- Process and resource monitoring
- JSON configuration management
- Performance troubleshooting
