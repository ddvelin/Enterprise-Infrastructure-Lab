# Pulse Proxmox Monitoring Lab

## Why I Built It

As the number of VMs, containers, backups, and game servers increased, checking each guest individually became slow and easy to neglect. Pulse was added to provide a central operational view of the Proxmox environment and help answer the first incident-response question quickly: what is down or under pressure right now?

Pulse complements, rather than replaces, Proxmox metrics, Netdata, service logs, and application-specific checks.

## Role in the Lab

```text
Proxmox nodes and guests
        |
        v
Pulse monitoring view
        |
        +-- availability overview
        +-- CPU and memory pressure
        +-- storage and guest status
        +-- fast triage before deeper investigation
```

## Design Reasoning

### Centralize the first look

The monitoring dashboard reduces the need to open every guest or remember every IP address during an incident.

### Keep monitoring separate from the workload being observed

Monitoring is most useful when it does not disappear with the first application failure. Pulse was treated as an infrastructure service instead of being installed inside a game-server VM.

### Use multiple layers of evidence

Pulse can show that a VM is running or using resources, but application health still requires systemd status, ports, logs, RCON, HTTP checks, or game-client testing. The lab intentionally avoids equating VM uptime with service health.

## Problems Encountered and Fixes

### A running VM did not guarantee a healthy application

Game-server incidents showed that the guest could be online while the game port or service was unavailable. The fix was to pair Pulse with service-level watchdogs and dashboards.

### Monitoring credentials require careful scope

Proxmox monitoring integrations should use the least privilege needed for visibility. Tokens and credentials were kept out of code and documentation.

### Alert noise can hide useful events

The broader automation design favors state-change notifications and meaningful thresholds instead of sending a message for every successful check. This same principle guides how monitoring data is reviewed.

### Metrics needed correlation with maintenance windows

CPU, memory, or network spikes are not automatically faults. Backup jobs, Ansible patching, server startup, and world generation can all create expected load. The troubleshooting process correlates metrics with scheduled work before changing resources.

## Triage Workflow

1. Check Pulse for node and guest status.
2. Check Proxmox task history for backups, migrations, or failed operations.
3. Check the affected guest's systemd services.
4. Check application ports and logs.
5. Compare the incident time with PBS and Ansible schedules.
6. Restart only the affected non-critical service when evidence supports it.
7. Restore from PBS when recovery is safer than continued repair.

## Useful Supporting Commands

```bash
# Proxmox host
pvesh get /cluster/resources
pvesh get /nodes
pvesm status

# Linux guest
systemctl --failed
journalctl -p err --since today
free -h
df -h
ss -lntup
```

## Skills Demonstrated

- Infrastructure monitoring design
- Proxmox resource visibility
- Alert-noise reduction
- Metric correlation
- Layered application-health validation
- Incident triage and escalation

## Private Data Excluded

API tokens, node names, guest names where sensitive, IP addresses, dashboard URLs, authentication details, screenshots containing internal topology, and real alert history are excluded.