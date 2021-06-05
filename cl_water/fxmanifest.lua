fx_version "bodacious"
games { "gta5" };

author "Canis Lupus"
description "Pump Water | Cayo Perico small job"

client_scripts {
    "client/client.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "server/server.lua"
}

shared_scripts {
    "locations.lua"
}