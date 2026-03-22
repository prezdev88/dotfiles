#!/usr/bin/env bash
set -euo pipefail

if ! command -v apt >/dev/null 2>&1; then
  echo "N/A"
  exit 0
fi

count="$(apt list --upgradable 2>/dev/null | sed 1d | wc -l | tr -d ' ')"
echo "${count}"
