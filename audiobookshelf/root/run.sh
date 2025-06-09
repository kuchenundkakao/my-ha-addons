#!/bin/sh

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration Variables ---
# Audiobookshelf expects these environment variables to be set.
# We'll use values from the add-on configuration, with fallbacks.

# Default values if not specified by the user in add-on options
DEFAULT_MEDIA_DIR="/media/audiobooks" # Standard location for media
DEFAULT_CONFIG_DIR="/config/audiobookshelf" # Standard location for config data

# Set MEDIA_DIR
if [ -z "${MEDIA_DIR}" ]; then
    echo "[Info] MEDIA_DIR not explicitly set, using default: ${DEFAULT_MEDIA_DIR}"
    export MEDIA_DIR="${DEFAULT_MEDIA_DIR}"
else
    echo "[Info] Using MEDIA_DIR from add-on options: ${MEDIA_DIR}"
    export MEDIA_DIR
fi

# Set CONFIG_DIR
if [ -z "${CONFIG_DIR}" ]; then
    echo "[Info] CONFIG_DIR not explicitly set, using default: ${DEFAULT_CONFIG_DIR}"
    export CONFIG_DIR="${DEFAULT_CONFIG_DIR}"
else
    echo "[Info] Using CONFIG_DIR from add-on options: ${CONFIG_DIR}"
    export CONFIG_DIR
fi

# Ensure directories exist
mkdir -p "${MEDIA_DIR}"
mkdir -p "${CONFIG_DIR}"

# --- Logging Configuration ---
# Set the log level based on the add-on option
case "${LOG_LEVEL}" in
    "trace")
        export ABS_LOG_LEVEL="trace"
        ;;
    "debug")
        export ABS_LOG_LEVEL="debug"
        ;;
    "info")
        export ABS_LOG_LEVEL="info"
        ;;
    "notice") # Audiobookshelf might not have a 'notice' level, mapping to info
        export ABS_LOG_LEVEL="info"
        ;;
    "warning")
        export ABS_LOG_LEVEL="warn" # Map to 'warn' for Audiobookshelf
        ;;
    "error")
        export ABS_LOG_LEVEL="error"
        ;;
    "fatal") # Audiobookshelf might not have a 'fatal' level, mapping to error
        export ABS_LOG_LEVEL="error"
        ;;
    *)
        echo "[Warning] Unknown log level '${LOG_LEVEL}', defaulting to 'info'."
        export ABS_LOG_LEVEL="info"
        ;;
esac
echo "[Info] Audiobookshelf log level set to: ${ABS_LOG_LEVEL}"

# --- Start Audiobookshelf ---
echo "[Info] Starting Audiobookshelf..."

# The 'audiobookshelf' command should be available if we're building from a base image
# that already contains it or if we installed it via the Dockerfile.
# We'll assume the official Audiobookshelf image structure, where the main executable is 'audiobookshelf'.
# If you are using a generic base image, you might need to install audiobookshelf here.
# For now, we'll assume the base image provides the 'audiobookshelf' binary or it's accessible.
# In a real scenario, you'd be building ON TOP OF the official Audiobookshelf Docker image,
# or installing it directly here from source/pre-built binaries.

# To simplify, we will base the final add-on on the actual Audiobookshelf image.
# This part of the script is preparing for that.
# The `exec` command replaces the shell process with the Audiobookshelf process.
# This is a common practice in Docker to ensure that signals (like stop) are handled correctly.
exec /app/server