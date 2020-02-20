#!/bin/bash -e

sudo wg-quick up wg0

cd ~/.wireguard
gpg --output privatekey --decrypt privatekey.gpg
gpgconf --reload gpg-agent
echo "Decrypting private key"

sudo wg set wg0 private-key privatekey

rm privatekey
