fx_version 'cerulean'
game 'gta5'

name 'ayerosu_weather'
description 'ayerosu_weather - Lightweight Weather and Time Management'
author 'ayerosu'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    'server.lua'
}

provide 'qb-weathersync'
