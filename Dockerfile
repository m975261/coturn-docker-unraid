FROM debian:bookworm-slim

# Install coturn
RUN apt-get update && \
    apt-get install -y --no-install-recommends coturn && \
    rm -rf /var/lib/apt/lists/*

# Create required directories
RUN mkdir -p /var/lib/coturn && \
    mkdir -p /var/log/coturn

# Set correct permissions for existing user 'nobody'
RUN chown -R nobody:nogroup /var/lib/coturn /var/log/coturn

# Copy TURN configuration
COPY turnserver.conf /etc/turnserver.conf

# Expose ports
EXPOSE 3478/udp
EXPOSE 3478/tcp
EXPOSE 5349/tcp

# Run as nobody (standard Debian safe user)
USER nobody

# Start coturn
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
