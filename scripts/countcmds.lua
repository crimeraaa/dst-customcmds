-- ===============
-- [[ COUNT FNs ]]
-- ===============
local invalid_mode = "Invalid announce mode '%s'; true, false, or omit it entirely."
local function EntsCount(prefab, remove)
    local name = DisplayName(prefab)
    local prefab = string.lower(prefab)
    local world = GetShard()
    local total = 0
    local stacks = 0
    for k,v in pairs(Ents) do 
        -- if (v.prefab == prefab) and not (v.components.inventoryitem and v.components.inventoryitem:IsHeld()) then 
		if v.prefab == prefab then 
            local stacksize = v.components.stackable and v.components.stackable:StackSize() or 1    
            total = total + stacksize
            stacks = stacks + 1 
			if remove then
				v:Remove()
			end
        end
    end

    local prefabstr = stringf("%s ('%s')", name, prefab)
    local found = world.." - Found %d "..prefabstr
    local notfound = world.." - No "..prefabstr.." currently found."
    local final = nil

    if total == 0 then
        final = notfound
    elseif total == stacks then
		final = stringf(found..".", total)
    else -- if total ~= stacks then
		final = stringf(found..", in %d stacks.", total, stacks)
    end

	if remove and (total > 0) then
		final = gsub(final, "Found", "Removed")
	end

    return final
end

local function EntEvaluate(prefab, Announce, mode)
	if ValidPrefab(prefab) == nil then
		-- do nothing, keep going
		-- function ValidPrefab will print the invalid prefab warning already anyway
	else
		local final_count = EntsCount(prefab, remove)
		Announce(final_count)
	end
end

local function EntsLooper(Announce, prefabs, mode, remove)
	for i,v in pairs(prefabs) do
		EntEvaluate(v, Announce, mode)
	end
end

local function ModeCheck(prefabs)
	local mode
	local last = prefabs[#prefabs]
	if type(last) == "string" or type(last) == "nil" then 
		-- assume it's a prefab string or flat out nil, therefore no mode input
		mode = nil -- set mode to nil as default in that case
	elseif type(last) == "boolean" then
		mode = last
		prefabs[#prefabs] = nil -- erase that non-string index cause it's not needed anymore
	else
		mode = tostring(last)
		local invalid = stringf(invalid_mode, mode)
		cmdprintf(invalid)
	end
	return mode
end

local function AnnounceCheck(mode)
	local Announce
	if mode == nil or mode == true then
		Announce = function(msg) 
			TheNet:Announce(msg)
		end
	elseif mode == false then
		Announce = function(msg) 
			cmdprintf(msg) 
		end
	end 
	return Announce
end

local function CountAndRemove(remove, ...)
	local prefabs = { ... }
	if #prefabs == 0 then
		NoInput("prefab")
		return
	end

	local mode = ModeCheck(prefabs)
	if type(mode) == "string" then
		return
	end
	
	local Announce = AnnounceCheck(mode)
	if Announce == nil then
		return
	end
	
	return EntsLooper(Announce, prefabs, mode, remove)
end
-- ===============
-- [[ COUNT CMD ]]
-- ===============
local function c_countall(...) -- should be variable number of prefabs, optional mode argument as the last
	CountAndRemove(false, ...) -- false means don't remove the prefabs, just count them.
end
-- ================
-- [[ TO GLOBALS ]]
-- ================
debugprint(cmd_msg, "c_countall")
_G.c_countall = c_countall

-- don't declare _G.c_removeall = c_removeall as c_removeall is an existing basegame console cmd, ours will get overwritten

AddSimPostInit(function() -- all PostInits within mod env, so gotta use _G
	debugprint(cmd_msg, "c_removeall")
	_G.c_removeall = function(...) -- overwrite it basegame c_removeall
		CountAndRemove(true, ...)
	end
	debugprint = nil
end)