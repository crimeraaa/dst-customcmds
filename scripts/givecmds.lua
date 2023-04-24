-- ====================================
-- [[ GIVE INV ITEM TO EVERYBODY CMD ]]
-- ====================================
local gave_msg = "%s - Gave %s %d %s ('%s')."
local function c_giveall(prefab, count)
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
	local gaveto = "everybody"
    local count = count or 1
	for i,v in pairs(AllPlayers) do 
        local player = AllPlayers[i]
		GiveInInventory(player, prefab, count) 
    end

    cmdprintf(gave_msg, world, gaveto, count, name, prefab)
end

-- ==========================================
-- [[ GIVE INV ITEM TO SPECIFIC PERSON CMD ]]
-- ==========================================
local function c_giveto(num, prefab, count) 
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
	local gaveto = stringf("Player %s (%d - %s)", player.name, player.GUID, player.prefab)
    local count = count or 1    
	GiveInInventory(player, prefab, count)

    cmdprintf(gave_msg, world, gaveto, count, name, prefab)
end

-- ===============
-- [[ TO GLOBAL ]]
-- ===============
debugprint(cmd_msg, "c_giveall")
debugprint(cmd_msg, "c_giveto")
_G.c_giveall = c_giveall
_G.c_giveto = c_giveto