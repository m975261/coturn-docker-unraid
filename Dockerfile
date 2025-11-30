FROM debian:bookworm-slim

# Install coturn
RUN apt-get update && \
    apt-get install -y --no-install-recommends coturn && \
    rm -rf /var/lib/apt/lists/*

# Create required folders
RUN mkdir -p /var/lib/coturn && \
    mkdir -p /var/log/coturn

# Use nobody user (safe, built-in)
USER nobody

# Copy entrypoint script (must be in root of repo)
COPY entrypoint.sh /entrypoint.sh

# Make script executable
USER root
RUN chmod +x /entrypoint.sh

# Expose ports
EXPOSE 3478/udp
EXPOSE 3478/tcp
EXPOSE 5349/tcp

# Drop back to nobody for security
USER nobody

# Start coturn with dynamic config
ENTRYPOINT ["/entrypoint.sh"]
