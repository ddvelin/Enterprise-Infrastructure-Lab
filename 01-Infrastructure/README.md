# Infrastructure Overview

## Purpose

The lab is a Proxmox-based virtualization environment built from a repurposed gaming PC. It supports practical learning, private services, game hosting, automation, monitoring, backups, and future security and networking labs.

## Current Hardware

| Component | Current implementation |
|---|---|
| CPU | Intel Core i7-8700K |
| Memory | 32 GB DDR4, upgraded from 16 GB |
| Primary storage | 1 TB SSD for the main virtualization workload |
| Secondary storage | 256 GB SSD retained for secondary or backup use |
| Former GPU | NVIDIA RTX 3060 Ti, later repurposed for another gaming PC |
| Switching | Small managed Ethernet switch |
| Hypervisor | Proxmox VE |

The system started as an older gaming computer. Reusing existing hardware kept the project financially possible while still providing enough CPU capacity for multiple Linux guests and small private game servers.

## Hardware Lessons

### Memory became the main constraint

The move from 16 GB to 32 GB made multi-VM operation practical, but memory remains the largest limit when several game servers, Windows labs, and infrastructure services run together.

If rebuilding from the beginning, I would choose 64 GB or ensure the platform had a simple upgrade path to it.

### Storage was designed for the current budget, not future growth

The original SSD layout was enough to begin learning, but backups, VM disks, game saves, ISO images, and application data expanded faster than expected.

The long-term storage goal is a dedicated NAS with large-capacity drives, redundancy, and clearer separation between production storage and backups.

> Plan for where the environment may be in two years, not only where it is today.

## Current Network

The network is intentionally simple because the present home limits permanent cabling and rack deployment.

```text
Internet
   |
ISP router and gateway
   |
Managed switch
   |
   +-- Proxmox server
   +-- Primary desktop systems
   +-- Other wired devices
```

Pi-hole and Unbound provide the default DNS path for the network. Private addressing, router security controls, static addressing, and reservations are used where infrastructure requires predictable connectivity.

## Virtualization Design

Virtual machines were chosen to create isolation and safe recovery boundaries.

Benefits include:

- snapshots before risky work,
- restoring one workload without affecting the others,
- independent resource allocation,
- easier troubleshooting,
- and the freedom to experiment without risking the entire server.

The design philosophy has evolved from "one VM for every service" toward grouping related workloads while protecting important failure domains.

The deciding question is no longer only whether applications can share a VM. It is:

> What else goes offline when this VM needs maintenance or fails?

Core infrastructure, disposable labs, container workloads, and game hosting should not automatically share the same maintenance and failure boundary.

## Long-Term Architecture

The future design is intended for a permanent home with structured cabling and a dedicated rack.

Planned components include:

- personal router and OPNsense firewall,
- managed core switching,
- 10 Gb connectivity where useful,
- structured Ethernet runs,
- rack-mounted server chassis,
- rack UPS,
- RAID-backed NAS storage,
- VLAN segmentation,
- security cameras,
- environmental monitoring,
- smart-home services,
- local media and storage,
- and centralized monitoring and automation.

The goal is a secure, cohesive smart-home and private-cloud environment that can approach the complexity of a small-business network while remaining understandable and maintainable.
