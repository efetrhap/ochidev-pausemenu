fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'OchiDev'
description 'OchiDev - Pause Menu'
version '1.0.0'

ui_page 'web/index.html'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

files {
    'web/index.html',
    'web/css/style.css',
    'web/js/app.js'
}

dependencies {
    'ox_lib'
}
