#!/bin/bash
# usage: sample_tpu_info.sh <out_file> <interval_s> <pid_to_watch>
# Appends a UTC-stamped `tpu-info` snapshot (duty cycle, HBM) every interval while the PID is alive.
OUT=$1; INTERVAL=${2:-30}; PID=$3
while kill -0 "$PID" 2>/dev/null; do
  echo "=== $(date -u +%FT%TZ)" >> "$OUT"
  tpu-info >> "$OUT" 2>&1
  sleep "$INTERVAL"
done
