# Home Assistant Add-on: Audiobookshelf
ARG BUILD_FROM=ghcr.io/hassio-addons/base:15.0.7
FROM ${BUILD_FROM}

# Argumente für Audiobookshelf Version
ARG AUDIOBOOKSHELF_VERSION=2.24.0

# Umgebungsvariablen
ENV \
    LANG="C.UTF-8" \
    PS1="$(whoami)@$(hostname):$(pwd)$ " \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_CMD_WAIT_FOR_SERVICES=1

# System Update und Dependencies installieren
RUN \
    apk add --no-cache --virtual .build-deps \
        build-base \
        git \
        python3-dev \
        npm \
    && apk add --no-cache \
        curl \
        ffmpeg \
        nodejs \
        npm \
        tone \
        jq \
    && npm install -g npm@latest

# Audiobookshelf installieren
RUN \
    git clone --branch v${AUDIOBOOKSHELF_VERSION} --depth 1 \
        https://github.com/advplyr/audiobookshelf.git /tmp/audiobookshelf \
    && cd /tmp/audiobookshelf \
    && npm ci --only=production \
    && mkdir -p /usr/app \
    && cp -R /tmp/audiobookshelf/* /usr/app/ \
    && cd /usr/app \
    && npm ci --only=production \
    && npm cache clean --force \
    && apk del --no-cache --purge .build-deps \
    && rm -rf \
        /tmp/* \
        /var/cache/apk/*

# S6-Overlay Skripte kopieren
COPY rootfs /

# Berechtigungen setzen
RUN chmod a+x /etc/services.d/audiobookshelf/run

# Labels
LABEL \
    io.hass.name="Audiobookshelf" \
    io.hass.description="Self-hosted audiobook and podcast server" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Your Name <your.email@example.com>" \
    org.opencontainers.image.title="Audiobookshelf" \
    org.opencontainers.image.description="Self-hosted audiobook and podcast server" \
    org.opencontainers.image.source="https://github.com/advplyr/audiobookshelf" \
    org.opencontainers.image.licenses="GPL-3.0"