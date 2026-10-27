# Dell PowerEdge R730D — Proxmox Infrastructure Host

## Project overview

I added a Dell PowerEdge R730D as a second physical Proxmox host to expand my lab beyond the resource limits of my original repurposed desktop. This host is intended for infrastructure services, virtual machines, and experimentation; the original i7-8700K system continues to handle game hosting.

The server was initially deployed at a remote location. That constraint made reliable out-of-band administration, encrypted remote access, and cautious network security especially important.

## Hardware and storage

| Component | Implementation |
|---|---|
| Platform | Dell PowerEdge R730D |
| Hypervisor | Proxmox VE 9.2 |
| Boot drive | 400 GB Intel SSD |
| Data drives | Four 1.2 TB SAS hard drives |
| Data pool | ZFS striped mirrors (RAID10-like topology) |
| Usable data capacity | Approximately 2.17 TiB |
| Pool name | `vm-storage` |
| ZFS sector alignment | `ashift=12` |
| Remote management | Dell iDRAC |

The two mirrored vdevs provide redundancy against a single drive failure per mirror, while the striped layout supports concurrent VM workloads. They do **not** replace independent backups. ZFS configuration and pool health should be verified after hardware changes.

## Deployment and administration

1. Installed Proxmox VE using remote management.
2. Disabled the subscription-only enterprise package repository where appropriate and applied available updates.
3. Created the ZFS VM storage pool from four SAS disks.
4. Prepared virtual-machine templates for repeatable deployments.
5. Deployed a Twingate connector in an Ubuntu 24.04 LXC container to provide private remote access.
6. Hardened SSH access and configured restrictive firewall policies with explicit allowances for approved management paths.
7. Confirmed remote connectivity and healthy pool status before treating the host as ready for workloads.

## Security model

- Remote administration uses a private, identity-aware access path instead of broadly exposing hypervisor management interfaces to the public internet.
- Host and guest access are restricted by firewall rules and SSH configuration.
- Infrastructure configuration shared in this repository is descriptive and sanitized; credentials, connector identifiers, routable addresses, and private keys are not published.

## Design decisions and lessons

**Separate workloads by failure domain.** The Dell host is planned for infrastructure and learning workloads; the original desktop-based host remains focused on game servers.

**Prefer recoverability over raw capacity.** Mirrored ZFS vdevs sacrifice some usable space in exchange for drive-level redundancy. Backups remain a separate requirement.

**Design for remote failure scenarios.** When the server is not physically nearby, out-of-band access, predictable boot/storage behavior, and a secure management path matter more than convenience.

**Document actual state versus future plans.** Network redesign, a rack, and additional centralized storage remain future work rather than claims about the current deployment.

## Current status and next steps

The Proxmox host, ZFS pool, and private remote-access connector have been configured and verified. Next steps include expanding hosted infrastructure services, formalizing backup/restore validation, and updating architecture diagrams after the physical relocation.

*Portfolio note: This is a sanitized case study of a personal lab, not a claim of production enterprise employment.*
