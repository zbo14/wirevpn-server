#!/bin/bash -e

sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:wireguard/wireguard

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y libexpat-dev libssl-dev wireguard

mkdir -p ~/Downloads
wget -O ~/Downloads/unbound-1.9.6.tar.gz https://nlnetlabs.nl/downloads/unbound/unbound-1.9.6.tar.gz
tar xf ~/Downloads/unbound-1.9.6.tar.gz -C ~/Downloads
rm ~/Downloads/unbound-1.9.6.tar.gz

cd ~/Downloads/unbound-1.9.6
./configure
make
sudo make install
