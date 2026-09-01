#!/bin/bash
# simple import script for database
DB_USER="fivem"
DB_PASS="securepassword"
DB_NAME="fivem_rp"

mysql -u${DB_USER} -p${DB_PASS} ${DB_NAME} < database/schema.sql
mysql -u${DB_USER} -p${DB_PASS} ${DB_NAME} < database/seed_factions.sql
mysql -u${DB_USER} -p${DB_PASS} ${DB_NAME} < database/police.sql

echo "SQL import complete. Please configure server.cfg.example and start your server."
