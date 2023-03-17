-- name = "Custom Console Commands (Local)" --this is just so in testing i use the "Local" version which is clearly separated from the workshop version.
name = "Custom Console Commands"
author = "Crimeraaa"
description = 
[[Server-side commands you can use from the console (open it using the ` key!)

This is also designed to help Server Hosters run some simple commands directly from the terminal window.

The possible commands are:

c_countall(prefab, mode)
c_giveall(prefab, count)
c_giveto(playernum, prefab, count)
c_creativeon() / c_creativeoff() / c_creativeall()
c_godmodeon() / c_godmodeoff() / c_godmodeall()
c_spawnbeef(tendency, playernum, saddle)

]]

version = "1.2.0"
api_version = 10

dst_compatible = true 
dont_starve_compatible = false

client_only_mod = false
server_only_mod = true
all_clients_require_mod = false
