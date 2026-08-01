# Pi-hole and Unbound DNS Lab

## Why I Built It

The homelab needed a dependable internal DNS service that could block unwanted domains, provide visibility into client queries, and reduce dependence on a third-party upstream resolver. Pi-hole was selected for filtering and management, while Unbound was added as a local recursive resolver.

This service was kept separate from game-server workloads because DNS is foundational. A game server can be powered off without consequence, but a DNS outage can make the entire network appear broken.

## Architecture

```text
LAN clients
    |
    v
Router DHCP advertises Pi-hole
    |
    v
Pi-hole filtering and query logging
    |
    v
Unbound recursive resolver on localhost
    |
    v
Authoritative DNS hierarchy
```

## What Was Implemented

- Pi-hole hosted in a lightweight Proxmox guest.
- A stable address assigned through the network's address-management plan.
- Unbound used as the upstream recursive resolver.
- DNS service configured to start automatically.
- Proxmox firewall rules designed to permit required LAN DNS traffic while keeping management access private.
- Twingate used for remote administration rather than publicly exposing the web interface or SSH.
- The guest included in Proxmox Backup Server protection.

## Operational Reasoning

### Keep DNS lightweight and always on

Pi-hole and Unbound use few resources, so the guest can remain online continuously. Keeping the resolver independent from the Docker and game environments prevents unrelated maintenance from interrupting name resolution.

### Use recursive resolution locally

Unbound avoids forwarding every query to a single public resolver. Pi-hole still provides filtering and reporting, while Unbound performs the resolver work locally.

### Avoid public management exposure

The web console and SSH are intended for LAN or Twingate access only. DNS service ports are available where required, but administration interfaces are not internet-facing.

## Problems Encountered and Fixes

### DNS failures looked like complete internet outages

When a resolver is unavailable, clients may still have network connectivity but cannot resolve names. Troubleshooting was standardized to separate routing from DNS:

```bash
ping -c 3 1.1.1.1
getent hosts example.com
dig @PIHOLE_ADDRESS example.com
dig @127.0.0.1 -p 5335 example.com
```

If direct IP connectivity works but name resolution fails, the investigation stays focused on Pi-hole, Unbound, firewall rules, and client DNS settings.

### Firewall hardening can block DNS accidentally

With a default-drop firewall model, DNS must be explicitly allowed from the intended network. The fix was to verify both UDP and TCP DNS access and keep management rules separate from resolver rules.

### A single resolver creates a dependency

The lab currently prioritizes simplicity, but the documentation records the DNS guest as a critical dependency. Backups and a recovery procedure are therefore more important than they would be for a disposable application VM.

## Validation and Recovery

```bash
systemctl status pihole-FTL --no-pager
systemctl status unbound --no-pager
ss -lntup | grep -E ':(53|5335)\b'
pihole status
dig @127.0.0.1 example.com
dig @127.0.0.1 -p 5335 example.com
```

Recovery order:

1. Confirm the guest has network connectivity.
2. Confirm Pi-hole FTL and Unbound are active.
3. Test Unbound directly.
4. Test Pi-hole directly.
5. Confirm firewall rules permit DNS from the LAN.
6. Confirm the router or DHCP service is advertising the correct resolver.
7. Restore the guest from PBS if configuration recovery is faster than repair.

## Skills Demonstrated

- Linux DNS administration
- Recursive resolver design
- Network dependency analysis
- Proxmox firewall troubleshooting
- Service validation with systemd, `dig`, and socket inspection
- Backup and recovery planning
- Secure remote administration

## Private Data Excluded

No real IP addresses, local domain names, DHCP details, client query history, passwords, SSH keys, or Twingate resource information are included.