FoxyFarmhelper.cache = {}

function FoxyFarmhelper.cache:Clear()
    self.data = {
        ["text"] = {},
        ["source"] = {},
        ["dressup_source"] = {},
        ["sets"] = {},
        ["setsSumRatio"] = {},
    }
end


local function GetSourceIDKey(sourceID)
    return "source:" .. sourceID
end


local function GetItemIDKey(itemID)
    return "item:" .. itemID
end


local function GetItemLinkKey(itemLink)
    return "itemlink:" .. itemLink
end


local function CalculateCacheKey(itemLink)
    local sourceID = FoxyFarmhelper:GetSourceID(itemLink)
    local itemID = FoxyFarmhelper:GetItemID(itemLink)
    local key;
    if sourceID then
        key = GetSourceIDKey(sourceID)
    elseif itemID then
        key = GetItemIDKey(itemID)
    else
        key = GetItemLinkKey(itemLink)
    end
    return key
end


function FoxyFarmhelper.cache:GetItemTextValue(itemLink)
    return self.data["text"][CalculateCacheKey(itemLink)]
end


function FoxyFarmhelper.cache:SetItemTextValue(itemLink, value)
    self.data["text"][CalculateCacheKey(itemLink)] = value
end


function FoxyFarmhelper.cache:RemoveItem(itemLink)
    self.data["text"][CalculateCacheKey(itemLink)] = nil
    self.data["source"][CalculateCacheKey(itemLink)] = nil
    -- Have to remove all of the set data, since other itemLinks may cache
    -- the same set information. Alternatively, we scan through and find
    -- the same set on other items, but they're loaded on mouseover anyway,
    -- so it shouldn't be slow. Also applies to RemoveItemBySourceID.
    self:ClearSetData()
end


function FoxyFarmhelper.cache:RemoveItemBySourceID(sourceID)
    self.data["text"][GetSourceIDKey(sourceID)] = nil
    self.data["source"][GetSourceIDKey(sourceID)] = nil
    self:ClearSetData()
end


function FoxyFarmhelper.cache:GetItemSourcesValue(itemLink)
    return self.data["source"][CalculateCacheKey(itemLink)]
end


function FoxyFarmhelper.cache:SetItemSourcesValue(itemLink, value)
    self.data["source"][CalculateCacheKey(itemLink)] = value
end


function FoxyFarmhelper.cache:GetSetsInfoTextValue(itemLink)
    return self.data["sets"][CalculateCacheKey(itemLink)]
end


function FoxyFarmhelper.cache:SetSetsInfoTextValue(itemLink, value)
    self.data["sets"][CalculateCacheKey(itemLink)] = value
end


function FoxyFarmhelper.cache:GetDressUpModelSource(itemLink)
    return self.data["dressup_source"][itemLink]
end

function FoxyFarmhelper.cache:SetDressUpModelSource(itemLink, value)
    self.data["dressup_source"][itemLink] = value
end


function FoxyFarmhelper.cache:ClearSetData()
    self.data["sets"] = {}
    self.data["setsSumRatio"] = {}
end


function FoxyFarmhelper.cache:GetSetsSumRatioTextValue(key)
    return self.data["setsSumRatio"][key]
end


function FoxyFarmhelper.cache:SetSetsSumRatioTextValue(key, value)
    self.data["setsSumRatio"][key] = value
end


FoxyFarmhelper.cache:Clear()
