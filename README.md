# wirevpn-server

Some scripts and config files to run a WireGuard VPN server on Ubuntu.

## Install

`$ sh scripts/install.sh`

Install WireGuard, Unbound, and other required packages.

### Setup

`$ sh scripts/setup.sh`

This script does the following:

1. Generate public and private keys and write them to `~/.wireguard`
1. Encrypt the private key with a GPG key of your choosing
1. Write a WireGuard config to `/etc/wireguard`
1. Write the public key to stdout

### Start

`$ sh scripts/start.sh`

This script does the following:

1. Bring up the WireGuard interface
1. Decrypt your private key with the GPG key you chose
1. Set the private key on the interface

### Add client

```
$ sh scripts/addclient.sh <ip> <pubkey> <presharedkey>

Arguments:
  ip            - the desired tunnel IP address for the client
  pubkey        - the client's public key
  presharedkey  - the client's preshared key
```

### Remove client

```
$ sh scripts/rmclient.sh <pubkey>

Arguments:
  pubkey  - the client's public key
```

### Stop

`$ sh scripts/stop.sh`

Bring down the WireGuard interface.
