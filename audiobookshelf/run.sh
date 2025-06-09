#!/usr/bin/with-contenv bashio

# ==============================================================================
# Home Assistant Add-on: Audiobookshelf
# Runs the Audiobookshelf server
# ==============================================================================

# Parse configuration
declare log_level
declare ssl
declare certfile
declare keyfile
declare external_access
declare ingress_interface
declare ingress_port
declare audiobooks_path
declare podcasts_path
declare create_folders

log_level=$(bashio::config 'log_level')
ssl=$(bashio::config 'ssl')
certfile=$(bashio::config 'certfile')
keyfile=$(bashio::config 'keyfile')
external_access=$(bashio::config 'external_access')
audiobooks_path=$(bashio::config 'audiobooks_path')
podcasts_path=$(bashio::config 'podcasts_path')
create_folders=$(bashio::config 'create_folders')

# Get ingress configuration
if bashio::addon.ingress_url > /dev/null; then
    ingress_interface=$(bashio::addon.ip_address)
    ingress_port=$(bashio::addon.ingress_port)
    bashio::log.info "Ingress is enabled. Interface: ${ingress_interface}, Port: ${ingress_port}"
fi

# Set log level
bashio::log.info "Starting Audiobookshelf..."
bashio::log.info "Log level: ${log_level}"

# Create necessary directories
mkdir -p /config/audiobookshelf
mkdir -p /share/audiobookshelf

# Validate and create media directories
bashio::log.info "Configuring media directories..."
bashio::log.info "Audiobooks path: ${audiobooks_path}"
bashio::log.info "Podcasts path: ${podcasts_path}"

# Function to validate and create directory
validate_and_create_dir() {
    local dir_path="$1"
    local dir_type="$2"
    
    # Check if path starts with allowed prefixes
    if [[ ! "$dir_path" =~ ^(/share|/media|/config|/addon_configs) ]]; then
        bashio::log.error "${dir_type} path must start with /share, /media, /config, or /addon_configs"
        bashio::log.error "Invalid path: ${dir_path}"
        bashio::exit.nok
    fi
    
    # Create directory if it doesn't exist and create_folders is enabled
    if [[ ! -d "$dir_path" ]]; then
        if bashio::var.true "${create_folders}"; then
            bashio::log.info "Creating ${dir_type} directory: ${dir_path}"
            mkdir -p "$dir_path" || {
                bashio::log.error "Failed to create ${dir_type} directory: ${dir_path}"
                bashio::exit.nok
            }
        else
            bashio::log.warning "${dir_type} directory does not exist: ${dir_path}"
            bashio::log.warning "Set 'create_folders: true' to automatically create it"
        fi
    else
        bashio::log.info "${dir_type} directory exists: ${dir_path}"
    fi
    
    # Set permissions if directory exists
    if [[ -d "$dir_path" ]]; then
        chown -R audiobookshelf:audiobookshelf "$dir_path" 2>/dev/null || true
        chmod -R 755 "$dir_path" 2>/dev/null || true
    fi
}

# Validate and create audiobooks directory
validate_and_create_dir "${audiobooks_path}" "Audiobooks"

# Validate and create podcasts directory
validate_and_create_dir "${podcasts_path}" "Podcasts"

# Set environment variables for Audiobookshelf
export NODE_ENV=production
export CONFIG_PATH=/config/audiobookshelf
export METADATA_PATH=/config/audiobookshelf/metadata

# Configure host and port based on ingress
declare host="0.0.0.0"
declare port="13378"

if bashio::addon.ingress_url > /dev/null; then
    # Ingress is available
    export AUDIOBOOKSHELF_BASE_PATH="$(bashio::addon.ingress_path)"
    bashio::log.info "Setting base path for ingress: ${AUDIOBOOKSHELF_BASE_PATH}"
    
    # Use ingress port and interface
    port="${ingress_port}"
    host="${ingress_interface}"
    
    # Disable external port if not explicitly enabled
    if ! bashio::var.true "${external_access}"; then
        bashio::log.info "External access disabled, only ingress available"
    fi
else
    bashio::log.info "Ingress not available, using standard port configuration"
fi

# SSL Configuration
if bashio::var.true "${ssl}"; then
    bashio::log.info "SSL is enabled"
    export HTTPS=true
    export CERT_PATH="/ssl/${certfile}"
    export KEY_PATH="/ssl/${keyfile}"
    
    # Check if SSL certificate files exist
    if ! bashio::fs.file_exists "/ssl/${certfile}"; then
        bashio::log.fatal "SSL certificate file not found: /ssl/${certfile}"
        bashio::exit.nok
    fi
    
    if ! bashio::fs.file_exists "/ssl/${keyfile}"; then
        bashio::log.fatal "SSL key file not found: /ssl/${keyfile}"
        bashio::exit.nok
    fi
fi

# Create initial library configuration
create_initial_config() {
    local config_file="/config/audiobookshelf/config.json"
    
    if [[ ! -f "$config_file" ]]; then
        bashio::log.info "Creating initial Audiobookshelf configuration..."
        
        cat > "$config_file" << EOF
{
  "libraries": [
    {
      "id": "audiobooks",
      "name": "Audiobooks",
      "folders": [
        {
          "fullPath": "${audiobooks_path}",
          "libraryId": "audiobooks"
        }
      ],
      "displayOrder": 1,
      "icon": "audiobook",
      "mediaType": "book",
      "provider": "audible"
    },
    {
      "id": "podcasts", 
      "name": "Podcasts",
      "folders": [
        {
          "fullPath": "${podcasts_path}",
          "libraryId": "podcasts"
        }
      ],
      "displayOrder": 2,
      "icon": "podcast",
      "mediaType": "podcast",
      "provider": "itunes"
    }
  ]
}
EOF
        chown audiobookshelf:audiobookshelf "$config_file"
        bashio::log.info "Initial configuration created with your custom paths"
    else
        bashio::log.info "Existing configuration found, skipping initial setup"
    fi
}

# Create initial configuration
create_initial_config

# Set final permissions
chown -R audiobookshelf:audiobookshelf /config/audiobookshelf

# Start Audiobookshelf
bashio::log.info "Starting Audiobookshelf server on ${host}:${port}..."
bashio::log.info "Audiobooks directory: ${audiobooks_path}"
bashio::log.info "Podcasts directory: ${podcasts_path}"

# Display access information
if bashio::addon.ingress_url > /dev/null; then
    bashio::log.info "Audiobookshelf is available via Home Assistant Ingress"
    bashio::log.info "Access through: Sidebar -> Audiobookshelf"
    if bashio::var.true "${external_access}"; then
        bashio::log.info "External access also available at: http://$(bashio::addon.hostname):13378"
    fi
else
    bashio::log.info "Access Audiobookshelf at: http://$(bashio::addon.hostname):13378"
fi

# Run the original audiobookshelf command with dynamic host/port
exec node /audiobookshelf/index.js --host "${host}" --port "${port}"