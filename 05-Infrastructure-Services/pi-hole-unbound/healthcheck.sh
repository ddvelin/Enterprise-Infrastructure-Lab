#!/usr/bin/env bash
set -Eeuo pipefail

PIHOLE_SERVICE="${PIHOLE_SERVICE:-pihole-FTL}"
UNBOUND_SERVICE="${UNBOUND_SERVICE:-unbound}"
TEST_DOMAIN="${TEST_DOMAIN:-example.com}"
UNBOUND_PORT="${UNBOUND_PORT:-5335}"

failed=0

check() {
    local description="$1"
    shift

    if "$@" >/dev/null 2>&1; then
        printf 'OK: %s\n' "$description"
    else
        printf 'FAILED: %s\n' "$description" >&2
        failed=1
    fi
}

check "Pi-hole service is active" systemctl is-active --quiet "$PIHOLE_SERVICE"
check "Unbound service is active" systemctl is-active --quiet "$UNBOUND_SERVICE"
check "Pi-hole resolves a test domain" dig +time=2 +tries=1 @127.0.0.1 "$TEST_DOMAIN"
check "Unbound resolves a test domain" dig +time=2 +tries=1 @127.0.0.1 -p "$UNBOUND_PORT" "$TEST_DOMAIN"

exit "$failed"
