# Proxmox Backup Server Lab

## Why I Built It

The homelab had reached the point where rebuilding every VM manually was no longer acceptable. Proxmox Backup Server (PBS) was added to provide deduplicated VM and container backups, scheduled retention, integrity verification, and full-machine restoration.

The main goal was recovery, not simply producing backup jobs. The design therefore included restore testing, datastore monitoring, authentication separation, and a written response plan for failed backups.

## Environment and Architecture

PBS runs as a dedicated virtual machine on the Proxmox host. A separate storage device is presented to the PBS guest as its datastore.

```text
Proxmox VE workloads
        |
        v
Scheduled encrypted/authenticated backup jobs
        |
        v
Proxmox Backup Server VM
        |
        v
Dedicated datastore storage
```

The deployment used a dedicated PBS API token rather than the administrator password for routine backup jobs.

## What Was Implemented

- Dedicated PBS VM.
- Dedicated datastore mounted inside the PBS guest.
- Scheduled backups for important VMs and containers.
- API-token authentication from Proxmox VE to PBS.
- TLS fingerprint validation.
- Retention and pruning policies.
- Backup verification and restore testing.
- Daily backup window coordinated with later maintenance automation.
- A 3-2-1-oriented strategy combining live workloads, PBS copies, and additional storage planning.

## Design Reasoning

### Separate the backup service from ordinary application workloads

PBS is a recovery dependency. It was kept out of Docker and game-server guests so application failures or experimentation could not directly damage the backup service.

### Use a dedicated datastore

Backup data was separated from the PBS operating-system disk. This makes capacity planning and recovery clearer and avoids filling the root filesystem with backup chunks.

### Use API tokens

A scoped token reduces reliance on a full administrative password and makes authentication easier to revoke or rotate.

### Coordinate backup and maintenance windows

Backups run before automated guest patching. The intended sequence is:

```text
02:00 - environment becomes idle
04:00 - PBS backup window
06:00 - Ansible patch and verification
```

This gives the maintenance workflow a recent restore point before changes are applied.

## Problems Encountered and Fixes

### Authentication and fingerprint errors

Initial backup jobs failed because PBS requires both valid credentials and trust of the server certificate fingerprint. The resolution was to:

- create the API token correctly,
- assign the required datastore permissions,
- enter the token identity and secret accurately,
- verify the PBS certificate fingerprint,
- and test the storage connection before scheduling jobs.

This reinforced that authentication failure and certificate-trust failure are separate problems.

### PBS attempted to back up itself through the same job path

A self-backup loop or inappropriate job selection can waste space and create confusing dependencies. The backup selection was corrected so the PBS VM was not recursively protected by the same datastore workflow in a way that depended on itself.

### Datastore path and mount confusion

The datastore must point to the actual mounted storage inside PBS, not merely a directory that exists on the OS disk. Validation included checking the mount, filesystem capacity, and PBS datastore configuration before trusting the first successful job.

### Successful job did not automatically mean proven recovery

The lab treated restore testing as part of the deployment. A backup is only useful when the administrator knows how to locate snapshots, restore a guest, and confirm it boots.

## Operations

```bash
# On Proxmox VE
pvesm status
pvesh get /cluster/backup

# On PBS
proxmox-backup-manager datastore list
proxmox-backup-manager task list
systemctl status proxmox-backup-proxy --no-pager
journalctl -u proxmox-backup-proxy --since today --no-pager
findmnt
lsblk -f
df -h
```

## Recovery Procedure

1. Identify whether the failure affects one file, one application, one VM, or the entire host.
2. Select the newest known-good snapshot before the incident.
3. Restore to a new VM ID when validation is needed without overwriting the original.
4. Confirm network settings, guest boot, services, and application data.
5. Only retire the damaged VM after the restored copy is verified.
6. Record the failure and recovery outcome.

## Skills Demonstrated

- Proxmox Backup Server deployment
- Datastore and filesystem management
- API-token permissions
- TLS fingerprint validation
- Retention, pruning, and verification
- Restore testing and disaster recovery
- Backup-window coordination
- Troubleshooting recursive dependencies

## Private Data Excluded

Datastore names, exact storage paths, token IDs and secrets, certificate fingerprints, hostnames, IP addresses, encryption material, backup contents, and task logs are excluded.