# Stage 1: Build/fetch Audiobookshelf from its official image
# This stage pulls the official Audiobookshelf image and prepares its application files.
FROM advplyr/audiobookshelf:2.24.0 AS audiobookshelf_app

# Stage 2: Build the final add-on image based on the Home Assistant base image
# This is the actual image that Home Assistant Supervisor will run.
ARG BUILD_FROM
FROM $BUILD_FROM

# Set shell to bash for robust script execution within the container.
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install necessary system-level packages using apk (Alpine Linux's package manager).
# These packages (ffmpeg, imagemagick) are required by Audiobookshelf but might not be
# present in the lean Home Assistant base image.
RUN apk add --no-cache \
    ffmpeg \
    imagemagick \
    ;

# Copy the Audiobookshelf application files from the first stage (audiobookshelf_app)
# This brings the core Audiobookshelf server and associated files into our final add-on image.
COPY --from=audiobookshelf_app /usr/bin/audiobookshelf /usr/bin/audiobookshelf
COPY --from=audiobookshelf_app /app /app # Copy the main application directory

# Copy our add-on specific files (like run.sh) into the container's root.
COPY root /

# Ensure critical files (the Audiobookshelf server executable and our run.sh) are executable.
# It's common for Node.js apps like ABS to have their main executable in /app/server
# or rely on `node /app/index.js`. Let's ensure common paths are covered.
RUN chmod +x /usr/bin/audiobookshelf /app/server /run.sh

# Define the default command that will be executed when the container starts.
# This points to our run.sh script, which handles starting Audiobookshelf.
CMD ["/bin/bash", "/run.sh"]