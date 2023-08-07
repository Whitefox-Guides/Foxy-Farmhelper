-- This file is loaded from "FoxyFarmhelper.toc"

local L = FoxyFarmhelper.L

FoxyFarmhelper.DressUpModel = CreateFrame('DressUpModel')
FoxyFarmhelper.DressUpModel:SetUnit('player')


-----------------------------
-- Maps                    --
-----------------------------

---- Transmog Categories
-- 1 Head
-- 2 Shoulder
-- 3 Back
-- 4 Chest
-- 5 Shirt
-- 6 Tabard
-- 7 Wrist
-- 8 Hands
-- 9 Waist
-- 10 Legs
-- 11 Feet
-- 12 Wand
-- 13 One-Handed Axes
-- 14 One-Handed Swords
-- 15 One-Handed Maces
-- 16 Daggers
-- 17 Fist Weapons
-- 18 Shields
-- 19 Held In Off-hand
-- 20 Two-Handed Axes
-- 21 Two-Handed Swords
-- 22 Two-Handed Maces
-- 23 Staves
-- 24 Polearms
-- 25 Bows
-- 26 Guns
-- 27 Crossbows
-- 28 Warglaives


local HEAD = "INVTYPE_HEAD"
local SHOULDER = "INVTYPE_SHOULDER"
local BODY = "INVTYPE_BODY"
local CHEST = "INVTYPE_CHEST"
local ROBE = "INVTYPE_ROBE"
local WAIST = "INVTYPE_WAIST"
local LEGS = "INVTYPE_LEGS"
local FEET = "INVTYPE_FEET"
local WRIST = "INVTYPE_WRIST"
local HAND = "INVTYPE_HAND"
local CLOAK = "INVTYPE_CLOAK"
local WEAPON = "INVTYPE_WEAPON"
local SHIELD = "INVTYPE_SHIELD"
local WEAPON_2HAND = "INVTYPE_2HWEAPON"
local WEAPON_MAIN_HAND = "INVTYPE_WEAPONMAINHAND"
local RANGED = "INVTYPE_RANGED"
local RANGED_RIGHT = "INVTYPE_RANGEDRIGHT"
local WEAPON_OFF_HAND = "INVTYPE_WEAPONOFFHAND"
local HOLDABLE = "INVTYPE_HOLDABLE"
local TABARD = "INVTYPE_TABARD"
local BAG = "INVTYPE_BAG"


local inventorySlotsMap = {
    [HEAD] = {1},
    [SHOULDER] = {3},
    [BODY] = {4},
    [CHEST] = {5},
    [ROBE] = {5},
    [WAIST] = {6},
    [LEGS] = {7},
    [FEET] = {8},
    [WRIST] = {9},
    [HAND] = {10},
    [CLOAK] = {15},
    [WEAPON] = {16, 17},
    [SHIELD] = {17},
    [WEAPON_2HAND] = {16, 17},
    [WEAPON_MAIN_HAND] = {16},
    [RANGED] = {16},
    [RANGED_RIGHT] = {16},
    [WEAPON_OFF_HAND] = {17},
    [HOLDABLE] = {17},
    [TABARD] = {19},
}


-- This is a one-time call to get a "transmogLocation" object, which we don't actually care about,
-- but some functions require it now.
local transmogLocation = TransmogUtil.GetTransmogLocation(inventorySlotsMap[HEAD][1], Enum.TransmogType.Appearance, Enum.TransmogModification.Main)


local MISC = 0
local CLOTH = 1
local LEATHER = 2
local MAIL = 3
local PLATE = 4
local COSMETIC = 5

local classArmorTypeMap = {
    ["DEATHKNIGHT"] = PLATE,
    ["DEMONHUNTER"] = LEATHER,
    ["DRUID"] = LEATHER,
    ["EVOKER"] = MAIL,
    ["HUNTER"] = MAIL,
    ["MAGE"] = CLOTH,
    ["MONK"] = LEATHER,
    ["PALADIN"] = PLATE,
    ["PRIEST"] = CLOTH,
    ["ROGUE"] = LEATHER,
    ["SHAMAN"] = MAIL,
    ["WARLOCK"] = CLOTH,
    ["WARRIOR"] = PLATE,
}


-- Class Masks
local classMask = {
    [1] = "WARRIOR",
    [2] = "PALADIN",
    [4] = "HUNTER",
    [8] = "ROGUE",
    [16] = "PRIEST",
    [32] = "DEATHKNIGHT",
    [64] = "SHAMAN",
    [128] = "MAGE",
    [256] = "WARLOCK",
    [512] = "MONK",
    [1024] = "DRUID",
    [2048] = "DEMONHUNTER",
    [4096] = "EVOKER",
}


local armorTypeSlots = {
    [HEAD] = true,
    [SHOULDER] = true,
    [CHEST] = true,
    [ROBE] = true,
    [WRIST] = true,
    [HAND] = true,
    [WAIST] = true,
    [LEGS] = true,
    [FEET] = true,
}


local miscArmorExceptions = {
    [HOLDABLE] = true,
    [BODY] = true,
    [TABARD] = true,
}


local APPEARANCES_ITEMS_TAB = 1
local APPEARANCES_SETS_TAB = 2


-- Get the name for Cosmetic. Uses http://www.wowhead.com/item=130064/deadeye-monocle.
local COSMETIC_NAME = select(3, GetItemInfoInstant(130064))


-- Built-in colors
-- TODO: move to constants
local BLIZZARD_RED = "|cffff1919"
local BLIZZARD_GREEN = "|cff19ff19"
local BLIZZARD_DARK_GREEN = "|cff40c040"
local BLIZZARD_YELLOW = "|cffffd100"


-------------------------
-- Text related tables --
-------------------------


-- Maps a text to its simpler version
local simpleTextMap = {
    [FoxyFarmhelper.KNOWN_BY_ANOTHER_CHARACTER] = FoxyFarmhelper.KNOWN,
    [FoxyFarmhelper.KNOWN_BY_ANOTHER_CHARACTER_BOE] = FoxyFarmhelper.KNOWN_BOE,
    [FoxyFarmhelper.KNOWN_BUT_TOO_LOW_LEVEL] = FoxyFarmhelper.KNOWN,
    [FoxyFarmhelper.KNOWN_BUT_TOO_LOW_LEVEL_BOE] = FoxyFarmhelper.KNOWN_BOE,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL] = FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL_BOE] = FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BOE,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE] = FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BOE,
}


-- List of all Known texts
local knownTexts = {
    [FoxyFarmhelper.KNOWN] = true,
    [FoxyFarmhelper.KNOWN_BOE] = true,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM] = true,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BOE] = true,
    [FoxyFarmhelper.KNOWN_BY_ANOTHER_CHARACTER] = true,
    [FoxyFarmhelper.KNOWN_BY_ANOTHER_CHARACTER_BOE] = true,
    [FoxyFarmhelper.KNOWN_BUT_TOO_LOW_LEVEL] = true,
    [FoxyFarmhelper.KNOWN_BUT_TOO_LOW_LEVEL_BOE] = true,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL] = true,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL_BOE] = true,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = true,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE] = true,
}


local unknownTexts = {
    [FoxyFarmhelper.UNKNOWN] = true,
    [FoxyFarmhelper.UNKNOWABLE_BY_CHARACTER] = true,
}


-----------------------------
-- Exceptions              --
-----------------------------

-- This is a list of exceptions with a key of their itemID and a value of what their result should be.

local exceptionItems = {
    [HEAD] = {
        -- [134110] = FoxyFarmhelper.KNOWN, -- Hidden Helm
        [133320] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Illidari Blindfold (Alliance)
        [112450] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Illidari Blindfold (Horde)
        -- [150726] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Illidari Blindfold (Alliance) - starting item
        -- [150716] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Illidari Blindfold (Horde) - starting item
        [130064] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Deadeye Monocle
    },
    [SHOULDER] = {
        [119556] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Trailseeker Spaulders - 100 Salvage Yard ilvl 610
        [117106] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Trailseeker Spaulders - 90 boost ilvl 483
        [129714] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Trailseeker Spaulders - 100 trial/boost ilvl 640
        [150642] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Trailseeker Spaulders - 100 trial/boost ilvl 600
        [153810] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Trailseeker Spaulders - 110 trial/boost ilvl 870
        [162796] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Wildguard Spaulders - 8.0 BfA Pre-Patch event
        [119588] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Mistdancer Pauldrons - 100 Salvage Yard ilvl 610
        [117138] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Mistdancer Pauldrons - 90 boost ilvl 483
        [129485] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Mistdancer Pauldrons - 100 trial/boost ilvl 640
        [150658] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Mistdancer Pauldrons - 100 trial/boost ilvl 600
        [153842] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Mistdancer Pauldrons - 110 trial/boost ilvl 870
        [162812] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Serene Disciple's Padding - 8.0 BfA Pre-Patch event
        [134112] = FoxyFarmhelper.KNOWN, -- Hidden Shoulders
    },
    [BODY] = {},
    [CHEST] = {},
    [ROBE] = {},
    [WAIST] = {
        [143539] = FoxyFarmhelper.KNOWN, -- Hidden Belt
    },
    [LEGS] = {},
    [FEET] = {},
    [WRIST] = {},
    [HAND] = {
        [119585] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Mistdancer Handguards - 100 Salvage Yard ilvl 610
        [117135] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Mistdancer Handguards - 90 boost ilvl 483
        [129482] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Mistdancer Handguards - 100 trial/boost ilvl 640
        [150655] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Mistdancer Handguards - 100 trial/boost ilvl 600
        [153839] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Mistdancer Handguards - 110 trial/boost ilvl 870
        [162809] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Serene Disciple's Handguards - 8.0 BfA Pre-Patch event
    },
    [CLOAK] = {
        -- [134111] = FoxyFarmhelper.KNOWN, -- Hidden Cloak
        [112462] = FoxyFarmhelper.NOT_TRANSMOGABLE, -- Illidari Drape
    },
    [WEAPON] = {},
    [SHIELD] = {},
    [WEAPON_2HAND] = {},
    [WEAPON_MAIN_HAND] = {},
    [RANGED] = {},
    [RANGED_RIGHT] = {},
    [WEAPON_OFF_HAND] = {},
    [HOLDABLE] = {},
    [TABARD] = {
        -- [142504] = FoxyFarmhelper.KNOWN, -- Hidden Tabard
    },
}


-----------------------------
-- Helper functions        --
-----------------------------

FoxyFarmhelper.Utils = {}


function FoxyFarmhelper.Utils.pairsByKeys (t, f)
    -- returns a sorted iterator for a table.
    -- https://www.lua.org/pil/19.3.html
    -- Why is it not a built in function? ¯\_(ツ)_/¯
    local a = {}
    for n in pairs(t) do table.insert(a, n) end
        table.sort(a, f)
        local i = 0      -- iterator variable
        local iter = function ()   -- iterator function
        i = i + 1
        if a[i] == nil then return nil
            else return a[i], t[a[i]]
        end
    end
    return iter
end


function FoxyFarmhelper.Utils.copyTable (t)
    -- shallow-copy a table
    if type(t) ~= "table" then return t end
    local target = {}
    for k, v in pairs(t) do target[k] = v end
    return target
end


function FoxyFarmhelper.Utils.spairs(t, order)
    -- Returns an iterator that is a sorted table. order is the function to sort by.
    -- http://stackoverflow.com/questions/15706270/sort-a-table-in-lua
    -- Again, why is this not a built in function? ¯\_(ツ)_/¯

    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end


function FoxyFarmhelper.Utils.strsplit(delimiter, text)
    -- from http://lua-users.org/wiki/SplitJoin
    -- Split text into a list consisting of the strings in text,
    -- separated by strings matching delimiter (which may be a pattern).
    -- example: strsplit(",%s*", "Anna, Bob, Charlie,Dolores")
    local list = {}
    local pos = 1
    if string.find("", delimiter, 1) then -- this would result in endless loops
       error("delimiter matches empty string!")
    end
    while 1 do
       local first, last = string.find(text, delimiter, pos)
       if first then -- found?
          table.insert(list, string.sub(text, pos, first-1))
          pos = last+1
       else
          table.insert(list, string.sub(text, pos))
          break
       end
    end
    return list
end


function FoxyFarmhelper.Utils.tablelength(T)
    -- Count the number of keys in a table, because tables don't bother
    -- counting themselves if it's filled with key-value pairs...
    -- ¯\_(ツ)_/¯
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end


function FoxyFarmhelper.Utils.GetKeys(T)
    --- Get an array of the keys from a table.
    local result = {}
    for key, _ in pairs(T) do
        table.insert(result, key)
    end
    return result
end


-----------------------------
-- FoxyFarmhelper Core methods  --
-----------------------------

-- Variables for managing updating appearances.
local appearanceIndex = 0
local sourceIndex = 0
local getAppearancesDone = false;
local sourceCount = 0
local appearanceCount = 0
local buffer = 0
local sourcesAdded = 0
local sourcesRemoved = 0
local loadingScreen = true


local appearancesTable = {}
local removeAppearancesTable = nil
local appearancesTableGotten = false
local doneAppearances = {}


local function LoadingScreenStarted(event)
    if event ~= "LOADING_SCREEN_ENABLED" then return end
    loadingScreen = true
end
FoxyFarmhelper.frame:AddEventFunction(LoadingScreenStarted)


local function LoadingScreenEnded(event)
    if event ~= "LOADING_SCREEN_DISABLED" then return end
    loadingScreen = false
end
FoxyFarmhelper.frame:AddEventFunction(LoadingScreenEnded)


local function GetAppearancesTable()
    -- Sort the C_TransmogCollection.GetCategoryAppearances tables into something
    -- more usable.
    if appearancesTableGotten then return end
    for categoryID=1,28 do
        local categoryAppearances = C_TransmogCollection.GetCategoryAppearances(categoryID, transmogLocation)
        for i, categoryAppearance in pairs(categoryAppearances) do
            if categoryAppearance.isCollected then
                appearanceCount = appearanceCount + 1
                appearancesTable[categoryAppearance.visualID] = true
            end
        end
    end
    appearancesTableGotten = true
end


local function AddSource(source, appearanceID)
    -- Adds the source to the database, and increments the buffer.
    buffer = buffer + 1
    sourceCount = sourceCount + 1
    local sourceID = source.sourceID
    local sourceItemLink = FoxyFarmhelper:GetItemLinkFromSourceID(sourceID)
    local added = FoxyFarmhelper:DBAddItem(sourceItemLink, appearanceID, sourceID)
    if added then
        sourcesAdded = sourcesAdded + 1
    end
end


local function AddAppearance(appearanceID)
    -- Adds all of the sources for this appearanceID to the database.
    -- returns early if the buffer is reached.
    local sources = C_TransmogCollection.GetAppearanceSources(appearanceID, 1, transmogLocation)
    if sources then
        for i, source in pairs(sources) do
            if source.isCollected then
                AddSource(source, appearanceID)
            end
        end
    end
end


-- Remembering iterators for later
local appearancesIter, removeIter = nil, nil


local function _GetAppearances()
    -- Core logic for getting the appearances.
    if getAppearancesDone then return end
    C_TransmogCollection.ClearSearch(APPEARANCES_ITEMS_TAB)
    GetAppearancesTable()
    buffer = 0

    if appearancesIter == nil then appearancesIter = FoxyFarmhelper.Utils.pairsByKeys(appearancesTable) end
    -- Add new appearances learned.
    for appearanceID, collected in appearancesIter do
        AddAppearance(appearanceID)
        if buffer >= FoxyFarmhelper.bufferMax then return end
        appearancesTable[appearanceID] = nil
    end

    if removeIter == nil then removeIter = FoxyFarmhelper.Utils.pairsByKeys(removeAppearancesTable) end
    -- Remove appearances that are no longer learned.
    for appearanceHash, sources in removeIter do
        for sourceID, source in pairs(sources.sources) do
            if not C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID) then
                local itemLink = FoxyFarmhelper:GetItemLinkFromSourceID(sourceID)
                local appearanceID = FoxyFarmhelper:GetAppearanceIDFromSourceID(sourceID)
                FoxyFarmhelper:DBRemoveItem(appearanceID, sourceID, itemLink, appearanceHash)
                sourcesRemoved = sourcesRemoved + 1
            end
            buffer = buffer + 1
        end
        if buffer >= FoxyFarmhelper.bufferMax then return end
        removeAppearancesTable[appearanceHash] = nil
    end

    getAppearancesDone = true
    appearancesTable = {} -- cleanup
    FoxyFarmhelper:ResetCache()
    appearancesIter = nil
    removeIter = nil
    FoxyFarmhelper.frame:SetScript("OnUpdate", nil)
    if FoxyFarmhelperOptions["printDatabaseScan"] then
        FoxyFarmhelper:Print(FoxyFarmhelper.DATABASE_DONE_UPDATE_TEXT..FoxyFarmhelper.BLUE.."+" .. sourcesAdded .. ", "..FoxyFarmhelper.ORANGE.."-".. sourcesRemoved)
    end
end


function FoxyFarmhelper:PauseDatabaseScan(message)
    if FoxyFarmhelperOptions["printDatabaseScan"] then
        FoxyFarmhelper:Print(message or L["Database scan paused."])
    end
    FoxyFarmhelper.frame:SetScript("OnUpdate", nil)
end


local timer = 0
local function GetAppearancesOnUpdate(self, elapsed)
    -- OnUpdate function with a reset timer to throttle getting appearances.
    -- We also don't run things if the loading screen is currently up, as some
    -- functions don't return values when loading.
    timer = timer + elapsed
    if timer >= FoxyFarmhelper.throttleTime and not loadingScreen then
        _GetAppearances()
        timer = 0
    end
end


function FoxyFarmhelper:GetAppearances()
    -- Gets a table of all the appearances known to
    -- a character and adds it to the database.
    if FoxyFarmhelperOptions["printDatabaseScan"] then
        FoxyFarmhelper:Print(FoxyFarmhelper.DATABASE_START_UPDATE_TEXT)
    end
    removeAppearancesTable = FoxyFarmhelper.Utils.copyTable(FoxyFarmhelper.db.global.appearances)
    FoxyFarmhelper.frame:SetScript("OnUpdate", GetAppearancesOnUpdate)
end


function CIMI_GetVariantSets(setID)
    --[[
        It seems that C_TransmogSets.GetVariantSets(setID) returns a number
        (instead of the expected table of sets) if it can't find a matching
        base set. We currently are checking that it's returning a table first
        to prevent issues.
    ]]
    local variantSets = C_TransmogSets.GetVariantSets(setID)
    if type(variantSets) == "table" then
        return variantSets
    end
    return {}
end


function FoxyFarmhelper:GetSets()
    -- Gets a table of all of the sets available to the character,
    -- along with their items, and adds them to the sets database.
    C_TransmogCollection.ClearSearch(APPEARANCES_SETS_TAB)
    for i, set in pairs(C_TransmogSets.GetAllSets()) do
        -- This is a base set, so we need to get the variant sets as well
        for i, sourceID in pairs(C_TransmogSets.GetAllSourceIDs(set.setID)) do
            FoxyFarmhelper:SetsDBAddSetItem(set, sourceID)
        end
        for i, variantSet in pairs(CIMI_GetVariantSets(set.setID)) do
            for i, sourceID in pairs(C_TransmogSets.GetAllSourceIDs(variantSet.setID)) do
                FoxyFarmhelper:SetsDBAddSetItem(variantSet, sourceID)
            end
        end
    end
end


function FoxyFarmhelper:_GetRatio(setID)
    -- Gets the count of known and total sources for the given setID.
    local have = 0
    local total = 0
    for _, appearance in pairs(C_TransmogSets.GetSetPrimaryAppearances(setID)) do
        total = total + 1
        if appearance.collected then
            have = have + 1
        end
    end
    return have, total
end


function FoxyFarmhelper:_GetRatioTextColor(have, total)
    if have == total then
        return FoxyFarmhelper.BLUE
    elseif have > 0 then
        return FoxyFarmhelper.RED_ORANGE
    else
        return FoxyFarmhelper.GRAY
    end
end


function FoxyFarmhelper:_GetRatioText(setID)
    -- Gets the ratio text (and color) of known/total for the given setID.
    local have, total = FoxyFarmhelper:_GetRatio(setID)

    local ratioText = FoxyFarmhelper:_GetRatioTextColor(have, total)
    ratioText = ratioText .. "(" .. have .. "/" .. total .. ")"
    return ratioText
end


function FoxyFarmhelper:GetSetClass(set)
    --[[
        Returns the set's class. If it belongs to more than one class,
        return an empty string.

        This is done based on the player's sex.
        Player's sex
        1 = Neutrum / Unknown
        2 = Male
        3 = Female
    ]]
    local playerSex = UnitSex("player")
    local className
    if playerSex == 2 then
        className = LOCALIZED_CLASS_NAMES_MALE[classMask[set.classMask]]
    else
        className = LOCALIZED_CLASS_NAMES_FEMALE[classMask[set.classMask]]
    end
    return className or ""
end


local classSetIDs = nil


function FoxyFarmhelper:CalculateSetsText(itemLink)
    --[[
        Gets the two lines of text to display on the tooltip related to sets.

        Example:

        Demon Hunter: Garb of the Something or Other
        Ulduar: 25 Man Normal (2/8)

        This function is not cached, so avoid calling often!
        Use GetSetsText whenever possible!
    ]]
    local sourceID = FoxyFarmhelper:GetSourceID(itemLink)
    if not sourceID then return end
    local setID = FoxyFarmhelper:SetsDBGetSetFromSourceID(sourceID)
    if not setID then return end

    local set = C_TransmogSets.GetSetInfo(setID)

    local ratioText = FoxyFarmhelper:_GetRatioText(setID)

    -- Build the classSetIDs table, if it hasn't been built yet.
    if classSetIDs == nil then
        classSetIDs = {}
        for i, baseSet in pairs(C_TransmogSets.GetBaseSets()) do
            classSetIDs[baseSet.setID] = true
            for i, variantSet in pairs(C_TransmogSets.GetVariantSets(baseSet.setID)) do
                classSetIDs[variantSet.setID] = true
            end
        end
    end

    local setNameColor, otherClass
    if classSetIDs[set.setID] then
        setNameColor = FoxyFarmhelper.WHITE
        otherClass = ""
    else
        setNameColor = FoxyFarmhelper.GRAY
        otherClass = FoxyFarmhelper:GetSetClass(set) .. ": "
    end


    local secondLineText = ""
    if set.label and set.description then
        secondLineText = FoxyFarmhelper.WHITE .. set.label .. ": " .. BLIZZARD_GREEN ..  set.description .. " "
    elseif set.label then
        secondLineText = FoxyFarmhelper.WHITE .. set.label .. " "
    elseif set.description then
        secondLineText = BLIZZARD_GREEN .. set.description .. " "
    end
    -- TODO: replace FoxyFarmhelper.WHITE with setNameColor, add otherClass
    -- e.g.: setNameColor .. otherClass .. set.name
    return FoxyFarmhelper.WHITE .. set.name, secondLineText .. ratioText
end


function FoxyFarmhelper:GetSetsText(itemLink)
    -- Gets the cached text regarding the sets info for the given item.
    local line1, line2;
    if FoxyFarmhelper.cache:GetSetsInfoTextValue(itemLink) then
        line1, line2 = unpack(FoxyFarmhelper.cache:GetSetsInfoTextValue(itemLink))
        return line1, line2
    end

    line1, line2 = FoxyFarmhelper:CalculateSetsText(itemLink)

    FoxyFarmhelper.cache:SetSetsInfoTextValue(itemLink, {line1, line2})

    return line1, line2
end


function FoxyFarmhelper:CalculateSetsVariantText(setID)
    --[[
        Given a setID, calculate the sum of all known sources for this set
        and it's variants.
    ]]

    local baseSetID = C_TransmogSets.GetBaseSetID(setID)

    local variantSets = {C_TransmogSets.GetSetInfo(baseSetID)}
    for i, variantSet in ipairs(CIMI_GetVariantSets(baseSetID)) do
        variantSets[#variantSets+1] = variantSet
    end

    local variantsText = ""

    for i, variantSet in FoxyFarmhelper.Utils.spairs(variantSets, function(t,a,b) return t[a].uiOrder < t[b].uiOrder end) do
        local variantHave, variantTotal = FoxyFarmhelper:_GetRatio(variantSet.setID)

        variantsText = variantsText .. FoxyFarmhelper:_GetRatioTextColor(variantHave, variantTotal)

        -- There is intentionally an extra space before the newline, for positioning.
        variantsText = variantsText .. variantHave .. "/" .. variantTotal .. " \n"
    end

    -- uncomment for debug
    -- variantsText = variantsText .. "setID: " .. setID .. "  "

    return string.sub(variantsText, 1, -2)
end


function FoxyFarmhelper:GetSetsVariantText(setID)
    -- Gets the cached text regarding the sets info for the given item.
    if not setID then return end
    local line1;
    if FoxyFarmhelper.cache:GetSetsSumRatioTextValue(setID) then
        line1 = FoxyFarmhelper.cache:GetSetsSumRatioTextValue(setID)
        return line1
    end

    line1 = FoxyFarmhelper:CalculateSetsVariantText(setID)

    FoxyFarmhelper.cache:SetSetsSumRatioTextValue(setID, line1)

    return line1
end


function FoxyFarmhelper:ResetCache()
    -- Resets the cache, and calls things relying on the cache being reset.
    FoxyFarmhelper.cache:Clear()
    FoxyFarmhelper:SendMessage("ResetCache")
    -- Fake a BAG_UPDATE event to updating the icons. TODO: Replace this with message
    FoxyFarmhelper.frame:ItemOverlayEvents("BAG_UPDATE")
end


function FoxyFarmhelper:CalculateSourceLocationText(itemLink)
    --[[
        Calculates the sources for this item.
        This function is not cached, so avoid calling often!
        Use GetSourceLocationText whenever possible!
    ]]
    local output = ""

    local appearanceID = FoxyFarmhelper:GetAppearanceID(itemLink)
    if appearanceID == nil then return end
    local sources = C_TransmogCollection.GetAppearanceSources(appearanceID, 1, transmogLocation)
    if sources then
        local totalSourceTypes = { 0, 0, 0, 0, 0, 0 }
        local knownSourceTypes = { 0, 0, 0, 0, 0, 0 }
        local totalUnknownType = 0
        local knownUnknownType = 0
        for _, source in pairs(sources) do
            if source.sourceType ~= 0 and source.sourceType ~= nil then
                totalSourceTypes[source.sourceType] = totalSourceTypes[source.sourceType] + 1
                if source.isCollected then
                    knownSourceTypes[source.sourceType] = knownSourceTypes[source.sourceType] + 1
                end
            elseif source.sourceType == 0 and source.isCollected then
                totalUnknownType = totalUnknownType + 1
                knownUnknownType = knownUnknownType + 1
            end
        end
        for sourceType, totalCount in ipairs(totalSourceTypes) do
            if (totalCount > 0) then
                local knownCount = knownSourceTypes[sourceType]
                local knownColor = FoxyFarmhelper.RED_ORANGE
                if knownCount == totalCount then
                    knownColor = FoxyFarmhelper.GRAY
                elseif knownCount > 0 then
                    knownColor = FoxyFarmhelper.BLUE
                end
                output = string.format("%s"..knownColor.."%s ("..knownColor.."%i/%i"..knownColor..")"..FoxyFarmhelper.WHITE..", ",
                    output, _G["TRANSMOG_SOURCE_"..sourceType], knownCount, totalCount)
            end
        end
        if totalUnknownType > 0 then
            output = string.format("%s"..FoxyFarmhelper.GRAY.."Unobtainable ("..FoxyFarmhelper.GRAY.."%i/%i"..FoxyFarmhelper.GRAY..")"..FoxyFarmhelper.WHITE..", ",
                output, knownUnknownType, totalUnknownType)
        end
        output = string.sub(output, 1, -3)
    end
    return output
end


function FoxyFarmhelper:GetSourceLocationText(itemLink)
    -- Returns string of the all the types of sources which can provide an item with this appearance.

    cached_value = FoxyFarmhelper.cache:GetItemSourcesValue(itemLink)
    if cached_value then
        return cached_value
    end

    local output = FoxyFarmhelper:CalculateSourceLocationText(itemLink)

    FoxyFarmhelper.cache:SetItemSourcesValue(itemLink, output)

    return output
end


function FoxyFarmhelper:GetPlayerArmorTypeName()
    local playerArmorTypeID = classArmorTypeMap[select(2, UnitClass("player"))]
    return select(1, GetItemSubClassInfo(4, playerArmorTypeID))
end


function FoxyFarmhelper:GetItemID(itemLink)
    return tonumber(itemLink:match("item:(%d+)"))
end


function FoxyFarmhelper:GetItemLinkFromSourceID(sourceID)
    return select(6, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
end


function FoxyFarmhelper:GetItemExpansion(itemID)
    return select(15, GetItemInfo(itemID))
end


function FoxyFarmhelper:GetItemMinTransmogLevel(itemID)
    -- Returns the minimum level required to transmog the item.
    -- This uses the expansion ID of the item to figure it out.
    -- Expansions before Shadowlands are all opened at level 10
    -- as of 9.0. Shadowlands is opened at level 48.
    local expansion = FoxyFarmhelper:GetItemExpansion(itemID)
    if expansion == nil or expansion == 0 then return end
    if expansion < FoxyFarmhelper.Expansions.SHADOWLANDS then
        return FoxyFarmhelper.MIN_TRANSMOG_LEVEL
    else
        return FoxyFarmhelper.MIN_TRANSMOG_LEVEL_SHADOWLANDS
    end
end


function FoxyFarmhelper:GetItemClassName(itemLink)
    return select(2, GetItemInfoInstant(itemLink))
end


function FoxyFarmhelper:GetItemSubClassName(itemLink)
    return select(3, GetItemInfoInstant(itemLink))
end


function FoxyFarmhelper:GetItemSlotName(itemLink)
    return select(4, GetItemInfoInstant(itemLink))
end


function FoxyFarmhelper:IsItemBattlepet(itemLink)
    return string.match(itemLink, ".*(battlepet):.*") == "battlepet"
end


function FoxyFarmhelper:IsItemKeystone(itemLink)
    return string.match(itemLink, ".*(keystone):.*") == "keystone"
end


function FoxyFarmhelper:IsReadyForCalculations(itemLink)
    -- Returns true of the item's GetItemInfo is ready, or if it's a keystone,
    -- or if it's a battlepet.
    if GetItemInfo(itemLink)
        or FoxyFarmhelper:IsItemKeystone(itemLink)
        or FoxyFarmhelper:IsItemBattlepet(itemLink) then
        return true
    end
    return false
end


function FoxyFarmhelper:IsItemArmor(itemLink)
    local itemClass = FoxyFarmhelper:GetItemClassName(itemLink)
    if itemClass == nil then return end
    return GetItemClassInfo(4) == itemClass
end


function FoxyFarmhelper:IsArmorSubClassID(subClassID, itemLink)
    local itemSubClass = FoxyFarmhelper:GetItemSubClassName(itemLink)
    if itemSubClass == nil then return end
    return select(1, GetItemSubClassInfo(4, subClassID)) == itemSubClass
end


function FoxyFarmhelper:IsArmorSubClassName(subClassName, itemLink)
    local itemSubClass = FoxyFarmhelper:GetItemSubClassName(itemLink)
    if itemSubClass == nil then return end
    return subClassName == itemSubClass
end


function FoxyFarmhelper:IsItemSubClassIdentical(itemLinkA, itemLinkB)
    local subClassA = FoxyFarmhelper:GetItemSubClassName(itemLinkA)
    local subClassB = FoxyFarmhelper:GetItemSubClassName(itemLinkB)
    if subClassA == nil or subClassB == nil then return end
    return subClassA == subClassB
end


function FoxyFarmhelper:IsArmorCosmetic(itemLink)
    return FoxyFarmhelper:IsArmorSubClassID(COSMETIC, itemLink)
end


function FoxyFarmhelper:IsArmorAppropriateForPlayer(itemLink)
    local playerArmorTypeID = FoxyFarmhelper:GetPlayerArmorTypeName()
    local slotName = FoxyFarmhelper:GetItemSlotName(itemLink)
    if slotName == nil then return end
    local isArmorCosmetic = FoxyFarmhelper:IsArmorCosmetic(itemLink)
    if isArmorCosmetic == nil then return end
    if armorTypeSlots[slotName] and isArmorCosmetic == false then
        return playerArmorTypeID == FoxyFarmhelper:GetItemSubClassName(itemLink)
    else
        return true
    end
end


local function IsHeirloomRedText(redText, itemLink)
    local itemID = FoxyFarmhelper:GetItemID(itemLink)
    if redText == _G["ITEM_SPELL_KNOWN"] and C_Heirloom.IsItemHeirloom(itemID) then
        return true
    end
end


local function IsLevelRequirementRedText(redText)
    if string.match(redText, _G["ITEM_MIN_LEVEL"]) then
        return true
    end
end


function FoxyFarmhelper:CharacterCanEquipItem(itemLink)
    -- Can the character equip this item eventually? (excluding level)
    if FoxyFarmhelper:IsItemArmor(itemLink) and FoxyFarmhelper:IsArmorCosmetic(itemLink) then
        return true
    end
    local redText = CIMIScanTooltip:GetRedText(itemLink)
    if redText == "" or redText == nil then
        return true
    end
    if IsHeirloomRedText(redText, itemLink) then
        -- Special case for heirloom items. They always have red text if it was learned.
        return true
    end
    if IsLevelRequirementRedText(redText) then
        -- We ignore the level, since it will be equipable eventually.
        return true
    end
    return false
end


function FoxyFarmhelper:IsValidAppearanceForCharacter(itemLink)
    -- Can the character transmog this appearance right now?
    if not FoxyFarmhelper:CharacterIsHighEnoughLevelForTransmog(itemLink) then
        return false
    end
    if FoxyFarmhelper:CharacterCanEquipItem(itemLink) then
        if FoxyFarmhelper:IsItemArmor(itemLink) then
            return FoxyFarmhelper:IsArmorAppropriateForPlayer(itemLink)
        else
            return true
        end
    else
        return false
    end
end


function FoxyFarmhelper:CharacterIsHighEnoughLevelForTransmog(itemLink)
    local minLevel = FoxyFarmhelper:GetItemMinTransmogLevel(itemLink)
    if minLevel == nil then return true end
    return UnitLevel("player") > minLevel
end


function FoxyFarmhelper:IsItemSoulbound(itemLink, bag, slot)
    return CIMIScanTooltip:IsItemSoulbound(itemLink, bag, slot)
end


function FoxyFarmhelper:IsItemBindOnEquip(itemLink, bag, slot)
    return CIMIScanTooltip:IsItemBindOnEquip(itemLink, bag, slot)
end


function FoxyFarmhelper:GetItemClassRestrictions(itemLink)
    if not itemLink then return end
    return CIMIScanTooltip:GetClassesRequired(itemLink)
end


function FoxyFarmhelper:GetExceptionText(itemLink)
    -- Returns the exception text for this item, if it has one.
    local itemID = FoxyFarmhelper:GetItemID(itemLink)
    local slotName = FoxyFarmhelper:GetItemSlotName(itemLink)
    if slotName == nil then return end
    local slotExceptions = exceptionItems[slotName]
    if slotExceptions then
        return slotExceptions[itemID]
    end
end


function FoxyFarmhelper:IsEquippable(itemLink)
    -- Returns whether the item is equippable or not (exluding bags)
    local slotName = FoxyFarmhelper:GetItemSlotName(itemLink)
    if slotName == nil then return end
    return slotName ~= "" and slotName ~= BAG
end


function FoxyFarmhelper:GetSourceID(itemLink)
    local sourceID = select(2, C_TransmogCollection.GetItemInfo(itemLink))
    if sourceID then
        return sourceID, "C_TransmogCollection.GetItemInfo"
    end

    -- Some items don't have the C_TransmogCollection.GetItemInfo data,
    -- so use the old way to find the sourceID (using the DressUpModel).
    local itemID, _, _, slotName = GetItemInfoInstant(itemLink)
    local slots = inventorySlotsMap[slotName]

    if slots == nil or slots == false or C_Item.IsDressableItemByID(itemID) == false then return end

    local cached_source = FoxyFarmhelper.cache:GetDressUpModelSource(itemLink)
    if cached_source then
        return cached_source, "DressUpModel:GetItemTransmogInfo cache"
    end
    FoxyFarmhelper.DressUpModel:SetUnit('player')
    FoxyFarmhelper.DressUpModel:Undress()
    for i, slot in pairs(slots) do
        FoxyFarmhelper.DressUpModel:TryOn(itemLink, slot)
        local transmogInfo = FoxyFarmhelper.DressUpModel:GetItemTransmogInfo(slot)
        if transmogInfo and
            transmogInfo.appearanceID ~= nil and
            transmogInfo.appearanceID ~= 0 then
            -- Yes, that's right, we are setting `appearanceID` to the `sourceID`. Blizzard messed
            -- up the DressUpModel functions, so _they_ don't even know what they do anymore.
            -- The `appearanceID` field from `DressUpModel:GetItemTransmogInfo` is actually its
            -- source ID, not it's appearance ID.
            sourceID = transmogInfo.appearanceID
            if not FoxyFarmhelper:IsSourceIDFromItemLink(sourceID, itemLink) then
                -- This likely means that the game hasn't finished loading things
                -- yet, so let's wait until we get good data before caching it.
                return
            end
            FoxyFarmhelper.cache:SetDressUpModelSource(itemLink, sourceID)
            return sourceID, "DressUpModel:GetItemTransmogInfo"
        end
    end
end


function FoxyFarmhelper:IsSourceIDFromItemLink(sourceID, itemLink)
    -- Returns whether the source ID given matches the itemLink.
    local sourceItemLink = select(6, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
    if not sourceItemLink then return false end
    return FoxyFarmhelper:DoItemIDsMatch(sourceItemLink, itemLink)
end


function FoxyFarmhelper:DoItemIDsMatch(itemLinkA, itemLinkB)
    return FoxyFarmhelper:GetItemID(itemLinkA) == FoxyFarmhelper:GetItemID(itemLinkB)
end


function FoxyFarmhelper:GetAppearanceID(itemLink)
    -- Gets the appearanceID of the given item. Also returns the sourceID, for convenience.
    local sourceID = FoxyFarmhelper:GetSourceID(itemLink)
    return FoxyFarmhelper:GetAppearanceIDFromSourceID(sourceID), sourceID
end


function FoxyFarmhelper:GetAppearanceIDFromSourceID(sourceID)
    -- Gets the appearanceID from the sourceID.
    if sourceID ~= nil then
        local appearanceID = select(2, C_TransmogCollection.GetAppearanceSourceInfo(sourceID))
        return appearanceID
    end
end


function FoxyFarmhelper:_PlayerKnowsTransmog(itemLink, appearanceID)
    -- Internal logic for determining if the item is known or not.
    -- Does not use the CIMI database.
    if itemLink == nil or appearanceID == nil then return end
    local sources = C_TransmogCollection.GetAppearanceSources(appearanceID, 1, transmogLocation)
    if sources then
        for i, source in pairs(sources) do
            local sourceItemLink = FoxyFarmhelper:GetItemLinkFromSourceID(source.sourceID)
            if FoxyFarmhelper:IsItemSubClassIdentical(itemLink, sourceItemLink) and source.isCollected then
                return true
            end
        end
    end
    return false
end


function FoxyFarmhelper:PlayerKnowsTransmog(itemLink)
    -- Returns whether this item's appearance is already known by the player.
    local appearanceID = FoxyFarmhelper:GetAppearanceID(itemLink)
    if appearanceID == nil then return false end
    local requirements = FoxyFarmhelper.Requirements:GetRequirements()
    if FoxyFarmhelper:DBHasAppearanceForRequirements(appearanceID, itemLink, requirements) then
        if FoxyFarmhelper:IsItemArmor(itemLink) then
            -- The character knows the appearance, check that it's from the same armor type.
            for sourceID, knownItem in pairs(FoxyFarmhelper:DBGetSources(appearanceID, itemLink)) do
                if FoxyFarmhelper:IsArmorSubClassName(knownItem.subClass, itemLink)
                        or knownItem.subClass == COSMETIC_NAME then
                    return true
                end
            end
        else
            -- Is not armor, don't worry about same appearance for different types
            return true
        end
    end

    -- Don't know from the database, try using the API.
    local knowsTransmog = FoxyFarmhelper:_PlayerKnowsTransmog(itemLink, appearanceID)
    if knowsTransmog then
        FoxyFarmhelper:DBAddItem(itemLink)
    end
    return knowsTransmog
end


function FoxyFarmhelper:PlayerKnowsTransmogFromItem(itemLink)
    -- Returns whether the transmog is known from this item specifically.
    local slotName = FoxyFarmhelper:GetItemSlotName(itemLink)
    if slotName == TABARD then
        local itemID = FoxyFarmhelper:GetItemID(itemLink)
        return C_TransmogCollection.PlayerHasTransmog(itemID)
    end
    local appearanceID, sourceID = FoxyFarmhelper:GetAppearanceID(itemLink)
    if sourceID == nil then return end

    -- First check the Database
    if FoxyFarmhelper:DBHasSource(appearanceID, sourceID, itemLink) then
        return true
    end

    local hasTransmog;
    hasTransmog = C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)

    -- Update Database
    if hasTransmog then
        FoxyFarmhelper:DBAddItem(itemLink, appearanceID, sourceID)
    end

    return hasTransmog
end


function FoxyFarmhelper:CharacterCanLearnTransmog(itemLink)
    -- Returns whether the player can learn the item or not.
    local slotName = FoxyFarmhelper:GetItemSlotName(itemLink)
    if slotName == TABARD then return true end
    local sourceID = FoxyFarmhelper:GetSourceID(itemLink)
    if sourceID == nil then return end
    if select(2, C_TransmogCollection.PlayerCanCollectSource(sourceID)) then
        return true
    end
    return false
end


function FoxyFarmhelper:GetReason(itemLink)
    local reason = CIMIScanTooltip:GetRedText(itemLink)
    if reason == "" then
        reason = FoxyFarmhelper:GetItemSubClassName(itemLink)
    end
    return reason
end


function FoxyFarmhelper:IsTransmogable(itemLink)
    -- Returns whether the item is transmoggable or not.

    local is_misc_subclass = FoxyFarmhelper:IsArmorSubClassID(MISC, itemLink)
    if is_misc_subclass and miscArmorExceptions[FoxyFarmhelper:GetItemSlotName(itemLink)] == nil then
        return false
    end

    local itemID, _, _, slotName = GetItemInfoInstant(itemLink)

    if FoxyFarmhelper:IsItemBattlepet(itemLink) or FoxyFarmhelper:IsItemKeystone(itemLink) then
        -- Item is never transmoggable if it's a battlepet or keystone.
        -- We can't wear battlepets on our heads yet!
        return false
    end

    -- See if the game considers it transmoggable
    local transmoggable = select(3, C_Transmog.CanTransmogItem(itemID))
    if transmoggable == false then
        return false
    end

    -- See if the item is in a valid transmoggable slot
    if inventorySlotsMap[slotName] == nil then
        return false
    end
    return true
end


function FoxyFarmhelper:TextIsKnown(text)
    -- Returns whether the text is considered to be a KNOWN value or not.
    return knownTexts[text] or false
end


function FoxyFarmhelper:TextIsUnknown(unmodifiedText)
    -- Returns whether the text is considered to be an UNKNOWN value or not.
    return unknownTexts[unmodifiedText] or false
end


function FoxyFarmhelper:PreLogicOptionsContinue(itemLink)
    -- Apply the options. Returns false if it should stop the logic.
    if FoxyFarmhelperOptions["showEquippableOnly"] and
            not FoxyFarmhelper:IsEquippable(itemLink) then
        -- Don't bother if it's not equipable.
        return false
    end

    return true
end


function FoxyFarmhelper:PostLogicOptionsText(text, unmodifiedText)
    -- Apply the options to the text. Returns the relevant text.

    if FoxyFarmhelperOptions["showUnknownOnly"] and not FoxyFarmhelper:TextIsUnknown(unmodifiedText) then
        -- We don't want to show the tooltip if it's already known.
        return "", ""
    end

    if FoxyFarmhelperOptions["showTransmoggableOnly"]
            and (unmodifiedText == FoxyFarmhelper.NOT_TRANSMOGABLE
            or unmodifiedText == FoxyFarmhelper.NOT_TRANSMOGABLE_BOE) then
        -- If we don't want to show the tooltip if it's not transmoggable
        return "", ""
    end

    if not FoxyFarmhelperOptions["showVerboseText"] then
        text = simpleTextMap[text] or text
    end

    return text, unmodifiedText
end


function FoxyFarmhelper:CalculateTooltipText(itemLink, bag, slot)
    --[[
        Calculate the tooltip text.
        No caching is done here, so don't call this often!
        Use GetTooltipText whenever possible!
    ]]
    local exception_text = FoxyFarmhelper:GetExceptionText(itemLink)
    if exception_text then
        return exception_text, exception_text
    end

    local isTransmogable = FoxyFarmhelper:IsTransmogable(itemLink)
    -- if isTransmogable == nil then return end

    local playerKnowsTransmogFromItem, isValidAppearanceForCharacter,
        characterIsHighEnoughLevelToTransmog, playerKnowsTransmog, characterCanLearnTransmog,
        isItemSoulbound, text, unmodifiedText;

    local isItemSoulbound = FoxyFarmhelper:IsItemSoulbound(itemLink, bag, slot)

    -- Is the item transmogable?
    if isTransmogable then
        --Calculating the logic for each rule

        -- If the item is transmogable, bug didn't give a result for soulbound state, it's
        -- probably not ready yet.
        if isItemSoulbound == nil then return end

        playerKnowsTransmogFromItem = FoxyFarmhelper:PlayerKnowsTransmogFromItem(itemLink)
        if playerKnowsTransmogFromItem == nil then return end

        isValidAppearanceForCharacter = FoxyFarmhelper:IsValidAppearanceForCharacter(itemLink)
        if isValidAppearanceForCharacter == nil then return end

        playerKnowsTransmog = FoxyFarmhelper:PlayerKnowsTransmog(itemLink)
        if playerKnowsTransmog == nil then return end

        characterCanLearnTransmog = FoxyFarmhelper:CharacterCanLearnTransmog(itemLink)
        if characterCanLearnTransmog == nil then return end

        -- Is the item transmogable?
        if playerKnowsTransmogFromItem then
            -- Is this an appearance that the character can use now?
            if isValidAppearanceForCharacter then
                -- The player knows the appearance from this item
                -- and the character can transmog it.
                text = FoxyFarmhelper.KNOWN
                unmodifiedText = FoxyFarmhelper.KNOWN
            else
                -- Can the character use the appearance eventually?
                if characterCanLearnTransmog then
                    -- The player knows the appearance from this item, but
                    -- the character is too low level to use the appearance.
                    text = FoxyFarmhelper.KNOWN_BUT_TOO_LOW_LEVEL
                    unmodifiedText = FoxyFarmhelper.KNOWN_BUT_TOO_LOW_LEVEL
                else
                    if isItemSoulbound then
                        -- The player knows the appearance from this item, but
                        -- the character can never use it.
                        text = FoxyFarmhelper.KNOWN_BY_ANOTHER_CHARACTER
                        unmodifiedText = FoxyFarmhelper.KNOWN_BY_ANOTHER_CHARACTER
                    else
                        -- The player knows the appearance from this item, but
                        -- the character can never use it, but it is BoE.
                        text = FoxyFarmhelper.KNOWN_BY_ANOTHER_CHARACTER_BOE
                        unmodifiedText = FoxyFarmhelper.KNOWN_BY_ANOTHER_CHARACTER_BOE
                    end
                end
            end
        -- Does the player know the appearance from a different item?
        elseif playerKnowsTransmog then
            -- Is this an appearance that the character can use/learn now?
            if isValidAppearanceForCharacter then
                -- The player knows the appearance from another item, and
                -- the character can use it.
                text = FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM
                unmodifiedText = FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM
            else
                -- Can the character use/learn the appearance from the item eventually?
                if characterCanLearnTransmog then
                    -- The player knows the appearance from another item, but
                    -- the character is too low level to use/learn the appareance.
                    text = FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL
                    unmodifiedText = FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL
                else
                    if isItemSoulbound then
                        -- The player knows the appearance from another item, but
                        -- this charater can never use/learn the apperance.
                        text = FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER
                        unmodifiedText = FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER
                    else
                        -- The player knows the appearance from another item, but
                        -- this charater can never use/learn the apperance, but it is BoE.
                        text = FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE
                        unmodifiedText = FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE
                    end
                end
            end
        else
            -- Can the character learn the appearance?
            if characterCanLearnTransmog then
                -- The player does not know the appearance and the character
                -- can learn this appearance.
                text = FoxyFarmhelper.UNKNOWN
                unmodifiedText = FoxyFarmhelper.UNKNOWN
            else
                -- Is the item Soulbound?
                if isItemSoulbound then
                    -- The player does not know the appearance, the character
                    -- cannot use the appearance, and the item cannot be mailed
                    -- because it is soulbound.
                    text = FoxyFarmhelper.UNKNOWABLE_SOULBOUND
                            .. BLIZZARD_RED .. FoxyFarmhelper:GetReason(itemLink)
                    unmodifiedText = FoxyFarmhelper.UNKNOWABLE_SOULBOUND
                else
                    -- The player does not know the apperance, and the character
                    -- cannot use/learn the appearance.
                    text = FoxyFarmhelper.UNKNOWABLE_BY_CHARACTER
                            .. BLIZZARD_RED .. FoxyFarmhelper:GetReason(itemLink)
                    unmodifiedText = FoxyFarmhelper.UNKNOWABLE_BY_CHARACTER
                end
            end
        end
    else
        -- This item is never transmogable.
        text = FoxyFarmhelper.NOT_TRANSMOGABLE
        unmodifiedText = FoxyFarmhelper.NOT_TRANSMOGABLE
    end

    return text, unmodifiedText
end


function FoxyFarmhelper:CheckItemBindType(text, unmodifiedText, itemLink, bag, slot)
    --[[
        Check what binding text is used on the tooltip and then
        change the Can I Mog It text where appropirate.
    ]]
    local isItemBindOnEquip = FoxyFarmhelper:IsItemBindOnEquip(itemLink, bag, slot)
    if isItemBindOnEquip == nil then return end

    if isItemBindOnEquip then
        if unmodifiedText == FoxyFarmhelper.KNOWN then
            text = FoxyFarmhelper.KNOWN_BOE
            unmodifiedText = FoxyFarmhelper.KNOWN_BOE
        elseif unmodifiedText == FoxyFarmhelper.KNOWN_BUT_TOO_LOW_LEVEL then
            text = FoxyFarmhelper.KNOWN_BUT_TOO_LOW_LEVEL_BOE
            unmodifiedText = FoxyFarmhelper.KNOWN_BUT_TOO_LOW_LEVEL_BOE
        elseif unmodifiedText == FoxyFarmhelper.KNOWN_BY_ANOTHER_CHARACTER then
            text = FoxyFarmhelper.KNOWN_BY_ANOTHER_CHARACTER_BOE
            unmodifiedText = FoxyFarmhelper.KNOWN_BY_ANOTHER_CHARACTER_BOE
        elseif unmodifiedText == FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM then
            text = FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BOE
            unmodifiedText = FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BOE
        elseif unmodifiedText == FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL then
            text = FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL_BOE
            unmodifiedText = FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL_BOE
        elseif unmodifiedText == FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER then
            text = FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE
            unmodifiedText = FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE
        elseif unmodifiedText == FoxyFarmhelper.NOT_TRANSMOGABLE then
            text = FoxyFarmhelper.NOT_TRANSMOGABLE_BOE
            unmodifiedText = FoxyFarmhelper.NOT_TRANSMOGABLE_BOE
        end
    -- elseif BoA
    end
    return text, unmodifiedText
end


local foundAnItemFromBags = false


function FoxyFarmhelper:GetTooltipText(itemLink, bag, slot)
    --[[
        Gets the text to display on the tooltip from the itemLink.

        If bag and slot are given, this will use the itemLink from
        bag and slot instead.

        Returns two things:
            the text to display.
            the unmodifiedText that can be used for lookup values.
    ]]
    if bag and slot then
        itemLink = C_Container.GetContainerItemLink(bag, slot)
        if not itemLink then
            if foundAnItemFromBags then
                return "", ""
            else
                -- If we haven't found any items in the bags yet, then
                -- it's likely that the inventory hasn't been loaded yet.
                return nil
            end
        else
            foundAnItemFromBags = true
        end
    end
    if not itemLink then return "", "" end
    if not FoxyFarmhelper:IsReadyForCalculations(itemLink) then
        return
    end

    local text = ""
    local unmodifiedText = ""

    if not FoxyFarmhelper:PreLogicOptionsContinue(itemLink) then return "", "" end

    -- Return cached items
    local cachedData = FoxyFarmhelper.cache:GetItemTextValue(itemLink)
    if cachedData then
        local cachedText, cachedUnmodifiedText = unpack(cachedData)
        return cachedText, cachedUnmodifiedText
    end

    text, unmodifiedText = FoxyFarmhelper:CalculateTooltipText(itemLink, bag, slot)

    text = FoxyFarmhelper:PostLogicOptionsText(text, unmodifiedText)

    -- Update cached items
    if text ~= nil then
        FoxyFarmhelper.cache:SetItemTextValue(itemLink, {text, unmodifiedText})
    end

    return text, unmodifiedText
end


function FoxyFarmhelper:GetIconText(itemLink, bag, slot)
    --[[
        Gets the icon as text for this itemLink/bag+slot. Does not include the other text
        that is also caluculated.
    ]]
    local text, unmodifiedText = FoxyFarmhelper:GetTooltipText(itemLink, bag, slot)
    local icon
    if text ~= "" and text ~= nil then
        icon = FoxyFarmhelper.tooltipIcons[unmodifiedText]
    else
        icon = ""
    end
    return icon
end
