fx_version 'cerulean'
games { 'gta5' }

author 'ESX Custom Template'
description 'Core: Dynamic Faction System (ESX + oxmysql)'
version '1.0.0'

shared_script 'config.lua'

server_scripts {
  'server/db.lua',
  'server/permissions.lua',
  'server/faction_manager.lua',
  'server/main.lua'
}

client_scripts {
  'client/main.lua'
}

ui_page 'client/nui/index.html'

files {
  'client/nui/index.html',
  'client/nui/app.js',
  'client/nui/style.css'
}

dependencies {
  'es_extended',
  'oxmysql'
}
