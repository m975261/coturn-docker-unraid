#!/bin/bash
set -e

# Load environment variables
REALM=${REALM:-"example.com"}
EXTERNAL_IP=${EXTERNAL_IP:-""}
USERNAME=${USERNAME:-"turnuser"}
PASSWORD=${PASSWORD:-"password"}
TLS_CERT=${TLS_CERT:-""}
TLS_KEY=${TLS_KEY:-""}

# Resolve domain to IPv4 dynamically if EXTERNAL_IP is not an IP
if [[ ! $EXTERNAL_IP =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Resolving public IP for hostname: $EXTERNAL_IP"
    RESOLVED_IP=$(getent ahostsv4 "$EXTERNAL_IP" | head -n 1 | awk '{print $1}')
    if [[ -n "$RESOLVED_IP" ]]; then
        EXTERNAL_IP="$RESOLVED_IP"
        echo "Resolved IP: $EXTERNAL_IP"
    else
        echo "ERROR: Cannot resolve $EXTERNAL_IP"
        exit 1
    fi
fi

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

if [[ -n "$TLS_CERT" && -n "$TLS_KEY" ]]; then
cat <<EOF >> /etc/turnserver.conf
cert=$TLS_CERT
pkey=$TLS_KEY
tls-listening-port=5349
EOF
fi

echo "TURN server starting with external IP: $EXTERNAL_IP"
exec /usr/bin/turnserver -c /etc/turnserver.conf --no-cli
