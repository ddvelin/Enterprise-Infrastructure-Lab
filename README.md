# 🖥️ Enterprise Infrastructure Lab

> A production-inspired homelab focused on enterprise infrastructure, networking, Linux administration, virtualization, automation, monitoring, and disaster recovery.

---

# 📊 Environment Overview

| Component | Status |
|-----------|--------|
| 🖥 Hypervisor | Proxmox VE 9.1.4 |
| 🏷 Cluster | HomeLab-Cluster |
| 📦 Infrastructure Services | 6 |
| 🎮 Hosted Services | 4 |
| 💾 Automated Backups | ✅ Proxmox Backup Server |
| 🤖 Automation | ✅ Ansible + Bash |
| 📈 Monitoring | ✅ Netdata + Pulse |
| 🔒 Remote Access | ✅ Twingate Zero Trust |
| 🌐 DNS | ✅ Pi-hole |
| 🛡 Firewall | ✅ Proxmox Datacenter + Node |

---

# 📖 Documentation

## 🖥 Infrastructure

- 📁 [Hardware Overview](01-Hardware/)
- 🌐 [Network Architecture](02-Network/)
- 🖥️ [Proxmox Virtualization Platform](03-Virtual-Infrastructure/systems/proxmox-virtualization-platform.md)

---

## ⚙ Infrastructure Services

| Service | Status |
|----------|--------|
| Pi-hole | 🚧 In Progress |
| Twingate Connector | 🚧 In Progress |
| Proxmox Backup Server | 🚧 In Progress |
| Docker | 🚧 In Progress |
| Pulse | 🚧 In Progress |
| Ansible | 🚧 In Progress |

---

## 🎮 Hosted Services

See the [Hosted Game Server Labs index](04-Hosted-Services/) for the complete portfolio section.

| Service | Status |
|----------|--------|
| [Cozy Zen Modded Minecraft Automation Lab](04-Hosted-Services/cozy-zen-minecraft/) | ✅ Documented |
| [ATM10 Modded Minecraft Server Lab](04-Hosted-Services/atm10-minecraft/) | ✅ Documented |
| [Palworld Dedicated Server Lab](04-Hosted-Services/palworld/) | ✅ Documented |
| [Enshrouded Dedicated Server Lab](04-Hosted-Services/enshrouded/) | ✅ Documented |

The hosted-service projects include sanitized Bash scripts, systemd examples, backup and recovery procedures, health monitoring, SteamCMD workflows, RCON administration, Wine-based hosting, Playit.gg connectivity, resource tuning, and troubleshooting documentation.

---

## 📈 Operations Documentation

- 🤖 Automation
- 📊 Monitoring
- 💾 Backup Strategy
- 🚨 Disaster Recovery
- 📒 Engineering Journal

---

# 🛠 Technologies Used

## Infrastructure

- Proxmox VE
- Debian Linux
- Ubuntu Server
- Linux Containers (LXC)
- KVM Virtual Machines

## Networking

- Pi-hole
- Twingate
- Playit.gg
- Static IP Addressing
- Managed Switching
- QoS
- Firewall Rules

## Automation

- Bash
- Ansible
- systemd Services and Timers
- RCON
- SteamCMD
- Discord Webhooks
- Cron
- Automated VM Maintenance

## Monitoring

- Netdata
- Pulse
- Proxmox Monitoring
- Custom Bash Health Checks and Status Dashboards
- Spark Minecraft Profiling

## Game Server Platforms

- Minecraft Forge and NeoForge
- Palworld Dedicated Server
- Enshrouded Dedicated Server
- Wine and Xvfb

---

# 🚀 Current Roadmap

## Phase 1 — Foundation ✅

- [x] Hardware Documentation
- [x] Network Documentation
- [x] Infrastructure Architecture
- [x] Proxmox Virtualization Platform

## Phase 2 — Infrastructure Services 🚧

- [ ] Pi-hole Documentation
- [ ] Twingate Documentation
- [ ] PBS Documentation
- [ ] Docker Documentation
- [ ] Pulse Documentation
- [ ] Ansible Documentation

## Phase 3 — Hosted Services ✅

- [x] Cozy Zen Modded Minecraft Automation Lab
- [x] ATM10 Modded Minecraft Server Lab
- [x] Palworld Dedicated Server Lab
- [x] Enshrouded Dedicated Server Lab

## Phase 4 — Enterprise Features

- [ ] Rack Infrastructure
- [ ] OPNsense Firewall
- [ ] VLAN Segmentation
- [ ] TrueNAS Storage
- [ ] 24-Port Managed Switch
- [ ] UPS Integration
- [ ] Draw.io Network Diagrams
- [ ] Rack Elevation Diagram
- [ ] Configuration Management Database (CMDB)

---

# 🔐 Public Repository Privacy Standard

Configuration and code examples are sanitized before publication. This repository does not include:

- Passwords, tokens, webhook URLs, or SSH keys
- Internal or public IP addresses
- Playit tunnel hostnames or claim information
- Player names, UUIDs, or whitelist contents
- World files, savegames, backups, or production logs
- Copyrighted game binaries, server packs, or mod files

---

# 🎯 Project Goals

This project exists to continuously develop practical enterprise infrastructure skills through hands-on experience.

Primary areas of focus include:

- Enterprise Virtualization
- Linux Administration
- Networking
- Infrastructure Automation
- Infrastructure Monitoring
- Disaster Recovery
- Documentation
- Security
- Troubleshooting
- Capacity Planning

The lab is continuously expanded as new technologies are learned and implemented.
