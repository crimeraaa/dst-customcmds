modimport("main/util") -- this is where all my var = _G.var declarations are, this includ _G = GLOBAL

if TheNet and not TheNet:GetIsServerAdmin() then
	return
end

local cmdnames = { "help", "give", "mode", "count", "beef", "tags" }
for i, v in pairs(cmdnames) do
	modimport("scripts/"..v.."cmds")
end

debugprint("Done declaring all commands!")

-- debugprint = nil -- don't set nil here, set it to nil at the end of the AddSimPostInit in countcmds.lua.