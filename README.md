# dst-customcmds
Some simple console commands that make my life ingame easier.

You must either be an ingame admin or a Server Hoster to make use of these functions.

# The Commands

## Count All of a Prefab and Announce

> `c_countall(prefab, mode)`

Counts all instances of a specified in the shard. Stacksizes are taken into consideration, and number of stacks will be separate should stacksizes greater than 1 exist. It always prints out the result in the console.

Parameter `prefab` is just a string of the prefab's ingame code. For example, `"beefalo"` is the prefab code for Beefalo. `wathgrithr` is the prefab code for Wigfrid.

Parameter `mode` lets you specify how you can announce it to chat. 

### Options for `mode`

None of the below options are strings. They are either `nil`, `number` or `boolean`.

> `nil` input (or even typing out `nil` as is) defaults to announcing the count in chat, directly from the server.
> 
> `0` input makes your character talk and a global chat message is sent from you.
> 
> `1` input makes your character talk and a whisper chat message is sent from you.
> 
> `2` input sends a local chat message which only you can see.
> 
> `3` and `true` do the same as `nil`.
> 
> `false` will not announce it to any form of chat. The only form of response is in the console printout.

### Give an amount of a Prefab

> `c_giveall(prefab, count)`
> 
> `c_giveto(playernum, prefab, count)`

Similar to the `c_give(prefab)` command. The `prefab` parameter is always a string which represents a prefab code. It should also always be an `inventoryitem`, as you can't give mobs to players' inventories for example.

The `count` parameter is optional and will default to number `1`. If it is specified, it should always be a number.

Both functions work the exact same as `c_give`. 
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
`c_creativeall()` toggles between on and off. This may cause some confusion if some folks went up from a different shard after this command was called.

## Godmode Commands

> `c_godmodeon()`
> 
> `c_godmodeoff()`
> 
> `c_godmodeall()`

Allows you to choose (Super) Godmode for all players. 
`c_godmodeon()` always, well, activates it for everybody on the shard. 
`c_godmodeoff()` deactivates it.
`c_godmodeall()` toggles between on and off. This may cause some confusion if some folks went up from a different shard after this command was called.

## Spawn Tamed Beefalo for a Player

> `c_spawnbeef(tendency, playernum, saddle)`

Parameter `tendency` can be set to `"DEFAULT"`, `"RIDER"`, `"ORNERY"` or `"PUDGY"`. 

Parameter `playernum` is self explanatory I hope. They will be given a Beefalo Bell, and also act as the location where the Beefalo is spawned.

Parameter `saddle` lets you choose what saddle for this Beefalo. If `nil`, it will default to the Glossamer Saddle.
