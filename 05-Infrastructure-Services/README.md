# Infrastructure Services Labs

This section documents the always-on services that support the homelab rather than a single application workload.

The design goal was to keep foundational services lightweight, recoverable, observable, and isolated enough that maintenance on one workload would not disrupt unrelated systems.

| Service | Purpose | Primary lesson |
|---|---|---|
| [Pi-hole and Unbound](pi-hole-unbound/) | Local DNS filtering and recursive resolution | DNS availability, resolver design, and safe network troubleshooting |
| [Twingate Connector](twingate/) | Zero-trust remote access to private services | Remote administration without exposing management ports |
| [Proxmox Backup Server](proxmox-backup-server/) | VM and container backup, retention, and restore | Recovery-first design, authentication, fingerprints, and backup-loop prevention |
| [Docker Application Host](docker/) | Isolated container platform for internal applications | Separating application lifecycle from core infrastructure |
| [Pulse Monitoring](pulse/) | Central Proxmox visibility and operational status | Fast fault detection without logging into every guest |
| [Ansible Maintenance Automation](ansible/) | Repeatable patching, verification, and reporting | Controlled automation with validation and limited self-recovery |

## Design Philosophy

These services were introduced to solve practical problems encountered while operating the lab:

- DNS needed to remain stable and independent from game servers.
- Remote management needed to work without opening Proxmox, SSH, or service dashboards to the public internet.
- Backups needed to be testable and recoverable, not merely scheduled.
- Container applications needed a dedicated home so experiments could not destabilize DNS, remote access, or backups.
- Monitoring needed to show failures quickly across the environment.
- Routine patching needed to be repeatable, logged, and cautious rather than a blind unattended upgrade.

## Privacy Standard

Public examples omit or replace:

- Internal and public IP addresses
- DNS names and private domains
- Twingate network, resource, connector, and tenant identifiers
- API tokens, fingerprints, passwords, and webhook URLs
- Backup datastore paths that reveal private naming
- Hostnames, usernames, inventory addresses, and SSH keys
- Application secrets, environment files, and container volumes
- Real alert history and operational logs
