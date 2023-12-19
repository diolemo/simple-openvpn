FROM debian:bullseye
WORKDIR /root

ENV DEBIAN_FRONTEND noninteractive
ENV EASYRSA /root/easy-rsa

# Install essential apps/services
RUN apt-get update && \
    apt-get install -y \
        openvpn \
        easy-rsa \
        iptables \
        gettext-base \
        net-tools nano curl wget iputils-ping dnsutils htop psmisc \
        && \
    # APT Cleanup
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN ln -sf /root/easy-rsa/ta.key                  /etc/openvpn/server/   ; \
    ln -sf /root/easy-rsa/pki/private/server.key  /etc/openvpn/server/   ; \
    ln -sf /root/easy-rsa/pki/issued/server.crt   /etc/openvpn/server/   ; \
    ln -sf /root/easy-rsa/pki/ca.crt              /etc/openvpn/server/   ; \
    ln -sf /root/easy-rsa/pki/crl.pem             /etc/openvpn/server/

COPY files/root/scripts /root/scripts
RUN  chmod +x /root/scripts/*

COPY files/etc/openvpn/server.conf /etc/openvpn/server.conf
COPY files/entrypoint.sh /entrypoint.sh
RUN  chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]



