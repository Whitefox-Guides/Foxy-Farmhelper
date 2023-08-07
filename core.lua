--[[
    Check http://wow.gamepedia.com/Localizing_an_addon for how this works.
]]

FoxyFarmhelper = LibStub("AceAddon-3.0"):NewAddon("FoxyFarmhelper", "AceConsole-3.0", "AceEvent-3.0")

FoxyFarmhelper.L = FoxyFarmhelper.L or setmetatable({}, {
    __index = function(t, k)
        rawset(t, k, k)
        return k
    end,
    __newindex = function(t, k, v)
        if v == true then
            rawset(t, k, k)
        else
            rawset(t, k, v)
        end
    end,
})


function FoxyFarmhelper:RegisterLocale(locale, tbl)
    if not tbl then return end
    if locale == "enUS" or locale == GetLocale() then
        for k,v in pairs(tbl) do
            if v == true then
                self.L[k] = k
            elseif type(v) == "string" then
                self.L[k] = v
            else
                self.L[k] = k
            end
        end
    end
end


-- Overwrite Ace3's messaging system, since it doesn't work
-- (or at least I can't figure out how it works).
FoxyFarmhelper.messageFunctions = {}

function FoxyFarmhelper:RegisterMessage(message, func)
    -- Adds the func to the list of functions that are called for the custom message.
    if not FoxyFarmhelper.messageFunctions[message] then
        FoxyFarmhelper.messageFunctions[message] = {}
    end
    table.insert(FoxyFarmhelper.messageFunctions[message], func)
end

function FoxyFarmhelper:SendMessage(message)
    -- Call functions attached to the message
    if FoxyFarmhelper.messageFunctions[message] == nil then return end
    for i, func in ipairs(FoxyFarmhelper.messageFunctions[message]) do
        func(message)
    end
end
