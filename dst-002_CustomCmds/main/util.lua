-- call modimport("path_from_modroot/util") and all the non-locals here will be ready to use.

_G = GLOBAL -- :hmmmm_pray:

-- ======================
-- [[ C++ ENGINE STUFF ]]
-- ======================
TheNet = _G.TheNet 
TheShard = _G.TheShard
-- ===============
-- [[ CONSTANTS ]]
-- ===============
TENDENCY = _G.TENDENCY
-- ===================
-- [[ GLOBAL TABLES ]]
-- ===================
STRINGS = _G.STRINGS
-- =========================================
-- [[ EMPTY BUT INITIALIZED GLOBAL TABLES ]]
-- =========================================
-- see main.lua
AllPlayers = _G.AllPlayers
Ents = _G.Ents
--[[
other tables like Prefabs can't be declared here, for some reason.
some tables aren't initialized at the time the mod is being compiled, such as ThePlayer, TheWorld, etc.
^ for those cases you'll have to declare them as global within functions you intend to call them in.
]]
-- ======================
-- [[ GLOBAL FUNCTIONS ]]
-- ======================
SpawnPrefab = _G.SpawnPrefab
FirstToUpper = _G.FirstToUpper
-- ===========================
-- [[ MISC FUNCTIONS/TABLES ]]
-- ===========================
debug = _G.debug 
unpack = _G.unpack 
dumptable = _G.dumptable 
--[[
debug is a Lua library, but Klei did not set it to be included within the mod env. So we initialize debug = _G.debug
similar case with unpack.
dumptable is a function Klei made themselves, it prints out all contents of a table including subtables, sub-subtables, until the very last.
]]
-- =========================
-- [[ SHORTHAND FUNCTIONS ]]
-- =========================
gsub = string.gsub -- no other Lua fn uses the name "gsub" so i'll assume it's always related to strings.
tinsert = table.insert 
stringf = string.format 
function printf(format, ...) -- stands for "Print Format".
	print(stringf(format, ...)) 
end 
-- =====================
-- [[ DEBUG PRINTOUTS ]] 
-- =====================
prettyname = "CustomCmd: "
function debugprint(msg, ...)
end

local should_debug = GetModConfigData("should_debug")
if should_debug then
    local debugname = "[DEBUG] "..string.upper(prettyname)
    debugprint = function(msg, ...) -- msg can be a stringf or a simple string
        printf(debugname..msg, ... ) 
    end
end

local cmd_msg_name = prettyname.."%s"
function cmdprintf(msg, ...) -- msg can be a stringf or a simple string
    -- cmdprintf is just printf with the modname prefixed to it
    printf(cmd_msg_name, stringf(msg, ...)) 
end
-- ===========================
-- [[ CUSTOM CMD HELPER FNs ]]
-- ===========================
function GetShard()
    local TheWorld = _G.TheWorld -- doesn't exist at compile time, so declare it within the fn
    local shard = "This Shard" -- default if somehow none of the below match
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

function NoInput(check)
    local msg = "Please input a '%s' for the command to work with!"
    if check == "prefab" then
        check = FirstToUpper(check)
    elseif check == "tendency" then
        check = "Beefalo tendency"
    elseif check == "player" then
        check = "Player number"
	else
		msg = "'%s' is an invalid parameter? Somehow???"
    end
    cmdprintf(msg, check)
end

function CheckInputType(input, what_type, prefix)
    prefix = prefix or "Input"
	local msg = prefix.." '%s' %s!"
	if not (type(input) == what_type) then
		local not_type = stringf("is not a %s", what_type)
		cmdprintf(msg, tostring(input), not_type)
		return false
	end
    return true
end

function ValidPlayerNum(num)
    if CheckInputType(num, "number", "Player Number") == false then
        return nil
    elseif num == 0 or (num > #AllPlayers) or (num < 0) then 
        local invalid = "Player number '%d' is outside the current playerlist."
        cmdprintf(invalid, num)
        return nil
    end
    return true
end

-- ==========================
-- [[ GIVING INV ITEMS FNs ]]
-- ==========================
function DisplayName(prefab)
    local upper = string.upper(prefab) 
	local invalid = "Prefab '%s' has no Display Name!"
    local name = ""
    for k,v in pairs(STRINGS.NAMES) do
        if k == upper then 
            name = v
            return name
        end
    end
    cmdprintf(invalid, prefab)
    name =  "MISSING NAME" 
    return name
end

function IsInvItem(prefab)
    local prefab = string.lower(prefab)
	local invalid = "Prefab '%s' is not an inventory item!"
    local item = SpawnPrefab(prefab) --thanks to Anagram and HarryPPPotter for helping here!
    if item.components.inventoryitem == nil then
        cmdprintf(invalid, prefab)
        item:Remove() -- this is so stupid but whatever
        return nil
    end 
    item:Remove()
    return true
end

function ValidPrefab(prefab)
	local invalid = "Prefab input '%s'"
    if CheckInputType(prefab, "string", "Prefab") == false then
        return nil
    end
    -- simply using Prefabs = _G.Prefabs at the top returns nil for some reason, 
    -- i thought it gets populated tho? strange
    local lower = string.lower(prefab)
    if _G.Prefabs[lower] == nil then 
        cmdprintf(invalid.." is not an existing prefab!", prefab)
        return nil 
    end --thanks to Atoba Azul and thegreatmanagement for the Prefabs[prefab] check line!
    return true
end

function GiveInInventory(player, prefab, count)
    local prefab = string.lower(prefab)
    for i=1, count do
        player.components.inventory:GiveItem(SpawnPrefab(prefab))
    end
end
-- ==================
-- [[ DEBUG PRINTS ]]
-- ==================
debugprint("Begin declaring all commands...")
cmd_msg = " Declaring command %s..."
debugprint(cmd_msg, "c_listcmd and c_helpcmd")