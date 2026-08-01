# Engineering Principles

This section documents how I plan, build, automate, troubleshoot, and decide when a project is complete.

## Plan Before Deployment

My early approach was to create a VM, install the application, and solve everything else afterward. That worked for learning, but it often made later changes harder than they needed to be.

Before deploying a new service, I now ask:

- What problem is this solving?
- How long is the project expected to live?
- What CPU, memory, storage, and network constraints exist?
- Should it be a VM, container, or application inside an existing host?
- What is the failure domain?
- How will it be accessed remotely?
- Does it need public exposure, Twingate, Playit.gg, or no external access?
- What data must be backed up?
- What should be monitored?
- Does the application already provide scheduling and automation?
- What is the simplest design that satisfies the real requirement?

An extra hour spent planning can prevent many hours of redesign and troubleshooting.

## Isolation by Failure Domain

Virtual machines should not only separate applications. They should separate failures.

When deciding whether services belong together, I consider:

- whether they share the same purpose,
- whether they should be online at the same time,
- whether they have similar maintenance windows,
- and who or what is affected if the VM stops.

A game-server maintenance reboot should not take down DNS or remote administration. Likewise, a test environment should not create risk for backups or persistent applications.

## Automation Philosophy

Automation should solve real problems rather than create new ones.

I evaluate a task based on:

1. how often it must be performed,
2. how long it takes,
3. how likely manual inconsistency is,
4. and whether failure can be detected and reported.

Frequent, repetitive tasks such as backups, health checks, cleanup, patching, restart procedures, and reporting are strong candidates.

Built-in application features are preferred when they are reliable and meet the requirement. Custom scripts are useful when they add needed control, visibility, validation, or recovery behavior.

> My goal is not to automate everything. My goal is to automate the right things.

Useful automation should:

- run without constant attention,
- log what it changed,
- verify the result,
- avoid unlimited recovery loops,
- and notify me when manual intervention is required.

## Troubleshooting Philosophy

Intermittent problems taught me to avoid changing many variables at once.

My general process is:

1. Define the exact symptom.
2. Identify the affected layer: hardware, host, guest, network, service, or application.
3. Capture logs and state before restarting anything.
4. Change one variable.
5. Record the change and result.
6. Reproduce or wait for recurrence.
7. Roll back unsuccessful changes.
8. Document the final cause and fix.

The goal is not merely to make the symptom disappear. It is to understand why it occurred and how to prove the repair worked.

## Definition of Done

A project is complete when it reliably performs its intended function, is maintainable, and leaves a practical path for future changes.

The expected lifespan determines how much engineering effort is appropriate.

A temporary game server used for a few weeks does not require the same automation and documentation as DNS, backups, monitoring, or the hypervisor itself.

A completed project should be:

- reliable enough for its purpose,
- recoverable from expected failures,
- documented well enough to revisit later,
- maintainable without unnecessary complexity,
- and expandable without a full rebuild when reasonable.

> I no longer try to make every project perfect. I try to make every project appropriate for its purpose.

## Security and Privacy Standard

Public documentation must never include:

- passwords, keys, tokens, or webhook URLs,
- internal or public IP addresses,
- private DNS names,
- Twingate or Playit deployment identifiers,
- player names or UUIDs,
- real inventories or backup data,
- application volumes and production logs,
- or copyrighted server binaries, game files, and modpacks.

Examples use placeholders and preserve only the technical pattern needed to demonstrate the work.
