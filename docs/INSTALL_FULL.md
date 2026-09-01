# Installationsanleitung (kurz)

Diese Anleitung führt dich Schritt-für-Schritt durch das Einrichten des ESX Custom Template (Core + Police MVP).

Voraussetzungen
- FiveM Server (cfx) installiert
- MySQL / MariaDB erreichbar
- Git installiert
- oxmysql Resource
- ESX (es_extended) kompatible Version

Schritte
1) Repository clonen
   git clone https://github.com/lukasvonfalke-collab/esx-custom-template.git
   cd esx-custom-template

2) Ressourcen in den Server kopieren
   Kopiere die Ordner `core` und `police` (oder das gesamte Repo) in dein FiveM `resources/` Verzeichnis.

3) MySQL-Datenbank anlegen
   mysql -u root -p
   CREATE DATABASE fivem_rp CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
   CREATE USER 'fivem'@'%' IDENTIFIED BY 'securepassword';
   GRANT ALL PRIVILEGES ON fivem_rp.* TO 'fivem'@'%';
   FLUSH PRIVILEGES;

4) Importiere die SQL-Schemas
   mysql -u fivem -p fivem_rp < database/schema.sql
   mysql -u fivem -p fivem_rp < database/seed_factions.sql
   mysql -u fivem -p fivem_rp < database/police.sql

5) server.cfg konfigurieren
   - Öffne `server.cfg.example`, trage mysql_connection_string und ggf. sv_licenseKey ein
   - Füge `ensure oxmysql`, `ensure es_extended`, `ensure core`, `ensure police` hinzu (siehe Beispiel)

6) Starte den Server
   - Starte den FiveM Server
   - Prüfe die Konsole auf Fehler (DB connection etc.)

7) Setze initiale Fraktions-Leader
   - Öffne deine DB und setze `head_identifier` für Fraktionen:
     UPDATE factions SET head_identifier = 'steam:STEAMHEX' WHERE tag = 'LSPD';
   - Alternativ: erstelle in-game per Admin Event

8) Ingame Tests
   - Verbinde dich mit einem Account (Admin/Leader)
   - /factionmenu → öffnet Fraktionsmanagement (NUI Skeleton)
   - /mdt → öffnet MDT (Police MVP)

Fehlerbehebung
- DB-Verbindung prüfen: stimmt mysql_connection_string? oxmysql läuft?
- oxmysql logs: prüfe resource start order
- Server-Konsole auf Lua-Fehler prüfen

Lizenz & Assets
- Dieses Repo enthält keine kostenpflichtigen Assets. Fahrzeuge/MLOs müssen separat installiert und legal erworben werden.

Support
- Eröffne ein Issue im Repository für Fehler oder Wünsche.
