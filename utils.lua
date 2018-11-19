ShamanHUD = {}
ShamanHUD_GameTooltip = CreateFrame("GAMETOOLTIP", "WFTtooltip", nil, "GameTooltipTemplate")
ShamanHUD_GameTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")

local function ReadRegions(...)
    local result = {}
    for i = 1, select("#", ...) do
        local region = select(i, ...)
        if region and region:GetObjectType() == "FontString" then
            local text = region:GetText() -- string or nil
            if text and strlen(text) > 0 then 
                tinsert(result, text)
            end
        end
    end
    return result
end

function ShamanHUD_GetTooltipLines(link, debug)
    if not link then return end
    local result = {}
    local t = ShamanHUD_GameTooltip
    t:ClearLines()
    t:SetHyperlink(link)
    return ReadRegions(t:GetRegions())
end