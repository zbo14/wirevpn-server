#!/bin/bash -e

if [ "$#" -lt 3 ]; then
  echo "Usage: addclient <ip> <pubkey> <presharedkey>"
  exit 1
fi

echo "$3" | sudo wg set wg0 peer "$2" allowed-ips "$1"/32 preshared-key /dev/stdin
