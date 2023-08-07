-----------------------------
-- Adding to tooltip       --
-----------------------------

local function addDoubleLine(tooltip, left_text, right_text)
    tooltip:AddDoubleLine(left_text, right_text)
    tooltip:Show()
end


local function addLine(tooltip, text)
    tooltip:AddLine(text, nil, nil, nil, true)
    tooltip:Show()
end


-----------------------------
-- Debug functions         --
-----------------------------


local function printDebug(tooltip, itemLink, bag, slot)
    -- Add debug statements to the tooltip, to make it easier to understand
    -- what may be going wrong.

    addLine(tooltip, '--------')

    addDoubleLine(tooltip, "Addon Version:", GetAddOnMetadata("FoxyFarmhelper", "Version"))
    local playerClass = select(2, UnitClass("player"))
    local playerLevel = UnitLevel("player")
    local playerSpec = GetSpecialization()
    local playerSpecName = playerSpec and select(2, GetSpecializationInfo(playerSpec)) or "None"
    addDoubleLine(tooltip, "Player Class:", playerClass)
    addDoubleLine(tooltip, "Player Spec:", playerSpecName)
    addDoubleLine(tooltip, "Player Level:", playerLevel)

    addLine(tooltip, '--------')

    local itemID = FoxyFarmhelper:GetItemID(itemLink)
    addDoubleLine(tooltip, "Item ID:", tostring(itemID))
    if not itemID then
        -- Keystones don't have an itemID...
        addLine(tooltip, 'No ItemID found. Is this a Keystone or Battle Pet?')
        return
    end
    local _, _, quality, _, _, itemClass, itemSubClass, _, equipSlot, _, _, _, _, _, expansion = GetItemInfo(itemID)
    addDoubleLine(tooltip, "Item quality:", tostring(quality))
    addDoubleLine(tooltip, "Item class:", tostring(itemClass))
    addDoubleLine(tooltip, "Item subClass:", tostring(itemSubClass))
    addDoubleLine(tooltip, "Item equipSlot:", tostring(equipSlot))
    addDoubleLine(tooltip, "Item expansion:", tostring(expansion or "nil"))

    local sourceID, sourceIDSource = FoxyFarmhelper:GetSourceID(itemLink)
    addDoubleLine(tooltip, "Item sourceID:", tostring(sourceID))
    addDoubleLine(tooltip, "Item sourceIDSource:", tostring(sourceIDSource))
    local appearanceID = FoxyFarmhelper:GetAppearanceID(itemLink)
    addDoubleLine(tooltip, "Item appearanceID:", tostring(appearanceID))

    local setID = FoxyFarmhelper:SetsDBGetSetFromSourceID(sourceID) or "nil"
    addDoubleLine(tooltip, "Item setID:", tostring(setID))

    local baseSetID = setID ~= nil and setID ~= "nil" and C_TransmogSets.GetBaseSetID(setID) or "nil"
    addDoubleLine(tooltip, "Item baseSetID:", tostring(setID))

    addLine(tooltip, '--------')

    if sourceID then
        local playerCanCollectIsReady = select(1, C_TransmogCollection.PlayerCanCollectSource(sourceID))
        if playerCanCollectIsReady ~= nil then
            addDoubleLine(tooltip, "BLIZZ PlayerCanCollectSource_1_IsReady:", tostring(playerCanCollectIsReady))
        end
    end

    if sourceID then
        local playerCanCollect = select(2, C_TransmogCollection.PlayerCanCollectSource(sourceID))
        if playerCanCollect ~= nil then
            addDoubleLine(tooltip, "BLIZZ PlayerCanCollectSource_2_CanCollect:", tostring(playerCanCollect))
        end
    end

    addLine(tooltip, '--------')

    local playerHasTransmog = C_TransmogCollection.PlayerHasTransmog(itemID)
    if playerHasTransmog ~= nil then
        addDoubleLine(tooltip, "BLIZZ PlayerHasTransmog:", tostring(playerHasTransmog))
    end

    if sourceID then
        local playerHasTransmogItem = C_TransmogCollection.PlayerHasTransmogItemModifiedAppearance(sourceID)
        if playerHasTransmogItem ~= nil then
            addDoubleLine(tooltip, "BLIZZ PlayerHasTransmogItemModifiedAppearance:", tostring(playerHasTransmogItem))
        end
    end

    addLine(tooltip, '--------')

    addDoubleLine(tooltip, "IsTransmogable:", tostring(FoxyFarmhelper:IsTransmogable(itemLink)))
    local playerKnowsTransmogFromItem = FoxyFarmhelper:PlayerKnowsTransmogFromItem(itemLink)
    if playerKnowsTransmogFromItem ~= nil then
        addDoubleLine(tooltip, "PlayerKnowsTransmogFromItem:", tostring(playerKnowsTransmogFromItem))
    end

    local playerKnowsTrasmog = FoxyFarmhelper:_PlayerKnowsTransmog(itemLink, appearanceID)
    if playerKnowsTrasmog ~= nil then
        addDoubleLine(tooltip, "PlayerKnowsTransmog:", tostring(playerKnowsTrasmog))
    end
    local characterCanLearnTransmog = FoxyFarmhelper:CharacterCanLearnTransmog(itemLink)
    if characterCanLearnTransmog ~= nil then
        addDoubleLine(tooltip, "CharacterCanLearnTransmog:", tostring(characterCanLearnTransmog))
    end

    addLine(tooltip, '--------')

    addDoubleLine(tooltip, "IsItemSoulbound:", tostring(FoxyFarmhelper:IsItemSoulbound(itemLink, bag, slot)))
    addDoubleLine(tooltip, "CharacterCanEquipItem:", tostring(FoxyFarmhelper:CharacterCanEquipItem(itemLink)))
    addDoubleLine(tooltip, "IsValidAppearanceForCharacter:", tostring(FoxyFarmhelper:IsValidAppearanceForCharacter(itemLink)))
    addDoubleLine(tooltip, "CharacterIsHighEnoughLevelForTransmog:", tostring(FoxyFarmhelper:CharacterIsHighEnoughLevelForTransmog(itemLink)))

    local classesRequired = CIMIScanTooltip:GetClassesRequired(itemLink)
    if classesRequired ~= nil then
        addDoubleLine(tooltip, "Required Classes:", tostring(table.concat(classesRequired, ", ") ))
    else
        addDoubleLine(tooltip, "Required Classes:", 'nil')
    end

    addLine(tooltip, '--------')

    if appearanceID ~= nil then
        addDoubleLine(tooltip, "DBHasAppearance:", tostring(FoxyFarmhelper:DBHasAppearance(appearanceID, itemLink)))
    else
        addDoubleLine(tooltip, "DBHasAppearance:", 'nil')
    end

    local requirements = FoxyFarmhelper.Requirements:GetRequirements()
    if appearanceID ~= nil then
        addDoubleLine(tooltip, "DBHasAppearanceForRequirements:", tostring(FoxyFarmhelper:DBHasAppearanceForRequirements(appearanceID, itemLink, requirements)))
    else
        addDoubleLine(tooltip, "DBHasAppearanceForRequirements:", 'nil')
    end

    if appearanceID ~= nil and sourceID ~= nil then
        addDoubleLine(tooltip, "DBHasSource:", tostring(FoxyFarmhelper:DBHasSource(appearanceID, sourceID, itemLink)))
    else
        addDoubleLine(tooltip, "DBHasSource:", 'nil')
    end
    if FoxyFarmhelper:DBHasItem(itemLink) ~= nil then
        addDoubleLine(tooltip, "DBHasItem:", tostring(FoxyFarmhelper:DBHasItem(itemLink)))
    else
        addDoubleLine(tooltip, "DBHasItem:", 'nil')
    end

    addLine(tooltip, '--------')

    addDoubleLine(tooltip, "Tooltip:", tostring(FoxyFarmhelper:CalculateTooltipText(itemLink, bag, slot)))

    addLine(tooltip, '--------')

end


-----------------------------
-- Tooltip hooks           --
-----------------------------

local itemLinks = {}

local function addToTooltip(tooltip, itemLink, bag, slot)
    -- Does the calculations for determining what text to
    -- display on the tooltip.
    if tooltip.CIMI_tooltipWritten then return end
    if not itemLink then return end
    if not FoxyFarmhelper:IsReadyForCalculations(itemLink) then
        return
    end

    if FoxyFarmhelperOptions["debug"] then
        printDebug(tooltip, itemLink, bag, slot)
        tooltip.CIMI_tooltipWritten = true
    end

    -- If it's a battlepet, then don't add any lines. Battle Pet uses a
    -- different tooltip frame than normal.
    local isBattlepet = string.match(itemLink, ".*(battlepet):.*") == "battlepet"
    if isBattlepet then
        tooltip.CIMI_tooltipWritten = true
        return
    end

    local text;
    text = FoxyFarmhelper:GetTooltipText(itemLink, bag, slot)
    if text and text ~= "" then
        addDoubleLine(tooltip, " ", text)
        tooltip.CIMI_tooltipWritten = true
    end

    if FoxyFarmhelperOptions["showSetInfo"] then
        local setFirstLineText, setSecondLineText = FoxyFarmhelper:GetSetsText(itemLink)
        if setFirstLineText and setFirstLineText ~= "" then
            addDoubleLine(tooltip, " ", setFirstLineText)
            tooltip.CIMI_tooltipWritten = true
        end
        if setSecondLineText and setSecondLineText ~= "" then
            addDoubleLine(tooltip, " ", setSecondLineText)
            tooltip.CIMI_tooltipWritten = true
        end
    end

    if FoxyFarmhelperOptions["showSourceLocationTooltip"] then
        local sourceTypesText = FoxyFarmhelper:GetSourceLocationText(itemLink)
        if sourceTypesText and sourceTypesText ~= "" then
            addDoubleLine(tooltip, " ", sourceTypesText)
            tooltip.CIMI_tooltipWritten = true
        end
    end
end


-- Enable this to get a very verbose debug message for every tooltip
-- change that occurs.
local VVDebug = false

function VVDebugPrint(tooltip, event)
    if VVDebug then
        FoxyFarmhelper:Print(tooltip:GetName(), event)
    end
end


local function TooltipCleared(tooltip)
    -- Clears the tooltipWritten flag once the tooltip is done rendering.
    tooltip.CIMI_tooltipWritten = false
    VVDebugPrint(tooltip, "OnTooltipCleared")
end


GameTooltip:HookScript("OnTooltipCleared", TooltipCleared)
ItemRefTooltip:HookScript("OnTooltipCleared", TooltipCleared)
ItemRefShoppingTooltip1:HookScript("OnTooltipCleared", TooltipCleared)
ItemRefShoppingTooltip2:HookScript("OnTooltipCleared", TooltipCleared)
ShoppingTooltip1:HookScript("OnTooltipCleared", TooltipCleared)
ShoppingTooltip2:HookScript("OnTooltipCleared", TooltipCleared)
GameTooltip.ItemTooltip.Tooltip:HookScript("OnTooltipCleared", TooltipCleared)


local function FoxyFarmhelper_AttachItemTooltip(tooltip)
    -- Hook for normal tooltips.
    if tooltip.GetItem == nil then return end
    local link = select(2, tooltip:GetItem())
    if link then
        addToTooltip(tooltip, link)
        VVDebugPrint(tooltip, "OnTooltipSetItem")
    end
end


TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, FoxyFarmhelper_AttachItemTooltip)


hooksecurefunc(GameTooltip, "SetMerchantItem",
    function(tooltip, index)
        addToTooltip(tooltip, GetMerchantItemLink(index))
        VVDebugPrint(tooltip, "SetMerchantItem")
    end
)


hooksecurefunc(GameTooltip, "SetBuybackItem",
    function(tooltip, index)
        addToTooltip(tooltip, GetBuybackItemLink(index))
        VVDebugPrint(tooltip, "SetBuybackItem")
    end
)


hooksecurefunc(GameTooltip, "SetBagItem",
    function(tooltip, bag, slot)
        addToTooltip(tooltip, C_Container.GetContainerItemLink(bag, slot), bag, slot)
        VVDebugPrint(tooltip, "SetBagItem")
    end
)


hooksecurefunc(GameTooltip, "SetLootItem",
    function(tooltip, slot)
        if LootSlotHasItem(slot) then
            local link = GetLootSlotLink(slot)
            addToTooltip(tooltip, link)
            VVDebugPrint(tooltip, "SetLootItem")
        end
    end
)


hooksecurefunc(GameTooltip, "SetLootRollItem",
    function(tooltip, slot)
        addToTooltip(tooltip, GetLootRollItemLink(slot))
        VVDebugPrint(tooltip, "SetLootRollItem")
    end
)


hooksecurefunc(GameTooltip, "SetInventoryItem",
    function(tooltip, unit, slot)
        addToTooltip(tooltip, GetInventoryItemLink(unit, slot))
        VVDebugPrint(tooltip, "SetInventoryItem")
    end
)


hooksecurefunc(GameTooltip, "SetGuildBankItem",
    function(tooltip, tab, slot)
        addToTooltip(tooltip, GetGuildBankItemLink(tab, slot))
        VVDebugPrint(tooltip, "SetGuildBankItem")
    end
)


-- TODO DF: Make sure this hook in still needed. The crafting system got reworked.
-- hooksecurefunc(GameTooltip, "SetRecipeReagentItem",
--     function(tooltip, itemID, index)
--         addToTooltip(tooltip, C_TradeSkillUI.GetRecipeReagentItemLink(itemID, index))
--         VVDebugPrint(tooltip, "SetRecipeReagentItem")
--     end
-- )


hooksecurefunc(GameTooltip, "SetTradeTargetItem",
    function(tooltip, index)
        addToTooltip(tooltip, GetTradeTargetItemLink(index))
        VVDebugPrint(tooltip, "SetTradeTargetItem")
    end
)


hooksecurefunc(GameTooltip, "SetQuestLogItem",
    function(tooltip, type, index)
        addToTooltip(tooltip, GetQuestLogItemLink(type, index))
        VVDebugPrint(tooltip, "SetQuestLogItem")
    end
)


hooksecurefunc(GameTooltip, "SetInboxItem",
    function(tooltip, mailIndex, attachmentIndex)
        addToTooltip(tooltip, GetInboxItemLink(mailIndex, attachmentIndex or 1))
        VVDebugPrint(tooltip, "SetInboxItem")
    end
)


hooksecurefunc(GameTooltip, "SetSendMailItem",
    function(tooltip, index)
        local name = GetSendMailItem(index)
        local _, link = GetItemInfo(name)
        addToTooltip(tooltip, link)
        VVDebugPrint(tooltip, "SetSendMailItem")
    end
)


local function OnSetHyperlink(tooltip, link)
    local type, id = string.match(link, ".*(item):(%d+).*")
    if not type or not id then return end
    if type == "item" then
        addToTooltip(tooltip, link)
        VVDebugPrint(tooltip, "SetHyperlink")
    end
end


hooksecurefunc(GameTooltip, "SetHyperlink", OnSetHyperlink)
