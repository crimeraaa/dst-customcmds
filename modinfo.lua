name = "Custom Console Commands (Local)" --this is just so in testing i use the "Local" version which is clearly separated from the workshop version.
-- name = "Custom Console Commands"
author = "crimeraaa"
description = 
[[
Custom remote console commands you can use from the console. This is also designed to help Server Hosters run some useful commands directly from the terminal window.

The possible commands are:

`c_countall(prefab, mode)`
`c_giveall(prefab, count)` and `c_giveto(playernum, prefab, count)`
`c_creativeon()`, `c_creativeoff()` and `c_creativeall()`
`c_godmodeon()`, `c_godmodeoff()` and `c_godmodeall()`
`c_spawnbeef(tendency, playernum, saddle)`

For more information run `c_listcmd()` or `c_helpcmd()`.
]]

version = "1.2.4"
api_version = 10

dst_compatible = true 
dont_starve_compatible = false

client_only_mod = false
server_only_mod = true
all_clients_require_mod = false
