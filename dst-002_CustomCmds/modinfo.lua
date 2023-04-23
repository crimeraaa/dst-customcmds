local IS_LOCAL = true
local IS_CLIENT = false

local NAME_APPEND = (IS_LOCAL and "(Local)") or (IS_CLIENT and "(Client)") or "(Server)"
name = "Custom Console Commands "..NAME_APPEND
author = "Crimeraaa"
description = [[
Custom remote commands you can use from the console. This is also designed to help Server Hosters run some useful commands directly from the terminal window.

The possible commands are:

c_countall(prefab, ..., mode) and c_removeall(prefab, ..., mode)
c_giveall(prefab, count) and c_giveto(playernum, prefab, count)
c_creativeon(), c_creativeoff() and c_creativeall()
c_godmodeon(), c_godmodeoff() and c_godmodeall()
c_spawnbeef(tendency, playernum, saddle)
c_checktags(playernum, tag, ...), c_addtags(playernum, tag, ...) and c_removetags(playernum, tag, ...)

For more information run `c_listcmd()` or `c_helpcmd()`.]]

version = "1.3.0"
api_version = 10

dst_compatible = true 
dont_starve_compatible = false

client_only_mod = IS_CLIENT
server_only_mod = false
all_clients_require_mod = not IS_CLIENT

icon_atlas = "customcmd.xml"
icon = "customcmd.tex"

configuration_options = {
    {
        name = "should_debug",
        label = "Debug",
        hover = "Enable Debug printouts in the console?",
        options = {
            { description = "Enabled", data = true, hover = "The mod will printout debug messages on load." },
            { description = "Disabled", data = false, hover = "The mod not print out anything on load." },
        },
        default = false,
    }
}
--[[
STEAM WORKSHOP DESC:

Custom remote commands you can use from the console. This is also designed to help Server Hosters run some useful commands directly from the terminal window, where there is no concept of the current player ("ThePlayer").

[h1]The possible commands are:[/h1]

[table]
    [tr]
        [th]Command[/th]
        [th]Details[/th]
        [th]c_helpcmd Key[/th]
    [/tr]
    [tr]
        [td]c_countall(prefab, ..., mode)[/td]
        [td]Counts all existing instances (in the current shard) of input prefabs.         
            [list]
                [*]'...' is a variable input, meaning you can input as many prefabs as you like.
                [*]'mode' is an optional parameter which defaults to true. 
                [*]'true' will run a server announcement and 'false' will only print out to console.
            [/list]
        [/td]
        [td]"count", "countall", "countprefabs"[/td]
    [/tr]
    [tr]
        [td]c_removeall(prefab, ..., mode)[/td]
        [td]Removes  all existing instances (in the current shard) of input prefabs.      
            [list]
                [*]'...' is a variable input, meaning you can input as many prefabs as you like.
                [*]'mode' is an optional parameter which defaults to true. 
                [*]'true' will run a server announcement and 'false' will only print out to console.
            [/list]
        [/td]
        [td]"remove", "removeall", "removeprefabs"[/td]
    [/tr]
    [tr]
        [td]
            [list]
                [*]c_giveall(prefab, count)
                [*]c_giveto(playernum, prefab, count)
            [/list]
        [/td]
        [td]Gives an input prefab to everyone or a specific player number.
            [list]
                [*]'count' is an optional parameter which defaults to 1. 
                [*]You can specify how much of this prefab you want to give.
            [/list]
        [/td]
        [td]"give", "giveall", "giveto", "giveitem"[/td]
    [/tr]
    [tr]
        [td]
            [list]
                [*]c_creativeon()
                [*]c_creativeoff()
                [*]c_creativeall()
            [/list]
        [/td]
        [td]
            [list]
                [*]Sets Creative Mode to on, off, or toggles it. 
                [*]Applies to everyone on the shard.[/td]
        [td]"creative", "freecrafting", "creativemode", "creativeon", "creativeoff", "creativeall"[/td]
    [/tr]
    [tr]
        [td]
            [list]
                [*]c_godmodeon()
                [*]c_godmodeoff()
                [*]c_godmodeall()
            [/list]
        [/td]
        [td]
            [list]
                [*]Sets Godmode to on, off, or toggles it. 
                [*]Applies to everyone on the shard.
            [/list]
        [/td]
        [td]"godmode", "god", "invincible", "supergodmode", "godmodeon", "godmodeoff", "godmodeall"[/td]
    [/tr]
    [tr]
        [td]c_spawnbeef(playernum, tendency, saddle)[/td]
        [td]
            [list]
                [*]For a specific player number, spawn a fully tamed beefalo.
                [*]Beefalo will be set to given tendency and Player given a Beefalo Bell in their inventory.
                [*]'saddle' is an optional parameter which defaults to Glossamer saddle. 
                [*]Use the prefab code such as "saddle_race", "saddle_basic" and "saddle_war".
            [/list]
        [/td]
        [td]"spawnbeef", "beef", "beefalo", "tamedbeef"[/td]
    [/tr]
    [tr]
        [td]
            [list]
                [*]c_checktags(playernum, tag, ...)
                [*]c_addtags(playernum, tag, ...)
                [*]c_removetags(playernum, tag, ...)
            [/list]
        [/td]
        [td]
            [list]
                [*]Checks, adds or removes a specific player number's tags. 
                [*]'...' is a variable input, meaning you can input as many prefabs as you like.
            [/list]
        [/td]
        [td]"tags", "checktags", "addtags", "removetags"[/td]
    [/tr]
[/table]

[b]For more information run `c_listcmd()` or `c_helpcmd()`.[/b]
]]
