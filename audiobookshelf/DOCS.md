# Home Assistant Add-on: Audiobookshelf

## Installation

1. Füge das Repository zu Home Assistant hinzu
2. Installiere das Audiobookshelf Add-on
3. Konfiguriere deine Medienverzeichnisse
4. Starte das Add-on
5. Öffne die Web-UI über Ingress

## Konfiguration

Das Add-on kann über die Home Assistant UI konfiguriert werden. Die wichtigsten Einstellungen sind die Pfade zu deinen Audiobuch- und Podcast-Verzeichnissen.

## Fehlerbehebung

### Häufige Probleme

1. **Add-on startet nicht**: Überprüfe die Log-Ausgabe
2. **Keine Medien sichtbar**: Stelle sicher, dass die Verzeichnispfade korrekt sind
3. **Ingress funktioniert nicht**: Starte das Add-on neu

### Log-Analyse

Aktiviere Debug-Logging für detaillierte Informationen:

```yaml
log_level: debug