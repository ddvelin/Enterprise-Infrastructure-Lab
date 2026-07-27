# Proxmox Virtualization Platform

> The Proxmox Virtualization Platform serves as the foundation of my Enterprise Infrastructure Lab. Every infrastructure service, monitoring system, automation workflow, and hosted application runs on this platform.

---

# Overview

This platform was built to provide a production-style environment for learning enterprise infrastructure, Linux administration, networking, virtualization, automation, monitoring, and disaster recovery.

Originally created to expand beyond the limitations of school-provided virtual machines, it has evolved into a continuously improving homelab supporting multiple infrastructure services and hosted applications.

The platform is designed around five core principles:

- Reliability
- Security
- Automation
- Scalability
- Documentation

Every new service follows a standardized deployment workflow that includes monitoring, backups, static IP addressing, firewall configuration, and documentation before it is considered production-ready.

---

# Network Architecture

The Proxmox host uses a single Intel I219-V Gigabit Ethernet adapter connected to the managed office switch.

## Physical Interface

| Property | Value |
|---|---|
| Interface | `eno1` |
| Adapter | Intel I219-V Gigabit Ethernet |
| Link Speed | 1 Gbps |
| Duplex | Full Duplex |
| Switch Connection | Netgear managed switch |
| Host Operation | Headless |

The physical interface provides the network uplink for the Proxmox host and all hosted virtual machines and Linux containers.

## Virtual Bridge

Proxmox uses the Linux bridge `vmbr0` as the primary virtual network switch.

```text
Physical Network
       │
       ▼
Intel I219-V NIC
     eno1
       │
       ▼
Linux Bridge
     vmbr0
       │
       ├── Virtual Machines
       └── Linux Containers
```

Virtual machines and containers connect to `vmbr0`, allowing them to communicate with the local network through the host's physical Ethernet interface.

Although Proxmox may report virtual interfaces at higher internal link speeds, the external network connection is limited by the physical 1 Gbps Ethernet adapter and managed switch.

## Addressing Strategy

The Verizon router currently provides DHCP services for the home network.

New virtual machines and containers follow this provisioning process:

1. Receive an initial DHCP address.
2. Verify local and Internet connectivity.
3. Install operating system updates.
4. Assign a static address inside the guest operating system.
5. Reserve and label the address in the router.
6. Configure the system hostname.
7. Apply firewall rules.
8. Add monitoring and backup coverage.

Static addressing is used for infrastructure systems because consistent addresses simplify administration, monitoring, firewall configuration, DNS management, and troubleshooting.

## Current Network Segmentation

All hosted systems currently operate on the same local subnet.

This design was selected because the current topology is small and does not yet require VLAN separation. Future plans include creating separate networks for:

- Management
- Infrastructure servers
- Workstations
- IoT devices
- Guest wireless devices

## Remote Management

The Proxmox management interface is accessible from the local network and through Twingate Zero Trust access.

Twingate provides authenticated remote connectivity without exposing the Proxmox web interface or SSH service directly to the public Internet.

## Network Security

The network design follows a default-deny philosophy.

Current controls include:

- Proxmox Datacenter firewall rules
- Node-level firewall rules
- Individual VM and LXC firewall rules
- Restricted management access
- Static infrastructure addressing
- Twingate for remote administration
- Playit.gg tunnels for selected public game services
- No direct public exposure of the Proxmox management interface

## Current Limitations

- Single physical network adapter
- 1 Gbps external network connection
- No VLAN segmentation yet
- No redundant network path
- ISP router limits advanced routing features

## Future Improvements

- Add a dedicated OPNsense firewall
- Introduce VLAN segmentation
- Upgrade to a multi-port or 10 Gbps network adapter
- Add a 24-port managed switch
- Separate management and server traffic
- Add redundant network connectivity where practical
