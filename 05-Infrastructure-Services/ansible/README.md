# Ansible Maintenance Automation Lab

## Why I Built It

Maintaining multiple Linux guests manually created several problems:

- updates were easy to postpone,
- commands were repeated inconsistently,
- failures were discovered late,
- and it was difficult to prove which systems had been patched successfully.

Ansible was introduced to provide one controlled maintenance workflow for non-critical Linux guests. The goal was not blind automation. The goal was a repeatable process that checks readiness, applies updates, verifies health, attempts limited recovery, records results, and reports what needs attention.

## Operating Schedule

The maintenance window was designed around the backup schedule:

```text
02:00 - environment expected to be idle
04:00 - Proxmox Backup Server jobs run
06:00 - Ansible patch-and-verify workflow runs
```

A recent backup exists before patching begins, reducing the risk of unattended changes.

## Architecture

```text
Ansible control host
       |
       +-- SSH key authentication
       |
       +-- inventory groups
       |
       +-- pre-checks
       +-- package updates
       +-- reboot decision
       +-- service verification
       +-- one limited recovery attempt
       +-- local result report
       +-- Discord summary
       |
       v
Managed Ubuntu/Debian guests
```

## What Was Automated

- Connectivity and privilege checks.
- Disk-space validation before upgrades.
- Package-cache refresh.
- Safe package upgrades.
- Reboot detection.
- Controlled reboot with wait-for-connection.
- Post-update service verification.
- One automatic recovery attempt for selected non-critical services.
- Per-host success/failure results.
- Local text reporting.
- Discord webhook summary.

## Design Reasoning

### Back up first, patch second

The update schedule intentionally follows PBS. Automation is safer when a recent recovery point exists.

### Separate essential and non-essential systems

Not every guest should be treated identically. DNS, remote access, PBS, and the Ansible control path require more caution than a disposable application VM. Inventory groups and maintenance scopes prevent a single broad play from treating every workload as equally safe to restart.

### Verify services after package success

`apt` returning success only proves package management completed. The playbook also checks that expected services are active and that the guest reconnects after a reboot.

### Attempt recovery only once

Unlimited restart loops can hide the original fault and make incidents worse. The workflow attempts one repair or restart for approved services, verifies again, and then reports failure for manual intervention.

### Report useful changes, not noise

Discord reporting was used for the maintenance result rather than sending a message for every individual task. The goal is a summary showing which hosts changed, rebooted, recovered, or failed.

## Problems Encountered and Fixes

### SSH and privilege assumptions caused inconsistent runs

A managed host may be reachable but still fail because the expected user, SSH key, or `sudo` permissions are wrong. The playbook includes early connectivity and privilege checks so it fails before making partial changes.

### Reboots broke the middle of the play

Package upgrades can require a reboot. The workflow was changed to detect the reboot marker, reboot intentionally, wait for SSH to return, and then continue verification.

### A host was updated but its application stayed unhealthy

Package status alone was insufficient. Post-update checks were added for expected systemd units and, where appropriate, listening ports or application responses.

### Automation could overlap with backups or active game sessions

The maintenance window was scheduled after PBS and during expected idle time. Game servers and other workloads that should not be interrupted can be excluded, placed in a different group, or handled with a dedicated playbook.

### Notifications risked exposing secrets

The Discord webhook remains in an encrypted or local secret source and is represented publicly only as a placeholder. Reports avoid including private IP addresses, tokens, passwords, or full logs.

### A failed service could trigger repeated restarts

Recovery was capped at one attempt. After that, the result is marked failed and escalated rather than creating an endless loop.

## Example Workflow

The repository includes a sanitized [`patch-and-verify.yml`](patch-and-verify.yml) example. It demonstrates the structure without including the real inventory, usernames, service list, or webhook.

## Troubleshooting Order

1. Run Ansible ping against the affected inventory group.
2. Confirm SSH key authentication manually.
3. Confirm passwordless or expected `sudo` behavior.
4. Review free disk space and package-manager locks.
5. Run the playbook with increased verbosity against one host.
6. Review systemd failures and package logs on the guest.
7. Restore from PBS if the update caused a serious regression.

```bash
ansible all -m ping
ansible-playbook patch-and-verify.yml --limit example-host -vv
ansible example-host -b -m shell -a 'systemctl --failed --no-pager'
ansible example-host -b -m shell -a 'journalctl -p err --since today --no-pager'
```

## Skills Demonstrated

- Ansible inventories and playbooks
- SSH key automation
- Privilege escalation
- Debian/Ubuntu package management
- Conditional reboots
- Post-change verification
- Limited automated recovery
- Maintenance-window design
- Backup and change coordination
- Secret handling and reporting

## Private Data Excluded

Inventory IPs and hostnames, SSH usernames and keys, vault passwords, webhook URLs, real service lists, internal paths, reports, and logs are excluded.