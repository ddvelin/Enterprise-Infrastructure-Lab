# Enshrouded Operations Guide

## Service Commands

```bash
sudo systemctl status enshrouded --no-pager -l
sudo systemctl start enshrouded
sudo systemctl stop enshrouded
sudo systemctl restart enshrouded
journalctl -u enshrouded -f
```

## Process and Port Checks

```bash
pgrep -af enshrouded_server.exe
ss -lunp | grep -E '15636|15637'
systemctl status playit --no-pager
journalctl -u playit --since "15 minutes ago" --no-pager
```

## Proxmox Performance Settings Used

- CPU type: `host`
- vCPU count increased from six to eight
- CPU units increased to `2048`
- CPU limit left at `0` (unlimited)
- Memory sized to leave room for Ubuntu, Wine, and the server process

## Troubleshooting Workflow

1. Confirm the systemd service is active.
2. Confirm Wine is running `enshrouded_server.exe`.
3. Review journal and game logs for session startup.
4. Verify both UDP ports are listening.
5. Verify both Playit UDP tunnels point to the correct local ports.
6. Confirm the client uses the expected password/access settings.
7. Review Proxmox CPU and memory use during an overload warning.
8. Confirm the VM uses the host CPU model rather than a generic QEMU model.

## Safe Configuration Changes

1. Stop the service.
2. Back up the JSON configuration and save directory.
3. Edit the local configuration.
4. Validate the JSON syntax.
5. Start the service and watch logs.
6. Confirm both UDP ports and external connectivity.

Example validation:

```bash
jq . /home/gameserver/enshrouded/server/enshrouded_server.json >/dev/null
```

## Excluded Private Data

- Server and friend passwords
- Internal VM IP address
- Playit public endpoints and claim data
- Player identifiers
- Savegame contents
- Production logs
- Real usernames and home-directory paths
