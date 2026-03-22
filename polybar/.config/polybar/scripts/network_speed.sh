#!/bin/bash

interface="$(ip route get 1.1.1.1 2>/dev/null | awk '/dev/ {for (i = 1; i <= NF; i++) if ($i == "dev") {print $(i+1); exit}}')"

if [ -z "$interface" ]; then
  echo "%{F#4FC3F7}↓%{F-} -- %{F#FFB300}↑%{F-} --"
  exit 0
fi

rx1="$(awk -v iface="$interface" '$1 ~ iface ":" {print $2}' /proc/net/dev)"
tx1="$(awk -v iface="$interface" '$1 ~ iface ":" {print $10}' /proc/net/dev)"
sleep 1
rx2="$(awk -v iface="$interface" '$1 ~ iface ":" {print $2}' /proc/net/dev)"
tx2="$(awk -v iface="$interface" '$1 ~ iface ":" {print $10}' /proc/net/dev)"

down_bytes=$((rx2 - rx1))
up_bytes=$((tx2 - tx1))

format_rate() {
  local bytes_per_sec="$1"
  local kib_per_sec
  local mib_per_sec

  kib_per_sec=$((bytes_per_sec / 1024))
  mib_per_sec=$((bytes_per_sec / 1024 / 1024))

  if [ "$mib_per_sec" -ge 1 ]; then
    printf "%s MB/s" "$mib_per_sec"
  else
    printf "%s KB/s" "$kib_per_sec"
  fi
}

printf "%%{F#4FC3F7}↓%%{F-} %s %%{F#FFB300}↑%%{F-} %s\n" "$(format_rate "$down_bytes")" "$(format_rate "$up_bytes")"
