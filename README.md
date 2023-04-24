# dst-customcmds
Some simple console commands that make my life ingame easier.

You must either be an ingame admin or a Server Hoster to make use of these functions.

# The Commands

## List Command

> `c_listcmd()`

Will print out in the console the list of general syntax for each command as well as the `Help Key` you can input for `c_helpcmd(key)`.

## Help Commands

> `c_helpcmd(key)`

If called as is `c_helpcmd()` it will print out in the console a list of `Help Keys`. Each `Help Key` can be used as an input string for the command to get more detailed information on that specific command. 

## Count All of a Prefab and Announce

> `c_countall(prefab, ..., mode)`
> 
> `c_removeall(prefab, ..., mode)`

Counts or removes all instances of specified in the shard. The `...` indicates a variable argument, meaning that you can include as many prefabs as you like. 

Stack sizes are taken into consideration, and number of stacks will be separate should stack sizes greater than 1 exist. It always prints out the result in the console.

Parameter `prefab` is just a string of the prefab's ingame code. For example, `"beefalo"` is the prefab code for Beefalo. `"wathgrithr"` is the prefab code for Wigfrid, and so on.

Parameter `mode` lets you specify how you can announce it to chat. It can be a boolean or a number from 0-3. It can be omitted and the command will default to a Server Announcement. If you do want to include it, make sure it is the very last argument in the command as that is the only index it will check.

### Options for `mode`

> `true` will run a Server Announcement.
> 
> `false` will not announce it to any form of chat. The only form of response is in the console printout.

## Give Prefabs

> `c_giveall(prefab, count)`
> 
> `c_giveto(num, prefab, count)`

Similar to the `c_give(prefab)` command. The `prefab` parameter is always a string which represents a prefab code. It should also always be an `inventoryitem`, as you can't give mobs to players' inventories for example.

The `count` parameter is optional and will default to number `1`. If it is specified, it should always be a number.

`c_giveall` will give everybody in the server the number of prefab specified. 
`c_giveto` will give the number of prefab specified to that exact player number. 

The reason I created `c_giveto` was because the normal `c_give` command only applies to the person who ran the command, never to anybody else on the server.

## Creative Mode Commands

> `c_creativeon()`
> 
> `c_creativeoff()`
> 
> `c_creativeall()`

Allows you to choose Creative Mode for all players. 
`c_creativeon()` always, well, activates it for everybody on the shard. 
`c_creativeoff()` deactivates it.
`c_creativeall()` toggles between on and off. It uses a local variable `switcharoo1` to toggle, so it is independent of any one player's creative mode boolean. You can input `true` or `false` to specifically set it if you'd like as well.

## Godmode Commands

> `c_godmodeon()`
> 
> `c_godmodeoff()`
> 
> `c_godmodeall()`

Allows you to choose (Super) Godmode for all players. 
`c_godmodeon()` always, well, activates it for everybody on the shard. 
`c_godmodeoff()` deactivates it.
`c_godmodeall()` toggles between on and off. It uses a local variable `switcharoo2` to toggle, so it is independent of any one player's godmode boolean. You can input `true` or `false` to specifically set it if you'd like as well.

## Spawn Tamed Beefalo for a Player

> `c_spawnbeef(num, tendency, saddle)`


Parameter `num` refers to the player number of the person you'd like to spawn the Beefalo on. They will be given a Beefalo Bell, and also act as the location where the Beefalo is spawned.

Parameter `tendency` can be set to `"DEFAULT"`, `"RIDER"`, `"ORNERY"` or `"PUDGY"`. 

Optional Parameter `saddle` lets you choose what saddle for this Beefalo. If none specified, it will default to the Glossamer Saddle. You can either input the full prefab code (e.g. `"saddle_basic"`) or simply use only the second word, e.g. `"race"` as this command will prefix `"saddle_"` to your input string if that pattern is not found.

## Check, Add or Remove Tags for a Player

> `c_checktags(num, tag, ...)`
> 
> `c_addtags(num, tag, ...)`
> 
> `c_removetags(num, tag, ...)`

For a specifc player number, check/add/remove the variable input tags.
