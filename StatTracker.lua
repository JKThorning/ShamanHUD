local StatTracker = CreateFrame("FRAME", "SHUD_StatTracker", UIParent)
StatTracker.o = "o"
local o
local FRAME_STATTRACKER_EDGESIZE = 3
local STAT_BAR_WIDTH = 25
local STAT_BAR_HEIGHT = 130
local STAT_BAR_OFFSET = 2

local BOLD_FONT = "Interface\\Addons\\ShamanHUD\\Media\\BF.ttf"
local TEXTURE_BAR = "Interface\\Addons\\ShamanHUD\\Media\\Bar.tga"
local FRAME_BACKDROP = ({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
edgeFile = nil, 
tile = true, tileSize = 16, edgeSize = 16, 
insets = { left = 0, right = 0, top = 0, bottom = 0 }})
local stats = {
	["Attack Power"] = {
		["short"] = "AP",
		["EP"] = 1,
		["call"] = function() return select(2,UnitAttackPower("player")) end,
		["color"] = {173,255,47},
		["nr"] = 1
	},
	["Strength"] = {
		["short"] = "STR",
		["EP"] = 2.2,
		["call"] = function() return  select(3,UnitStat("PLAYER", 1)) end,
		["color"] = {139,69,19},
		["nr"] = 2
	},
	["Agility"] = {
		["short"] = "AGI",
		["EP"] = 1.89,
		["call"] = function() return select(3,UnitStat("PLAYER", 2)) end,
		["color"] = {15,128,15},
		["nr"] = 3
	},
	["Crit Rating"] = {
		["short"] = "CRT",
		["EP"] = 1.94,
		["call"] = function() return floor(GetCombatRatingBonus(9)*22.077) end,
		["color"] = {255, 255, 0},
		["nr"] = 4
	},
	["Haste Rating"] = {
		["short"] = "HST",
		["EP"] = 1.98,
		["call"] = function() return floor(GetCombatRatingBonus(18)*15.77) end,
		["color"] = {255, 127, 80},
		["nr"] = 5
	},
	["Hit Rating"] = {
		["short"] = "HIT",
		["EP"] = 1.8,
		["call"] = function() return floor(GetCombatRatingBonus(6)*15.77) end,
		["color"] = {255, 255, 224},
		["nr"] = 6
	},
	["Armor Penetration"] = {
		["short"] = "ARP",
		["EP"] = 0.41,
		["call"] = function() return GetArmorPenetration() end,
		["color"] = {169,169,169},
		["nr"] = 7
	},
	["Expertise Rating"] = {
		["short"] = "EXP",
		["EP"] = 3.53,
		["call"] = function() return floor(GetCombatRatingBonus(24))*4 end,
		["color"] = {233,150,122},
		["nr"] = 8
	}
}

-- functions
local function printArgs(...)
	local nArgs = select("#", ...)
	local str = ""
	for i = 1,nArgs do
		local arg = select(i, ...)
		if arg then
			str = str .." " ..i .. " = "..arg
		end
	end
	print(str)
end

local function tableHasKey(table,key)
    return table[key] ~= nil
end
local function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

local function addEvent(eventTable, event, eventFunc, isFrame)
    if type(event) == "string" and type(eventFunc) == "function" and type(eventTable) == "table" then
        eventTable[event] = eventFunc
        if isFrame then
            eventTable:RegisterEvent(event)
            print(event.." added to "..eventTable:GetName().."\n")
        end
        return true
    end
    return false
end

local function addEventWatcher(frame)
	frame:SetScript("OnEvent", function(self, event, ...) 
		print(self:GetName().. ": "..event)
		if tableHasKey(self,event) then
			self[event](self,event,...) 
		end
	end)
end
addEventWatcher(StatTracker)

local function updateStats()
	local maxEPVal = 0
	local totalEP = 0
	for k,v in pairs(stats) do
		v.value = v.call()
		maxEPVal = (v.EP*v.value > maxEPVal) and v.value or maxEPVal
	end
	print(maxEPVal)
	for k,v in pairs(stats) do
		print(k.." = "..v.EP*v.value)
		local s = StatTracker[k]
		print(s:GetName())
		s:SetMinMaxValues(0,maxEPVal)
		s:SetValue(v.value*v.EP)
		totalEP = totalEP + v.value*v.EP
		s.highlight:SetText(k.."\nEP: "..v.value*v.EP.."\nValue: "..v.value)
		local valuetext = ""
		for i = 1,strlen(v.value) do
			valuetext = valuetext .. "\n"..strsub(v.value,i,i)
		end
		s.valuetext:SetText(valuetext)
	end
	StatTracker.toptext:SetText("Total EP: "..totalEP)
end	

local StatTracker_OnLoad = function(self, event)
	self:UnregisterEvent("VARIABLES_LOADED")
	updateStats()
	o = ST_SV
	print("StatTracker var loaded")
end

local StatTracker_OnUnitStats = function(self, event, ...)
	updateStats()	
end
local StatTracker_OnUnitAura = function(self, event, ...)
	if ... == "player" then
		updateStats()
	end
end
local StatTracker_OnInventoryChanged = function(self, event, ...)
	if ... == "player" then
		updateStats()
	end
end
addEvent(StatTracker, "VARIABLES_LOADED", StatTracker_OnLoad, true)
addEvent(StatTracker, "UNIT_STATS", StatTracker_OnUnitStats, true)
addEvent(StatTracker, "UNIT_AURA", StatTracker_OnUnitAura, true)
addEvent(StatTracker, "UNIT_INVENTORY_CHANGED", StatTracker_OnInventoryChanged, true)

StatTracker:SetPoint("LEFT", 35, -5)
StatTracker:EnableMouse(true)
StatTracker:SetMovable(true)
StatTracker:RegisterForDrag("LeftButton")
StatTracker:IsUserPlaced(true)
StatTracker:SetScript("OnDragStart", StatTracker.StartMoving)
StatTracker:SetScript("OnDragStop", StatTracker.StopMovingOrSizing)
StatTracker:SetWidth(2*FRAME_STATTRACKER_EDGESIZE+tablelength(stats)*STAT_BAR_WIDTH)
StatTracker:SetHeight(8*FRAME_STATTRACKER_EDGESIZE+STAT_BAR_HEIGHT)
StatTracker:SetBackdrop(FRAME_BACKDROP)
StatTracker:SetBackdropColor(0.5,0.5,0.5,1)
StatTracker.toptext = StatTracker:CreateFontString(StatTracker:GetName().."_title", "OVERLAY", GameFontNormal)
StatTracker.toptext:SetFont(BOLD_FONT, 12)
StatTracker.toptext:SetPoint("TOP", StatTracker, "TOP", 0, -2)
StatTracker.toptext:SetText("ShamanHUD StatTracker")
for k,v in pairs(stats) do
	local f = CreateFrame("StatusBar", StatTracker:GetName()..v.short, StatTracker)
	f:SetPoint("BOTTOMLEFT", f:GetParent(), "BOTTOMLEFT", FRAME_STATTRACKER_EDGESIZE+(STAT_BAR_WIDTH)*(v.nr - 1), 3)
	f:SetWidth(STAT_BAR_WIDTH)
	f:SetHeight(STAT_BAR_HEIGHT)
	f:SetOrientation("VERTICAL")
	f:SetMinMaxValues(0,100)
	f:EnableMouse(true)
	local r,g,b = unpack(v.color)
	f:SetStatusBarTexture(TEXTURE_BAR)
	f:SetStatusBarColor(r/255, g/255, b/255,0.5)
	f.title = f:CreateFontString(f:GetName().."_title", "OVERLAY", GameFontNormal)
	f.title:SetFont(BOLD_FONT, 10)
	f.title:SetPoint("TOP", f, "TOP", 0, -2)
	f.title:SetText(v.short)
	f.highlight = f:CreateFontString(f:GetName().."_highlight", "HIGHLIGHT", GameFontNormal)
	f.highlight:SetFont(BOLD_FONT, 16, "THINOUTLINE")
	f.highlight:SetPoint("BOTTOM", f, "BOTTOM", 0, 10)
	f.highlight:SetText(v.short)
	f.valuetext = f:CreateFontString(f:GetName().."_valuetext", "OVERLAY", GameFontNormal)
	f.valuetext:SetFont(BOLD_FONT, 14, "THINOUTLINE")
	f.valuetext:SetPoint("BOTTOM", f, "BOTTOM", 0, FRAME_STATTRACKER_EDGESIZE)
	f.valuetext:SetText(v.short)
	StatTracker[k] = f
end

print("StatTracker script end")
