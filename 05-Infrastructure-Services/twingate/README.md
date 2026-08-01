# Twingate Zero-Trust Remote Access Lab

## Why I Built It

The homelab needed reliable remote administration without exposing Proxmox, SSH, dashboards, or internal web applications directly to the internet. Twingate was selected to provide authenticated access to private resources through an outbound connector.

The connector became the preferred route for remote SSH sessions, Proxmox management, and internal service access. Public game traffic remained on Playit.gg because game clients need a simple public endpoint, while management traffic stayed private through Twingate.

## Architecture

```text
Remote administrator
       |
       v
Twingate client and identity policy
       |
       v
Twingate cloud coordination
       |
       v
Outbound-only connector in Proxmox guest
       |
       v
Approved private resources on the LAN
```

## What Was Implemented

- A dedicated lightweight Linux container for the connector.
- Outbound connector communication with no inbound router port-forward requirement.
- Private resources defined for selected management interfaces and SSH targets.
- Twingate used from Termius and other client devices to reach internal systems.
- Proxmox firewall rules adjusted so connector-originated access could reach approved services.
- Connector availability monitored as part of the homelab's operational checks.

## Design Reasoning

### Separate management access from public game access

Playit.gg was used for game protocols, but it was not used to expose SSH, RCON, Proxmox, or administrative dashboards. Twingate kept management traffic behind user authentication and resource policy.

### Use a dedicated connector guest

A small dedicated guest limits the blast radius. Rebuilding the connector does not require modifying Pi-hole, Docker, game-server, or backup workloads.

### Prefer outbound connectivity

The connector initiates outbound sessions, reducing the need for public firewall rules and avoiding direct exposure of sensitive management services.

## Problems Encountered and Fixes

### Remote SSH worked only when the resource definition matched the target

Access problems were often caused by an incorrect private resource, address, protocol, or policy rather than SSH itself. The troubleshooting order became:

1. Confirm the connector is online.
2. Confirm the client is authenticated.
3. Confirm the requested host is included in a Twingate resource.
4. Confirm the user has access to that resource.
5. Confirm the target service is listening.
6. Confirm the Proxmox or guest firewall allows the connector path.

### Firewall default-drop rules interrupted connector traffic

After firewall hardening, management traffic had to be explicitly permitted. The fix was to identify the source path and add narrow rules rather than broadly disabling the firewall.

### Connector dependency during remote incidents

If the connector guest is down, remote administration is unavailable even if the target VM is healthy. The connector was therefore configured for automatic startup and included in backup and monitoring plans.

## Validation Commands

```bash
systemctl status twingate-connector --no-pager
journalctl -u twingate-connector --since "30 minutes ago" --no-pager
ip route
ss -lntup
ping -c 3 PRIVATE_TARGET
```

Service names can vary by installation, so the deployed unit name should be confirmed locally rather than copied blindly.

## Security Decisions

- No public SSH or Proxmox port forwarding.
- SSH key authentication used on managed Linux guests.
- Twingate resource access scoped to required systems.
- Connector tokens and deployment commands kept outside the repository.
- RCON and other administrative ports were not published as Twingate examples or Playit tunnels.

## Skills Demonstrated

- Zero-trust remote access concepts
- Network-path and firewall troubleshooting
- Linux container administration
- Identity-based resource access
- Separation of management and application traffic
- Secure SSH operations

## Private Data Excluded

Tenant names, network IDs, connector tokens, deployment tokens, resource names, IP addresses, hostnames, user identities, and access policies are not included.