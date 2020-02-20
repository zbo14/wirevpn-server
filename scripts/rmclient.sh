#!/bin/bash -e

if [ -z "$1" ]; then
  echo "Usage: rmclient <pubkey>"
  exit 1
fi

sudo wg set wg0 peer "$1" remove
