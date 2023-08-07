--[[
    Contains logic for building the requirements for this player,
    such as class, professions, faction, etc.
]]

FoxyFarmhelper.Requirements = {}


local function GetPlayerClass()
    return select(1, UnitClass("player"))
end


local requirements


function FoxyFarmhelper.Requirements:GetRequirements()
    if not requirements then
        requirements = {
            classRestrictions = GetPlayerClass()
        }
    end
    return requirements
end
