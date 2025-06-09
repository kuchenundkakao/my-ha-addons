ARG BUILD_FROM=ghcr.io/advplyr/audiobookshelf:2.24.0
FROM $BUILD_FROM

# Set shell
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy data for add-on
COPY run.sh /
COPY logo.png /
RUN chmod a+x /run.sh

# Labels
LABEL \
    io.hass.name="Audiobookshelf" \
    io.hass.description="Self-hosted audiobook and podcast server" \
    io.hass.arch="armhf|aarch64|amd64|armv7|i386" \
    io.hass.type="addon" \
    io.hass.version="2.24.0b11" \
    maintainer="Your Name <your.email@example.com>" \
    org.opencontainers.image.title="Audiobookshelf Home Assistant Add-on" \
    org.opencontainers.image.description="Self-hosted audiobook and podcast server for Home Assistant" \
    org.opencontainers.image.source="https://github.com/your-username/hassio-audiobookshelf" \
    org.opencontainers.image.licenses="MIT"

CMD [ "/run.sh" ]