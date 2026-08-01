# Damian's Enterprise Infrastructure Portfolio

> **Building enterprise-inspired infrastructure one project at a time.**

Hi, I'm Damian. I built this homelab because I learn best by owning the entire problem: planning the system, deploying it, breaking it, recovering it, and understanding why it works.

What started as an unused gaming PC and a place to complete college labs has grown into a Proxmox-based platform for Linux administration, networking, cybersecurity practice, automation, monitoring, backups, container hosting, and private game servers used by friends and family.

My goal is not to build the most complicated environment possible. My goal is to build infrastructure that I understand, can recover, and can continue improving.

---

## Start Here

| Section | What it explains |
|---|---|
| [My Journey](00-My-Journey/) | Why I built the lab, how it changed my learning, what it taught me, and where I want it to go |
| [Infrastructure Overview](01-Infrastructure/) | Current hardware, network, storage constraints, virtualization design, and future architecture |
| [Engineering Principles](02-Engineering-Principles/) | Planning, failure domains, automation, troubleshooting, security, and definition of done |
| [Lessons and Failures](03-Lessons-and-Failures/) | RAM and storage planning, passthrough, backup failures, overengineering, and what changed afterward |
| [Hosted Game Server Labs](04-Hosted-Services/) | Sanitized technical case studies and reusable scripts for Cozy Zen, ATM10, Palworld, and Enshrouded |
| [Infrastructure Service Labs](05-Infrastructure-Services/) | Pi-hole, Twingate, PBS, Docker, Pulse, and Ansible architecture and troubleshooting |
| [Game Hosting Portfolio](06-Game-Hosting/) | Why I self-host, tailored VMs versus AMP, and the evolution of the hosting strategy |
| [Roadmap](08-Roadmap/) | Completed foundation, current work, career labs, network upgrades, and long-term smart-home goals |
| [Assets](Assets/) | Planned diagrams, screenshots, and the visual privacy checklist |

---

## Current Environment

| Area | Implementation |
|---|---|
| Hypervisor | Proxmox VE |
| Physical host | Repurposed Intel Core i7-8700K gaming PC |
| Memory | 32 GB DDR4 |
| Main storage | 1 TB SSD with secondary 256 GB SSD |
| Virtualization | KVM virtual machines and Linux containers |
| DNS | Pi-hole and Unbound |
| Remote administration | Twingate zero-trust access |
| Backups | Proxmox Backup Server plus workload-specific backups |
| Automation | Bash, systemd timers, and Ansible |
| Containers | Docker, Portainer, n8n, and Dashy |
| Monitoring | Proxmox, Pulse, Netdata, and application health checks |
| External game access | Playit.gg tunnels where required |
| Primary focus | Infrastructure, Linux, networking, automation, recovery, and documentation |

---

## Featured Projects

### Cozy Zen Minecraft Automation Lab

A short-lived family Minecraft server became the most complete custom automation project in the lab. It includes a systemd service, RCON wrapper, graceful backups, restore validation, restart warnings, health checks, watchdog recovery, cleanup, lock files, timers, and a terminal status dashboard.

[View the Cozy Zen project →](04-Hosted-Services/cozy-zen-minecraft/)

### Proxmox Backup Server

PBS protects VMs and containers and shaped the lab's recovery-first design. The project documents API-token and TLS-fingerprint issues, datastore design, backup scheduling before maintenance, recursive self-backup problems, and restore verification.

[View the PBS project →](05-Infrastructure-Services/proxmox-backup-server/)

### Ansible Patch-and-Verify Workflow

Routine Linux maintenance is coordinated after backups and includes readiness checks, updates, conditional reboots, service verification, one limited recovery attempt, local reports, and summarized notifications.

[View the Ansible project →](05-Infrastructure-Services/ansible/)

### Private Game Hosting

Minecraft, Palworld, and Enshrouded servers demonstrate Forge/NeoForge administration, SteamCMD, RCON, Wine and Xvfb, UDP and TCP tunneling, resource tuning, backups, monitoring, and real-world troubleshooting.

[View the game-hosting portfolio →](06-Game-Hosting/)

---

## How I Think About Infrastructure

### Plan before deployment

I now define the workload, constraints, access model, expected lifespan, backup needs, monitoring, and failure domain before creating the VM.

### Separate failures, not only applications

The important question is not only whether two services can run together. It is what else stops when that VM requires maintenance or fails.

### Automate the right things

Repetitive, time-consuming tasks deserve automation when the result can be logged, validated, and escalated if it fails. Built-in application features are preferred when they already solve the problem reliably.

### Design recovery before trusting automation

A successful backup job is not enough. Restore procedures, validation, staging, rollback, ownership correction, and post-recovery checks are part of the design.

### Match effort to project lifespan

Long-term services such as DNS, backups, remote access, and monitoring justify more engineering than a temporary game server that may exist for only a few weeks.

[Read the complete engineering principles →](02-Engineering-Principles/)

---

## Skills Demonstrated

| Category | Hands-on experience |
|---|---|
| Virtualization | Proxmox VE, KVM VMs, LXC, snapshots, cloning, resource allocation, CPU tuning, passthrough troubleshooting |
| Linux administration | Ubuntu and Debian, SSH, permissions, package management, process management, logs, filesystems, services |
| Automation | Bash, Ansible, systemd services and timers, lock files, health checks, limited recovery, reporting |
| Networking | DNS, Unbound, managed switching, static addressing, firewalls, Twingate, Playit.gg, TCP/UDP service checks |
| Backup and recovery | PBS, workload backups, retention, archive validation, restore staging, rollback design |
| Containers | Docker, Compose, Portainer, persistent volumes, application isolation |
| Monitoring | Pulse, Netdata, Proxmox metrics, service checks, port checks, RCON checks, status dashboards |
| Game infrastructure | Forge, NeoForge, SteamCMD, Wine, Xvfb, RCON, JVM planning, performance troubleshooting |
| Security | Zero-trust remote access, private management paths, secret handling, repository sanitization, isolated labs |
| Documentation | Architecture explanations, operations guides, troubleshooting records, sanitized code, roadmap planning |

---

## The Most Important Lessons

The most difficult problems were rarely solved by one perfect command. They were solved by isolating variables, preserving evidence, changing one thing at a time, waiting long enough to validate the result, and documenting what happened.

Major lessons include:

- plan memory and storage for future growth,
- avoid hardware passthrough unless it solves a real requirement,
- group workloads by lifecycle and failure impact,
- test restores instead of assuming backups are usable,
- and avoid adding complexity that a short-lived project will never benefit from.

[Read the failure stories and lessons →](03-Lessons-and-Failures/)

---

## Current Roadmap

The next stage focuses on making the environment easier to operate and easier for employers to understand:

- evaluate AMP for casual game hosting,
- document every VM and container,
- create physical, logical, backup, and automation diagrams,
- add sanitized screenshots,
- build a CMDB-style inventory,
- expand into Windows Server, Active Directory, Cisco networking, and isolated security labs,
- and eventually redesign the physical network around OPNsense, VLANs, NAS storage, a rack, UPS, and structured cabling.

[View the full roadmap →](08-Roadmap/)

---

## Public Repository Privacy Standard

All examples are sanitized before publication. This repository excludes:

- passwords, tokens, webhook URLs, API secrets, SSH keys, and encryption material,
- internal or public IP addresses and private DNS names,
- Twingate, Playit, PBS, and connector deployment identifiers,
- player names, UUIDs, whitelist contents, and chat data,
- world saves, backup archives, application volumes, and production logs,
- and copyrighted game binaries, server packs, and mod files.

The repository preserves the technical design and troubleshooting lessons without exposing the private environment.

---

## Long-Term Vision

My goal is to grow this environment into infrastructure that can rival the complexity of a small business while remaining understandable and maintainable.

The future design includes OPNsense, managed switching, VLAN segmentation, 10 Gb connectivity where practical, RAID-backed NAS storage, rack infrastructure, local security cameras, environmental monitoring, smart-home automation, private cloud services, and documented recovery procedures.

I want this portfolio to show more than servers that happen to work. I want it to show how I plan, troubleshoot, recover, document, and improve real systems.

> **The biggest accomplishment is not that the server works. It is that I understand why it works.**
