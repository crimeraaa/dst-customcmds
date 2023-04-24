-- ===================
-- [[ HELP MESSAGES ]]
-- ===================
local cmdlist = {}
cmdlist[1] = {
	name = "count",
	aliases = { "countall", "countprefabs" },
	desc = [[

The 'count' command:
'c_countall(prefab, ..., mode)'

'prefab' is a string of your desired inventory item's code.
	* It will count all instances in the shard it was run.
	* Stack sizes are taken into consideration.
	* '...' is a variable argument. You can input any number of prefabs.
	
'mode' is an optional parameter for how you would like to announce it.
	* If not specified it will default to Server Announcment.
	* Must always be the last argument in the command.
    	* 'true' will do a Server Announcement.
    	* 'false' will not do any kind of announcement or message.
		- It will print the result in console only.]]
}

cmdlist[2] = {
	name = "remove",
	aliases = { "removeall", "removeprefabs" }, 
	desc = gsub(cmdlist[1].desc, "count", "remove"), -- :)
}

cmdlist[3] = {
	name = "give",
	aliases = { "giveall", "giveto", "giveitem" },
	desc = [[
The 'give' commands:
c_giveall(prefab, count)
c_giveto(num, prefab, count)

'num' is the player number of the person you'd like to give the item/s to. 

'prefab' is a string of your desired inventory item's code.

'count' is an optional parameter. It should be a number value.
	- If not specified, it will default to 1.]],
}
cmdlist[4] = {
	name = "creative",
	aliases = { "freecrafting", "creativemode", "creativeon", "creativeoff", "creativeall" },
	desc = [[

The 'creative' commands:
c_creativeon()
c_creativeoff()
c_creativeall()

Sets all players' Creative Mode in the shard it was run.

'c_creativeon()' and 'c_creativeoff()' turn Creative Mode on and off respectively.
'c_creativeall()' will alternate between on and off. You can also input 'true' and 'false'.]],
}

local godmode_desc = gsub(cmdlist[4].desc, "creative", "godmode")
godmode_desc = gsub(godmode_desc, "Creative Mode", "Godmode")

cmdlist[5] = {
	name = "godmode",
	aliases = { "god", "invincible", "supergodmode", "godmodeon", "godmodeoff", "godmodeall" },
	desc = godmode_desc,
}

cmdlist[6] = {
	name = "spawnbeef",
	aliases = { "beef", "beefalo", "tamedbeef" },
	desc = [[

The 'spawnbeef' command:
c_spawnbeef(num, tendency, saddle)

'num' is the number of the player you'd like to spawn the beefalo for.
	- They will also receive 1 Beefalo Bell.

'tendency' is a string of the type of beefalo. 
	- "DEFAULT"
	- "RIDER"
	- "ORNERY"
	- "PUDGY"

'saddle' is an optional string of the prefab code for the saddle you'd like.
You may use the full prefab code or simply use the second word.
	- "saddle_basic" or "basic"
	- "saddle_race"  or "race"
	- "saddle_war"   or "war"]],
}

cmdlist[7] = {
	name = "tags",
	aliases = { "checktags", "addtags", "removetags" },
	desc = [[

The 'tags' commands:
c_checktags(num, ...)
c_addtags(num, ...)
c_removetags(num, ...)	

'num' is the number of the player you'd like to check/remove the tags for.

'...' is a variable number of inputs. You can check as many tags as you like.
	- tags must always be strings.

'c_checktags' will simply print out if the input tags are present.
'c_addtags' will add tags not yet present on the player.
'c_removetags' remove a player's tags, provided they exist.]],
}
-- ===================
-- [[ HELPER PRINTS ]]
-- ===================
local help = [[

To get help of only one command, run 'c_helpcmd()' with a 'Help Key'.
To see the list of 'Help Keys', run 'c_helpcmd()' as is.
To see a quick list of the commands, run 'c_listcmd()' as is.]]
-- ================
-- [[ HELPER FNS ]]
-- ================
local function PrintHelpKeys(name, aliases_tbl, index)
	local helpkeys = stringf("[%d] Help Keys: '%s', ", index, name)
	for i=1, #aliases_tbl-1 do
		helpkeys = helpkeys.."'%s', "
	end
	helpkeys = helpkeys.."or '%s'"
	printf(helpkeys, unpack(aliases_tbl))
end

local function PrintAllHelpKeys()
	for i, cmd in pairs(cmdlist) do
		PrintHelpKeys(cmd.name, cmd.aliases, i)
	end 
end

local function DoPrintCmd(cmd, i)
	PrintHelpKeys(cmd.name, cmd.aliases, i)
	print(cmd.desc)
end

local function NamesLoop(input)
	for i, cmd in pairs(cmdlist) do
		if input == cmd.name then
			DoPrintCmd(cmd, i)
			return true
		end

		local alias = cmd.aliases
		local j = 1
		while alias[j] ~= input and not (j > #alias) do
			j = j + 1
		end

		if alias[j] == input then
			DoPrintCmd(cmd, i)
			return true
		end
	end
	return false
end

-- ===============
-- [[ HELP CMDs ]]
-- ===============
local running = 	"=============== [[ RUNNING: %s COMMANDS ]] ==============="
local dummyline = 	"----------------------------------------------------------"
local function c_listcmd()
	printf(running, "LIST")
	PrintAllHelpKeys()
	print(help)
	print(dummyline)
end

local function c_helpcmd(input)
	printf(running, "HELP")
	if input == nil then
		PrintAllHelpKeys()
		print(dummyline)
		return
	end

	if CheckInputType(input, "string") == false then
		print(dummyline)
		return
	end

	if NamesLoop(input) == false then
		cmdprintf("Input '%s' did not match any existing Help Keys!", input)
		print(dummyline)
		return
	end
	print(dummyline)
end
-- ================
-- [[ TO GLOBALS ]]
-- ================
debugprint(cmd_msg, "c_listcmd and c_helpcmd")
_G.c_listcmd = c_listcmd
_G.c_helpcmd = c_helpcmd