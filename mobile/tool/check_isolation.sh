#!/usr/bin/env bash
# Enforces the two architectural rules from docs/mobile-v1-plan.md §2:
#
#   1. No feature imports another feature directly -- cross-feature needs
#      go through data/ or ui/.
#   2. No file outside lib/core/network/ or lib/data/api/ imports `dio` --
#      that's what keeps the request-envelope hazard (§4.2) contained to
#      one place.
#
# Run from the mobile/ directory: ./tool/check_isolation.sh
set -euo pipefail
cd "$(dirname "$0")/.."

fail=0

echo "Checking for cross-feature imports..."
if [ -d lib/features ]; then
  for dir in lib/features/*/; do
    [ -d "$dir" ] || continue   # no subdirectories yet -- nothing to check
    feature=$(basename "$dir")
    others=$(find lib/features -mindepth 1 -maxdepth 1 -type d ! -name "$feature" -exec basename {} \;)
    for other in $others; do
      hits=$(grep -rn "features/$other/" "$dir" --include="*.dart" || true)
      if [ -n "$hits" ]; then
        echo "✗ lib/features/$feature imports lib/features/$other:"
        echo "$hits"
        fail=1
      fi
    done
  done
else
  echo "  (lib/features/ doesn't exist yet -- nothing to check)"
fi

echo "Checking that Dio is only imported under lib/core/network/ or lib/data/api/..."
hits=$(grep -rln "^import 'package:dio/dio.dart'" lib --include="*.dart" \
  | grep -v '^lib/core/network/' \
  | grep -v '^lib/data/api/' || true)
if [ -n "$hits" ]; then
  echo "✗ Dio imported outside core/network or data/api:"
  echo "$hits"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "OK: no isolation violations found."
fi
exit $fail
