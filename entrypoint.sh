#!/bin/bash

# Required ENV variables
REALM=${REALM:-"example.com"}
EXTERNAL_IP=${EXTERNAL_IP:-"0.0.0.0"}
USERNAME=${USERNAME:-"turnuser"}
PASSWORD=${PASSWORD:-"password"}
TLS_CERT=${TLS_CERT:-""}
TLS_KEY=${TLS_KEY:-""}

echo "Generating turnserver.conf..."

cat <<EOF > /etc/turnserver.conf
realm=$REALM
external-ip=$EXTERNAL_IP
listening-ip=0.0.0.0
user=$USERNAME:$PASSWORD
lt-cred-mech
fingerprint
mobility
no-loopback-peers
no-multicast-peers
EOF

# If TLS is enabled
if [[ -n "$TLS_CERT" && -n "$TLS_KEY" ]]; then
cat <<EOF >> /etc/turnserver.conf
cert=$TLS_CERT
pkey=$TLS_KEY
tls-listening-port=5349
EOF
fi

echo "turnserver.conf created:"
cat /etc/turnserver.conf

exec /usr/bin/turnserver -c /etc/turnserver.conf --no-cli
