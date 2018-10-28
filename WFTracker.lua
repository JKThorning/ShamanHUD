local WFT = {}

local GetTime = GetTime
local UnitMana = UnitMana
local UnitManaMax = UnitManaMax
local GetTotemInfo = GetTotemInfo

function WFT.SlashCmdList_AddSlashCommand(name, func, ...)
    SlashCmdList[name] = func
    local command = ''
    for i = 1, select('#', ...) do
        command = select(i, ...)
        if strsub(command, 1, 1) ~= '/' then
            command = '/' .. command
        end
        _G['SLASH_'..name..i] = command
    end
end

local function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
end

function WFT.print( msg )
	if msg then
		DEFAULT_CHAT_FRAME:AddMessage("WFT: "..msg)
	end
end

function WFT.delay(frames)
	local counter = 0

	local frame = CreateFrame("Frame",nil,nil)
	frame:SetScript("OnUpdate", function(self)
		counter = counter + 1
		if counter >= frames then
			return true
		end
	end)
end

WFT.combatlogclearer = CreateFrame("Frame",nil,nil)
WFT.combatlogclearer:SetScript("OnUpdate", CombatLogClearEntries)

WFT.ini = CreateFrame("Frame")
WFT.ini:RegisterEvent("VARIABLES_LOADED")
WFT.ini:SetScript("OnEvent", function(self, event, ...)
	WFT.ini:UnregisterEvent("VARIABLES_LOADED")
	
	local playerName = GetUnitName("PLAYER")
	local localizedClass, englishClass, classIndex = UnitClass("PLAYER")
	if not (englishClass == "SHAMAN") then return end

	local framesize = 50
	WFT.mf = CreateFrame("Button", "WFT MF" , UIParent)
	if WFT_SV then 
		local pos = {}
		local i = 0
		for k,v in pairs(WFT_SV) do
			pos[i] = v
		end
		local point = pos[1]
		local relativePoint = pos[2]
		local xOfs = pos[4]
		local yOfs = pos[0]
		if point then 
			WFT.mf:SetPoint(point, UIParent,relativePoint,xOfs,yOfs)
		else
			WFT.mf:SetPoint("CENTER", UIParent,"CENTER", 300,0)
		end
	else
		WFT.mf:SetPoint("CENTER", UIParent,"CENTER", 300,0)
		WFT_SV = {}
	end
	WFT.mf:SetWidth(framesize)
	WFT.mf:SetHeight(framesize)
	WFT.mf:SetMovable(true)
	WFT.mf:SetFrameStrata("LOW")
	local mfTexture = WFT.mf:CreateTexture()
	mfTexture:SetAllPoints()
	mfTexture:SetTexture(select(3,GetSpellInfo(27621)))
	local edgeSize = 3
	WFT.mf.cooldown = CreateFrame("Cooldown", "myCooldown", WFT.mf, "CooldownFrameTemplate")
	WFT.mf.cooldown:SetPoint("TOPLEFT", WFT.mf.cooldown:GetParent(), "TOPLEFT", edgeSize,-edgeSize)
	WFT.mf.cooldown:SetPoint("BOTTOMRIGHT", WFT.mf.cooldown:GetParent(), "BOTTOMRIGHT", -edgeSize,edgeSize)	
	WFT.mf.cooldown:SetReverse(true)
	WFT.mf.cooldown:SetFrameStrata("LOW")
	WFT.mf.cooldown:SetCooldown(GetTime(),1)

	WFT.tf = CreateFrame("Frame",nil,WFT.mf)
	WFT.tf:SetAllPoints()
	WFT.tf.text = WFT.tf:CreateFontString("maintext","OVERLAY","GameFontNormalLarge")
	WFT.tf.text:SetFont(STANDARD_TEXT_FONT, 18, "THINOUTLINE")
	WFT.tf.text:SetPoint("CENTER")
	WFT.tf.text:SetJustifyH("CENTER")
	WFT.tf.text:SetJustifyV("CENTER")
	WFT.tf.text:SetText("WF\nTT")
	WFT.mf:EnableMouse(true)
	WFT.mf:RegisterForDrag("LeftButton")
	WFT.mf:SetClampedToScreen(true)
	WFT.mf:SetMovable(true)
	WFT.mf:Show()
	WFT.mf:SetScript("OnDragStart", WFT.mf.StartMoving)
	WFT.mf:SetScript("OnDragStop", function()
		WFT.mf:StopMovingOrSizing()
		local point, relativeTo, relativePoint, xOfs, yOfs = WFT.mf:GetPoint()
		WFT_SV.WFTMFpoint = point
		WFT_SV.WFTMFrelativePoint = relativePoint
		WFT_SV.WFTMFxOfs = xOfs
		WFT_SV.WFTMFyOfs = yOfs
	end)

	WFT.mf:Show()	
	WFT.mf:SetScript("OnClick", function(self, button)
		if button == "RightButton" then
			WFT.mf:Hide()
			WFT.active = false
			ShamanHUDSV.active = false
			DEFAULT_CHAT_FRAME:AddMessage("Annihilator hidden. type /bluey on to show again.")
		end
	end)

	WFT.wft = CreateFrame("Frame", "WFTextureFrame", WFT.mf)
	WFT.wft:SetPoint("TOPLEFT", WFT.wft:GetParent(), "TOPRIGHT", 2, 0)
	WFT.wft:SetHeight(WFT.wft:GetParent():GetHeight())
	WFT.wft:SetWidth(WFT.wft:GetParent():GetWidth())

	
	WFT.wft.texture = WFT.wft:CreateTexture()
	WFT.wft.texture:SetAllPoints()
	WFT.wft.texture:SetTexture(select(3,GetSpellInfo(25505)))
	WFT.wft.cooldown = CreateFrame("Cooldown", "myCooldown", WFT.wft, "CooldownFrameTemplate")
	WFT.wft.cooldown:SetPoint("TOPLEFT", WFT.wft.cooldown:GetParent(), "TOPLEFT", edgeSize,-edgeSize)
	WFT.wft.cooldown:SetPoint("BOTTOMRIGHT", WFT.wft.cooldown:GetParent(), "BOTTOMRIGHT", -edgeSize,edgeSize)	
	WFT.wft.cooldown:SetFrameStrata("LOW")
	WFT.wft.cooldown:SetCooldown(GetTime(),1)
	WFT.wft.text = WFT.wft.cooldown:CreateFontString("WFTTextureText","OVERLAY","GameFontNormalLarge")
	WFT.wft.text:SetFont(STANDARD_TEXT_FONT, 18, "THINOUTLINE")
	WFT.wft.text:SetPoint("CENTER")
	WFT.wft.text:SetJustifyH("CENTER")
	WFT.wft.text:SetJustifyV("CENTER")


	WFT.SST = CreateFrame("Frame", "WFTextureFrame", WFT.wft)
	WFT.SST:SetPoint("TOPLEFT", WFT.SST:GetParent(), "TOPRIGHT", 2, 0)
	WFT.SST:SetHeight(WFT.SST:GetParent():GetHeight())
	WFT.SST:SetWidth(WFT.SST:GetParent():GetWidth())

	WFT.SST.texture = WFT.SST:CreateTexture()
	WFT.SST.texture:SetAllPoints()
	WFT.SST.texture:SetTexture(select(3,GetSpellInfo(17364)))
	WFT.SST.cooldown = CreateFrame("Cooldown", "myCooldown", WFT.SST, "CooldownFrameTemplate")
	WFT.SST.cooldown:SetAllPoints()
	WFT.SST.cooldown:SetFrameStrata("LOW")
	WFT.SST.cooldown:SetCooldown(GetTime(),1)
	WFT.SST.indicator = WFT.SST:CreateTexture(nil,"OVERLAY")
	WFT.SST.indicator:SetPoint("TOPLEFT", WFT.SST.indicator:GetParent(), "TOPLEFT", edgeSize,-edgeSize)
	WFT.SST.indicator:SetPoint("BOTTOMRIGHT", WFT.SST.indicator:GetParent(), "BOTTOMRIGHT", -edgeSize,edgeSize)
	WFT.SST.text = WFT.SST.cooldown:CreateFontString("WFTTextureText","OVERLAY","GameFontNormalLarge")
	WFT.SST.text:SetFont(STANDARD_TEXT_FONT, 18, "THINOUTLINE")
	WFT.SST.text:SetPoint("CENTER")
	WFT.SST.text:SetJustifyH("CENTER")
	WFT.SST.text:SetJustifyV("CENTER")

	WFT.NEXTSPELL = CreateFrame("Frame", "WFTextureFrame", WFT.SST)
	WFT.NEXTSPELL:SetPoint("TOPLEFT", WFT.NEXTSPELL:GetParent(), "TOPRIGHT", 2, 0)
	WFT.NEXTSPELL:SetHeight(WFT.NEXTSPELL:GetParent():GetHeight())
	WFT.NEXTSPELL:SetWidth(WFT.NEXTSPELL:GetParent():GetWidth())

	WFT.NEXTSPELL.texture = WFT.NEXTSPELL:CreateTexture()
	WFT.NEXTSPELL.texture:SetAllPoints()
	WFT.NEXTSPELL.texture:SetTexture(select(3,GetSpellInfo(27621)))
	WFT.NEXTSPELL.cooldown = CreateFrame("Cooldown", "myCooldown", WFT.NEXTSPELL, "CooldownFrameTemplate")
	WFT.NEXTSPELL.cooldown:SetAllPoints()
	WFT.NEXTSPELL.cooldown:SetFrameStrata("LOW")
	WFT.NEXTSPELL.cooldown:SetCooldown(GetTime(),1)
	WFT.NEXTSPELL.indicator = WFT.NEXTSPELL:CreateTexture(nil,"OVERLAY")
	WFT.NEXTSPELL.indicator:SetPoint("TOPLEFT", WFT.NEXTSPELL.indicator:GetParent(), "TOPLEFT", edgeSize,-edgeSize)
	WFT.NEXTSPELL.indicator:SetPoint("BOTTOMRIGHT", WFT.NEXTSPELL.indicator:GetParent(), "BOTTOMRIGHT", -edgeSize,edgeSize)
	WFT.NEXTSPELL.text = WFT.NEXTSPELL.cooldown:CreateFontString("WFTTextureText","OVERLAY","GameFontNormalLarge")
	WFT.NEXTSPELL.text:SetFont(STANDARD_TEXT_FONT, 18, "THINOUTLINE")
	WFT.NEXTSPELL.text:SetPoint("CENTER")
	WFT.NEXTSPELL.text:SetJustifyH("CENTER")
	WFT.NEXTSPELL.text:SetJustifyV("CENTER")

	

	local baropacity = 0.4
	WFT.swingtimer = CreateFrame("STATUSBAR", "swingtimer", UIParent)
	WFT.swingtimer:SetStatusBarTexture("Interface\\Addons\\ShamanHUD\\Media\\Bar.tga")
	WFT.swingtimer:SetStatusBarColor(baropacity,baropacity,baropacity,1)
	WFT.swingtimer:SetOrientation("HORIZONTAL")
	WFT.swingtimer:SetPoint("BOTTOMLEFT", WFT.tf, "TOPLEFT", 0, 6)
	WFT.swingtimer:SetPoint("BOTTOMRIGHT", WFT.NEXTSPELL, "TOPRIGHT", 0, 6)
	WFT.swingtimer:SetHeight(15)
	WFT.swingtimer:SetMinMaxValues(0,100)
	WFT.swingtimer.text = WFT.swingtimer:CreateFontString(nil,"OVERLAY","GameFontNormal")
	WFT.swingtimer.text:SetPoint("CENTER")
	WFT.swingtimer.text:SetText("Swingtimer")
	
	WFT.gcdtimer = CreateFrame("STATUSBAR", "gcdtimer", UIParent)
	WFT.gcdtimer:SetStatusBarTexture("Interface\\AddOns\\ShamanHUD\\Media\\Bar.tga")
	WFT.gcdtimer:SetStatusBarColor(baropacity,baropacity,baropacity,1) -- 4286f4
	WFT.gcdtimer:SetOrientation("HORIZONTAL")
	WFT.gcdtimer:SetMinMaxValues(0,100)
	WFT.gcdtimer:SetPoint("TOPLEFT", WFT.tf, "BOTTOMLEFT", 0, -6)
	WFT.gcdtimer:SetPoint("TOPRIGHT", WFT.NEXTSPELL, "BOTTOMRIGHT", 0, -6)
	WFT.gcdtimer:SetHeight(15)
	WFT.gcdtimer:SetMinMaxValues(0,100)
	WFT.gcdtimer.text = WFT.gcdtimer:CreateFontString(nil,"OVERLAY","GameFontNormal")
	WFT.gcdtimer.text:SetPoint("CENTER")
	WFT.gcdtimer.text:SetText("MANA")
	WFT.gcdtimer:Hide()

	WFT.manabar = CreateFrame("STATUSBAR", "manabar", UIParent)
	WFT.manabar:SetStatusBarTexture("Interface\\AddOns\\ShamanHUD\\Media\\Bar.tga")
	WFT.manabar:SetStatusBarColor(48/255,89/255,155/255,1)
	WFT.manabar:SetOrientation("HORIZONTAL")
	WFT.manabar:SetMinMaxValues(0,100)
	WFT.manabar:SetPoint("TOPLEFT", WFT.tf, "BOTTOMLEFT", 0, -6)
	WFT.manabar:SetPoint("TOPRIGHT", WFT.NEXTSPELL, "BOTTOMRIGHT", 0, -6)
	WFT.manabar:SetHeight(15)
	WFT.manabar:SetMinMaxValues(0,100)
	WFT.manabar.text = WFT.manabar:CreateFontString(nil,"OVERLAY","GameFontNormal")
	WFT.manabar.text:SetPoint("CENTER")
	WFT.manabar.text:SetText("mana")

	WFT.background = CreateFrame("FRAME", nil, UIParent)
	WFT.background:SetFrameStrata("BACKGROUND")
	WFT.background:SetPoint("TOPLEFT", WFT.swingtimer, "TOPLEFT", -4,4)
	WFT.background:SetPoint("BOTTOMRIGHT", WFT.gcdtimer, "BOTTOMRIGHT", 4, -4)
	WFT.background:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
    edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
    tile = true, tileSize = 16, edgeSize = 16, 
    insets = { left = 4, right = 4, top = 4, bottom = 4 }})
    WFT.background:SetBackdropColor(0,0,0,1)
    WFT.background:SetBackdropBorderColor(0.5,0.5,0.5,1)
	
	local totemFrames = {}
	totemFrames.airtotem = CreateFrame("Frame", "airtotemframe", WFT.mf)
	totemFrames.airtotem:SetPoint("TOPRIGHT", WFT.background, "BOTTOMRIGHT", -edgeSize*4-framesize*3, -edgeSize)
	totemFrames.airtotem.totemNR = 4

	
	totemFrames.earthtotem = CreateFrame("Frame", "earthtotemframe", WFT.mf)
	totemFrames.earthtotem:SetPoint("TOPRIGHT", WFT.background, "BOTTOMRIGHT", -edgeSize*3-framesize*2, -edgeSize)
	totemFrames.earthtotem.totemNR = 2

	
	totemFrames.watertotem = CreateFrame("Frame", "watertotemframe", WFT.mf)
	totemFrames.watertotem.totemNR = 3
	totemFrames.watertotem:SetPoint("TOPRIGHT", WFT.background, "BOTTOMRIGHT", -edgeSize*2-framesize*1, -edgeSize)
	
	
	totemFrames.firetotem = CreateFrame("Frame", "firetotemframe", WFT.mf)
	totemFrames.firetotem.totemNR = 1
	totemFrames.firetotem:SetPoint("TOPRIGHT", WFT.background, "BOTTOMRIGHT", -edgeSize, -edgeSize)
	
	for k,totem in pairs(totemFrames) do
		totem:SetHeight(framesize)
		totem:SetWidth(framesize)

		totem.texture = totem:CreateTexture()
		totem.texture:SetAllPoints()
		totem.cooldown = CreateFrame("Cooldown", "myCooldown", totem, "CooldownFrameTemplate")
		totem.cooldown:SetAllPoints()
		totem.cooldown:SetFrameStrata("LOW")
		totem.cooldown:SetReverse(true)
		totem.indicator = totem:CreateTexture(nil,"OVERLAY")
		totem.indicator:SetAllPoints()
		totem.text = totem.cooldown:CreateFontString("firetotemtext","OVERLAY","GameFontNormalLarge")
		totem.text:SetFont(STANDARD_TEXT_FONT, 18, "THINOUTLINE")
		totem.text:SetPoint("CENTER")
		totem.text:SetJustifyH("CENTER")
		totem.text:SetJustifyV("CENTER")

		totem:EnableMouse(true)
		totem:SetScript("OnMouseDown", function(self, button, hold)
			if button == "RightButton" then
				DestroyTotem(totem.totemNR)
				totem.up = false
				totem:Hide()
			end
		
		end)
	end
	
	--[[ totemFrames.firetotem:SetHeight(framesize)
	totemFrames.firetotem:SetWidth(framesize)

	totemFrames.firetotem.texture = totemFrames.firetotem:CreateTexture()
	totemFrames.firetotem.texture:SetAllPoints()
	totemFrames.firetotem.cooldown = CreateFrame("Cooldown", "myCooldown", totemFrames.firetotem, "CooldownFrameTemplate")
	totemFrames.firetotem.cooldown:SetAllPoints()
	totemFrames.firetotem.cooldown:SetFrameStrata("LOW")
	totemFrames.firetotem.cooldown:SetReverse(true)
	totemFrames.firetotem.indicator = totemFrames.firetotem:CreateTexture(nil,"OVERLAY")
	totemFrames.firetotem.indicator:SetAllPoints()
	totemFrames.firetotem.text = totemFrames.firetotem.cooldown:CreateFontString("firetotemtext","OVERLAY","GameFontNormalLarge")
	totemFrames.firetotem.text:SetFont(STANDARD_TEXT_FONT, 18, "THINOUTLINE")
	totemFrames.firetotem.text:SetPoint("CENTER")
	totemFrames.firetotem.text:SetJustifyH("CENTER")
	totemFrames.firetotem.text:SetJustifyV("CENTER") ]]
	

	local function setNextSpell(texture)
		if texture then 
			WFT.NEXTSPELL.texture:SetTexture(texture)
		end
	end

	local latency = select(3,GetNetStats())/1000
	local WFTexture = select(3,GetSpellInfo(25505))
	local WFTTexture = select(3,GetSpellInfo(27621))
	local ShockTexture = select(3,GetSpellInfo(25457))
	local SSTexture = select(3,GetSpellInfo(17364))

	local GCD = 0
	local lastGCD = GetTime()

	local flurry = false

	local lastShock = 0
	local shockCD = false

	local swingTime = 0
	local timeSinceLastSwing = 0
	local lastSwing = 0
	local mhSwing = true

	local lastWFTrefresh = 0
	local WFTup = false
	local duration = 0
	local wftotem = false
	local wftguid = 0

	local lastWFproc = GetTime()
	local totalWFprocs = 0
	local wfCD = 0
	local wfDelay = 0
	local wfDamage = 0
	local wfDelay_total = 0
	local wfDelay_average = 0
	local combatStart = 0

	local lastSSuse = 0
	local SSCD = false

	local airtotems = {
		"Windfury Totem",
		"Grace of Air Totem",
		"Grounding Totem",
		"Nature Resistance Totem",
		"Sentry Totem",
		"Windwall Totem",
		"Wrath of Air Totem",
		"Tranquil Air Totem"
	}

	WFT.combatlogger = CreateFrame("Frame")
	WFT.combatlogger:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
	WFT.combatlogger:SetScript("OnEvent", function(self, event, ...)
		local timestamp,eventType,source,srcName,_,dstGUID,auraDest,_,spellID, spellName = ...

		if eventType == "SPELL_CAST_SUCCESS" and srcName == playerName then
			GCD = select(2,GetSpellCooldown("Lightning Bolt"))
			lastGCD = GetTime()
		end

		if strmatch(eventType,"SWING") and srcName == playerName then
			
			local now = GetTime()

			if now > lastSwing + (swingTime/2) then
				lastSwing = now
				timeSinceLastSwing = 0
				swingTime = UnitAttackSpeed("PLAYER")
			else
				--mhSwing = true -- SEE ON_UPDATE CODE FOR RESETTING mhSwing TO TRUE
			end
			
		elseif auraDest == playerName and spellName == "Flurry" then
			if eventType == "SPELL_AURA_APPLIED" then
				flurry = true
			elseif eventType == "SPELL_AURA_REMOVED" then
				flurry = false
			end

		elseif eventType == "SPELL_SUMMON" and srcName == playerName then

			if ( spellName == "Windfury Totem" ) then
				wftguid=dstGUID;
				lastWFTrefresh = GetTime()
				WFTup = true
				WFT.mf.cooldown:SetCooldown(GetTime(), 10)
				wftotem = true
			elseif tContains(airtotems,spellName) then
				wftotem = false
			end
			
			for k,totem in pairs(totemFrames) do
				local haveTotem, totemName, start, duration, texture = GetTotemInfo(totem.totemNR)
				if duration > 0 then
					totem.up = true
					totem.texture:SetTexture(texture)
					totem.cooldown:SetCooldown(start,duration)
					totem.start = start
					totem.duration = duration
					totem:Show()
				end
			end
		elseif srcName == playerName and spellName == "Totemic Call" then

			for k,totem in pairs(totemFrames) do
				totem.up = false
				totem:Hide()
			end
			
		elseif eventType == "SPELL_DAMAGE" and srcName == playerName and spellName == "Windfury Attack" then
			local now = GetTime()

			if wfCD then
				
			else
				totalWFprocs = totalWFprocs + 1
				wfDelay = (now - lastWFproc) - 3
				wfDelay_total = wfDelay_total + wfDelay
				wfDelay_average = wfDelay_total / totalWFprocs
				lastWFproc = now - latency
			end

			wfDamage = wfDamage + select(12,...)
			
			wfCD = true
			WFT.wft.cooldown:SetCooldown(GetTime(),3 - latency)

			if not SSCD then
				WFT.SST.indicator:SetTexture(0.6,0.1,0.1,0.5)
				WFT.SST.text:SetText("|cffc65743".."WF\nCD".."|r")
			end

		elseif eventType == "SPELL_CAST_SUCCESS" and srcName == playerName and spellName == "Stormstrike" then
			local now = GetTime()

			WFT.SST.indicator:SetTexture(0.6,0.1,0.1,0.5)
			SSCD = true
			lastSSuse = now - latency
			WFT.SST.cooldown:SetCooldown(now,10)
		elseif eventType == "SPELL_CAST_SUCCESS" and srcName == playerName and strmatch(spellName, "Shock") then
			now = GetTime()

			if spellName == "Flame Shock" then
				ShockTexture = select(3,GetSpellInfo(10473))
			else
				ShockTexture = select(3,GetSpellInfo(25457))
			end

			lastShock = now - latency
			shockCD = true

		end
	end)

	local delay = 0
	local framerate = 0
	local UPDATEDELAY = 0.2
	local TIMESINCELASTUPDATE = 0
	WFT.combatlogger:SetScript("OnUpdate", function(self, elapsed) 
		TIMESINCELASTUPDATE = TIMESINCELASTUPDATE + elapsed
		local now = GetTime()
		combat = true
		delay = delay + 1
		if TIMESINCELASTUPDATE > UPDATEDELAY then
			TIMESINCELASTUPDATE = 0
			latency = select(3,GetNetStats())/1000
			framerate = GetFramerate()

			WFT.manabar:SetValue(100*(UnitMana("PLAYER")/UnitManaMax("PLAYER")))
			WFT.manabar.text:SetText(UnitMana("PLAYER"))

			for k,totem in pairs(totemFrames) do
				if totem.up then
					
					remaining = totem.duration - (now - totem.start)
					if remaining < 0 then
						totem.up = false
						totem:Hide()
					else
						totem.text:SetText(floor(remaining))
					end
				end
			end
			
			if WFTup then
				local duration = 10 - (now - lastWFTrefresh)
				print(lastWFTrefresh)
				if wftotem and ( duration < 5 ) then
					lastWFTrefresh = lastWFTrefresh + 5
					duration =  10 - (now - lastWFTrefresh)
					WFT.mf.cooldown:SetCooldown(now, duration)
				elseif duration < 0 then
					WFT.tf.text:SetText("|cffc65743".."WF\nDOWN")
					WFTup = false
					return
				end
				WFT.tf.text:SetText("|cff3d9633"..ceil(duration))
				delay = 0				
			end

			local _,name,startTime,duration = GetTotemInfo(4)
			if name == "Windfury Totem V" then
				WFTup = true
				wftotem = true
			else
				wftotem = false
			end

			if wfCD then
				if now - lastWFproc < 3 then
					local wfCDduration = 3 - (now - lastWFproc)
					-- "|cffc65743"..ceil(wfCDduration).."|r\n"..
					WFT.wft.text:SetText(ceil(wfDamage).."\n"..(round(wfDelay_average,1)).."s")
				else
					WFT.wft.text:SetText("|cff3d9633RDY")
					wfDamage = 0

					if not SSCD then
						WFT.SST.indicator:SetTexture(0.1,0.6,0.1,0.5)
						WFT.SST.text:SetText("|cff3d9633RDY")
					end
					wfCD = false
				end
			end

			if SSCD then
				if now - lastSSuse < 10 then
					local duration = 10 - (now - lastSSuse)
					WFT.SST.text:SetText("|cffc65743"..ceil(duration))
				else
					SSCD = false
					if wfCD then						
						WFT.SST.indicator:SetTexture(0.6,0.1,0.1,0.5)
						WFT.SST.text:SetText("|cffc65743".."WF\nCD".."|r")
					else
						WFT.SST.indicator:SetTexture(0.1,0.6,0.1,0.5)
						WFT.SST.text:SetText("|cff3d9633RDY")
					end
				end
			end

			if shockCD then
				if now - lastShock < 6 then
					shockCD = false
				end
			end

		end

		timeSinceLastSwing = timeSinceLastSwing + elapsed
		local autoremaining = swingTime - timeSinceLastSwing
		local WFTremaining = 10 - (now - lastWFTrefresh)
		local WFremaining = 3 - (now - lastWFproc)
		local shockremaining = 6 - (now - lastShock)
		local SSremaining = 10 - (now - lastSSuse)
		local GCDremaining = GCD - (now - lastGCD)

		if WFTremaining > 0.5 then
			if SSremaining > 0.5 then
				if WFremaining < 0.5 and (SSremaining - WFremaining) < 0.5 and (autoremaining - SSremaining) < 0.6 then
					setNextSpell(SSTexture)
					WFT.NEXTSPELL.cooldown:SetCooldown(now - SSremaining,10)
				elseif shockCD then
					if shockremaining < (WFTremaining + 0.5) or SSremaining < (WFTremaining + 0.5) then
						if shockremaining < SSremaining then
							setNextSpell(ShockTexture)
							WFT.NEXTSPELL.cooldown:SetCooldown(now - shockremaining,6)
						else
							setNextSpell(SSTexture)
							WFT.NEXTSPELL.cooldown:SetCooldown(now - SSremaining,10)
						end
					else
						setNextSpell(WFTTexture)
					end
				else
					setNextSpell(ShockTexture)
				end
			else
				if wfCD then
					if flurry then
						if shockCD then
							if shockremaining < (WFTremaining + 0.5) then
								setNextSpell(ShockTexture)
								WFT.NEXTSPELL.cooldown:SetCooldown(now,shockremaining)
							else
								setNextSpell(WFTTexture)
							end
						else
							setNextSpell(ShockTexture)
						end
					else
						setNextSpell(SSTexture)
					end
				else
					setNextSpell(SSTexture)
				end
			end
		else
			setNextSpell(WFTTexture)
		end

		--[[ if GCDremaining < 0 then
			WFT.gcdtimer.text:SetText(GCD)
			WFT.gcdtimer:SetValue(100)
		else
			WFT.gcdtimer.text:SetText(round(GCD-GCDremaining,1).. " / " .. GCD)
			WFT.gcdtimer:SetValue(100 - (100 * GCDremaining / GCD))
		end ]]

		if autoremaining < 0 then
			WFT.swingtimer.text:SetText(swingTime)
			WFT.swingtimer:SetValue(100)
		else
			swingTime = UnitAttackSpeed("PLAYER")
			local text = ""
			if swingTime > 1.5 then
				text = round(autoremaining,1) .. " / " .. round(swingTime,2)
			else
				text = "|cffc65743" .. round(autoremaining,1) .. " / " .. round(swingTime,2) .. "|r"
			end
			WFT.swingtimer.text:SetText(text)
			WFT.swingtimer:SetValue(100 - (100 * (swingTime - timeSinceLastSwing)/swingTime))
		end
	end)

	WFT.combattracker = CreateFrame("FRAME", nil, nil)
	WFT.combattracker:RegisterEvent("PLAYER_REGEN_DISABLED")
	WFT.combattracker:SetScript("OnEvent", function(self, event,...)

		if event == "PLAYER_REGEN_DISABLED" then
			local now = GetTime()
			combatStart = now
			lastWFproc = now - 3
			wfDelay_total = 0
			totalWFprocs = 0
		end
	end)

	WFT.enhancements = {
		["Windfury"] = {
			name = "Windfury Weapom",
			id = 25505,
			texture = select(3,GetSpellInfo(25505))
		},
		["Flametongue"] = {
			name = "Flametongue Weapon",
			id = 25489,
			texture = select(3, GetSpellInfo(25489))
		},
		["Frostbrand"] = {
			name = "Frostbrand Weapon",
			id = 25500,
			texture = select(3, GetSpellInfo(25500))
		},
		["Rockbiter"] = {
			name = "Rockbiter Weapon",
			id = 25485,
			texture = select(3, GetSpellInfo(25485))
		}
	}

	WFT.tooltip = CreateFrame("GAMETOOLTIP", "WFTtooltip", nil, "GameTooltipTemplate")
--[[ 	local L = L or WFT.tooltip:CreateFontString()
	local R = R or WFT.tooltip:CreateFontString()
	L:SetFontObject(GameFontNormal)
	R:SetFontObject(GameFontNormal)
	WFT.tooltip:AddFontStrings(L,R) ]]
	WFT.tooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
	
	WFT.WepModule = CreateFrame("FRAME", "WFT_wepModuleFrame", WFT.mf)
	WFT.WepModule:SetPoint("TOPRIGHT", WFT.background, "TOPLEFT", -edgeSize)
	WFT.WepModule:SetWidth(framesize)
	WFT.WepModule:SetHeight(WFT.background:GetHeight())

	WFT.WepModule.tex = WFT.WepModule:CreateTexture("nil", "BACKGROUND")
	WFT.WepModule.tex:SetAllPoints()
	--WFT.WepModule.tex:SetTexture(0.2,0.2,0.2,0.5)
	local small = true
	WFT.WepModule.MH = CreateFrame("FRAME", nil, WFT.WepModule)
	WFT.WepModule.MH.invSlot = 16
	WFT.WepModule.MH:SetPoint("TOPRIGHT", WFT.WepModule, "TOPRIGHT")
	WFT.WepModule.MH:SetPoint("BOTTOMLEFT", WFT.WepModule, "LEFT")
	WFT.WepModule.MH.texture = WFT.WepModule.MH:CreateTexture(nil, "BACKGROUND")
	WFT.WepModule.MH.texture:SetAllPoints()
	WFT.WepModule.MH.enhtexture = WFT.WepModule.MH:CreateTexture(nil, "ARTWORK")
	if small then
		WFT.WepModule.MH.enhtexture:SetPoint("TOPLEFT")
		WFT.WepModule.MH.enhtexture:SetPoint("BOTTOMRIGHT", WFT.WepModule.MH, "CENTER")
	else
		WFT.WepModule.OH.enhtexture:SetAlpha(0.4)
		WFT.WepModule.MH.enhtexture:SetAllPoints()
	end

	WFT.WepModule.OH = CreateFrame("FRAME", nil, WFT.WepModule)
	WFT.WepModule.OH.invSlot = 17
	WFT.WepModule.OH:SetPoint("BOTTOMRIGHT", WFT.WepModule, "BOTTOMRIGHT")
	WFT.WepModule.OH:SetPoint("TOPLEFT", WFT.WepModule, "LEFT")
	WFT.WepModule.OH.texture = WFT.WepModule.OH:CreateTexture(nil, "BACKGROUND")
	WFT.WepModule.OH.texture:SetAllPoints()
	WFT.WepModule.OH.enhtexture = WFT.WepModule.OH:CreateTexture(nil, "ARTWORK")
	if small then
		WFT.WepModule.OH.enhtexture:SetPoint("TOPLEFT")
		WFT.WepModule.OH.enhtexture:SetPoint("BOTTOMRIGHT", WFT.WepModule.OH, "CENTER")
	else
		WFT.WepModule.OH.enhtexture:SetAlpha(0.4)
		WFT.WepModule.OH.enhtexture:SetAllPoints()
	end

	local function addHandObjects(hand)
		if not hand.cooldown then
			hand.cooldown = CreateFrame("COOLDOWN", nil, hand, "CooldownFrameTemplate")
			hand.cooldown:SetAllPoints()
			hand.cooldown:SetReverse(true)
			hand.cdtext = hand.cooldown:CreateFontString(nil,"OVERLAY","GameFontNormal")
			hand.cdtext:SetPoint("BOTTOMRIGHT", -3,3)
			hand.cdtext:SetText("Dur")
			hand.updateDelay = 1
			hand.timeSinceLastUpdate = -1

			hand:SetScript("OnUpdate", function(self, elapsed)
				self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed
				self.remaining = self.remaining - elapsed
				if self.timeSinceLastUpdate > self.updateDelay then
					self.timeSinceLastUpdate = 0
					local r = floor(self.remaining)
					local t
					if r < 60 then
						t = r.." s"
					else
						t = ceil(r/60).." m"
					end
					if r < 10*60 then
						t = "|cffff2222"..t
						self.cdtext:SetFontObject(GameFontNormalLarge)
					else
						self.cdtext:SetFontObject(GameFontNormal)
					end
					self.cdtext:SetText(t)
				end
			end)
		end

		if not hand.cancelTempEnchant then
			hand:EnableMouse(true)
			hand:SetScript("OnMouseDown",function(self,button,down)
				if button == "RightButton" then
					CancelItemTempEnchantment(hand.invSlot - 15)
				else

				end
			end)
		end
	end
	
	addHandObjects(WFT.WepModule.MH)
	addHandObjects(WFT.WepModule.OH)

	function WFT.getEnhancement(...)
		for i = 1, select("#", ...) do
			local region = select(i, ...)
			if region and region:GetObjectType() == "FontString" then
				local text = region:GetText() -- string or nil
				if text then
					for k,v in pairs(WFT.enhancements) do
						if strmatch(text,k) then 
							local name, rank, texture, manaCost = GetSpellInfo(v.id)
							local enhDur = strsub(text,strlen(k)+5, strlen(text)-5)
							enhDur = tonumber(enhDur)
							return name, texture, enhDur
						end
					end
				end
			end
		end
		return nil, nil, nil
	end

	function WFT.updateEnhancement(hand)
		-- update weapon tooltip -- 
		local link = GetInventoryItemLink("player", hand.invSlot)
		if link then 
			local wepTexture = select(10,GetItemInfo(link))
			hand.texture:SetTexture(wepTexture)
		end
		

		-- update enhancement tooltip -- 
		local t = WFT.tooltip
		t:ClearLines()
		t:SetInventoryItem("player", hand.invSlot)
		local name, texture, enhDur = WFT.getEnhancement(WFT.tooltip:GetRegions())
		local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo()
		if hand.invSlot == 16 and mainHandExpiration then
			enhDur = mainHandExpiration/1000
			--WFT.print(floor(enhDur/60).."mins "..floor(mod(enhDur,60)).."sec")
		elseif offHandExpiration then
			enhDur = offHandExpiration/1000
		end
		if (name and texture and enhDur) then
			hand:Show()
			hand.enhtexture:SetTexture(texture)
			hand.cooldown:SetCooldown(GetTime()-(30*60 - enhDur), 30*60)
			hand.remaining = enhDur
		else
			hand:Hide()
		end
	end
	WFT.updateEnhancement(WFT.WepModule.MH)
	WFT.updateEnhancement(WFT.WepModule.OH)
	WFT.WepModule:RegisterEvent("UNIT_INVENTORY_CHANGED")
	WFT.WepModule:SetScript("OnEvent", function(self, event, ...)
		local now = GetTime()

		if event == "UNIT_INVENTORY_CHANGED" then
			if ... == "player" then
				WFT.updateEnhancement(WFT.WepModule.MH)
				WFT.updateEnhancement(WFT.WepModule.OH)
			end
		end
	end)
end)