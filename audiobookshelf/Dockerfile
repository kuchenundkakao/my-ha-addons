ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell to bash for better scripting
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install necessary packages for Audiobookshelf using apk (Alpine Linux package manager)
# The HA base images are often Alpine-based, which uses apk.
RUN apk add --no-cache \
    ffmpeg \
    imagemagick \
    # Add any other dependencies if Audiobookshelf's official image requires them that are not in the base HA image
    # For a full list of common packages, you might look at other HA add-ons' Dockerfiles.
    # We remove the old apt-get related commands entirely.
    ;

# The multi-stage build approach from our previous discussion is still the best way
# to get the Audiobookshelf application itself. Let's combine them properly.

# Stage 1: Build/fetch Audiobookshelf from its official image
FROM advplyr/audiobookshelf:2.24.0 AS audiobookshelf_app 
# Or use a specific version like :2.11.1

# Stage 2: Build the final add-on image based on the HA base image
FROM $BUILD_FROM

# Set shell to bash for better scripting
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install necessary packages using apk (Alpine Linux package manager)
# These are packages that are expected to be on the *final* HA add-on image
# and are often needed by Audiobookshelf or other components.
RUN apk add --no-cache \
    ffmpeg \
    imagemagick \
    # Add any other dependencies if the HA base image is minimal and Audiobookshelf needs them.
    # Examples: 'ca-certificates' (often in base), 'curl', 'nodejs' (but ABS image already has Node)
    # Check if the base HA image provides these by default; otherwise, install.
    # For now, let's keep ffmpeg and imagemagick as those were in your original error.
    ;

# Copy the Audiobookshelf application files from the builder stage (audiobookshelf_app)
COPY --from=audiobookshelf_app /usr/bin/audiobookshelf /usr/bin/audiobookshelf
COPY --from=audiobookshelf_app /app /app 
# Copy the entire /app directory from the official image, which contains Node.js app etc.

# Copy root filesystem (run.sh etc.)
COPY root /

# Ensure the Audiobookshelf binary/script is executable.
# The entrypoint is usually /app/index.js in the official image, but we're running it via run.sh
# so ensure run.sh is executable and it calls the correct entrypoint.
RUN chmod +x /usr/bin/audiobookshelf /app/server /run.sh 
# Add /app/server or whatever the main executable is if not audiobookshelf

# Set the entry point for the add-on.
# This will be our run.sh script.
CMD ["/bin/bash", "/run.sh"]