ARG BUILD_FROM
FROM $BUILD_FROM
# Stage 1: Build/fetch Audiobookshelf from its official image
# This stage pulls the specified version of the official Audiobookshelf Docker image.
# We use a specific version (2.24.0) for stability, but you can change it to 'latest'
# if you prefer to always pull the newest release (remember the cache invalidation steps).
FROM advplyr/audiobookshelf:2.24.0 AS audiobookshelf_app

# Stage 2: Build the final add-on image based on the Home Assistant Supervisor's base image.
# The ARG BUILD_FROM receives the architecture-specific base image (e.g., aarch64-base)
# from the Home Assistant Supervisor during the build process.


# Set the default shell for all subsequent RUN, CMD, and ENTRYPOINT instructions
# to bash, with pipefail for better error handling in scripts.
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install necessary system-level packages using apk (Alpine Linux's package manager).
# The Home Assistant base images are typically Alpine-based.
# 'ffmpeg' is crucial for media processing in Audiobookshelf.
# 'imagemagick' is often used for image manipulation (e.g., cover art resizing).
# '--no-cache' keeps the final image size smaller.
RUN apk add --no-cache \
    ffmpeg \
    imagemagick \
    ;

# Copy the core Audiobookshelf application files from the first stage (audiobookshelf_app).
# '/app' typically contains the Node.js application code and assets.
# '/usr/bin/audiobookshelf' might be a wrapper script or symbolic link, or the actual binary.
# We copy both to ensure all necessary components are present.
COPY --from=audiobookshelf_app /usr/bin/audiobookshelf /usr/bin/audiobookshelf
COPY --from=audiobookshelf_app /app /app

# Copy our custom add-on files (like run.sh) into the root filesystem of the container.
COPY root /

# Ensure that the main application executable(s) and our run.sh script are executable.
# '/app/server' is a common main executable for Audiobookshelf within its container.
RUN chmod +x /usr/bin/audiobookshelf /app/server /run.sh

# Define the default command that the container will execute when it starts.
# This points to our custom 'run.sh' script, which orchestrates the startup
# of the Audiobookshelf application within the add-on environment.
CMD ["/bin/ash", "/run.sh"]