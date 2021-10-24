#!/usr/bin/env bash

LAST_INPUT_MS=$(ioreg -c IOHIDSystem | awk '/HIDIdleTime/{print $NF}')

if ! [ -e "$HOME/.heartbeat" ]; then
    echo "$HOME/.heartbeat not setup, please create it"
    exit 1
fi

if [[ -z "$HEARTBEAT_AUTH" ]] || [[ -z "$HEARTBEAT_DEVICE_NAME" ]] || [[ -z "$HEARTBEAT_HOSTNAME" ]]; then
  echo "Environment variables not setup correctly!"
  echo "HEARTBEAT_AUTH: $HEARTBEAT_AUTH"
  echo "HEARTBEAT_DEVICE_NAME:   $HEARTBEAT_HOSTNAME"
  echo "HEARTBEAT_HOSTNAME: $HEARTBEAT_HOSTNAME"
  exit
else
  # Launchd will execute task if the system is locked/in sleep, so do not have to worry about the lock
  if [[ $LAST_INPUT_MS -lt 120000 ]]; then
    echo "$(date +"%Y/%m/%d %T") - Running Heartbeat"
    curl -s -X POST -H "Auth: $HEARTBEAT_AUTH" -H "Device: $HEARTBEAT_DEVICE_NAME" "$HEARTBEAT_HOSTNAME/api/beat"
  fi
fi