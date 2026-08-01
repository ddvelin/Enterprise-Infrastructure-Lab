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
| 🌐 DNS | ✅ Pi-hole + Unbound |
| 🛡 Firewall | ✅ Proxmox Datacenter + Node |

---

# 📖 Documentation

## 🖥 Infrastructure

- 📁 [Hardware Overview](01-Hardware/)
- 🌐 [Network Architecture](02-Network/)
- 🖥️ [Proxmox Virtualization Platform](03-Virtual-Infrastructure/systems/proxmox-virtualization-platform.md)

---

## ⚙ Infrastructure Services

See the [Infrastructure Services Labs index](05-Infrastructure-Services/) for architecture, implementation reasoning, operational procedures, sanitized examples, failure stories, and recovery notes.

| Service | Status |
|----------|--------|
| [Pi-hole and Unbound](05-Infrastructure-Services/pi-hole-unbound/) | ✅ Documented |
| [Twingate Connector](05-Infrastructure-Services/twingate/) | ✅ Documented |
| [Proxmox Backup Server](05-Infrastructure-Services/proxmox-backup-server/) | ✅ Documented |
| [Docker Application Host](05-Infrastructure-Services/docker/) | ✅ Documented |
| [Pulse Monitoring](05-Infrastructure-Services/pulse/) | ✅ Documented |
| [Ansible Maintenance Automation](05-Infrastructure-Services/ansible/) | ✅ Documented |

These labs explain why each service exists, how it fits the architecture, what problems were encountered, how failures were diagnosed, and how the final design supports secure operations and recovery.

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
- Proxmox Backup Server
- Debian Linux
- Ubuntu Server
- Linux Containers (LXC)
- KVM Virtual Machines
- Docker and Compose

## Networking

- Pi-hole
- Unbound
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

## Phase 2 — Infrastructure Services ✅

- [x] Pi-hole and Unbound Documentation
- [x] Twingate Documentation
- [x] PBS Documentation
- [x] Docker Documentation
- [x] Pulse Documentation
- [x] Ansible Documentation

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

- Passwords, tokens, webhook URLs, API secrets, or SSH keys
- Internal or public IP addresses and private DNS names
- Twingate tenant, connector, resource, or deployment identifiers
- PBS token secrets, certificate fingerprints, datastore details, or encryption material
- Playit tunnel hostnames or claim information
- Player names, UUIDs, or whitelist contents
- World files, savegames, backups, application volumes, or production logs
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
