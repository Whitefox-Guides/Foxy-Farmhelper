-- Constants for FoxyFarmhelper

local L = FoxyFarmhelper.L


--------------------------------------------
-- Database scan speed values             --
--------------------------------------------


-- Instant - Only the best of connections, or you WILL crash with Error #134
-- FoxyFarmhelper.throttleTime = 0.25
-- FoxyFarmhelper.bufferMax = 10000

-- Near Instant - May cause your game to crash with Error #134
-- FoxyFarmhelper.throttleTime = 0.25
-- FoxyFarmhelper.bufferMax = 200

-- Fast - Less likely to cause lag or crash
-- FoxyFarmhelper.throttleTime = 0.1
-- FoxyFarmhelper.bufferMax = 50

-- Medium - Most likely safe
FoxyFarmhelper.throttleTime = 0.1
FoxyFarmhelper.bufferMax = 25

-- Slow - Will take a long time, but be 100% safe. Use if you have a poor connection.
-- FoxyFarmhelper.throttleTime = 0.5
-- FoxyFarmhelper.bufferMax = 5


--------------------------------------------
-- Tooltip icon, color and text constants --
--------------------------------------------

-- Icons
FoxyFarmhelper.KNOWN_ICON = "|TInterface\\Addons\\FoxyFarmhelper\\Icons\\KNOWN:0|t "
FoxyFarmhelper.KNOWN_ICON_OVERLAY = "Interface\\Addons\\FoxyFarmhelper\\Icons\\KNOWN_OVERLAY"
FoxyFarmhelper.KNOWN_SOULBOUND_ICON = "|TInterface\\Addons\\FoxyFarmhelper\\Icons\\KNOWN_BOP:0|t "
FoxyFarmhelper.KNOWN_SOULBOUND_ICON_OVERLAY = "Interface\\Addons\\FoxyFarmhelper\\Icons\\KNOWN_BOP_OVERLAY"
FoxyFarmhelper.KNOWN_BOE_ICON = "|TInterface\\Addons\\FoxyFarmhelper\\Icons\\KNOWN_BOE:0|t "
FoxyFarmhelper.KNOWN_BOE_ICON_OVERLAY = "Interface\\Addons\\FoxyFarmhelper\\Icons\\KNOWN_BOE_OVERLAY"
FoxyFarmhelper.KNOWN_BUT_ICON = "|TInterface\\Addons\\FoxyFarmhelper\\Icons\\KNOWN_circle:0|t "
FoxyFarmhelper.KNOWN_BUT_ICON_OVERLAY = "Interface\\Addons\\FoxyFarmhelper\\Icons\\KNOWN_circle_OVERLAY"
FoxyFarmhelper.KNOWN_BUT_BOE_ICON = "|TInterface\\Addons\\FoxyFarmhelper\\Icons\\KNOWN_BOE_circle:0|t "
FoxyFarmhelper.KNOWN_BUT_BOE_ICON_OVERLAY = "Interface\\Addons\\FoxyFarmhelper\\Icons\\KNOWN_BOE_circle_OVERLAY"
FoxyFarmhelper.KNOWN_BUT_SOULBOUND_ICON = "|TInterface\\Addons\\FoxyFarmhelper\\Icons\\KNOWN_BOP_circle:0|t "
FoxyFarmhelper.KNOWN_BUT_SOULBOUND_ICON_OVERLAY = "Interface\\Addons\\FoxyFarmhelper\\Icons\\KNOWN_BOP_circle_OVERLAY"
FoxyFarmhelper.UNKNOWABLE_SOULBOUND_ICON = "|TInterface\\Addons\\FoxyFarmhelper\\Icons\\UNKNOWABLE_SOULBOUND:0|t "
FoxyFarmhelper.UNKNOWABLE_SOULBOUND_ICON_OVERLAY = "Interface\\Addons\\FoxyFarmhelper\\Icons\\UNKNOWABLE_SOULBOUND_OVERLAY"
FoxyFarmhelper.UNKNOWABLE_BY_CHARACTER_ICON = "|TInterface\\Addons\\FoxyFarmhelper\\Icons\\UNKNOWABLE_BY_CHARACTER:0|t "
FoxyFarmhelper.UNKNOWABLE_BY_CHARACTER_ICON_OVERLAY = "Interface\\Addons\\FoxyFarmhelper\\Icons\\UNKNOWABLE_BY_CHARACTER_OVERLAY"
FoxyFarmhelper.UNKNOWN_ICON = "|TInterface\\Addons\\FoxyFarmhelper\\Icons\\UNKNOWN:0|t "
FoxyFarmhelper.UNKNOWN_ICON_OVERLAY = "Interface\\Addons\\FoxyFarmhelper\\Icons\\UNKNOWN_OVERLAY"
FoxyFarmhelper.NOT_TRANSMOGABLE_ICON = "|TInterface\\Addons\\FoxyFarmhelper\\Icons\\NOT_TRANSMOGABLE:0|t "
FoxyFarmhelper.NOT_TRANSMOGABLE_ICON_OVERLAY = "Interface\\Addons\\FoxyFarmhelper\\Icons\\NOT_TRANSMOGABLE_OVERLAY"
FoxyFarmhelper.NOT_TRANSMOGABLE_BOE_ICON = "|TInterface\\Addons\\FoxyFarmhelper\\Icons\\NOT_TRANSMOGABLE_BOE:0|t "
FoxyFarmhelper.NOT_TRANSMOGABLE_BOE_ICON_OVERLAY = "Interface\\Addons\\FoxyFarmhelper\\Icons\\NOT_TRANSMOGABLE_BOE_OVERLAY"
FoxyFarmhelper.QUESTIONABLE_ICON = "|TInterface\\Addons\\FoxyFarmhelper\\Icons\\QUESTIONABLE:0|t "
FoxyFarmhelper.QUESTIONABLE_ICON_OVERLAY = "Interface\\Addons\\FoxyFarmhelper\\Icons\\QUESTIONABLE_OVERLAY"


-- Colorblind colors
FoxyFarmhelper.BLUE =   "|cff15abff"
FoxyFarmhelper.BLUE_GREEN = "|cff009e73"
FoxyFarmhelper.PINK = "|cffcc79a7"
FoxyFarmhelper.ORANGE = "|cffe69f00"
FoxyFarmhelper.RED_ORANGE = "|cffff9333"
FoxyFarmhelper.YELLOW = "|cfff0e442"
FoxyFarmhelper.GRAY =   "|cff888888"
FoxyFarmhelper.WHITE =   "|cffffffff"


-- Tooltip Text
local KNOWN =                                           L["Learned."]
local KNOWN_BOE =                                       L["Learned."]
local KNOWN_FROM_ANOTHER_ITEM =                         L["Learned from another item."]
local KNOWN_FROM_ANOTHER_ITEM_BOE =                     L["Learned from another item."]
local KNOWN_BY_ANOTHER_CHARACTER =                      L["Learned for a different class."]
local KNOWN_BY_ANOTHER_CHARACTER_BOE =                  L["Learned for a different class."]
local KNOWN_BUT_TOO_LOW_LEVEL =                         L["Learned but cannot transmog yet."]
local KNOWN_BUT_TOO_LOW_LEVEL_BOE =                     L["Learned but cannot transmog yet."]
local KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL =       L["Learned from another item but cannot transmog yet."]
local KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL_BOE =   L["Learned from another item but cannot transmog yet."]
local KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER =           L["Learned for a different class and item."]
local KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE =       L["Learned for a different class and item."]
local UNKNOWABLE_SOULBOUND =                            L["Cannot learn: Soulbound"] .. " " -- subClass
local UNKNOWABLE_BY_CHARACTER =                         L["Cannot learn:"] .. " " -- subClass
local CAN_BE_LEARNED_BY =                               L["Can be learned by:"] -- list of classes
local UNKNOWN =                                         L["Not learned."]
local NOT_TRANSMOGABLE =                                L["Cannot be learned."]
local NOT_TRANSMOGABLE_BOE =                            L["Cannot be learned."]
local CANNOT_DETERMINE =                                L["Cannot determine status on other characters."]


-- Combine icons, color, and text into full tooltip
FoxyFarmhelper.KNOWN =                                           FoxyFarmhelper.KNOWN_ICON .. FoxyFarmhelper.BLUE .. KNOWN
FoxyFarmhelper.KNOWN_BOE =                                       FoxyFarmhelper.KNOWN_BOE_ICON .. FoxyFarmhelper.YELLOW .. KNOWN
FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM =                         FoxyFarmhelper.KNOWN_BUT_ICON .. FoxyFarmhelper.BLUE .. KNOWN_FROM_ANOTHER_ITEM
FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BOE =                     FoxyFarmhelper.KNOWN_BUT_BOE_ICON .. FoxyFarmhelper.YELLOW .. KNOWN_FROM_ANOTHER_ITEM
FoxyFarmhelper.KNOWN_BY_ANOTHER_CHARACTER =                      FoxyFarmhelper.KNOWN_SOULBOUND_ICON .. FoxyFarmhelper.BLUE_GREEN .. KNOWN_BY_ANOTHER_CHARACTER
FoxyFarmhelper.KNOWN_BY_ANOTHER_CHARACTER_BOE =                  FoxyFarmhelper.KNOWN_BOE_ICON .. FoxyFarmhelper.YELLOW .. KNOWN_BY_ANOTHER_CHARACTER
FoxyFarmhelper.KNOWN_BUT_TOO_LOW_LEVEL =                         FoxyFarmhelper.KNOWN_ICON .. FoxyFarmhelper.BLUE .. KNOWN_BUT_TOO_LOW_LEVEL
FoxyFarmhelper.KNOWN_BUT_TOO_LOW_LEVEL_BOE =                     FoxyFarmhelper.KNOWN_BOE_ICON .. FoxyFarmhelper.YELLOW .. KNOWN_BUT_TOO_LOW_LEVEL
FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL =       FoxyFarmhelper.KNOWN_BUT_ICON .. FoxyFarmhelper.BLUE .. KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL
FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL_BOE =   FoxyFarmhelper.KNOWN_BUT_BOE_ICON .. FoxyFarmhelper.YELLOW .. KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL
FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER =           FoxyFarmhelper.KNOWN_BUT_SOULBOUND_ICON .. FoxyFarmhelper.BLUE_GREEN .. KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER
FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE =       FoxyFarmhelper.KNOWN_BUT_BOE_ICON .. FoxyFarmhelper.YELLOW .. KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER
-- FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER =        FoxyFarmhelper.QUESTIONABLE_ICON .. FoxyFarmhelper.YELLOW .. CANNOT_DETERMINE
FoxyFarmhelper.UNKNOWABLE_SOULBOUND =                            FoxyFarmhelper.UNKNOWABLE_SOULBOUND_ICON .. FoxyFarmhelper.BLUE_GREEN .. UNKNOWABLE_SOULBOUND
FoxyFarmhelper.UNKNOWABLE_BY_CHARACTER =                         FoxyFarmhelper.UNKNOWABLE_BY_CHARACTER_ICON .. FoxyFarmhelper.YELLOW .. UNKNOWABLE_BY_CHARACTER
FoxyFarmhelper.UNKNOWN =                                         FoxyFarmhelper.UNKNOWN_ICON .. FoxyFarmhelper.RED_ORANGE .. UNKNOWN
FoxyFarmhelper.NOT_TRANSMOGABLE =                                FoxyFarmhelper.NOT_TRANSMOGABLE_ICON .. FoxyFarmhelper.GRAY .. NOT_TRANSMOGABLE
FoxyFarmhelper.NOT_TRANSMOGABLE_BOE =                            FoxyFarmhelper.NOT_TRANSMOGABLE_BOE_ICON .. FoxyFarmhelper.YELLOW .. NOT_TRANSMOGABLE
FoxyFarmhelper.CANNOT_DETERMINE =                                FoxyFarmhelper.QUESTIONABLE_ICON


FoxyFarmhelper.tooltipIcons = {
    [FoxyFarmhelper.KNOWN] = FoxyFarmhelper.KNOWN_ICON,
    [FoxyFarmhelper.KNOWN_BOE] = FoxyFarmhelper.KNOWN_BOE_ICON,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM] = FoxyFarmhelper.KNOWN_BUT_ICON,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BOE] = FoxyFarmhelper.KNOWN_BUT_BOE_ICON,
    [FoxyFarmhelper.KNOWN_BY_ANOTHER_CHARACTER] = FoxyFarmhelper.KNOWN_SOULBOUND_ICON,
    [FoxyFarmhelper.KNOWN_BY_ANOTHER_CHARACTER_BOE] = FoxyFarmhelper.KNOWN_BOE_ICON,
    [FoxyFarmhelper.KNOWN_BUT_TOO_LOW_LEVEL] = FoxyFarmhelper.KNOWN_ICON,
    [FoxyFarmhelper.KNOWN_BUT_TOO_LOW_LEVEL_BOE] = FoxyFarmhelper.KNOWN_BOE_ICON,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL] = FoxyFarmhelper.KNOWN_BUT_ICON,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL_BOE] = FoxyFarmhelper.KNOWN_BUT_BOE_ICON,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = FoxyFarmhelper.KNOWN_BUT_SOULBOUND_ICON,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE] = FoxyFarmhelper.KNOWN_BUT_BOE_ICON,
    -- [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = FoxyFarmhelper.QUESTIONABLE_ICON,
    [FoxyFarmhelper.UNKNOWABLE_SOULBOUND] = FoxyFarmhelper.UNKNOWABLE_SOULBOUND_ICON,
    [FoxyFarmhelper.UNKNOWABLE_BY_CHARACTER] = FoxyFarmhelper.UNKNOWABLE_BY_CHARACTER_ICON,
    -- [FoxyFarmhelper.CAN_BE_LEARNED_BY] = FoxyFarmhelper.UNKNOWABLE_BY_CHARACTER_ICON,
    [FoxyFarmhelper.UNKNOWN] = FoxyFarmhelper.UNKNOWN_ICON,
    [FoxyFarmhelper.NOT_TRANSMOGABLE] = FoxyFarmhelper.NOT_TRANSMOGABLE_ICON,
    [FoxyFarmhelper.NOT_TRANSMOGABLE_BOE] = FoxyFarmhelper.NOT_TRANSMOGABLE_BOE_ICON,
    [FoxyFarmhelper.CANNOT_DETERMINE] = FoxyFarmhelper.QUESTIONABLE_ICON,
}


-- Used by itemOverlay
FoxyFarmhelper.tooltipOverlayIcons = {
    [FoxyFarmhelper.KNOWN] = FoxyFarmhelper.KNOWN_ICON_OVERLAY,
    [FoxyFarmhelper.KNOWN_BOE] = FoxyFarmhelper.KNOWN_BOE_ICON_OVERLAY,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM] = FoxyFarmhelper.KNOWN_BUT_ICON_OVERLAY,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BOE] = FoxyFarmhelper.KNOWN_BUT_BOE_ICON_OVERLAY,
    [FoxyFarmhelper.KNOWN_BY_ANOTHER_CHARACTER] = FoxyFarmhelper.KNOWN_SOULBOUND_ICON_OVERLAY,
    [FoxyFarmhelper.KNOWN_BY_ANOTHER_CHARACTER_BOE] = FoxyFarmhelper.KNOWN_BOE_ICON_OVERLAY,
    [FoxyFarmhelper.KNOWN_BUT_TOO_LOW_LEVEL] = FoxyFarmhelper.KNOWN_ICON_OVERLAY,
    [FoxyFarmhelper.KNOWN_BUT_TOO_LOW_LEVEL_BOE] = FoxyFarmhelper.KNOWN_BOE_ICON_OVERLAY,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL] = FoxyFarmhelper.KNOWN_BUT_ICON_OVERLAY,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_BUT_TOO_LOW_LEVEL_BOE] = FoxyFarmhelper.KNOWN_BUT_BOE_ICON_OVERLAY,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = FoxyFarmhelper.KNOWN_BUT_SOULBOUND_ICON_OVERLAY,
    [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER_BOE] = FoxyFarmhelper.KNOWN_BUT_BOE_ICON_OVERLAY,
    -- [FoxyFarmhelper.KNOWN_FROM_ANOTHER_ITEM_AND_CHARACTER] = FoxyFarmhelper.QUESTIONABLE_ICON_OVERLAY,
    [FoxyFarmhelper.UNKNOWABLE_SOULBOUND] = FoxyFarmhelper.UNKNOWABLE_SOULBOUND_ICON_OVERLAY,
    [FoxyFarmhelper.UNKNOWABLE_BY_CHARACTER] = FoxyFarmhelper.UNKNOWABLE_BY_CHARACTER_ICON_OVERLAY,
    -- [FoxyFarmhelper.CAN_BE_LEARNED_BY] = FoxyFarmhelper.UNKNOWABLE_BY_CHARACTER_ICON_OVERLAY,
    [FoxyFarmhelper.UNKNOWN] = FoxyFarmhelper.UNKNOWN_ICON_OVERLAY,
    [FoxyFarmhelper.NOT_TRANSMOGABLE] = FoxyFarmhelper.NOT_TRANSMOGABLE_ICON_OVERLAY,
    [FoxyFarmhelper.NOT_TRANSMOGABLE_BOE] = FoxyFarmhelper.NOT_TRANSMOGABLE_BOE_ICON_OVERLAY,
    [FoxyFarmhelper.CANNOT_DETERMINE] = FoxyFarmhelper.QUESTIONABLE_ICON_OVERLAY,
}


-- Other text

FoxyFarmhelper.DATABASE_START_UPDATE_TEXT = L["Updating appearances database."]
FoxyFarmhelper.DATABASE_DONE_UPDATE_TEXT = L["Items updated: "] -- followed by a number


--------------------------------------------
-- Location constants                     --
--------------------------------------------

FoxyFarmhelper.ICON_LOCATIONS = {
    ["TOPLEFT"] = {"TOPLEFT", 2, -2},
    ["TOPRIGHT"] = {"TOPRIGHT", -2, -2},
    ["BOTTOMLEFT"] = {"BOTTOMLEFT", 2, 2},
    ["BOTTOMRIGHT"] = {"BOTTOMRIGHT", -2, 2},
    ["CENTER"] = {"CENTER", 0, 0},
    ["RIGHT"] = {"RIGHT", -2, 0},
    ["LEFT"] = {"LEFT", 2, 0},
    ["BOTTOM"] = {"BOTTOM", 0, 2},
    ["TOP"] = {"TOP", 0, -2},
    ["AUCTION_HOUSE"] = {"LEFT", 137, 0}
}

--------------------------------------------
-- Blizzard frame constants --
--------------------------------------------


---- Auction Houses ----
FoxyFarmhelper.NUM_BLACKMARKET_BUTTONS = 12  -- No Blizzard constant

---- Containers ----
-- Bags = NUM_CONTAINER_FRAMES
-- Bag Items = MAX_CONTAINER_ITEMS  -- Blizzard removed this variable in 9.0 for some reason
FoxyFarmhelper.MAX_CONTAINER_ITEMS = MAX_CONTAINER_ITEMS or 36
-- Bank = NUM_BANKGENERIC_SLOTS
FoxyFarmhelper.NUM_VOID_STORAGE_FRAMES = 80 -- Blizzard functions are locals

---- Expansions ----
FoxyFarmhelper.Expansions = {}
FoxyFarmhelper.Expansions.BC = 1
FoxyFarmhelper.Expansions.WRATH = 2
FoxyFarmhelper.Expansions.CATA = 3
FoxyFarmhelper.Expansions.MISTS = 4
FoxyFarmhelper.Expansions.WOD = 5
FoxyFarmhelper.Expansions.LEGION = 6
FoxyFarmhelper.Expansions.BFA = 7
FoxyFarmhelper.Expansions.SHADOWLANDS = 8

---- Others ----
FoxyFarmhelper.NUM_ENCOUNTER_JOURNAL_ENCOUNTER_LOOT_FRAMES = 10 -- Blizzard functions are locals
FoxyFarmhelper.NUM_MAIL_INBOX_ITEMS = 7
-- Mail Attachments = ATTACHMENTS_MAX_RECEIVE
-- Merchant Items = MERCHANT_ITEMS_PER_PAGE
-- Trade Skill = no constants
-- Loot Roll = NUM_GROUP_LOOT_FRAMES -- Blizzard removed in patch 10.1.5, using our own constant
FoxyFarmhelper.NUM_GROUP_LOOT_FRAMES = 4

-- Expansions before Shadowlands are all opened at level 10 as of 9.0. Shadowlands is opened at level 48.
FoxyFarmhelper.MIN_TRANSMOG_LEVEL = 10
FoxyFarmhelper.MIN_TRANSMOG_LEVEL_SHADOWLANDS = 48