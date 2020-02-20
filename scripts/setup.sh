#!/bin/bash -e

cd "$(dirname "$0")"/../..

sudo mkdir -p /etc/wireguard
sudo cp etc/postup.sh /etc/wireguard

sudo cp etc/unbound.conf /usr/local/etc/unbound
sudo cp etc/unbound.service /etc/systemd/system
id -u unbound >/dev/null 2>&1 || sudo useradd -m unbound
sudo systemctl daemon-reload

mkdir -p ~/.wireguard
cd ~/.wireguard

umask 077
wg genkey > privatekey
wg pubkey < privatekey > publickey

gpg --encrypt --sign privatekey
gpgconf --reload gpg-agent
rm privatekey
echo "Encrypting private key"

echo '[Interface]
Address = 10.200.200.1/24
ListenPort = 51820
PostUp = bash /etc/wireguard/postup.sh
SaveConfig = true' | sudo tee /etc/wireguard/wg0.conf > /dev/null

echo "Server public key: $(cat publickey)"
