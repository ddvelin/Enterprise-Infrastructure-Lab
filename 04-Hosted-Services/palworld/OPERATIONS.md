# Palworld Operations Guide

## Service Commands

```bash
sudo systemctl status palworld --no-pager -l
sudo systemctl start palworld
sudo systemctl stop palworld
sudo systemctl restart palworld
journalctl -u palworld -f
```

## Playit Checks

The installed Playit CLI did not support every command found in older guides. The reliable checks were:

```bash
sudo systemctl status playit --no-pager
journalctl -u playit --since "15 minutes ago" --no-pager
```

## Update Workflow

```bash
sudo CONFIG_FILE=/path/to/local/server.conf ./scripts/update.sh
```

The update script:

1. Acquires a lock.
2. Stops Palworld.
3. Runs SteamCMD with `app_update 2394010 validate`.
4. Restarts the systemd service.
5. Confirms that the service became active.

## Configuration Verification

The real configuration remains outside Git. Example checks:

```bash
grep -E "RCONEnabled|RCONPort" \
  /home/gameserver/Steam/steamapps/common/PalServer/Pal/Saved/Config/LinuxServer/PalWorldSettings.ini

systemctl status palworld --no-pager
ss -lunp | grep 8211
```

## RCON Examples

```bash
./scripts/rcon.sh "Info"
./scripts/rcon.sh "ShowPlayers"
./scripts/rcon.sh "Save"
```

Administrative passwords are loaded from the local configuration and are never placed in public command examples.

## Troubleshooting Order

1. Check `palworld.service` status.
2. Review recent journal output.
3. Confirm Steam libraries and `steamclient.so` loaded.
4. Verify UDP port `8211` is listening.
5. Check Playit service and logs separately.
6. Confirm the server and client versions match.
7. Review the Palworld save/config directory permissions.

## Excluded Private Data

- Admin and RCON passwords
- Playit claim information and public tunnel address
- Twingate network details
- Internal VM IP address
- Player names and identifiers
- World saves and logs
- Full production configuration
