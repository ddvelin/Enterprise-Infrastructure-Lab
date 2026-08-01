# Game Hosting Portfolio

Game hosting became the first practical service that transformed the homelab from a school environment into infrastructure used by friends and family.

## Why I Self-Host Games

Self-hosting removes recurring rental costs and gives me control over:

- server resources,
- configuration,
- mods and updates,
- backups,
- player access,
- remote administration,
- and the lifecycle of the server.

Each deployment also creates a real Linux administration project involving systemd, networking, tunneling, storage, monitoring, recovery, and performance troubleshooting.

## Hosting Approach

My approach has evolved through two models.

### Tailored VM per game

Dedicated VMs provide strong isolation and allow the operating system, resources, automation, and troubleshooting process to be customized for one workload.

This is useful for:

- unusual Wine or Windows requirements,
- highly customized modpacks,
- experimental servers,
- and workloads that need an independent maintenance window.

### Shared game-management platform

A future AMP VM is being evaluated to reduce repeated operating-system maintenance and simplify the creation, update, backup, and start/stop workflow for casual servers.

The goal is not to replace everything with a panel. It is to use the simplest management model that fits how the server will actually be used.

## Documented Projects

| Project | What it demonstrates |
|---|---|
| [Cozy Zen Minecraft](../04-Hosted-Services/cozy-zen-minecraft/) | Full Bash automation framework, systemd timers, backups, restore validation, health checks, watchdog recovery, RCON, and a status dashboard |
| [ATM10 Minecraft](../04-Hosted-Services/atm10-minecraft/) | NeoForge administration, JVM resource planning, exploration lag troubleshooting, backups, health monitoring, and limited recovery |
| [Palworld](../04-Hosted-Services/palworld/) | SteamCMD updates, Linux service management, RCON, Playit.gg, remote administration, and configuration tuning |
| [Enshrouded](../04-Hosted-Services/enshrouded/) | Windows server hosting through Wine/Xvfb, UDP tunneling, Proxmox CPU tuning, and overload troubleshooting |

## Design Lessons

- Game servers should not share a failure domain only because they are all games.
- Temporary servers should receive automation appropriate to their expected lifespan.
- Public player traffic and private management traffic should use different access paths.
- In-guest save backups and VM-level PBS backups solve different recovery problems.
- Built-in management features should be considered before maintaining custom scripts.

## Next Evaluation: AMP

The next game-hosting project is a dedicated AMP VM. It will be compared with the tailored-VM approach based on:

- deployment speed,
- ease of updates,
- backup and restore behavior,
- resource sharing,
- visibility,
- maintenance effort,
- and how much control is lost or gained.

The comparison will determine whether AMP becomes the normal platform for casual private servers while custom VMs remain available for specialized workloads.
