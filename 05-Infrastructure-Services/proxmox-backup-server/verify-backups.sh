#!/usr/bin/env bash
set -Eeuo pipefail

# Run on the PBS host with sufficient permissions.
# Datastore names and notification integrations are supplied locally.

DATASTORE="${DATASTORE:-example-datastore}"
MAX_AGE_HOURS="${MAX_AGE_HOURS:-30}"

printf 'Datastore: %s\n' "$DATASTORE"
proxmox-backup-manager datastore list

echo
echo "Recent failed tasks:"
proxmox-backup-manager task list --errors-only true || true

echo
echo "Filesystem capacity:"
df -h

echo
echo "Recent datastore-related journal entries:"
journalctl -u proxmox-backup-proxy --since "${MAX_AGE_HOURS} hours ago" --no-pager \
    | grep -Ei 'backup|verify|prune|error|fail' \
    | tail -100 || true

# Snapshot-age and namespace checks vary by PBS version and datastore design.
# The production workflow validates expected guests and reports missing or stale
# snapshots without publishing guest names or datastore paths.