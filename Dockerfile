FROM debian:stable-slim

# Install coturn
RUN apt-get update && \
    apt-get install -y --no-install-recommends coturn && \
    rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /var/lib/coturn \
    && mkdir -p /var/log/coturn

# Create user safely (Debian version)
RUN useradd -r -M -d /var/lib/coturn -s /usr/sbin/nologin turnserver \
    && chown -R turnserver:turnserver /var/lib/coturn /var/log/coturn

# Copy config
COPY turnserver.conf /etc/turnserver.conf

# Expose TURN/STUN ports
EXPOSE 3478/udp
EXPOSE 3478/tcp
EXPOSE 5349/tcp

# Run as non-root
USER turnserver

# Start coturn
ENTRYPOINT ["/usr/bin/turnserver", "-c", "/etc/turnserver.conf", "--no-cli"]
