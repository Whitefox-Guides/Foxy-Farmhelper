-- Options for FoxyFarmhelper
--
-- Thanks to Stanzilla and Semlar and their addon AdvancedInterfaceOptions, which I used as reference.

local _G = _G
local L = FoxyFarmhelper.L

local CREATE_DATABASE_TEXT = L["Can I Mog It? Important Message: Please log into all of your characters to compile complete transmog appearance data."]

StaticPopupDialogs["FoxyFarmhelper_NEW_DATABASE"] = {
    text = CREATE_DATABASE_TEXT,
    button1 = L["Okay, I'll go log onto all of my toons!"],
    timeout = 0,
    whileDead = true,
    hideOnEscape = true,
    preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
}


local DATABASE_MIGRATION = "Can I Mog It?" .. "\n\n" .. L["We need to update our database. This may freeze the game for a few seconds."]


function FoxyFarmhelper.CreateMigrationPopup(dialogName, onAcceptFunc)
    StaticPopupDialogs[dialogName] = {
        text = DATABASE_MIGRATION,
        button1 = L["Okay"],
        button2 = L["Ask me later"],
        OnAccept = onAcceptFunc,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,  -- avoid some UI taint, see http://www.wowace.com/announcements/how-to-avoid-some-ui-taint/
    }
    StaticPopup_Show(dialogName)
end


-- OptionsVersion: Keep this as an integer, so comparison is easy.
FoxyFarmhelper_OptionsVersion = "20"


FoxyFarmhelperOptions_Defaults = {
    ["options"] = {
        ["version"] = FoxyFarmhelper_OptionsVersion,
        ["debug"] = false,
        ["databaseDebug"] = false,
        ["showEquippableOnly"] = true,
        ["showTransmoggableOnly"] = true,
        ["showUnknownOnly"] = false,
        ["showSetInfo"] = true,
        ["showItemIconOverlay"] = true,
        ["showVerboseText"] = false,
        ["showSourceLocationTooltip"] = false,
        ["printDatabaseScan"] = true,
        ["iconLocation"] = "TOPRIGHT",
    },
}


FoxyFarmhelperOptions_DisplayData = {
    ["debug"] = {
        ["displayName"] = L["Debug Tooltip"],
        ["description"] = L["Detailed information for debug purposes. Use this when sending bug reports."],
    },
    ["showEquippableOnly"] = {
        ["displayName"] = L["Equippable Items Only"],
        ["description"] = L["Only show on items that can be equipped."]
    },
    ["showTransmoggableOnly"] = {
        ["displayName"] = L["Transmoggable Items Only"],
        ["description"] = L["Only show on items that can be transmoggrified."]
    },
    ["showUnknownOnly"] = {
        ["displayName"] = L["Unknown Items Only"],
        ["description"] = L["Only show on items that you haven't learned."]
    },
    ["showSetInfo"] = {
        ["displayName"] = L["Show Transmog Set Info"],
        ["description"] = L["Show information on the tooltip about transmog sets."] .. "\n\n" .. L["Also shows a summary in the Appearance Sets UI of how many pieces of a transmog set you have collected."]
    },
    ["showItemIconOverlay"] = {
        ["displayName"] = L["Show Bag Icons"],
        ["description"] = L["Shows the icon directly on the item in your bag."]
    },
    ["showVerboseText"] = {
        ["displayName"] = L["Verbose Text"],
        ["description"] = L["Shows a more detailed text for some of the tooltips."]
    },
    ["showSourceLocationTooltip"] = {
        ["displayName"] = L["Show Source Location Tooltip"] .. " " .. FoxyFarmhelper.YELLOW .. L["(Experimental)"],
        ["description"] = L["Shows a tooltip with the source locations of an appearance (ie. Quest, Vendor, World Drop). This only works on items your current class can learn."] .. "\n\n" .. L["Please note that this may not always be correct as Blizzard's information is incomplete."]
    },
    ["printDatabaseScan"] = {
        ["displayName"] = L["Database Scanning chat messages"],
        ["description"] = L["Shows chat messages on login about the database scan."]
    },
    ["iconLocation"] = {
        ["displayName"] = L["Location: "],
        ["description"] = L["Move the icon to a different location on all frames."]
    },
}


FoxyFarmhelper.frame = CreateFrame("Frame", "FoxyFarmhelperOptionsFrame", UIParent);
FoxyFarmhelper.frame.name = "Can I Mog It?";
InterfaceOptions_AddCategory(FoxyFarmhelper.frame);


local EVENTS = {
    "ADDON_LOADED",
    "TRANSMOG_COLLECTION_UPDATED",
    "PLAYER_LOGIN",
    "AUCTION_HOUSE_SHOW",
    "AUCTION_HOUSE_BROWSE_RESULTS_UPDATED",
    "AUCTION_HOUSE_NEW_RESULTS_RECEIVED",
    "GET_ITEM_INFO_RECEIVED",
    "BLACK_MARKET_OPEN",
    "BLACK_MARKET_ITEM_UPDATE",
    "BLACK_MARKET_CLOSE",
    "CHAT_MSG_LOOT",
    "UNIT_INVENTORY_CHANGED",
    "PLAYER_SPECIALIZATION_CHANGED",
    "BAG_UPDATE",
    "BAG_NEW_ITEMS_UPDATED",
    "QUEST_ACCEPTED",
    "BAG_SLOT_FLAGS_UPDATED",
    "BANK_BAG_SLOT_FLAGS_UPDATED",
    "PLAYERBANKSLOTS_CHANGED",
    "BANKFRAME_OPENED",
    "START_LOOT_ROLL",
    "MERCHANT_SHOW",
    "VOID_STORAGE_CONTENTS_UPDATE",
    "GUILDBANKBAGSLOTS_CHANGED",
    "TRANSMOG_COLLECTION_SOURCE_ADDED",
    "TRANSMOG_COLLECTION_SOURCE_REMOVED",
    "TRANSMOG_SEARCH_UPDATED",
    "PLAYERREAGENTBANKSLOTS_CHANGED",
    "LOADING_SCREEN_ENABLED",
    "LOADING_SCREEN_DISABLED",
    "TRADE_SKILL_SHOW",
}

for i, event in pairs(EVENTS) do
    FoxyFarmhelper.frame:RegisterEvent(event);
end


-- Skip the itemOverlayEvents function until the loading screen is disabled.
local lastOverlayEventCheck = 0
local overlayEventCheckThreshold = .01 -- once per frame at 100 fps
local futureOverlayPrepared = false

local function futureOverlay(event)
    -- Updates the overlay in ~THE FUTURE~. If the overlay events had multiple
    -- requests in the same frame, then this gets called.
    futureOverlayPrepared = false
    local currentTime = GetTime()
    if currentTime - lastOverlayEventCheck > overlayEventCheckThreshold then
        lastOverlayEventCheck = currentTime
        FoxyFarmhelper.frame:ItemOverlayEvents(event)
    end
end


FoxyFarmhelper.frame.eventFunctions = {}


function FoxyFarmhelper.frame:AddEventFunction(func)
    -- Adds the func to the list of functions that are called for all events.
    table.insert(FoxyFarmhelper.frame.eventFunctions, func)
end


FoxyFarmhelper.frame:HookScript("OnEvent", function(self, event, ...)
    --[[
        To add functions you want to run with CIMI's "OnEvent", do:

        local function MyOnEventFunc(event, ...)
            Do stuff here
        end
        FoxyFarmhelper.frame:AddEventFunction(MyOnEventFunc)
        ]]

    for i, func in ipairs(FoxyFarmhelper.frame.eventFunctions) do
        func(event, ...)
    end

    -- TODO: Move this to it's own event function.
    -- Prevent the ItemOverlayEvents handler from running more than is needed.
    -- If more than one occur in the same frame, we update the first time, then
    -- prepare a future update in a couple frames.
    local currentTime = GetTime()
    if currentTime - lastOverlayEventCheck > overlayEventCheckThreshold then
        lastOverlayEventCheck = currentTime
        self:ItemOverlayEvents(event, ...)
    else
        -- If we haven't already, plan to update the overlay in the future.
        if not futureOverlayPrepared then
            futureOverlayPrepared = true
            C_Timer.After(.02, function () futureOverlay(event) end)
        end
    end
end)


function FoxyFarmhelper.frame.AddonLoaded(event, addonName)
    if event == "ADDON_LOADED" and addonName == "FoxyFarmhelper" then
        FoxyFarmhelper.frame.Loaded()
    end
end
FoxyFarmhelper.frame:AddEventFunction(FoxyFarmhelper.frame.AddonLoaded)


local changesSavedStack = {}


local function changesSavedText()
    local frame = CreateFrame("Frame", "FoxyFarmhelper_ChangesSaved", FoxyFarmhelper.frame)
    local text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    text:SetJustifyH("RIGHT")
    text:SetText(FoxyFarmhelper.YELLOW .. L["Changes saved!"])

    text:SetAllPoints()

    frame:SetPoint("BOTTOMRIGHT", -20, 10)
    frame:SetSize(200, 20)
    frame:SetShown(false)
    FoxyFarmhelper.frame.changesSavedText = frame
end


local function hideChangesSaved()
    table.remove(changesSavedStack, #changesSavedStack)
    if #changesSavedStack == 0 then
        FoxyFarmhelper.frame.changesSavedText:SetShown(false)
    end
end


local function showChangesSaved()
    FoxyFarmhelper.frame.changesSavedText:SetShown(true)
    table.insert(changesSavedStack, #changesSavedStack + 1)
    C_Timer.After(5, function () hideChangesSaved() end)
end


local function checkboxOnClick(self)
    local checked = self:GetChecked()
    PlaySound(PlaySoundKitID and "igMainMenuOptionCheckBoxOn" or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    self:SetValue(checked)
    showChangesSaved()
    -- Reset the cache when an option changes.
    FoxyFarmhelper:ResetCache()

    FoxyFarmhelper:SendMessage("OptionUpdate")
end


local function debugCheckboxOnClick(self)
    local checked = self:GetChecked()
    PlaySound(PlaySoundKitID and "igMainMenuOptionCheckBoxOn" or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
    self:SetValue(checked)
    showChangesSaved()
    FoxyFarmhelper:SendMessage("OptionUpdate")
end


local function newCheckbox(parent, variableName, onClickFunction)
    -- Creates a new checkbox in the parent frame for the given variable name
    onClickFunction = onClickFunction or checkboxOnClick
    local displayData = FoxyFarmhelperOptions_DisplayData[variableName]
    local checkbox = CreateFrame("CheckButton", "FoxyFarmhelperCheckbox" .. variableName,
            parent, "InterfaceOptionsCheckButtonTemplate")

    -- checkbox.value = FoxyFarmhelperOptions[variableName]

    checkbox.GetValue = function (self)
        return FoxyFarmhelperOptions[variableName]
    end
    checkbox.SetValue = function (self, value) FoxyFarmhelperOptions[variableName] = value end

    checkbox:SetScript("OnClick", onClickFunction)
    checkbox:SetChecked(checkbox:GetValue())

    checkbox.label = _G[checkbox:GetName() .. "Text"]
    checkbox.label:SetText(displayData["displayName"])

    checkbox.tooltipText = displayData["displayName"]
    checkbox.tooltipRequirement = displayData["description"]
    return checkbox
end


local function newRadioGrid(parent, variableName)
    local displayData = FoxyFarmhelperOptions_DisplayData[variableName]
    local frameName = "FoxyFarmhelperCheckGridFrame" .. variableName
    local frame = CreateFrame("Frame", frameName, parent)

    frame.texture = CreateFrame("Frame", frameName .. "_Texture", frame)
    frame.texture:SetSize(58, 58)
    local texture = frame.texture:CreateTexture("CIMITextureFrame", "BACKGROUND")
    texture:SetTexture("Interface/ICONS/INV_Sword_1H_AllianceToy_A_01.blp")
    texture:SetAllPoints()
    texture:SetVertexColor(0.5, 0.5, 0.5)

    local reloadButton = CreateFrame("Button", frameName .. "_ReloadButton",
            frame, "UIPanelButtonTemplate")
    reloadButton:SetText(L["Reload to apply"])
    reloadButton:SetSize(120, 25)
    reloadButton:SetEnabled(false)
    reloadButton:SetScript("OnClick", function () ReloadUI() end)

    local title = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    title:SetText(L["Icon Location"])

    local text = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    text:SetText(L["Does not affect Quests or Adventure Journal."])

    local text2 = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    text2:SetText(L["Default"] .. ": " .. L["Top Right"])

    local radioTopLeft = CreateFrame("CheckButton", frameName .. "_TopLeft",
            frame, "UIRadioButtonTemplate")
    local radioTop = CreateFrame("CheckButton", frameName .. "_Top",
            frame, "UIRadioButtonTemplate")
    local radioTopRight = CreateFrame("CheckButton", frameName .. "_TopRight",
            frame, "UIRadioButtonTemplate")
    local radioLeft = CreateFrame("CheckButton", frameName .. "_Left",
            frame, "UIRadioButtonTemplate")
    local radioCenter = CreateFrame("CheckButton", frameName .. "_Center",
            frame, "UIRadioButtonTemplate")
    local radioRight = CreateFrame("CheckButton", frameName .. "_Right",
            frame, "UIRadioButtonTemplate")
    local radioBottomLeft = CreateFrame("CheckButton", frameName .. "_BottomLeft",
            frame, "UIRadioButtonTemplate")
    local radioBottom = CreateFrame("CheckButton", frameName .. "_Bottom",
            frame, "UIRadioButtonTemplate")
    local radioBottomRight = CreateFrame("CheckButton", frameName .. "_BottomRight",
            frame, "UIRadioButtonTemplate")

    radioTopLeft:SetChecked(FoxyFarmhelperOptions[variableName] == "TOPLEFT")
    radioTop:SetChecked(FoxyFarmhelperOptions[variableName] == "TOP")
    radioTopRight:SetChecked(FoxyFarmhelperOptions[variableName] == "TOPRIGHT")
    radioLeft:SetChecked(FoxyFarmhelperOptions[variableName] == "LEFT")
    radioCenter:SetChecked(FoxyFarmhelperOptions[variableName] == "CENTER")
    radioRight:SetChecked(FoxyFarmhelperOptions[variableName] == "RIGHT")
    radioBottomLeft:SetChecked(FoxyFarmhelperOptions[variableName] == "BOTTOMLEFT")
    radioBottom:SetChecked(FoxyFarmhelperOptions[variableName] == "BOTTOM")
    radioBottomRight:SetChecked(FoxyFarmhelperOptions[variableName] == "BOTTOMRIGHT")

    local allRadios = {
        radioTopLeft,
        radioTop,
        radioTopRight,
        radioLeft,
        radioCenter,
        radioRight,
        radioBottomLeft,
        radioBottom,
        radioBottomRight
    }

    local function createOnRadioClicked (location)
        local function onRadioClicked (self, a, b, c)
            local checked = self:GetChecked()
            PlaySound(PlaySoundKitID and "igMainMenuOptionCheckBoxOn" or SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON)
            FoxyFarmhelperOptions[variableName] = location

            local anyChecked = false
            for _, radio in ipairs(allRadios) do
                if radio ~= self then
                    anyChecked = radio:GetChecked() or anyChecked
                    radio:SetChecked(false)
                end
            end
            if not anyChecked then
                self:SetChecked(true)
            end
            reloadButton:SetEnabled(true)
            showChangesSaved()
        end
        return onRadioClicked
    end

    radioTopLeft:SetScript("OnClick", createOnRadioClicked("TOPLEFT"))
    radioTop:SetScript("OnClick", createOnRadioClicked("TOP"))
    radioTopRight:SetScript("OnClick", createOnRadioClicked("TOPRIGHT"))
    radioLeft:SetScript("OnClick", createOnRadioClicked("LEFT"))
    radioCenter:SetScript("OnClick", createOnRadioClicked("CENTER"))
    radioRight:SetScript("OnClick", createOnRadioClicked("RIGHT"))
    radioBottomLeft:SetScript("OnClick", createOnRadioClicked("BOTTOMLEFT"))
    radioBottom:SetScript("OnClick", createOnRadioClicked("BOTTOM"))
    radioBottomRight:SetScript("OnClick", createOnRadioClicked("BOTTOMRIGHT"))

    title:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, -5)

    radioTopLeft:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -5)
    radioTop:SetPoint("TOPLEFT", radioTopLeft, "TOPRIGHT", 5, 0)
    radioTopRight:SetPoint("TOPLEFT", radioTop, "TOPRIGHT", 5, 0)
    radioLeft:SetPoint("TOPLEFT", radioTopLeft, "BOTTOMLEFT", 0, -5)
    radioCenter:SetPoint("TOPLEFT", radioLeft, "TOPRIGHT", 5, 0)
    radioRight:SetPoint("TOPLEFT", radioCenter, "TOPRIGHT", 5, 0)
    radioBottomLeft:SetPoint("TOPLEFT", radioLeft, "BOTTOMLEFT", 0, -5)
    radioBottom:SetPoint("TOPLEFT", radioBottomLeft, "TOPRIGHT", 5, 0)
    radioBottomRight:SetPoint("TOPLEFT", radioBottom, "TOPRIGHT", 5, 0)

    text:SetPoint("TOPLEFT", radioTopRight, "TOPRIGHT", 14, -3)
    text2:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -3)

    reloadButton:SetPoint("TOPLEFT", text2, "BOTTOMLEFT", 4, -8)

    frame.texture:SetPoint("TOPLEFT", radioTopLeft, "TOPLEFT")

    frame:SetSize(600, 80)

    -- Use this to show the bottom of the frame.
    -- local sample = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    -- sample:SetText("example.")
    -- sample:SetPoint("TOPLEFT", frame, "BOTTOMLEFT")

    return frame
end


local function createOptionsMenu()
    -- define the checkboxes
    FoxyFarmhelper.frame.debug =  newCheckbox(FoxyFarmhelper.frame, "debug", debugCheckboxOnClick)
    FoxyFarmhelper.frame.showEquippableOnly = newCheckbox(FoxyFarmhelper.frame, "showEquippableOnly")
    FoxyFarmhelper.frame.showTransmoggableOnly = newCheckbox(FoxyFarmhelper.frame, "showTransmoggableOnly")
    FoxyFarmhelper.frame.showUnknownOnly = newCheckbox(FoxyFarmhelper.frame, "showUnknownOnly")
    FoxyFarmhelper.frame.showSetInfo = newCheckbox(FoxyFarmhelper.frame, "showSetInfo")
    FoxyFarmhelper.frame.showItemIconOverlay = newCheckbox(FoxyFarmhelper.frame, "showItemIconOverlay")
    FoxyFarmhelper.frame.showVerboseText = newCheckbox(FoxyFarmhelper.frame, "showVerboseText")
    FoxyFarmhelper.frame.showSourceLocationTooltip = newCheckbox(FoxyFarmhelper.frame, "showSourceLocationTooltip")
    FoxyFarmhelper.frame.printDatabaseScan = newCheckbox(FoxyFarmhelper.frame, "printDatabaseScan")
    FoxyFarmhelper.frame.iconLocation = newRadioGrid(FoxyFarmhelper.frame, "iconLocation")

    -- position the checkboxes
    FoxyFarmhelper.frame.debug:SetPoint("TOPLEFT", 16, -16)
    FoxyFarmhelper.frame.showEquippableOnly:SetPoint("TOPLEFT", FoxyFarmhelper.frame.debug, "BOTTOMLEFT")
    FoxyFarmhelper.frame.showTransmoggableOnly:SetPoint("TOPLEFT", FoxyFarmhelper.frame.showEquippableOnly, "BOTTOMLEFT")
    FoxyFarmhelper.frame.showUnknownOnly:SetPoint("TOPLEFT", FoxyFarmhelper.frame.showTransmoggableOnly, "BOTTOMLEFT")
    FoxyFarmhelper.frame.showSetInfo:SetPoint("TOPLEFT", FoxyFarmhelper.frame.showUnknownOnly, "BOTTOMLEFT")
    FoxyFarmhelper.frame.showItemIconOverlay:SetPoint("TOPLEFT", FoxyFarmhelper.frame.showSetInfo, "BOTTOMLEFT")
    FoxyFarmhelper.frame.showVerboseText:SetPoint("TOPLEFT", FoxyFarmhelper.frame.showItemIconOverlay, "BOTTOMLEFT")
    FoxyFarmhelper.frame.showSourceLocationTooltip:SetPoint("TOPLEFT", FoxyFarmhelper.frame.showVerboseText, "BOTTOMLEFT")
    FoxyFarmhelper.frame.printDatabaseScan:SetPoint("TOPLEFT", FoxyFarmhelper.frame.showSourceLocationTooltip, "BOTTOMLEFT")
    FoxyFarmhelper.frame.iconLocation:SetPoint("TOPLEFT", FoxyFarmhelper.frame.printDatabaseScan, "BOTTOMLEFT")

    changesSavedText()
end


function FoxyFarmhelper.frame.Loaded()
    -- Set the Options from defaults.
    if (not FoxyFarmhelperOptions) then
        FoxyFarmhelperOptions = FoxyFarmhelperOptions_Defaults.options
        print(L["FoxyFarmhelperOptions not found, loading defaults!"])
    end
    -- Set missing options from the defaults if the version is out of date.
    if (FoxyFarmhelperOptions["version"] < FoxyFarmhelper_OptionsVersion) then
        local FoxyFarmhelperOptions_temp = FoxyFarmhelperOptions_Defaults.options;
        for k,v in pairs(FoxyFarmhelperOptions) do
            if (FoxyFarmhelperOptions_Defaults.options[k]) then
                FoxyFarmhelperOptions_temp[k] = v;
            end
        end
        FoxyFarmhelperOptions_temp["version"] = FoxyFarmhelper_OptionsVersion;
        FoxyFarmhelperOptions = FoxyFarmhelperOptions_temp;
    end
    createOptionsMenu()
end

FoxyFarmhelper:RegisterChatCommand("cimi", "SlashCommands")
FoxyFarmhelper:RegisterChatCommand("FoxyFarmhelper", "SlashCommands")

local function printHelp()
    FoxyFarmhelper:Print([[
Can I Mog It? help:
    Usage: /cimi <command>
    e.g. /cimi help

    help            Displays this help message.
    debug           Toggles the debug tooltip.
    verbose         Toggles verbose mode on tooltip.
    overlay         Toggles the icon overlay.
    refresh         Refreshes the overlay, forcing a redraw.
    equiponly       Toggles showing overlay on non-equipable items.
    transmogonly    Toggles showing overlay on non-transmogable items.
    unknownonly     Toggles showing overlay on known items.
    count           Shows how many appearances CIMI has recorded.
    printdb         Toggles printing database debug messages when learning apperances.
    PleaseDeleteMyDB    WARNING: Completely deletes the database (for all characters)!
    ]])
end

function FoxyFarmhelper:SlashCommands(input)
    -- Slash command router.
    if input == "" then
        self:OpenOptionsMenu()
    elseif input == 'debug' then
        FoxyFarmhelper.frame.debug:Click()
    elseif input == 'overlay' then
        FoxyFarmhelper.frame.showItemIconOverlay:Click()
    elseif input == 'verbose' then
        FoxyFarmhelper.frame.showVerboseText:Click()
    elseif input == 'equiponly' then
        FoxyFarmhelper.frame.showEquippableOnly:Click()
    elseif input == 'transmogonly' then
        FoxyFarmhelper.frame.showTransmoggableOnly:Click()
    elseif input == 'unknownonly' then
        FoxyFarmhelper.frame.showUnknownOnly:Click()
    elseif input == 'count' then
        self:Print(FoxyFarmhelper.Utils.tablelength(FoxyFarmhelper.db.global.appearances))
    elseif input == 'PleaseDeleteMyDB' then
        self:DBReset()
    elseif input == 'printdb' then
        FoxyFarmhelperOptions['databaseDebug'] = not FoxyFarmhelperOptions['databaseDebug']
        self:Print("Database prints: " .. tostring(FoxyFarmhelperOptions['databaseDebug']))
    elseif input == 'refresh' then
        self:ResetCache()
    elseif input == 'help' then
        printHelp()
    else
        self:Print("Unknown command!")
    end
end

function FoxyFarmhelper:OpenOptionsMenu()
    -- Run it twice, because the first one only opens
    -- the main interface window.
    InterfaceOptionsFrame_OpenToCategory(FoxyFarmhelper.frame)
    InterfaceOptionsFrame_OpenToCategory(FoxyFarmhelper.frame)
end
