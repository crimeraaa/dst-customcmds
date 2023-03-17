local _G = GLOBAL
_G.setfenv(1, _G) --thanks to Atoba Azul for this! It's ridiculously useful. 

--[[ GENERIC FNs ]]

local function GetShard()
    local shard = "this shard" -- default if somehow none of the below match
    if TheWorld:HasTag("forest") then
        shard = "Surface"
    elseif TheWorld:HasTag("caves") then
        shard = "Caves"
    elseif TheWorld:HasTag("island") then -- IA support :D
        shard = "Shipwrecked"
    elseif TheWorld:HasTag("volcano") then
        shard = "Volcano"
    end
    return shard
end

local function NoInput(check)
    local generic = "Please input a prefab for the command to work with!"
    if check == "prefab" then
        generic = generic
    elseif check == "tendency" then
        generic = string.gsub(generic, "prefab", "Beefalo tendency")
    elseif check == "player" then
        generic = string.gsub(generic, "prefab", "Player Number")
    end
    return generic
end

local function ValidPlayerNum(num)
    assert(type(num) == "number", "Player Number input must be a number value!")
    if num == 0 or (num > #AllPlayers) or (num < 0) then 
        local invalid = "Player Number #%d is outside the current playerlist."
        print(string.format(invalid, num))
        return nil
    end
    return true
end

--[[ GIVING INV ITEMS LOCALFNs ]]

local function DisplayName(prefab)
    local upper = string.upper(prefab) 
    local name = ""
    for k,v in pairs(STRINGS.NAMES) do
        if k == upper then 
            name = v
            return name
        end
    end
    local errormsg = "Prefab \""..prefab.."\" has no Display Name!"
    print(errormsg)
    name =  "MISSING NAME" 
    return name
end

local function IsInvItem(prefab)
    local prefab = string.lower(prefab)
    local item = SpawnPrefab(prefab) --thanks to Anagram and HarryPPPotter for helping here!
    if item.components.inventoryitem == nil then 
        local errormsg = "Prefab \""..prefab.."\" is not an inventory item."
        print(errormsg)
        item:Remove() -- this is so stupid but whatever
        return nil
    end 
    item:Remove()
    return true
end

local function ValidPrefab(prefab)
    assert(type(prefab) == "string", "Prefab input must be a string!")
    local lower = string.lower(prefab)
    if Prefabs[lower] == nil then 
        local errormsg = "Prefab \""..prefab.."\" does not exist!"
        print(errormsg)
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

-- [[ GIVE INV ITEM TO EVERYBODY FN ]]

function c_giveall(prefab, count)
    if prefab == nil then
        return NoInput("prefab")
    elseif ValidPrefab(prefab) == nil or IsInvItem(prefab) == nil then
        return
    end

    local name = DisplayName(prefab)
    local world = GetShard()
    local count = count or 1
	for i,v in pairs(AllPlayers) do 
        local player = AllPlayers[i]
		GiveInInventory(player, prefab, count) 
    end

    local gave_all = "In %s, gave everybody #%d: %s (\"%s\")."
    print(string.format(gave_all, world, count, name, prefab))
end

-- [[ GIVE INV ITEM TO SPECIFIC PERSON FN ]]

function c_giveto(num, prefab, count) 
    if num == nil then
        return NoInput("player")
    elseif ValidPlayerNum(num) == nil then
        return
    elseif prefab == nil then
        return NoInput("prefab")
    elseif ValidPrefab(prefab) == nil or IsInvItem(prefab) == nil then
        return
    end
    
    local name = DisplayName(prefab)
    local world = GetShard()
    local player = AllPlayers[num]
    local count = count or 1    
	GiveInInventory(player, prefab, count)

    local gaveto = "In %s, gave Player #%d (%s): %d %s (\"%s\")."
    print(string.format(gaveto, world, num, player.name, count, name, prefab))
end


-- [[ CREATIVE MODE FNs ]]

local function Creative(bool)
    local world = GetShard()
    for i,v in ipairs(AllPlayers) do
        local player = AllPlayers[i]
        if bool == nil then
            local toggle = not player.components.builder.freebuildmode
            player.components.builder.freebuildmode = toggle
        else
            player.components.builder.freebuildmode = bool
            player:PushEvent("techlevelchange")
        end 
    end
end

function c_creativeon() 
    Creative(true) 
end

function c_creativeoff() 
    Creative(false)
end

function c_creativeall() 
    Creative() 
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

local function Godmode(bool)
    local world = GetShard()
    for i,v in ipairs(AllPlayers) do
        local player = AllPlayers[i]
        if bool == nil then
            local current_state = not player.components.health.invincible
            player.components.health:SetInvincible(current_state)
            SetAllStats(current_state)
        else
            player.components.health:SetInvincible(bool)
            SetAllStats(bool)
        end
    end
end

function c_godmodeon() 
    Godmode(true) 
end

function c_godmodeoff() 
    Godmode(false)
end

function c_godmodeall() 
    Godmode()
end 

-- [[ SPAWN TAMED BEEFALO FNs ]]

local function TendencyCheck(tendency)
    local upper = string.upper(tendency)
    if TENDENCY[upper] == nil then 
        local invalid = "Tendency \"%s\" is invalid!"
        print(string.format(invalid, tendency)) 
        return nil
    end
    return upper
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

function c_spawnbeef(tendency, number, saddle)
    if tendency == nil then
        return NoInput("tendency")
    elseif number == nil then
        return NoInput("player")
    elseif TendencyCheck(tendency) == nil then
        return
    end

    local tendency = TendencyCheck(tendency)
    local world = GetShard()


    local player = AllPlayers[number] --if all checks pass, let's finally start!
    local x,y,z = player.Transform:GetWorldPosition()
    local beef = c_spawn("beefalo") 
    local saddle = saddle or "saddle_race"
            
    Domesticate(beef, tendency, saddle)
	beef.Transform:SetPosition(x,y,z)

    GiveInInventory(player, "beef_bell", 1) --this is so you can bond your new buddy already :)

    local success = "In %s, spawned \"%s\" Beefalo for Player #%d (%s) and gave them a Beefalo Bell."
    print(string.format(success, world, tendency, number, player.name))        
end 

-- [[ ADMIN COUNT ALL OF A PREFAB FN ]]

local function AnnounceMode(mode, msg)
    local msg = string.format("%s %s", STRINGS.LMB, msg)
    if mode == 0 then
        TheNet:Say(msg) --global chat.
    elseif mode == 1 then
        TheNet:Say(msg, true) --whisper chat.
    elseif mode == 2 then
        ChatHistory:SendCommandResponse(msg) --local chat.
    elseif mode == 3 then
        TheNet:Announce(msg) -- from server, announce in the chat. mainly for hosters.
    else
        msg = "Invalid mode '%s'; please use numbers 0 to 3."
        ChatHistory:SendCommandResponse(string.format(msg, mode)) 
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

    local _world = "["..world.."]"
    local prefabstr = name.." (\""..prefab.."\")"
    local found = string.format("We found %d ", total)
    local final = ""

    if total == 0 then
        final = _world.." We could not find any "..prefabstr.."."
    elseif total == stacks then 
        final = found..prefabstr.."."
    elseif total ~= stacks then
        local in_stacks = string.format("in %d stacks.", stacks)
        final = found..prefabstr..", "..in_stacks
    end
    return final
end

-- [[ CONSOLE CMD ]]

function c_countall(prefab, mode)
    if prefab == nil then
        return NoInput("prefab")
    elseif ValidPrefab(prefab) == nil then
        return
    end

    local final_count = EntsCount(prefab) 
    print(final_count)
    -- input false for mode will result in not announcing it.
    if mode == nil or mode == true then
        AnnounceMode(3, final_count)
    elseif mode ~= nil and not (mode == false) then
        if type(mode) ~= "number" then
            local invalid = "The announce mode parameter must be a number from 0 to 3!"
            return invalid
        end
        AnnounceMode(mode, final_count)
    end
end