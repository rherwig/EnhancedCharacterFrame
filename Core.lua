ECF = LibStub("AceAddon-3.0"):NewAddon("ECF", "AceConsole-3.0");
ItemUpgrade = LibStub("LibItemUpgradeInfo-1.0");

local FONT = "Interface\\AddOns\\EnhancedCharacterFrame\\fonts\\Oswald-Regular.otf";

local slots = {
    HeadSlot = {
        Alignment = "LEFT",
    }, 
    NeckSlot = {
        Alignment = "LEFT",
    }, 
    ShoulderSlot = {
        Alignment = "LEFT",
    }, 
    BackSlot = {
        Alignment = "LEFT",
    }, 
    ChestSlot = {
        Alignment = "LEFT",
    }, 
    ShirtSlot = {
        Alignment = "LEFT",
    },
    TabardSlot = {
        Alignment = "LEFT",
    }, 
    WristSlot = {
        Alignment = "LEFT",
    },
    HandsSlot = {
        Alignment = "RIGHT",
    }, 
    WaistSlot = {
        Alignment = "RIGHT",
    }, 
    LegsSlot = {
        Alignment = "RIGHT",
    }, 
    FeetSlot = {
        Alignment = "RIGHT",
    },
    Finger0Slot = {
        Alignment = "RIGHT",
    }, 
    Finger1Slot = {
        Alignment = "RIGHT",
    }, 
    Trinket0Slot = {
        Alignment = "RIGHT",
    }, 
    Trinket1Slot = {
        Alignment = "RIGHT",
    },
    MainHandSlot = {
        Alignment = "BOTTOM",
    }, 
    SecondaryHandSlot = {
        Alignment = "BOTTOM",
    },
};

local itemInfo = {};

function ECF:OnInitialize()
    hooksecurefunc("PaperDollFrame_SetItemLevel", ECF.SetItemLevel);
end

function ECF:SetItemLevel(frame, player)
    local avgItemLevel, avgItemLevelEquipped = GetAverageItemLevel();
    local itemLevelString = (floor(avgItemLevelEquipped * 100) / 100).." / "..(floor(avgItemLevel * 100) / 100);
    PaperDollFrame_SetLabelAndText(CharacterStatsPane.ItemLevelFrame, STAT_AVERAGE_ITEM_LEVEL, itemLevelString, false, itemLevelString);

    CharacterStatsPane.ItemLevelFrame.Value:SetFont(FONT, 12);

    ECF:PopulateItemInfo();        
    ECF:RenderItemInfo();
end

function ECF:PopulateItemInfo()
    for slot, info in pairs(slots) do 
        if (itemInfo[slot] == nil or itemInfo[slot].ItemLevel == nil) then
            local ilvl, quality = ECF:GetItemInfo(slot);        
            itemInfo[slot] = {
                ItemLevel = ilvl,
                Quality = quality,
                Alignment = info.Alignment,
                IsRendered = false,
            };
        end
    end
end

function ECF:RenderItemInfo()
    for slot, info in pairs(itemInfo) do
        if (info.ItemLevel ~= nil and info.ItemLevel ~= 1 and info.IsRendered == false) then
            itemInfo[slot].IsRendered = true;

            if info.Alignment == "LEFT" then
                ECF[slot] = CreateFrame("Frame", nil, PaperDollItemsFrame, "ECF_ItemInfoLeftTemplate");        
                ECF[slot]:SetPoint("TOPLEFT", "Character"..slot, "TOPRIGHT", 7, -1);
                ECF[slot]:SetPoint("BOTTOMLEFT", "Character"..slot, "BOTTOMRIGHT", 7, 0);
            elseif info.Alignment == "RIGHT" then
                ECF[slot] = CreateFrame("Frame", nil, PaperDollItemsFrame, "ECF_ItemInfoRightTemplate");        
                ECF[slot]:SetPoint("TOPRIGHT", "Character"..slot, "TOPLEFT", -8, -1);
                ECF[slot]:SetPoint("BOTTOMRIGHT", "Character"..slot, "BOTTOMLEFT", -8, 0);
            else
                ECF[slot] = CreateFrame("Frame", nil, PaperDollItemsFrame, "ECF_ItemInfoWeaponTemplate");
                ECF[slot]:SetPoint("BOTTOMLEFT", "Character"..slot, "TOPLEFT", 1, 0);
                ECF[slot]:SetPoint("BOTTOMRIGHT", "Character"..slot, "TOPRIGHT", 1, 0);
            end

            ECF[slot].text:SetText(info.ItemLevel);
            ECF[slot].text:SetTextColor(GetItemQualityColor(info.Quality));
            ECF[slot]:Show();
        end
    end
end

function ECF:GetItemInfo(slot)
    local slotId, _, _ = GetInventorySlotInfo(slot);
    local itemLink = GetInventoryItemLink("player", slotId);

    if itemLink == nil then
        return nil;
    end

    local _, _, rarity = GetItemInfo(itemLink);
    local itemLevel = ItemUpgrade:GetUpgradedItemLevel(itemLink);

    return itemLevel, rarity;
end
