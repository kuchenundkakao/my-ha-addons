# Home Assistant Add-on: Audiobookshelf

Self-hosted audiobook and podcast server with a sleek web player, built for audiobook enthusiasts.

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]
![Supports i386 Architecture][i386-shield]

## About

Audiobookshelf is a self-hosted audiobook and podcast server. It allows you to:

- Organize your audiobook and podcast libraries
- Stream audiobooks and podcasts with a beautiful web player
- Track your listening progress
- Manage users and listening statistics
- Mobile app support for iOS and Android
- Automatic metadata fetching
- Chapter support
- Audiobook merging and management

## Installation

1. Add this repository to your Home Assistant Supervisor:
   - Navigate to Supervisor > Add-on Store
   - Click on the three dots in the top right corner
   - Select "Repositories"
   - Add the URL: `https://github.com/your-username/hassio-audiobookshelf`

2. Find "Audiobookshelf" in the add-on store and click "Install"

3. Configure the add-on (see Configuration section)

4. Start the add-on

## Configuration

### Basic Configuration

```yaml
log_level: info
ssl: false
certfile: fullchain.pem
keyfile: privkey.pem
external_access: false
audiobooks_path: /share/audiobooks
podcasts_path: /share/podcasts
create_folders: true
```

### Options

- **log_level** (string): Set the logging level (trace, debug, info, warn, error, fatal, off)
- **ssl** (boolean): Enable SSL/HTTPS support
- **certfile** (string): SSL certificate file (when SSL is enabled)
- **keyfile** (string): SSL private key file (when SSL is enabled)
- **external_access** (boolean): Enable direct access via port 13378 (in addition to ingress)
- **audiobooks_path** (string): Path to your audiobooks directory (default: /share/audiobooks)
- **podcasts_path** (string): Path to your podcasts directory (default: /share/podcasts)
- **create_folders** (boolean): Automatically create directories if they don't exist (default: true)

### Media Setup

Configure your media directories in the addon options:

**Recommended paths:**
- Audiobooks: `/share/audiobooks` (accessible via Samba/SMB)
- Podcasts: `/share/podcasts` (accessible via Samba/SMB)

**Alternative paths:**
- `/media/audiobooks` (if you have external storage mounted)
- `/config/audiobooks` (for smaller collections)
- `/addon_configs/audiobookshelf/audiobooks` (addon-specific storage)

**Important:** Paths must start with `/share`, `/media`, `/config`, or `/addon_configs` for security reasons.

### Automatic Configuration

The addon will automatically:
1. Create the specified directories (if `create_folders: true`)
2. Set up initial library configuration pointing to your custom paths
3. Configure proper permissions

### Folder Structure Example

Based on your configuration (`audiobooks_path: /share/audiobooks`):

```
/share/audiobooks/
├── Author Name/
│   └── Book Title/
│       ├── Chapter 01.mp3
│       ├── Chapter 02.mp3
│       └── cover.jpg
└── Another Author/
    └── Another Book/
        └── audiobook.m4b

/share/podcasts/
└── Podcast Name/
    ├── Episode 001.mp3
    └── Episode 002.mp3
```

## Usage

### With Ingress (Recommended)
1. Configure your media paths in the addon settings before starting
2. Start the add-on - it will create the directories and initial configuration automatically
3. Click on "Audiobookshelf" in the Home Assistant sidebar
4. Complete the initial setup wizard (your libraries will already be configured!)
5. Scan your libraries to import your audiobooks and podcasts
6. Start listening!

### Direct Access
If you need direct access (for mobile apps or external access):
1. Set `external_access: true` in the configuration
2. Configure your media paths
3. Access the interface at `http://your-home-assistant:13378`
4. Follow the same setup process

## SSL/HTTPS Setup

To enable SSL:

1. Ensure you have SSL certificates in the `/ssl/` directory
2. Set `ssl: true` in the configuration
3. Specify your certificate files in `certfile` and `keyfile`
4. Access the interface at `https://your-home-assistant:13378`

## Mobile Apps

Audiobookshelf offers mobile apps for:
- iOS: Available on the App Store
- Android: Available on Google Play Store or F-Droid

### Mobile App Configuration

**With Ingress (Recommended):**
- Server: Your Home Assistant external URL (e.g., `https://your-home-assistant.duckdns.org`)
- Use the same credentials as your Home Assistant user

**With Direct Access:**
- Enable `external_access: true` in addon configuration
- Server: `http://your-home-assistant:13378` (or https if SSL enabled)
- Username/Password: As configured in the Audiobookshelf interface

Note: For mobile apps to work with ingress, ensure your Home Assistant is accessible from outside your network.

## Backup

Your Audiobookshelf data is stored in `/config/audiobookshelf/`. This includes:
- User accounts and preferences
- Library metadata and progress
- Server settings

This directory is automatically included in Home Assistant backups.

## Troubleshooting

### Add-on won't start
- Check the add-on logs for error messages
- Ensure media directories exist and are accessible
- Verify SSL certificate paths if SSL is enabled

### Can't access web interface
- **With Ingress**: Check if the addon is running and look for "Audiobookshelf" in the Home Assistant sidebar
- **Direct Access**: Ensure `external_access: true` is set and port 13378 is not blocked by firewall
- Check if another service is using port 13378
- Verify the add-on is running in the Supervisor

### Audio files not detected
- Ensure files are in supported formats (MP3, M4A, M4B, etc.)
- Check file permissions
- Verify the library path is correct
- Try rescanning the library

## Support

For issues specific to this Home Assistant add-on:
- [GitHub Issues](https://github.com/your-username/hassio-audiobookshelf/issues)

For general Audiobookshelf support:
- [Official Documentation](https://www.audiobookshelf.org/docs)
- [Discord Community](https://discord.gg/audiobookshelf)

## License

MIT License - see the [LICENSE](LICENSE) file for details.

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg