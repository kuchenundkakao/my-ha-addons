ARG BUILD_FROM="ghcr.io/home-assistant/aarch64-base:latest" # This should be the base for Home Assistant add-ons
# You might want to use a specific version for stability, e.g., ghcr.io/home-assistant/aarch64-base:2024.04.0

# We will build FROM the official Audiobookshelf image,
# and then copy necessary components from the Home Assistant base image
# or ensure our script is compatible.

# Option 1: Multi-stage build - best practice for smaller images
# Use the official Audiobookshelf image to get the application
FROM advplyr/audiobookshelf:2.24.0 AS audiobookshelf_app 
# Use :latest or a specific version like :2.11.1

# Use the Home Assistant base image as the final image
FROM $BUILD_FROM

# Set shell to bash for better scripting
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install necessary packages that the HA base might not have
# (These might already be in the Audiobookshelf image, but good to have in base)
RUN apt-get update && \
    apt-get install -y \
    ffmpeg \
    imagemagick \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Copy the Audiobookshelf application files from the builder stage
COPY --from=audiobookshelf_app /usr/bin/audiobookshelf /usr/bin/audiobookshelf
COPY --from=audiobookshelf_app /usr/share/audiobookshelf /usr/share/audiobookshelf 
# Example: where static files might be

# Copy root filesystem
COPY root /

# Ensure the Audiobookshelf binary is executable
RUN chmod +x /usr/bin/audiobookshelf

# Set the entry point for the add-on.
CMD ["/bin/bash", "/run.sh"]