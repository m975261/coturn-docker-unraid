FROM debian:bookworm-slim

# Install coturn
RUN apt-get update && \
    apt-get install -y --no-install-recommends coturn && \
    rm -rf /var/lib/apt/lists/*

# Create folders
RUN mkdir -p /var/lib/coturn && \
    mkdir -p /var/log/coturn

# Copy entrypoint script EARLY
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose ports
EXPOSE 3478/udp
EXPOSE 3478/tcp
EXPOSE 5349/tcp

# Run as nobody
USER nobody

# Start Coturn
ENTRYPOINT ["/entrypoint.sh"]
