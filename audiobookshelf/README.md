# Home Assistant Add-on: Audiobookshelf

Ein selbst gehosteter Audiobook- und Podcast-Server für Home Assistant.

![Supports aarch64 Architecture][aarch64-shield]
![Supports amd64 Architecture][amd64-shield]
![Supports armhf Architecture][armhf-shield]
![Supports armv7 Architecture][armv7-shield]
![Supports i386 Architecture][i386-shield]

## Über

Audiobookshelf ist ein selbst gehosteter Audiobook- und Podcast-Server. Du kannst deine Audiobücher und Podcasts von jedem Gerät aus streamen und verwalten.

## Funktionen

- 📚 Audiobook-Bibliothek mit Cover-Art und Metadaten
- 🎧 Podcast-Management mit automatischen Downloads
- 📱 Responsive Web-Interface
- 🔄 Fortschrittsverfolgung und Lesezeichen
- 👥 Multi-User-Unterstützung
- 📊 Statistiken und Berichte
- 🔍 Erweiterte Suchfunktionen

## Installation

1. Navigiere zu **Supervisor** → **Add-on Store**
2. Füge dieses Repository hinzu: `https://github.com/deinusername/hassio-audiobookshelf`
3. Installiere das "Audiobookshelf" Add-on
4. Konfiguriere das Add-on (siehe Konfiguration unten)
5. Starte das Add-on

## Konfiguration

### Add-on Konfiguration

```yaml
data_directory: /config/audiobookshelf
audiobooks_directories:
  - /media/audiobooks
  - /share/audiobooks
podcasts_directories:
  - /media/podcasts
backup_directory: /config/audiobookshelf/backups
log_level: info
host: "0.0.0.0"
port: 13378
```

### Konfigurationsoptionen

#### Option: `data_directory`

Das Verzeichnis, in dem Audiobookshelf seine Daten speichert.

#### Option: `audiobooks_directories`

Liste der Verzeichnisse, die deine Audiobücher enthalten.

#### Option: `podcasts_directories`

Liste der Verzeichnisse, die deine Podcasts enthalten.

#### Option: `backup_directory`

Verzeichnis für Backups der Audiobookshelf-Datenbank.

#### Option: `log_level`

Legt das Log-Level fest.

- `debug`: Sehr detaillierte Debug-Informationen
- `info`: Allgemeine Informationen (Standard)
- `warn`: Nur Warnungen und Fehler
- `error`: Nur Fehler

#### Option: `host`

Die IP-Adresse, auf der Audiobookshelf lauscht. Standard ist `0.0.0.0`.

#### Option: `port`

Der Port, auf dem Audiobookshelf lauscht. Standard ist `13378`.

## Ingress

Dieses Add-on unterstützt Ingress und kann direkt über das Home Assistant Interface aufgerufen werden, ohne dass ein separater Port geöffnet werden muss.

## Unterstützung

Bei Problemen oder Fragen:

1. Überprüfe die Add-on Logs
2. Stelle sicher, dass deine Medienverzeichnisse existieren und lesbar sind
3. Erstelle ein Issue im GitHub Repository

## Changelog & Releases

Dieses Repository folgt [Semantic Versioning][semver].

## Beiträge

Beiträge sind willkommen! Bitte erstelle einen Pull Request oder ein Issue.

## Lizenz

MIT License

Copyright (c) 2024

## Autoren & Mitwirkende

[aarch64-shield]: https://img.shields.io/badge/aarch64-yes-green.svg
[amd64-shield]: https://img.shields.io/badge/amd64-yes-green.svg
[armhf-shield]: https://img.shields.io/badge/armhf-yes-green.svg
[armv7-shield]: https://img.shields.io/badge/armv7-yes-green.svg
[i386-shield]: https://img.shields.io/badge/i386-yes-green.svg
[semver]: http://semver.org/spec/v2.0.0.html