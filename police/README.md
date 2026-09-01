Police Module (MVP)

Install:
1. copy police resource to resources/police
2. import database/police.sql into DB
3. ensure core resource is running (feature/core branch)
4. ensure oxmysql and es_extended

Commands:
/mdt - open MDT (records)

Events:
police:arrestPlayer (server) - args: targetServerId, minutes, reason
police:releasePlayer (server) - args: targetServerId

Notes:
- Permission checks use faction tag 'LSPD' by default for arrests/release. Adjust queries or permission keys as needed.
