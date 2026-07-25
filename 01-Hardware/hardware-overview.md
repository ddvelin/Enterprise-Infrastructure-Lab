# Hardware Overview

## Purpose

This lab was built to provide a safe, hands-on environment for learning virtualization, Linux administration, networking, monitoring, automation, backup operations, and recovery procedures. The design prioritizes reliability, security, and the ability to test changes without affecting school or production systems.

## Proxmox Host

| Component | Current Hardware | Role |
|---|---|---|
| Processor | Intel Core i7-8700K | Runs the Proxmox VE host and supports multiple concurrent virtual machines and services |
| Memory | 32 GB DDR4 | Allocated across infrastructure, monitoring, automation, Docker, and hosted server workloads |
| Primary Storage | 1 TB NVMe SSD | Stores Proxmox VE workloads, virtual machines, containers, and active application data |
| Backup Storage | 256 GB NVMe SSD | Dedicated backup location separated from primary VM storage |
| Graphics | NVIDIA GeForce RTX 3060 Ti | Used for hardware passthrough testing and local AI workload experiments |
| Hypervisor | Proxmox VE | Provides centralized virtual machine and container management |

## Network Hardware

| Component | Current Hardware | Configuration and Use |
|---|---|---|
| Router | Verizon-provided ISP router | Provides internet access, DHCP services, and the routing features available through the ISP interface |
| Managed Switch | Netgear 5-port managed Gigabit Ethernet switch | Connects the main workstation and Proxmox host while providing port management, QoS, link-speed configuration, and traffic prioritization |
| Structured Link | Long-run shielded Ethernet cable sold and labeled as Cat6e | Provides a wired uplink between the ISP router and office switch; selected for added resistance to electromagnetic interference and future network-speed headroom |
| Connected Systems | Main workstation and Proxmox server | Currently uses a simple two-device switched topology while leaving room for future expansion |

> **Cabling note:** Cat6e is a vendor-used label rather than a formally recognized TIA cabling category. The installed cable is documented by its purchased label and shielding characteristics. Current throughput is limited by the Gigabit Ethernet interfaces on the router and managed switch.

## Current Switch Configuration

The managed switch was selected instead of an unmanaged model so that network behavior could be observed and controlled directly.

Current configuration includes:

- Port management for the connected server and workstation
- Higher traffic priority for the Proxmox server
- QoS configuration within the capabilities of the switch
- Link-speed settings based on connected device requirements
- Static addressing for infrastructure systems
- Bandwidth planning that preserves overhead for other network traffic

Loop protection, broadcast control, and larger MAC-address management workflows are not currently required because the switch is operating with a very small topology. These features are part of the planned design for a future rack-mounted environment with additional devices and switch ports.

## Storage and Recovery Design

The primary and backup workloads are separated so that a failure of the main VM storage does not automatically remove the most recent local recovery point.

The broader recovery strategy includes:

- Primary virtual machine storage on the 1 TB NVMe SSD
- Proxmox Backup Server storage on a separate 256 GB NVMe SSD
- Scheduled backup jobs before automated maintenance begins
- Daily, weekly, and monthly retention policies
- Additional copies maintained outside the primary storage location as part of a 3-2-1-inspired backup strategy

## Design Decisions

### Repurposed Hardware

The server was built from repurposed desktop hardware to create a capable virtualization platform without the initial cost of enterprise server equipment. The i7-8700K provides six physical cores and twelve threads, which is sufficient for the current mix of Linux servers, monitoring systems, automation tools, and test workloads.

### Managed Switching

A managed switch was chosen to provide practical experience with port configuration, traffic priority, QoS, link settings, and network growth planning. Even though the current topology is small, the hardware supports learning concepts that would not be available on an unmanaged switch.

### Separate Backup Storage

Backup data is stored separately from the active virtual machine disk. This reduces the risk of losing both the production workload and its most recent local backup during a single primary-storage failure.

### Rental-Friendly Design

The current lab is designed around the physical limitations of a rented property. It avoids permanent building modifications while still using a dedicated wired connection between the router and office equipment.

## Current Limitations

- No rack-mounted enclosure yet
- No UPS currently installed
- Limited physical switch-port capacity
- ISP router limits advanced routing and firewall options
- No permanent structured cabling throughout the property
- Current backup SSD capacity limits long-term local retention

These limitations are documented because understanding constraints and planning around them is part of the project.

## Planned Upgrades

Future expansion is expected to include:

- Open-frame or enclosed server rack
- Rack-mounted UPS with graceful shutdown support
- 24-port managed switch
- Patch panel and labeled structured cabling
- Dedicated OPNsense or pfSense firewall
- VLAN segmentation for management, servers, workstations, IoT, and guest traffic
- Expanded backup storage or a dedicated NAS/TrueNAS system
- Additional monitoring for power, storage health, and network availability

## Skills Demonstrated

- Hardware selection and repurposing
- Virtualization capacity planning
- Managed switch administration
- QoS and port-priority configuration
- Static IP planning
- Backup-storage separation
- Recovery-oriented infrastructure design
- Network growth planning
- Documentation of technical constraints and future improvements

---

This page will be updated as the lab moves from a rental-friendly desktop setup into a larger rack-mounted infrastructure environment.