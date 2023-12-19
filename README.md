### OpenVPN
First, configure the public hostname/port in the `.env` file.

```
SIMPLE_OPENVPN_HOST=1.2.3.4
SIMPLE_OPENVPN_PORT=1194
```

If you're behind a NAT firewall/router make sure you forward the port to the host machine.

```
# Bring up the openvpn container
docker compose up openvpn

# Generate the client config
docker exec -it simple-openvpn /root/scripts/add-client $OPTIONAL_CLIENT_NAME
```

The client config files will be saved in the `openvpn/clients` folder.\
Now, install the client config on the other machine.

If you need to revoke a client:

```
# Revoke a previously generated client certificate
docker exec -it simple-openvpn /root/scripts/revoke-client $CLIENT_NAME
```

If you need to re-build your server/CA certificates:

```
# Remove all server certs and rebuild
rm -rf openvpn/files/root/easy-rsa/pki
rm -rf openvpn/files/root/easy-rsa/ta.key
docker compose up openvpn
```
