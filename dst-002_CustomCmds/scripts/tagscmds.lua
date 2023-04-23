-- =====================
-- [[ TAGS HELPER FNS ]]
-- =====================
local function TagMode(player, tag, mode)
	if CheckInputType(tag, "string", "Tag") == false then 
		return
	end

	local tag_result = player:HasTag(tag)
	if tag_result then
		if mode == "remove" then
			player:RemoveTag(tag)
			printf("Removed tag '%s'.", tag)
		elseif mode == "add" then
			printf("Tag '%s' already exists.", tag)
		else
			printf("Tag '%s' is present.", tag)
		end
	else
		if mode == "add" then
			player:AddTag(tag)
			printf("Added tag '%s'.", tag)
		else
			printf("'%s' could not be found.", tag)
		end
	end
end

local function TagsLooper(num, tags_tbl, mode)
	if num == nil then 
		NoInput("player")
		return
    elseif ValidPlayerNum(num) == nil then
		return
	end

	local player = AllPlayers[num]
    printf("Tags for %s ('%s' - %d)", player.name, player.prefab, player.GUID)
    for k, tag in pairs(tags_tbl) do
        -- printf("Checking tag '%s'...", tag)
		TagMode(player, tag, mode)
    end
	print("\n")
end

-- ==================
-- [[ TAGS CMD FNS ]]
-- ==================
local function c_checktags(num, ...)
    local tags = { ... }
    TagsLooper(num, tags)
end

local function c_removetags(num, ...)
    local tags = { ... }
    TagsLooper(num, tags, "remove")
end

local function c_addtags(num, ...)
	local tags = { ... }
	TagsLooper(num, tags, "add")
end

-- ==========================
-- [[ DECLARING GLOBAL FNS ]]
-- ==========================
debugprint(cmd_msg, "c_checktags and c_removetags")
_G.c_checktags = c_checktags
_G.c_removetags = c_removetags
_G.c_addtags = c_addtags