fx_version 'cerulean'
games { 'gta5' }

author 'ESX Custom Template - Police'
description 'Police Module: MDT, Arrests, Jail, Queries'
version '1.0.0'

shared_script '@es_extended/imports.lua'

server_scripts {
  'server/main.lua',
  'server/mdt.lua'
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
  'oxmysql',
  'core'
}
