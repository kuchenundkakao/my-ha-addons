#!/usr/bin/with-contenv bashio

# Konfiguration laden
CONFIG_PATH=/data/options.json

DATA_DIR=$(bashio::config 'data_directory')
AUDIOBOOKS_DIRS=$(bashio::config 'audiobooks_directories')
PODCASTS_DIRS=$(bashio::config 'podcasts_directories')
BACKUP_DIR=$(bashio::config 'backup_directory')
LOG_LEVEL=$(bashio::config 'log_level')
HOST=$(bashio::config 'host')
PORT=$(bashio::config 'port')

# Logging
bashio::log.info "Starting Audiobookshelf..."
bashio::log.info "Data directory: ${DATA_DIR}"
bashio::log.info "Log level: ${LOG_LEVEL}"

# Verzeichnisse erstellen
mkdir -p "${DATA_DIR}"
mkdir -p "${BACKUP_DIR}"

# Audiobook-Verzeichnisse prüfen und erstellen
for dir in $(echo "${AUDIOBOOKS_DIRS}" | jq -r '.[]'); do
    if [ ! -d "${dir}" ]; then
        bashio::log.warning "Audiobook directory ${dir} does not exist, creating..."
        mkdir -p "${dir}"
    fi
    bashio::log.info "Audiobook directory: ${dir}"
done

# Podcast-Verzeichnisse prüfen und erstellen
for dir in $(echo "${PODCASTS_DIRS}" | jq -r '.[]'); do
    if [ ! -d "${dir}" ]; then
        bashio::log.warning "Podcast directory ${dir} does not exist, creating..."
        mkdir -p "${dir}"
    fi
    bashio::log.info "Podcast directory: ${dir}"
done

# Umgebungsvariablen setzen
export AUDIOBOOKSHELF_UID=0
export AUDIOBOOKSHELF_GID=0
export CONFIG_PATH="${DATA_DIR}/config"
export METADATA_PATH="${DATA_DIR}/metadata"

# Konfigurationsverzeichnisse erstellen
mkdir -p "${CONFIG_PATH}"
mkdir -p "${METADATA_PATH}"

# Audiobookshelf starten
bashio::log.info "Starting Audiobookshelf on ${HOST}:${PORT}"

exec node /usr/app/index.js \
    --host="${HOST}" \
    --port="${PORT}" \
    --config="${CONFIG_PATH}" \
    --metadata="${METADATA_PATH}"