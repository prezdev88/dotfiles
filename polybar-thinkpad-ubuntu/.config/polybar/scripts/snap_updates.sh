#!/usr/bin/env bash
set -euo pipefail

if ! command -v snap >/dev/null 2>&1; then
  echo "N/A"
  exit 0
fi

count="$(snap refresh --list 2>/dev/null | sed 1d | wc -l | tr -d ' ')"
echo "${count}"
