-- =============================
-- [[ SPAWN TAMED BEEFALO FNs ]]
-- =============================
local function TendencyCheck(tendency)
	if CheckInputType(tendency, "string", "Tendency input") == false then
		return nil
	end

    local upper = string.upper(tendency)
    if TENDENCY[upper] == nil then 
        cmdprintf("Tendency input '%s' is not an existing tendency!", tendency)
        return nil
    end
	
    return upper
end

local function ValidSaddle(saddle)
	if saddle == nil then -- if no input for saddle, set to glossamer.
		return "saddle_race"
	elseif CheckInputType(saddle, "string", "Saddle input") == false then
		-- what the hell are you inputting to get to this condition?
		return nil
	elseif string.find(saddle, "saddle_") == nil then
		saddle = "saddle_"..saddle 
		-- auto prefix "saddle_" so you can just type "basic", "race" and "war" :D
	end
	
	saddle = string.lower(saddle)
    -- Prefabs.saddle_basic
	if not (_G.Prefabs[saddle]) then
		cmdprintf("Saddle input %s is not an existing saddle!", saddle)
		-- look mate i dunno what you input but you should feel bad smh
		return nil
	end
	
	return saddle
end


local function Domesticate(beef, tendency, saddle)
	local domes = beef.components.domesticatable
    domes:DeltaDomestication(1) 
	domes:DeltaObedience(1) 
	domes:DeltaTendency(tendency, 1)
    beef:SetTendency() 
	domes:BecomeDomesticated() 
	beef.components.hunger:SetPercent(0.5) 
    beef.components.rideable:SetSaddle(nil, SpawnPrefab(saddle))   
end

-- =============================
-- [[ SPAWN TAMED BEEFALO CMD ]]
-- =============================
local spawnbeef_msg = "%s - Spawned %s Beefalo for %s and gave them a Beefalo Bell."
local function c_spawnbeef(num, tendency, saddle)
    if num == nil then
        NoInput("player")
        return
    elseif ValidPlayerNum(num) == nil then
        return
    elseif tendency == nil then
		NoInput("tendency")
		return
    elseif TendencyCheck(tendency) == nil then
		return
	elseif ValidSaddle(saddle) == nil then
		return
    end

	local world = GetShard()
    local tendency = TendencyCheck(tendency)
	local saddle = ValidSaddle(saddle) -- nil input will result in glossamer as default.
    
    local player = AllPlayers[num] 
    local x,y,z = player.Transform:GetWorldPosition()
    local beef = _G.c_spawn("beefalo") 
	          
    Domesticate(beef, tendency, saddle)
	beef.Transform:SetPosition(x,y,z)

	local gaveto = stringf("%s (%d - %s)", player.name, player.GUID, player.prefab)
    GiveInInventory(player, "beef_bell", 1) --this is so you can bond your new buddy already :)
    cmdprintf(spawnbeef_msg, world, tendency, gaveto)
end 
-- ===============
-- [[ TO GLOBAL ]]
-- ===============
debugprint(cmd_msg, "c_spawnbeef")
_G.c_spawnbeef = c_spawnbeef