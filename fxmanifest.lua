fx_version 'adamant'

game 'gta5'

author 'Diesel#6288'

description 'ESX Plastine operacija'


shared_script '@es_extended/imports.lua'

server_scripts {
  '@oxmysql/lib/MySQL.lua',
  '@es_extended/locale.lua',
  'locales/*.lua',
  'config.lua',
  'server/main.lua'
}

client_scripts {
  '@es_extended/locale.lua',
  'locales/*.lua',
  'config.lua',
  'client/main.lua'
}


dependencies {
	'es_extended'
}
