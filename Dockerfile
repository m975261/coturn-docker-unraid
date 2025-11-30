FROM debian:bookworm

# Install coturn & required tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends coturn passwd && \
    rm -rf /var/lib/apt/lists/*

# Create directories
RUN mkdir -p /var/lib/coturn && \
    mkdir -p /var/log/coturn

# Create nologin shell (some Debian builds miss this file)
RUN if [ ! -f /usr/sbin/nologin ]; then ln -s /bin/false /usr/sbin/nologin; fi

# Create turnserver user safely
RUN useradd -r -M -d /var/lib/coturn -s /usr/sbin/nologin turnserver

# Set permissions
RUN chown -R turnserver:turnserver /var/lib/coturn /var/log/coturn

# Copy TURN configuration
COPY turnserver.conf /etc/turnserver.conf

# Expose ports
EXPOSE 3478/udp
EXPOSE 3478/tcp
EXPOSE 5349/tcp

# Run as non-root
USER turnserver

# Start coturn
ENTRYPOINT ["/usr/bin/turnserver", "-c", "/etc/turnserver.conf", "--no-cli"]
