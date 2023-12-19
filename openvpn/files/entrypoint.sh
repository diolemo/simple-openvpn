#!/bin/bash

set -e

if [[ ! -f /root/easy-rsa/ta.key ]] || \
   [[ ! -d /root/easy-rsa/pki ]]
then
    cd /root/easy-rsa
    ln -sf /usr/share/easy-rsa/* .

    # Build CA + Server Certs
    ./easyrsa init-pki
    ./easyrsa build-ca nopass
    ./easyrsa gen-req server nopass
    ./easyrsa sign-req server server
    ./easyrsa gen-crl

    # HMAC signature for all SSL/TLS handshake packets
    openvpn --genkey secret ta.key
fi

mkdir -p /dev/net

if [ ! -c /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi

# Allow access to the wider world
iptables -A FORWARD -o eth0 -i tun0 -s 10.8.0.0/24 -m conntrack --ctstate NEW -j ACCEPT
iptables -A FORWARD -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

openvpn --config /etc/openvpn/server.conf
tail -f
