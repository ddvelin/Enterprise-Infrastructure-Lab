# Infrastructure Architecture

## Document Purpose

This document provides an overview of the current and planned architecture of my Enterprise Infrastructure Lab. It describes the physical layout, logical topology, security model, service-provisioning workflow, design decisions, current limitations, and long-term expansion plans.

The lab is designed to simulate many of the responsibilities found in a small enterprise environment while remaining practical within the constraints of a rented home. The primary goals are reliability, security, maintainability, automation, scalability, and clear documentation.

## Design Philosophy

Every infrastructure decision is evaluated against six principles:

- **Reliability** — Services should remain available whenever practical, and failures should be recoverable.
- **Security** — Administrative access should be authenticated and protected through layered controls rather than unnecessary public exposure.
- **Maintainability** — Systems should follow repeatable deployment and troubleshooting processes.
- **Automation** — Repetitive maintenance should be automated where practical to improve consistency.
- **Scalability** — The design should support future growth without requiring a complete rebuild.
- **Documentation** — Major components, dependencies, limitations, and recovery procedures should be recorded.

The goal is not to create the most complicated network possible. The goal is to maintain a stable environment that can expand over time without sacrificing visibility or control.

## Current Physical Topology

```text
                                    Internet
                                        |
                                        v
                             Verizon CR1000A Router
                      (DHCP, NAT, Internet Gateway, Wi-Fi)
                                        |
                 +----------------------+----------------------+
                 |                                             |
                 v                                             v
       Separate Network Access Point                  Long Cat6e-Labeled Run
                 |                                             |
                 v                                             v
          Fiancee's Desktop                         Netgear Managed Switch
                                                               |
                                        +----------------------+------------------+
                                        |                                         |
                                        v                                         v
                               Main Gaming PC                              Proxmox Host
```

### Physical Design Notes

- The Verizon router currently provides routing, NAT, DHCP, and wireless connectivity.
- A separate network access point provides a wired connection for another household desktop.
- A long cable sold and labeled as Cat6e connects the router area to the office switch. It was selected for interference resistance and future speed headroom.
- The Netgear five-port managed switch currently connects the primary workstation and Proxmox host.
- The Proxmox host uses one physical Ethernet interface.

> **Cabling note:** Cat6e is a vendor designation rather than an official TIA cabling category. The currently installed router and switch ports are Gigabit Ethernet, so they are the practical link-speed limit in the present design.

## Current Logical Topology

```text
Proxmox Host
|
+-- Infrastructure Services
|   +-- Pi-hole DNS filtering
|   +-- Twingate Connector
|   +-- Docker application-testing environment
|   +-- Proxmox Backup Server
|
+-- Monitoring Services
|   +-- Pulse LXC
|   +-- Netdata on the Proxmox host
|
+-- Hosted Application Services
    +-- Minecraft server VM
    +-- Palworld server VM
    +-- Enshrouded server VM
```

All current VMs and LXCs share the same local subnet and connect through the Proxmox Linux bridge. VLAN segmentation is planned for the future environment but is not currently required for the small physical topology.

## Addressing and Name Management

New virtual machines initially receive an address from router-based DHCP so connectivity can be verified immediately. After validation, infrastructure systems are assigned a permanent address and a recognizable name.

### Standard Addressing Workflow

1. Deploy the VM or LXC.
2. Allow router DHCP to assign an initial lease.
3. Verify local and Internet connectivity.
4. Configure a static address inside the guest.
5. Record or reserve the address in the router interface.
6. Assign a recognizable hostname.
7. Apply firewall, monitoring, and backup settings.

Actual IP addresses, MAC addresses, tunnel endpoints, and sensitive hostnames are intentionally excluded from this public repository.

## Core Infrastructure Services

### Verizon CR1000A Router

**Purpose:** Provides the Internet gateway, NAT, DHCP, and household wireless access.

**Design decision:** DHCP intentionally remains on the router rather than on a VM. The lab does not yet have a UPS, so keeping DHCP at the network edge allows household devices to continue receiving network configuration if the Proxmox host is unavailable or powered down.

### Netgear Managed Switch

**Purpose:** Acts as the central wired aggregation point for the office.

**Current configuration includes:**

- Port management
- Higher traffic priority for the Proxmox host
- QoS features supported by the switch
- Link-speed configuration
- Bandwidth planning with remaining overhead
- Static infrastructure connections

Loop prevention, broadcast storm control, and larger MAC-address management workflows are not currently necessary because only a small number of devices are attached. These features are planned as the physical network expands.

### Pi-hole

**Purpose:** Provides network-wide DNS filtering and advertisement blocking for household devices.

**Current design:**

- Pi-hole is the primary DNS service used across the home network.
- The router continues to provide DHCP.
- Google Public DNS is currently used as the upstream resolver.
- Whether Unbound is enabled will be verified and documented later.
- A secondary DNS service on separate hardware is planned to reduce dependence on the Proxmox host.

### Twingate Connector

**Purpose:** Provides authenticated Zero Trust remote access to internal management resources.

The connector runs in a dedicated LXC. It allows approved remote access to the Proxmox interface and internal services without publishing their management interfaces through traditional router port forwarding. Resource access and permitted ports are restricted through both Twingate configuration and local firewall rules.

### Playit.gg Agents

**Purpose:** Publish selected game services without direct traditional port forwarding to the home network.

Each hosted game server uses its own Playit.gg agent. This provides independent tunnel management, easier fault isolation, and simpler troubleshooting for Minecraft, Palworld, and Enshrouded.

### Pulse

**Purpose:** Provides centralized visibility into the Proxmox environment and its virtual infrastructure.

Pulse runs in its own LXC so that monitoring remains logically separated from hosted application workloads.

### Netdata

**Purpose:** Collects detailed host-level performance and health metrics.

Netdata runs directly on the Proxmox host to provide current data on CPU, memory, storage, network activity, and other system metrics.

## Virtual Machine Provisioning Workflow

```text
Create VM or LXC
        |
        v
Receive DHCP Lease
        |
        v
Verify Local and Internet Connectivity
        |
        v
Install Updates and Required Packages
        |
        v
Assign Static Address and Hostname
        |
        v
Deploy Application or Infrastructure Service
        |
        v
Configure Firewall and Access Rules
        |
        v
Enable Monitoring
        |
        v
Add Backup Policy
        |
        v
Document the System
```

This workflow reduces configuration drift and ensures that systems are not considered complete until networking, security, monitoring, backup, and documentation have been addressed.

## Security Architecture

The environment uses a layered security approach:

- Default-deny firewall philosophy for unsolicited inbound traffic
- Outbound traffic allowed only as required by the service design
- Local-network access restricted by Proxmox and guest firewall rules
- Separate rules maintained for individual VMs and LXCs
- Static addressing used for infrastructure services
- Pi-hole provides centralized DNS filtering
- Twingate provides authenticated remote administration
- Playit.gg limits public exposure to selected game services
- Management interfaces are not intentionally exposed directly to the public Internet

The current model acts like a stateful one-way valve: approved outbound connections and their return traffic are allowed, while unsolicited inbound traffic is denied unless a specific service path has been authorized.

## Current Traffic Flows

### Household DNS

```text
Household Device -> Router-Provided Network Configuration -> Pi-hole -> Google Public DNS -> Internet DNS
```

### Remote Administration

```text
Authorized Remote Device -> Twingate -> Twingate Connector LXC -> Approved Internal Resource
```

### Hosted Game Access

```text
Remote Player -> Playit.gg Tunnel -> Game-Specific Agent -> Game Server VM
```

### Local Infrastructure Management

```text
Main Workstation -> Managed Switch -> Proxmox Host / Approved VM or LXC Service
```

## Important Design Decisions

### Why DHCP remains on the router

This avoids making the virtualization host a dependency for basic household network configuration, especially while the server does not have UPS protection.

### Why infrastructure services use static addresses

Stable addressing simplifies monitoring, firewall rules, service dependencies, remote access, backups, and troubleshooting.

### Why the environment currently uses one subnet

The current network has a small number of physical devices and one virtualization host. A single subnet keeps the present environment manageable. VLANs will be introduced when additional hardware and a dedicated firewall make segmentation operationally useful.

### Why Twingate is used for administration

Twingate provides authenticated, resource-specific access without exposing Proxmox or internal management interfaces directly to the public Internet.

### Why each game server has its own Playit.gg agent

Independent agents improve service isolation and make tunnel troubleshooting easier. A failure or configuration change affecting one server is less likely to affect the others.

### Why monitoring is separated by function

Pulse provides virtual-infrastructure visibility, while Netdata provides detailed host-level metrics. Using both offers a broader operational view than either tool alone.

## Current Limitations

- Single Proxmox host
- One physical network interface on the host
- One local subnet
- No rack-mounted UPS yet
- One primary Pi-hole DNS instance
- Limited managed-switch port count
- ISP router limits advanced firewall and routing options
- Rental-property restrictions limit permanent structured cabling
- Hosted workload capacity is limited by current CPU and memory resources

These limitations are documented deliberately. Understanding constraints and planning around them is part of the project.

## Planned Future Architecture

```text
Internet
   |
   v
ISP ONT
   |
   v
Dedicated OPNsense Firewall
   |
   v
24-Port Managed Switch
   |
   +-- VLAN 10: Management
   |     +-- Proxmox management
   |     +-- Switch management
   |     +-- Firewall management
   |
   +-- VLAN 20: Servers
   |     +-- Proxmox workloads
   |     +-- DNS
   |     +-- Monitoring
   |     +-- Hosted applications
   |
   +-- VLAN 30: Workstations and Gaming
   |
   +-- VLAN 40: IoT Devices
   |
   +-- VLAN 50: Guest Wireless
   |
   +-- Storage Infrastructure
   |     +-- TrueNAS
   |     +-- Proxmox Backup Server
   |
   +-- Wireless Access Points
         +-- Main SSID
         +-- IoT SSID
         +-- Guest SSID
```

### Planned Physical Improvements

- Server rack
- Patch panel and labeled structured cabling
- Rack-mounted UPS with graceful shutdown support
- 24-port managed switch
- Dedicated OPNsense firewall appliance
- Rack-mounted or rack-adapted Proxmox host
- TrueNAS system focused on storage and application data
- Secondary DNS service on separate hardware
- Additional backup capacity and off-site recovery options
- Ceiling-mounted access points when permanent installation becomes possible

### Planned Logical Improvements

- VLAN segmentation
- Inter-VLAN firewall policies
- Separate management and user traffic
- Dedicated server and storage networks
- Guest and IoT isolation
- Improved DNS redundancy
- Additional monitoring for switch, firewall, power, and storage health

## Skills Demonstrated

- Physical and logical network documentation
- Router, DHCP, DNS, and NAT concepts
- Static-address planning
- Managed-switch administration
- QoS and port-priority configuration
- Linux bridge networking in Proxmox
- Zero Trust remote access
- Stateful firewall design
- Network-wide DNS filtering
- Service publishing through secure tunnels
- Infrastructure monitoring
- Capacity and growth planning
- Documentation of operational constraints

## Lessons Learned

The network began as a simple router-and-server environment. As more infrastructure services were added, static addressing, standardized hostnames, separate firewall rules, centralized monitoring, and repeatable deployment steps became increasingly important.

The design also reinforced that additional complexity should solve a real operational problem. Features such as VLANs, loop prevention, broadcast control, and dedicated DHCP services are valuable, but they should be introduced when the network size, redundancy, and available hardware justify them.

## Future Documentation Improvements

- Replace text diagrams with draw.io architecture diagrams
- Add sanitized screenshots of switch, Proxmox, Pulse, and Netdata dashboards
- Verify and document whether Pi-hole uses Unbound
- Add a sanitized IP-addressing plan
- Document implemented VLANs when the future firewall and switch environment is built
- Link each logical service to the VM and LXC inventory
- Add recovery and dependency diagrams

---

This page is a living document and will be updated as the lab moves from its current rental-friendly design into a rack-mounted, segmented infrastructure environment.