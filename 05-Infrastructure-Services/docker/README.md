# Docker Application Host Lab

## Why I Built It

The homelab needed a place to test and run containerized applications without installing every application directly into a critical infrastructure guest. A dedicated Docker environment was created so tools could be added, updated, removed, or rebuilt without affecting DNS, remote access, backups, or game-server VMs.

The environment has hosted applications such as Portainer, n8n, and Dashy. Its purpose is both practical application hosting and hands-on container administration.

## Architecture

```text
Proxmox VE
    |
    v
Dedicated Docker Linux guest
    |
    +-- Docker Engine
    +-- Portainer management
    +-- n8n automation workflows
    +-- Dashy internal dashboard
    +-- persistent application volumes
```

## What Was Implemented

- Dedicated Linux guest for Docker workloads.
- Docker Engine and Compose-style application definitions.
- Portainer for container and stack visibility.
- n8n for workflow experimentation and automation.
- Dashy as an internal service dashboard.
- Persistent volumes separated from disposable container layers.
- Twingate used for remote management access.
- Proxmox Backup Server used to protect the guest.
- Netdata/Pulse/Proxmox metrics used to observe host impact.

## Design Reasoning

### Keep experiments away from critical services

Containers are easy to deploy, which also makes it easy to deploy something misconfigured. A separate application guest prevents a failed image, bad environment file, port collision, or runaway container from directly taking down Pi-hole, Twingate, or PBS.

### Keep persistent data explicit

Containers are replaceable; application data is not. Volumes and bind mounts were treated as the recovery target while images could be downloaded again.

### Use Portainer as a convenience layer, not the only source of truth

Portainer improves visibility, but Docker CLI and Compose files remain important for troubleshooting and repeatability.

## Problems Encountered and Fixes

### Application and port collisions

Multiple internal applications may default to the same host ports. The fix was to document port assignments and change published ports rather than disabling unrelated services.

Useful checks:

```bash
docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
ss -lntup
docker compose config
```

### Container data appeared missing after recreation

This reinforced the difference between a container's writable layer and persistent volumes. Applications were changed to use named volumes or explicit bind mounts before being considered durable.

### A container could be healthy while the application was not usable

A running process is not always a working service. Validation expanded from `docker ps` to logs, listening ports, HTTP checks, and application-level login tests.

```bash
docker logs --tail 100 CONTAINER_NAME
docker inspect CONTAINER_NAME
curl -I http://127.0.0.1:PORT
```

### Privileged-container and nesting considerations

Running Docker inside a Proxmox container can require nesting and careful permissions. The lab treated these settings as a tradeoff: LXC is resource-efficient, but a VM provides stronger compatibility and isolation. The documentation preserves that decision point for future rebuilds.

### Updates could break dependencies

Images were not updated blindly across every stack at once. The safer workflow became:

1. Review the current stack and volumes.
2. Confirm a recent PBS backup.
3. Pull the intended image.
4. Recreate one stack.
5. Inspect logs and test the application.
6. Roll back the image tag or restore if necessary.

## Operations

```bash
docker version
docker info
docker ps -a
docker stats --no-stream
docker system df
docker compose ls
docker volume ls
journalctl -u docker --since today --no-pager
```

## Backup and Recovery

PBS protects the full Docker guest. For important applications, Compose definitions and sanitized configuration examples should also be version-controlled, while real `.env` files and volume contents remain private.

Recovery priorities:

1. Restore the guest when the platform is damaged.
2. Restore persistent volumes or bind-mounted data when one application is damaged.
3. Recreate containers from Compose definitions.
4. Verify application authentication, workflows, and integrations.

## Skills Demonstrated

- Docker and container lifecycle management
- Persistent storage design
- Port and process troubleshooting
- Compose configuration
- Application isolation
- Backup and recovery planning
- Secure remote management
- Resource monitoring

## Private Data Excluded

Environment files, API keys, passwords, workflow credentials, webhook URLs, private hostnames, IP addresses, application databases, volumes, and logs are excluded.