local AddOn = {}
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:SetScript("OnEvent", function(self, event)

    if event == "PLAYER_ENTERING_WORLD" and true then
        local model = {}
        model.FRAMEHEIGHT = 400
        model.FRAMEWIDTH = model.FRAMEHEIGHT*2.5/3
        model.ROTATION = 0.3
        model.MODELSCALE = 200/model.FRAMEHEIGHT
        local SHUD_PLAYERMODEL = {}
        SHUD_PLAYERMODEL.parent = UIParent
        if (IsAddOnLoaded("ElvUI")) then
            do SHUD_PLAYERMODEL.parent = ElvUF_Player
        end
        SHUD_PLAYERMODEL.frame = CreateFrame("DressUpModel", "SHUD_PLAYERMODEL", SHUD_PLAYERMODEL.parent)
        SHUD_PLAYERMODEL.frame:SetPoint("BOTTOMRIGHT")
        SHUD_PLAYERMODEL.frame:SetHeight(model.FRAMEHEIGHT)
        SHUD_PLAYERMODEL.frame:SetWidth(model.FRAMEWIDTH)
        SHUD_PLAYERMODEL.frame:SetUnit("PLAYER")
        SHUD_PLAYERMODEL.frame:Dress()
        SHUD_PLAYERMODEL.frame:SetModelScale(model.MODELSCALE)
        SHUD_PLAYERMODEL.frame:SetRotation(model.ROTATION)
        SHUD_PLAYERMODEL.frame:Show()
        --SHUD_PLAYERMODEL:SetLight(true, false, 0, -0.707, -0.707, 0.7, 1.0, 1.0, 1.0, 0.8, 1.0, 1.0, 0.8);
        SHUD_PLAYERMODEL:RegisterEvent("UNIT_INVENTORY_CHANGED")
        SHUD_PLAYERMODEL:RegisterEvent("PLAYER_ENTER_WORLD")
        SHUD_PLAYERMODEL:SetScript("OnEvent", function(self,event, ...)
            AddOn.refreshModel(SHUD_PLAYERMODEL.frame)
        end)
--[[ 
        local targetdressupmodel = CreateFrame("DressUpModel", nil, UIParent)
        targetdressupmodel:SetPoint("CENTER",400,-200)
        targetdressupmodel:SetHeight(model.FRAMEHEIGHT)
        targetdressupmodel:SetWidth(model.FRAMEWIDTH)
        targetdressupmodel:SetModelScale(model.MODELSCALE)
        targetdressupmodel:SetRotation(- model.ROTATION)
        targetdressupmodel:RegisterEvent("PLAYER_TARGET_CHANGED")

        local targetplayermodel = CreateFrame("PlayerModel", nil, UIParent)
        targetplayermodel:SetPoint("CENTER",400,-200)
        targetplayermodel:SetHeight(model.FRAMEHEIGHT)
        targetplayermodel:SetWidth(model.FRAMEWIDTH)
        targetplayermodel:SetRotation(- model.ROTATION)
        targetplayermodel:SetModelScale(model.MODELSCALE)
        targetplayermodel:RegisterEvent("PLAYER_TARGET_CHANGED")
        targetplayermodel:SetScript("OnEvent", function(self,event, ...)

            if UnitExists("TARGET") then
                if UnitIsPlayer("TARGET") then
                    targetdressupmodel:Show()
                    targetdressupmodel:SetUnit("TARGET")
                    targetdressupmodel:SetModelScale(model.MODELSCALE/2)
                    targetplayermodel:Hide()
                else
                    targetdressupmodel:Hide()
                    targetplayermodel:SetUnit("TARGET")
                    targetplayermodel:Show()
                    targetplayermodel:SetModelScale(model.MODELSCALE/2)
                end
            else
                targetplayermodel:Hide()
                targetdressupmodel:Hide()
            end
        end) ]]
    end
end)

AddOn.delayframe = CreateFrame("Frame")
AddOn.delayframe:SetScript("OnUpdate", function(self)
    if AddOn.scheduled then
        if (AddOn.timeAtStart + 0.1) < GetTime() then
            model:RefreshUnit()
            model:SetModelScale(model.MODELSCALE)
            AddOn.scheduled = false
        end
    end
end)
function AddOn.refreshModel(model)
    AddOn.scheduled = true
    AddOn.timeAtStart = GetTime()
end
function AddOn.printArgs(...)
    local args = ...
    local str = ""
    for i = 1, select("#",args) do
        if select(i,args) then
            str = str.."   "..i.." = "..select(i,args)
        end
    end
    DEFAULT_CHAT_FRAME:AddMessage(str)
end