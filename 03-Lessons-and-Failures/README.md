# Lessons and Failures

Failures are included because they show how the environment and my engineering process improved.

## Underestimating Memory Growth

The server began with 16 GB of RAM and was upgraded to 32 GB. That was enough to build the first version of the lab, but game servers, infrastructure services, Windows labs, and containers quickly made memory the main capacity constraint.

### Lesson

Resource planning should consider future concurrency, not only whether one workload can run today. If rebuilding the platform, I would choose 64 GB or a clearer upgrade path.

## Underestimating Storage Requirements

The first storage design used available SSDs because the budget was limited and I did not yet know how heavily the server would be used. VM disks, game worlds, backups, logs, ISO images, and application data grew much faster than expected.

### Lesson

Production data, VM storage, and backups need separate capacity and recovery plans. My future design includes RAID-backed NAS storage with large-capacity drives rather than relying on a small collection of independent SSDs.

## Intermittent Backup SSD Disconnects

One of the hardest problems involved a backup SSD passed through or mounted for Proxmox Backup Server. The device would disconnect unpredictably, causing backup jobs and PBS automation to fail.

The issue was difficult because:

- it could run correctly for days,
- restarting often made it appear fixed,
- it did not fail on demand,
- and the available logs did not clearly identify the cause.

Troubleshooting required weeks of changing one variable, waiting, recording results, and testing different passthrough and mount designs.

The final solution was to redesign how the storage device was presented and mounted between Proxmox and the guest.

### Lesson

Intermittent faults require patience and controlled testing. A temporary recovery is not proof of a fix. Capture state, change one variable, and allow enough observation time to validate the result.

## Hardware Passthrough Complexity

Hardware passthrough introduced instability and made it easy to blur the boundary between host hardware ownership and guest access.

### Lesson

Passthrough should be used only when the guest truly needs direct hardware access. Storage and GPU assignments need a clear ownership model, tested rollback path, and documentation of the host configuration.

## Grouping Unrelated Game Servers

Running more than one game server in the same VM reduced operating-system overhead, but it also combined their failure and maintenance domains. Restarting the VM while working on one Minecraft server disconnected players using another server.

### Lesson

Workloads should be grouped by shared lifecycle, not merely because they are all games. A management platform such as AMP may simplify hosting, but maintenance impact must still be considered.

## Overengineering Short-Lived Services

The Cozy Zen server received extensive custom automation, which was valuable as a learning project. It also demonstrated that a temporary server for one user does not always justify hours of additional engineering.

### Lesson

The expected lifespan and operational importance of a workload should determine how much automation, monitoring, and documentation it receives.

## Backup Jobs Are Not the Same as Recovery

Early backup work focused heavily on making scheduled jobs succeed. Later failures showed that a completed job is only useful if the archive can be validated and the workload can be restored.

### Lesson

A backup strategy must include restore procedures, test restores, ownership correction, staging, rollback copies, and clear verification steps.

## What These Failures Changed

These experiences changed my approach from quick deployment followed by reactive fixes to deliberate planning:

- identify failure domains,
- design recovery before automation,
- leave capacity for growth,
- avoid unnecessary passthrough,
- validate backups through restoration,
- and match engineering effort to project lifespan.
