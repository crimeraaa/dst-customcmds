local _G = GLOBAL
_G.setfenv(1, _G) --thanks to Atoba Azul for this! It's ridiculously useful. 

--[[ GENERIC FNs ]]

if TheNet and not TheNet:GetIsServerAdmin() then
    return -- if ingame player who is not an admin, return immediately
end

local prettyname = "CustomCmd:"
print(prettyname.." Begin declaring all commands...")
local cmd_msg = prettyname.." Declaring command %s..."

local cmdlist = {}
cmdlist["count"] = 
[[
The 'count' command:
    'c_countall(prefab, ..., mode)'

Takes a string "prefab" code as input and counts all instances in the shard it was run.
This command can count as many prefab strings as you want.
'mode' is optional, set it to the last input in the command. If none, will default to a Server Announcement. 
The command will always send a printout to your console.

'prefab' is a string of your desired inventory item's code.
'mode' is an optional parameter for how you would like to announce it.
    * input 'true' will do a Server Announcement.
    * input 'false' will not do any kind of announcement or message, but still print the result.
    * (Ingame Admins only):
        - inputs '0', '1' and '2' will send a Global, Whisper and Local chat message respectively.
	- for Server Hosters, these will only print out the result for you.
    * input '3' will also do a Server Announcement.
]]

cmdlist["give"] = 
[[
The 'give' commands:
    c_giveall(prefab, count)
    c_giveto(num, prefab, count)

Gives inventory items. If 'count' is not specified it defaults to 1.

'num' is the player number of the person you'd like to give the item/s to. 
'prefab' is a string of your desired inventory item's code.
'count' is an optional parameter. It should be a number value.
]]

cmdlist["creative"] = 
[[
The 'creative' commands:
    c_creativeon()
    c_creativeoff()
    c_creativeall()

Sets all players' Creative Mode in the shard it was run.

'c_creativeon()' and 'c_creativeoff()' turn Creative Mode on and off respectively.
'c_creativeall()' will alternate between on and off. You can also input 'true' and 'false'.
]]

cmdlist["godmode"] =
[[
The 'godmode' commands:
    c_godmodeon()
    c_godmodeoff()
    c_godmodeall()

Sets all players' Godmode in the shard it was run.

'c_godmodeon()' and 'c_godmodeoff()' turn Godmode on and off respectively.
'c_godmodeall()' will alternate between on and off. You can also input 'true' and 'false'.
]]

cmdlist["spawnbeef"] =
[[
The 'spawnbeef' command:
	c_spawnbeef(tendency, num, saddle)
	
Spawns a specific kind of Tamed Beefalo for a specified player number. 
If 'saddle' is not specified it will default to 'saddle_race' (Glossamer). 
It will also automatically give the specified player a Beefalo Bell.
	
Tendency is a string of the type of beefalo. 
	- "DEFAULT"
	- "RIDER"
	- "ORNERY"
	- "PUDGY"
	
'num' is the number of the player you'd like to spawn the beefalo for.

saddle' is a string of the prefab code for the saddle you'd like.
You may use the full prefab code or simply use the second word.
	- "saddle_basic" or "basic"
	- "saddle_race"  or "race"
	- "saddle_war" 	 or "war"
]]

local help = 
[[
To get help of only one command, run 'c_helpcmd()' with the string under 'Help Key' as the input.
To see the list of 'Help Keys', run 'c_helpcmd()' as is.
To see a quick list of the commands, run 'c_listcmd()' as is.
]]

-- [[ HELP CMDs ]]

print(string.format(cmd_msg, "c_listcmd and c_help"))
function c_listcmd()
    print("Suffixes indicate multiple versions of that command.")
	for k,v in pairs(cmdlist) do
		local cmdname = "Command Syntax:    'c_%s'"
		if k == "count" then
			cmdname = cmdname.."all"
		elseif k == "give" then
			cmdname = cmdname.."(-all and -to)"
		elseif k == "creative" or k == "godmode" then
			cmdname = cmdname.."(-on, -off and -all)"
		end
		local helpkey = "c_listcmd Key:     \"%s\""
		print(string.format(cmdname, k))
		print(string.format(helpkey, k))
	end
	print(help)
end

function c_helpcmd(input)	
	local helpkey = "Help Key: \"%s\""
	if input == nil then
		for k,v in pairs(cmdlist) do
			print(string.format(helpkey,k))
		end
		print(help)
		return
	end
	
	local invalid = prettyname.." Input '%s'"
	-- toss out all non strings and warn user
	if not (type(input) == "string") then
		input = tostring(input)
		print(string.format(invalid.." is not a string!", input))
		return
	end
	
	for k,v in pairs(cmdlist) do
		if k == input then
			print(string.format(helpkey, k))
			print(v)
		end
	end
	
	local help = string.gsub(help, "only one", "another")
	print(help)
end

-- [[ GENERAL FNs ]]

local function GetShard()
    local shard = "this shard" -- default if somehow none of the below match
    if TheWorld:HasTag("forest") then
        shard = "Surface"
    elseif TheWorld:HasTag("cave") then
        shard = "Caves"
    elseif TheWorld:HasTag("island") then -- IA support :D
        shard = "Shipwrecked"
    elseif TheWorld:HasTag("volcano") then
        shard = "Volcano"
    end
    return string.upper(shard)
end

local function NoInput(check)
    local msg = prettyname.." Please input a '%s' for the command to work with!"
    if check == "prefab" then
        msg = string.format(msg, "prefab")
    elseif check == "tendency" then
        msg = string.format(msg, "Beefalo tendency")
    elseif check == "player" then
        msg = string.format(msg, "Player number")
	else
		msg = "Seems like I forgot a NoInput check for another kind of variable!"
    end
    print(msg)
end

local function ValidPlayerNum(num)
	local invalid = prettyname.." Player number '%d'"
    if not (type(num) == "number") then
		invalid = string.gsub(invalid, "%d", "input")
		local _invalid = invalid.." is not a number value!"
        print(invalid)
        return nil
    elseif num == 0 or (num > #AllPlayers) or (num < 0) then 
        local _invalid = invalid.." is outside the current playerlist."
        print(string.format(_invalid, num))
        return nil
    end
    return true
end

--[[ GIVING INV ITEMS FNs ]]

local function DisplayName(prefab)
    local upper = string.upper(prefab) 
	local invalid = prettyname.." Prefab '%s' has no Display Name!"
    local name = ""
    for k,v in pairs(STRINGS.NAMES) do
        if k == upper then 
            name = v
            return name
        end
    end
    print(string.format(invalid, prefab))
    name =  "MISSING NAME" 
    return name
end

local function IsInvItem(prefab)
    local prefab = string.lower(prefab)
	local invalid = prettyname.." Prefab '%s' is not an inventory item!"
    local item = SpawnPrefab(prefab) --thanks to Anagram and HarryPPPotter for helping here!
    if item.components.inventoryitem == nil then
        print(string.format(invalid, prefab))
        item:Remove() -- this is so stupid but whatever
        return nil
    end 
    item:Remove()
    return true
end

local function ValidPrefab(prefab)
	local invalid = prettyname.." Prefab input '%s'"
    if not (type(prefab) == "string") then
		prefab = tostring(prefab)
        print(string.format(invalid.." is not a string!", prefab))
        return nil
    end

    local lower = string.lower(prefab)
    if Prefabs[lower] == nil then 
        print(string.format(invalid.." is not an existing prefab!", prefab))
        return nil 
    end --thanks to Atoba Azul and thegreatmanagement for the Prefabs[prefab] check line!
    return true
end

local function GiveInInventory(player, prefab, count)
    local prefab = string.lower(prefab)
    for i=1, count, 1 do
        player.components.inventory:GiveItem(SpawnPrefab(prefab))
    end
end

-- [[ GIVE INV ITEM TO EVERYBODY CMD ]]

print(string.format(cmd_msg, "c_giveall"))
function c_giveall(prefab, count)
	if prefab == nil then
		NoInput("prefab")
		return
    elseif ValidPrefab(prefab) == nil then 
        return
	elseif IsInvItem(prefab) == nil then
		return
    end

    local name = DisplayName(prefab)
    local world = GetShard()
    local count = count or 1
	for i,v in pairs(AllPlayers) do 
        local player = AllPlayers[i]
		GiveInInventory(player, prefab, count) 
    end

    local gave_all = prettyname.." %s - Gave everybody %d %s ('%s')."
    print(string.format(gave_all, world, count, name, prefab))
end

-- [[ GIVE INV ITEM TO SPECIFIC PERSON CMD ]]

print(string.format(cmd_msg, "c_giveto"))
function c_giveto(num, prefab, count) 
	if num == nil then
		NoInput("player")
		return
    elseif ValidPlayerNum(num) == nil then 
		return 
	elseif prefab == nil then
		NoInput("prefab")
		return
	elseif ValidPrefab(prefab) == nil then 
		return
	elseif IsInvItem(prefab) == nil then
        return
    end
    
    local name = DisplayName(prefab)
    local world = GetShard()
    local player = AllPlayers[num]
    local count = count or 1    
	GiveInInventory(player, prefab, count)

    local gaveto = prettyname.." %s - Gave Player '%d' ('%s'): %d %s ('%s')."
    print(string.format(gaveto, world, num, player.name, count, name, prefab))
end


-- [[ CREATIVE MODE FNs ]]

local mode_msg = prettyname.." %s - Set '%s' to '%s' for all players." -- generic print msg!

local function SetCreative(bool)
    for i,v in pairs(AllPlayers) do
        local player = AllPlayers[i]
		player.components.builder.freebuildmode = bool
        player:PushEvent("techlevelchange")
    end
	
	local world = GetShard()
	local _bool = tostring(bool)
	local msg = string.format(mode_msg, world, "Creative Mode", _bool)
	print(msg)
end

-- [[ CREATIVE MODE CMDs ]]

print(string.format(cmd_msg, "c_creativeon, c_creativeoff and c_creativeall"))
function c_creativeon() 
    SetCreative(true) 
end

function c_creativeoff() 
    SetCreative(false)
end

local invalid_bool = prettyname.." Command input must be the values true or false!"
local switcharoo1 = false -- so we can easily toggle! 
-- also so that the boolean for freebuildmode/SetInvincible is not dependent per player, esp. upon shard migration.
function c_creativeall(bool)
	if bool == nil then -- let user quickly toggle if no input
		switcharoo1 = not switcharoo1
		bool = switcharoo1
	elseif not (bool == true or bool == false) then
		print(invalid_bool)
		return
	end
    SetCreative(bool) 
end

-- [[ GODMODE FNs ]]

local function SetAllStats(bool)
    if bool == true then
        c_sethealth(1)
        c_setsanity(1)
        c_sethunger(1)
        c_settemperature(25)
        c_setmoisture(0)
    end
end

local function SetGodmode(bool)
    for i,v in pairs(AllPlayers) do
        local player = AllPlayers[i]
		player.components.health:SetInvincible(bool)
		SetAllStats(bool)
    end
	
	local world = GetShard()
	local _bool = tostring(bool)
    local msg = string.format(mode_msg, world, "God Mode", _bool)
    print(msg)
end

-- [[ GODMODE CMDs ]]

print(string.format(cmd_msg, "c_godmode, c_godmodeoff and c_godmodeall"))
function c_godmodeon() 
    SetGodmode(true) 
end

function c_godmodeoff() 
    SetGodmode(false)
end

local switcharoo2 = false
function c_godmodeall(bool)
	if bool == nil then -- let user quickly toggle if no input
		switcharoo2 = not switcharoo2
		bool = switcharoo2
	elseif not (bool == true or bool == false) then
		print(invalid_bool)
		return
	end
    SetGodmode(bool)
end 

-- [[ SPAWN TAMED BEEFALO FNs ]]

local function TendencyCheck(tendency)
	local invalid = prettyname.." Tendency input '%s'"
    if not (type(tendency) == "string") then
        print(string.format(invalid.." is not a string!", tostring(tendency)))
        return nil
    end

    local upper = string.upper(tendency)
    if TENDENCY[upper] == nil then 
        print(string.format(invalid.." is not an existing tendency!", tendency)) 
        return nil
    end
	
    return upper
end

local function ValidSaddle(saddle)
	local invalid = prettyname.." Saddle input '%s'"
	if saddle == nil then -- if no input for saddle, set to glossamer.
		return "saddle_race"
	elseif not (type(saddle) == "string") then
		print(string.format(invalid.." is not a string!", tostring(saddle)))
		-- what the hell are you inputting to get to this condition?
		return nil
	elseif string.find(saddle, "saddle") == nil then
		saddle = "saddle_"..saddle 
		-- auto prefix "saddle_" so you can just type "basic", "race" and "war" :D
	end
	
	saddle = string.lower(saddle)
	if not (saddle == "saddle_basic" or saddle == "saddle_race" or saddle == "saddle_war") then
		print(string.format(invalid.." is not an existing saddle!", saddle))
		-- look mate i dunno what you input but you should feel bad smh
		return nil
	end
	
	return saddle
end


local function Domesticate(beef, tendency, saddle) 
    beef.components.domesticatable:DeltaDomestication(1) 
	beef.components.domesticatable:DeltaObedience(1) 
	beef.components.domesticatable:DeltaTendency(tendency, 1)
    beef:SetTendency() 
	beef.components.domesticatable:BecomeDomesticated() 
	beef.components.hunger:SetPercent(0.5) 
    beef.components.rideable:SetSaddle(nil, SpawnPrefab(saddle))   
end

-- [[ SPAWN TAMED BEEFALO CMD ]]

print(string.format(cmd_msg, "c_spawnbeef"))
function c_spawnbeef(tendency, num, saddle)
	if tendency == nil then
		NoInput("tendency")
		return
    elseif TendencyCheck(tendency) == nil then
		return
	elseif num == nil then
		NoInput("player")
		return
	elseif ValidPlayerNum(num) == nil then
        return
	elseif ValidSaddle(saddle) == nil then
		return
    end

	local world = GetShard()
    local tendency = TendencyCheck(tendency)
	local saddle = ValidSaddle(saddle) -- nil input will result in glossamer as default.
    
    local player = AllPlayers[num] 
    local x,y,z = player.Transform:GetWorldPosition()
    local beef = c_spawn("beefalo") 
	          
    Domesticate(beef, tendency, saddle)
	beef.Transform:SetPosition(x,y,z)

    GiveInInventory(player, "beef_bell", 1) --this is so you can bond your new buddy already :)

    local success = prettyname.." %s - Spawned '%s' Beefalo for Player '%d' ('%s') and gave them a Beefalo Bell."
    print(string.format(success, world, tendency, num, player.name))
end 

-- [[ ADMIN COUNT ALL OF A PREFAB FNs ]]

local invalid_mode = prettyname.." Invalid announce mode '%s'; please use numbers '0' to '3' or boolean 'true', or omit it entirely."
local function AnnounceMode(mode, msg)
    local msg = string.format("%s %s", STRINGS.LMB, msg)
    if mode == 0 then
		print(msg)
        TheNet:Say(msg) --global chat.
    elseif mode == 1 then
		print(msg)
        TheNet:Say(msg, true) --whisper chat.
    elseif mode == 2 then
		print(msg)
        ChatHistory:SendCommandResponse(msg) --local chat.
    elseif mode == 3 then
		msg = string.gsub(msg, STRINGS.LMB, "")
        TheNet:Announce(msg) -- from server, announce in the chat. mainly for hosters.
    else
        ChatHistory:SendCommandResponse(string.format(invalid_mode, mode)) 
    end
end

local function EntsCount(prefab) 
    local name = DisplayName(prefab)
    local prefab = string.lower(prefab)
    local world = GetShard()
    local total = 0
    local stacks = 0
    for k,v in pairs(Ents) do 
        if (v.prefab == prefab) and not (v.components.inventoryitem and v.components.inventoryitem:IsHeld()) then 
            local stacksize = v.components.stackable and v.components.stackable:StackSize() or 1    
            total = total + stacksize
            stacks = stacks + 1 
        end
    end


    local prefabstr = string.format("%s ('%s')", name, prefab)
    local found = world.." - Found %d "..prefabstr
    local notfound = world.." - No "..prefabstr.." currently found."
    local final = ""

    if total == 0 then
        final = notfound
    elseif total == stacks then 
        final = string.format(found..".", total)
    elseif not total == stacks then
        final = string.format(found..", in %d stacks.", total, stacks)
    end
    return final
end

-- [[ COUNT CMD ]]

print(string.format(cmd_msg, "c_countall"))
function c_countall(...) -- should be variable number of prefabs, optional mode argument as the last
	local prefabs = { ... }
	if #prefabs == 0 then
		NoInput("prefab")
		return
	end
	
	local mode = nil 
	local last_arg = prefabs[#prefabs]
	if type(last_arg) == "string" then -- assume it's a prefab string, therefore no mode input
		mode = nil -- set mode to nil as default in that case
	elseif type(last_arg) == "nil" or type(last_arg) == "boolean" or type(last_arg) == "number" then
		mode = last_arg
		prefabs[#prefabs] = nil -- erase that non-string index cause it's not needed anymore
	else 
		mode = tostring(last_arg)
		print(string.format(invalid_mode, mode))
		return
	end
	
	local _AnnounceMode = AnnounceMode -- hookin
	local function AnnounceMode(mode, msg)
	end
	
	if mode == nil or mode == true then
		AnnounceMode = function(mode, msg) 
			_AnnounceMode(3, msg) 
		end
	elseif not (mode == false) then
		if type(mode) == "number" and not (mode > 3) and not (mode < 0) then
			AnnounceMode = function(mode, msg) 
				_AnnounceMode(mode, msg) 
			end
		else -- everything from this point except mode == false, mode == # will fail
			mode = tostring(mode)
			print(string.format(invalid_mode, mode))
			return
		end
	end
	
	for k,v in pairs(prefabs) do
		if ValidPrefab(v) == nil then
			--do nothing, keep going
			-- function ValidPrefab will print the invalid prefab warning already anyway
		else
			local final_count = EntsCount(v)
			if mode == false then
				print(final_count)
			else
				AnnounceMode(mode, final_count)
			end
		end
	end
end

print(prettyname.." Done declaring all commands!")