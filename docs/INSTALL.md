# INSTALL.md

## Quick Install (Core)

1. Ensure oxmysql is installed and configured.
2. Ensure ESX (es_extended) is installed and running.
3. Clone this repo into your server resources folder and ensure `core` resource is present.
4. Add to server.cfg (example):

set mysql_connection_string "server=127.0.0.1;uid=fivem;password=securepassword;database=fivem_rp;charset=utf8mb4"
ensure oxmysql
ensure es_extended
ensure core

5. Import database:
mysql -u user -p fivem_rp < database/schema.sql
mysql -u user -p fivem_rp < database/seed_factions.sql

6. Set initial faction heads (example):
UPDATE factions SET head_identifier = 'steam:YOURSTEAMHEX' WHERE tag = 'LSPD';

7. Start server and test /factionmenu as admin or leader.

