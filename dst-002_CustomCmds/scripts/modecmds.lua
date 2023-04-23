-- modimport("main/util")
-- =======================
-- [[ CREATIVE MODE FNs ]]
-- =======================
local mode_msg = "%s - Set '%s' to '%s' for all players." -- generic print msg!
local function SetCreative(bool)
    for i,v in pairs(AllPlayers) do
        local player = AllPlayers[i]
		player.components.builder.freebuildmode = bool
        player:PushEvent("techlevelchange")
    end
	
	local world = GetShard()
	bool = tostring(bool)
	cmdprintf(mode_msg, world, "Creative Mode", bool)
end
-- ========================
-- [[ CREATIVE MODE CMDs ]]
-- ========================
local function c_creativeon() 
    SetCreative(true) 
end

local function c_creativeoff() 
    SetCreative(false)
end

local invalid_bool = "Command input must be the values true or false!"
local switcharoo1 = false -- so we can easily toggle! 
-- also so that the boolean for freebuildmode/SetInvincible is not dependent per player, esp. upon shard migration.
function c_creativeall(bool)
	if bool == nil then -- let user quickly toggle if no input
		switcharoo1 = not switcharoo1
		bool = switcharoo1
	elseif not (bool == true or bool == false) then
		cmdprintf(invalid_bool)
		return
	end
    SetCreative(bool) 
end
-- =================
-- [[ GODMODE FNs ]]
-- =================
local function SetAllStats(bool)
    if bool == true then
        _G.c_sethealth(1)
        _G.c_setsanity(1)
        _G.c_sethunger(1)
        _G.c_settemperature(25)
        _G.c_setmoisture(0)
    end
end

local function SetGodmode(bool)
    for i,v in pairs(AllPlayers) do
        local player = AllPlayers[i]
		player.components.health:SetInvincible(bool)
		SetAllStats(bool)
    end
	
	local world = GetShard()
	bool = tostring(bool)
    cmdprintf(mode_msg, world, "God Mode", bool)
end
-- ==================
-- [[ GODMODE CMDs ]]
-- ==================
local function c_godmodeon() 
    SetGodmode(true) 
end

local function c_godmodeoff() 
    SetGodmode(false)
end

local switcharoo2 = false
local function c_godmodeall(bool)
	if bool == nil then -- let user quickly toggle if no input
		switcharoo2 = not switcharoo2
		bool = switcharoo2
	elseif not (type(bool) == "boolean") then
		cmdprintf(invalid_bool)
		return
	end
    SetGodmode(bool)
end 
-- ================
-- [[ TO GLOBALS ]]
-- ================
debugprint(cmd_msg, "c_creativeon, c_creativeoff and c_creativeall")
debugprint(cmd_msg, "c_godmode, c_godmodeoff and c_godmodeall")

_G.c_creativeon = c_creativeon
_G.c_creativeoff = c_creativeoff
_G.c_creativeall = c_creativeall

_G.c_godmodeon = c_godmodeon
_G.c_godmodeoff = c_godmodeoff
_G.c_godmodeall = c_godmodeall