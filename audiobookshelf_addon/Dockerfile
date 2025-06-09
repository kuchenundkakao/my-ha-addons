ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell to bash for better scripting
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install necessary packages for Audiobookshelf (e.g., ffmpeg, imagemagick)
# We're using a base image that likely includes these, but it's good to ensure
# Home Assistant add-ons often use a specific base image (e.g., ghcr.io/hassio-addons/base/...)
# For now, we'll assume a standard Linux base that we can then modify.
# If you run into issues, we might need to adjust the base image.

# Install general dependencies that Audiobookshelf might need
# These are common dependencies for many applications, adjust if specific errors occur.
RUN apt-get update && \
    apt-get install -y \
    ffmpeg \
    imagemagick \
    # Add any other dependencies specific to the Audiobookshelf Docker image if needed
    # For many pre-built images, these might already be present.
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Copy root filesystem
COPY root /

# Set the entry point for the add-on.
# This will be our run.sh script.
CMD ["/bin/bash", "/run.sh"]