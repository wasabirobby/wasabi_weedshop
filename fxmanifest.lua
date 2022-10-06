-----------------For support, scripts, and more----------------
--------------- https://discord.gg/wasabiscripts  -------------
---------------------------------------------------------------

fx_version 'cerulean'
game 'gta5'
lua54 'yes'
description 'ESX Advanced Weed Shop'
author 'wasabirobby#1111'
version '1.0.0'

files {
	'html/ui.html',
	'html/styles.css',
	'html/scripts.js',
	'html/debounce.min.js',
	'html/iransans.otf',
	'html/img/**.png'
}

ui_page 'html/ui.html'

shared_script 'config.lua'

client_scripts {
	'client/**.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/**.lua'
}

dependency 'es_extended'