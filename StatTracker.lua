local StatTracker = CreateFrame("FRAME", "SHUD_StatTracker", UIParent)
StatTracker.o = "o"
local o
local FRAME_STATTRACKER_EDGESIZE = 5
local STAT_BAR_WIDTH = 25
local STAT_BAR_HEIGHT = STAT_BAR_WIDTH*8*3/4
local STAT_BAR_OFFSET = 2
local AS = {0.9,0.901,0.902,0.903,0.904,0.905,0.906,0.907,0.908,0.909,0.91,0.911,0.912,0.913,0.914,0.915,0.916,0.917,0.918,0.919,0.92,0.921,0.922,0.923,0.924,0.925,0.926,0.927,0.928,0.929,0.93,0.931,0.932,0.933,0.934,0.935,0.936,0.937,0.938,0.939,0.94,0.941,0.942,0.943,0.944,0.945,0.946,0.947,0.948,0.949,0.95,0.951,0.952,0.953,0.954,0.955,0.956,0.957,0.958,0.959,0.96,0.961,0.962,0.963,0.964,0.965,0.966,0.967,0.968,0.969,0.97,0.971,0.972,0.973,0.974,0.975,0.976,0.977,0.978,0.979,0.98,0.981,0.982,0.983,0.984,0.985,0.986,0.987,0.988,0.989,0.99,0.991,0.992,0.993,0.994,0.995,0.996,0.997,0.998,0.999,1,1.001,1.002,1.003,1.004,1.005,1.006,1.007,1.008,1.009,1.01,1.011,1.012,1.013,1.014,1.015,1.016,1.017,1.018,1.019,1.02,1.021,1.022,1.023,1.024,1.025,1.026,1.027,1.028,1.029,1.03,1.031,1.032,1.033,1.034,1.035,1.036,1.037,1.038,1.039,1.04,1.041,1.042,1.043,1.044,1.045,1.046,1.047,1.048,1.049,1.05,1.051,1.052,1.053,1.054,1.055,1.056,1.057,1.058,1.059,1.06,1.061,1.062,1.063,1.064,1.065,1.066,1.067,1.068,1.069,1.07,1.071,1.072,1.073,1.074,1.075,1.076,1.077,1.078,1.079,1.08,1.081,1.082,1.083,1.084,1.085,1.086,1.087,1.088,1.089,1.09,1.091,1.092,1.093,1.094,1.095,1.096,1.097,1.098,1.099,1.1,1.101,1.102,1.103,1.104,1.105,1.106,1.107,1.108,1.109,1.11,1.111,1.112,1.113,1.114,1.115,1.116,1.117,1.118,1.119,1.12,1.121,1.122,1.123,1.124,1.125,1.126,1.127,1.128,1.129,1.13,1.131,1.132,1.133,1.134,1.135,1.136,1.137,1.138,1.139,1.14,1.141,1.142,1.143,1.144,1.145,1.146,1.147,1.148,1.149,1.15,1.151,1.152,1.153,1.154,1.155,1.156,1.157,1.158,1.159,1.16,1.161,1.162,1.163,1.164,1.165,1.166,1.167,1.168,1.169,1.17,1.171,1.172,1.173,1.174,1.175,1.176,1.177,1.178,1.179,1.18,1.181,1.182,1.183,1.184,1.185,1.186,1.187,1.188,1.189,1.19,1.191,1.192,1.193,1.194,1.195,1.196,1.197,1.198,1.199,1.2,1.201,1.202,1.203,1.204,1.205,1.206,1.207,1.208,1.209,1.21,1.211,1.212,1.213,1.214,1.215,1.216,1.217,1.218,1.219,1.22,1.221,1.222,1.223,1.224,1.225,1.226,1.227,1.228,1.229,1.23,1.231,1.232,1.233,1.234,1.235,1.236,1.237,1.238,1.239,1.24,1.241,1.242,1.243,1.244,1.245,1.246,1.247,1.248,1.249,1.25,1.251,1.252,1.253,1.254,1.255,1.256,1.257,1.258,1.259,1.26,1.261,1.262,1.263,1.264,1.265,1.266,1.267,1.268,1.269,1.27,1.271,1.272,1.273,1.274,1.275,1.276,1.277,1.278,1.279,1.28,1.281,1.282,1.283,1.284,1.285,1.286,1.287,1.288,1.289,1.29,1.291,1.292,1.293,1.294,1.295,1.296,1.297,1.298,1.299,1.3,1.301,1.302,1.303,1.304,1.305,1.306,1.307,1.308,1.309,1.31,1.311,1.312,1.313,1.314,1.315,1.316,1.317,1.318,1.319,1.32,1.321,1.322,1.323,1.324,1.325,1.326,1.327,1.328,1.329,1.33,1.331,1.332,1.333,1.334,1.335,1.336,1.337,1.338,1.339,1.34,1.341,1.342,1.343,1.344,1.345,1.346,1.347,1.348,1.349,1.35,1.351,1.352,1.353,1.354,1.355,1.356,1.357,1.358,1.359,1.36,1.361,1.362,1.363,1.364,1.365,1.366,1.367,1.368,1.369,1.37,1.371,1.372,1.373,1.374,1.375,1.376,1.377,1.378,1.379,1.38,1.381,1.382,1.383,1.384,1.385,1.386,1.387,1.388,1.389,1.39,1.391,1.392,1.393,1.394,1.395,1.396,1.397,1.398,1.399,1.4,1.401,1.402,1.403,1.404,1.405,1.406,1.407,1.408,1.409,1.41,1.411,1.412,1.413,1.414,1.415,1.416,1.417,1.418,1.419,1.42,1.421,1.422,1.423,1.424,1.425,1.426,1.427,1.428,1.429,1.43,1.431,1.432,1.433,1.434,1.435,1.436,1.437,1.438,1.439,1.44,1.441,1.442,1.443,1.444,1.445,1.446,1.447,1.448,1.449,1.45,1.451,1.452,1.453,1.454,1.455,1.456,1.457,1.458,1.459,1.46,1.461,1.462,1.463,1.464,1.465,1.466,1.467,1.468,1.469,1.47,1.471,1.472,1.473,1.474,1.475,1.476,1.477,1.478,1.479,1.48,1.481,1.482,1.483,1.484,1.485,1.486,1.487,1.488,1.489,1.49,1.491,1.492,1.493,1.494,1.495,1.496,1.497,1.498,1.499,1.5,1.501,1.502,1.503,1.504,1.505,1.506,1.507,1.508,1.509,1.51,1.511,1.512,1.513,1.514,1.515,1.516,1.517,1.518,1.519,1.52,1.521,1.522,1.523,1.524,1.525,1.526,1.527,1.528,1.529,1.53,1.531,1.532,1.533,1.534,1.535,1.536,1.537,1.538,1.539,1.54,1.541,1.542,1.543,1.544,1.545,1.546,1.547,1.548,1.549,1.55,1.551,1.552,1.553,1.554,1.555,1.556,1.557,1.558,1.559,1.56,1.561,1.562,1.563,1.564,1.565,1.566,1.567,1.568,1.569,1.57,1.571,1.572,1.573,1.574,1.575,1.576,1.577,1.578,1.579,1.58,1.581,1.582,1.583,1.584,1.585,1.586,1.587,1.588,1.589,1.59,1.591,1.592,1.593,1.594,1.595,1.596,1.597,1.598,1.599,1.6}
local ASPEN = {1,0.99582,0.99563,0.995,0.99459,0.99295,0.99272,0.98964,0.99005,0.98926,0.98764,0.98728,0.98606,0.98355,0.98378,0.98295,0.98111,0.98014,0.98042,0.97834,0.97705,0.97585,0.97627,0.97434,0.97141,0.9721,0.97028,0.97044,0.9681,0.96615,0.96596,0.96429,0.965,0.96299,0.9632,0.96156,0.96005,0.95817,0.95686,0.95766,0.95695,0.95492,0.95322,0.95361,0.95193,0.95146,0.95111,0.94948,0.94785,0.9474,0.94702,0.94549,0.9433,0.94266,0.9432,0.94177,0.94008,0.94046,0.93823,0.93744,0.93651,0.9342,0.93535,0.93319,0.9331,0.93187,0.93003,0.92873,0.92979,0.92746,0.92762,0.92525,0.92618,0.92379,0.92309,0.92175,0.92116,0.92079,0.91982,0.91935,0.91691,0.91713,0.91413,0.91633,0.91417,0.91272,0.91248,0.91088,0.91108,0.90828,0.90803,0.90722,0.90507,0.90447,0.9047,0.90328,0.90169,0.90131,0.90068,0.90138,0.89778,0.93994,0.93732,0.93647,0.93576,0.93625,0.93362,0.9336,0.93279,0.93109,0.92889,0.92827,0.92866,0.92728,0.92685,0.92515,0.92416,0.92448,0.92118,0.92241,0.92067,0.92188,0.91735,0.91779,0.9188,0.91733,0.91671,0.91364,0.91377,0.91451,0.9108,0.91099,0.90971,0.91015,0.90717,0.90729,0.90658,0.90583,0.90475,0.90623,0.90315,0.9031,0.90025,0.90075,0.89947,0.89894,0.89636,0.89719,0.89653,0.89795,0.895,0.89344,0.8918,0.89329,0.89083,0.89029,0.88704,0.8881,0.88856,0.88664,0.88421,0.8845,0.88444,0.88263,0.88332,0.88295,0.88007,0.88052,0.87878,0.87999,0.87719,0.87709,0.87517,0.87394,0.87501,0.8736,0.87161,0.87137,0.87094,0.87041,0.86823,0.8693,0.8694,0.86581,0.8656,0.864,0.86427,0.86504,0.86208,0.86101,0.86089,0.86148,0.86069,0.85854,0.8579,0.85727,0.85629,0.85452,0.85481,0.85446,0.85395,0.85357,0.85197,0.85118,0.85016,0.84799,0.84876,0.84794,0.84908,0.84795,0.84436,0.84639,0.84556,0.84365,0.84425,0.84192,0.84259,0.84127,0.83894,0.84055,0.83814,0.83811,0.83725,0.83554,0.83445,0.83355,0.8344,0.83305,0.83286,0.83304,0.83199,0.8304,0.82809,0.82867,0.83064,0.82763,0.82647,0.82445,0.82487,0.82423,0.82213,0.82329,0.82356,0.82035,0.8201,0.81983,0.8201,0.81763,0.81788,0.81609,0.81589,0.81617,0.81519,0.81381,0.81511,0.81388,0.8124,0.81209,0.81188,0.80874,0.81018,0.80985,0.80956,0.80875,0.80575,0.80503,0.806,0.80366,0.80428,0.80413,0.80313,0.8017,0.80146,0.80014,0.80004,0.79975,0.79932,0.79732,0.79738,0.79511,0.79696,0.79645,0.79368,0.79332,0.7941,0.79273,0.79111,0.79269,0.79003,0.79052,0.79037,0.78963,0.78924,0.7842,0.78824,0.78541,0.78616,0.78448,0.78212,0.78396,0.78341,0.78104,0.77981,0.77888,0.78096,0.77884,0.77942,0.77878,0.7778,0.77636,0.77561,0.77505,0.77492,0.77466,0.77415,0.77268,0.77349,0.77236,0.77164,0.7691,0.77048,0.76833,0.76916,0.76739,0.76666,0.76767,0.76613,0.76587,0.76516,0.76386,0.76348,0.76414,0.76337,0.7626,0.76171,0.76028,0.75873,0.75875,0.75832,0.75863,0.75593,0.75858,0.75621,0.75621,0.75528,0.7557,0.75463,0.75266,0.75268,0.75272,0.75158,0.74936,0.74858,0.74887,0.74868,0.74731,0.74707,0.74719,0.74601,0.74728,0.74766,0.74381,0.74333,0.74351,0.74325,0.74179,0.74101,0.74034,0.74053,0.7406,0.74059,0.73878,0.741,0.737,0.73623,0.73776,0.73629,0.73449,0.73518,0.73265,0.73406,0.73467,0.7322,0.73188,0.732,0.72953,0.73002,0.72983,0.72829,0.72893,0.72912,0.7276,0.72837,0.72638,0.7246,0.72765,0.72437,0.72481,0.72445,0.72234,0.72322,0.72185,0.72268,0.7207,0.72041,0.71962,0.71954,0.71829,0.71673,0.71753,0.71769,0.71877,0.71613,0.71684,0.71309,0.71327,0.71338,0.71148,0.71348,0.71264,0.71068,0.70957,0.71115,0.70977,0.70753,0.70954,0.70778,0.70846,0.70719,0.70438,0.70585,0.70565,0.7057,0.70408,0.70474,0.70555,0.7029,0.70123,0.70315,0.70178,0.70036,0.70032,0.69954,0.69899,0.70009,0.69786,0.69939,0.69746,0.69679,0.69573,0.69432,0.69533,0.69419,0.69543,0.6939,0.69187,0.69182,0.69058,0.69174,0.69162,0.69066,0.68988,0.68983,0.68961,0.68945,0.68878,0.68967,0.68667,0.687,0.68708,0.68631,0.68512,0.68426,0.68415,0.68273,0.68303,0.6823,0.68273,0.68128,0.68,0.67982,0.68026,0.67926,0.67998,0.67857,0.67803,0.6769,0.67734,0.67642,0.67682,0.6755,0.67442,0.67382,0.67271,0.67458,0.67375,0.67248,0.67211,0.67114,0.67078,0.67147,0.67067,0.66798,0.66848,0.66969,0.66744,0.6688,0.66767,0.6665,0.66641,0.66671,0.66613,0.66431,0.66527,0.66431,0.66567,0.66407,0.66221,0.66112,0.66031,0.66087,0.6611,0.6597,0.66064,0.65817,0.65958,0.65822,0.6591,0.65883,0.65628,0.65766,0.65597,0.65592,0.65566,0.65572,0.65574,0.65391,0.65336,0.65337,0.65408,0.65307,0.64993,0.6507,0.64962,0.65115,0.65141,0.6502,0.64934,0.64823,0.64745,0.64733,0.64647,0.6474,0.64729,0.64524,0.64616,0.64442,0.64477,0.64551,0.64367,0.64382,0.64193,0.64123,0.64239,0.64301,0.64081,0.64075,0.64029,0.64032,0.63873,0.6382,0.63723,0.63808,0.63711,0.63808,0.63641,0.63584,0.63508,0.63685,0.63484,0.6349,0.63463,0.63364,0.63286,0.63313,0.63184,0.63206,0.63159,0.63159,0.6317,0.631,0.63045,0.6306,0.62999,0.62895,0.62899,0.62853,0.62707,0.6271,0.62748,0.66912,0.66692,0.667,0.66555,0.6664,0.66551,0.66512,0.66482,0.66404,0.66326,0.66376,0.66206,0.66343,0.66274,0.66229,0.66174,0.66211,0.6609,0.65857,0.65996,0.65908,0.65844,0.65819,0.65837,0.65791,0.65714,0.65588,0.65682,0.65715,0.65624,0.65429,0.65556,0.65421,0.65248,0.65239,0.65335,0.65265,0.65184,0.65132,0.65179,0.65019,0.6502,0.64994,0.64957,0.64805,0.64861,0.64832,0.64882,0.64567,0.64834,0.64469,0.64371,0.64353,0.64569,0.64565,0.64545,0.64374,0.64506,0.64102,0.64248,0.64348,0.64227,0.64212,0.64239,0.64083,0.64009,0.63976,0.63925,0.63927,0.63693,0.6363,0.638,0.63801,0.63779,0.63665,0.63706,0.63591,0.63507,0.6351,0.63456,0.63424,0.63349,0.63261,0.63414,0.63458,0.63205,0.63282,0.63117,0.63063,0.63106,0.63136,0.62915,0.62805,0.62837,0.62875,0.6306,0.62756,0.62952,0.62824,0.6263,0.62808}
local PENALTY_15 = 0.9375
local PENALTY_10 = 0.9574
local BOLD_FONT = "Interface\\Addons\\ShamanHUD\\Media\\BF.ttf"
local TEXTURE_BAR = "Interface\\Addons\\ShamanHUD\\Media\\Bar.tga"
local FRAME_BACKDROP = ({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border", 
tile = true, tileSize = FRAME_STATTRACKER_EDGESIZE, edgeSize = 8, 
insets = { left = 0, right = 0, top = 0, bottom = 0 }})
local stats = {
	["Attack Power"] = {
		["short"] = "ATP",
		["EP"] = 1,
		["call"] = function() return select(2,UnitAttackPower("player")) end,
		["color"] = {122,255,11},
		["nr"] = 1
	},
	["Strength"] = {
		["short"] = "STR",
		["EP"] = 2.2,
		["call"] = function() return  select(3,UnitStat("PLAYER", 1)) end,
		["color"] = {200,100,0},
		["nr"] = 2
	},
	["Agility"] = {
		["short"] = "AGI",
		["EP"] = 1.89,
		["call"] = function() return select(3,UnitStat("PLAYER", 2)) end,
		["color"] = {255,11,11},
		["nr"] = 3
	},
	["Crit Rating"] = {
		["short"] = "CRT",
		["EP"] = 1.94,
		["call"] = function() return floor(GetCombatRatingBonus(9)*22.077) end,
		["color"] = {228,228,11},
		["nr"] = 4
	},
	["Haste Rating"] = {
		["short"] = "HST",
		["EP"] = 1.98,
		["call"] = function() return floor(GetCombatRatingBonus(18)*15.77) end,
		["color"] = {255,255,255},
		["nr"] = 5,
		["factor"] = 15.76
	},
	["Hit Rating"] = {
		["short"] = "HIT",
		["EP"] = 1.8,
		["call"] = function() return floor(GetCombatRatingBonus(6)*15.77) end,
		["color"] = {55, 55, 224},
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
local function round(number, decimals)
    return (("%%.%df"):format(decimals)):format(number)
end
local function tableHasKey(table,key)
    return table[key] ~= nil
end
local function tablelength(T)
	local count = 0
	for _ in pairs(T) do count = count + 1 end
	return count
end

local function setStyle(frame)
	local f = frame
	f:SetBackdrop(FRAME_BACKDROP)
	f:SetBackdropColor(0.5,0.5,0.5,1)
	f:SetBackdropBorderColor(0.2,0.2,0.2,1)
	return f
end
local function newEditBox(parent)
	local frame = CreateFrame("EditBox",parent:GetName().."_editBox",parent)
	frame:SetAutoFocus(false)
	frame:SetFont(BOLD_FONT, 12)
	frame:SetWidth(30)
	frame:SetHeight(25)
	frame:SetPoint("CENTER")
	frame:SetTextInsets(4, 0, 0, 0)
	frame:SetMaxLetters(3)
	frame:SetScript("OnEscapePressed", frame.ClearFocus)
	frame:SetScript("OnEnterPressed", frame.ClearFocus)
	frame:SetScript("OnTextChanged",function(self,userInput,...)
		local text = self:GetText()
		local num = tonumber(text)
		if num and num <= 4 and num >= 1 then
			self:SetTextColor(1,1,1,1)
			o.EBnum = num
			StatTracker.Statusbar:SetMinMaxValues(0,num)
			StatTracker:UpdateInfo()
			if num > 1.5 then
				local xOffs = StatTracker.Statusbar:GetWidth()-StatTracker.Statusbar:GetWidth()*1.5/num
				StatTracker.StatusbarBar:SetPoint("RIGHT", -xOffs, 0)
				xOffs = StatTracker.Statusbar:GetWidth()-StatTracker.Statusbar:GetWidth()*1.4/num
				StatTracker.StatusbarBar:SetPoint("LEFT",StatTracker.Statusbar, "RIGHT" ,-xOffs, 0)
				StatTracker.StatusbarBar:Show()
			else
				StatTracker.StatusbarBar:Hide()
			end
		else
			self:SetTextColor(255/255,76/255,76/255)
			self:SetText(tostring(frame.num or o.EBnum or 2.6))
		end
	end)

	frame:SetScript("OnHide",function(self)
	end)
	return frame
end
		
local function newFontString(f, point, xOffs, yOffs)
	local fs = f:CreateFontString(f:GetName().."_highlight", "OVERLAY", GameFontNormal)
	local str = fs:GetName()
	fs:SetFont(BOLD_FONT, 12)
	if point then
		fs:SetPoint(point, xOffs, yOffs)
		str = point.."x"..xOffs.."y"..yOffs
	end
	fs:SetText(str)
	return fs
end

local function addEvent(eventTable, event, eventFunc, isFrame)
    if type(event) == "string" and type(eventFunc) == "function" and type(eventTable) == "table" then
        eventTable[event] = eventFunc
        if isFrame then
            eventTable:RegisterEvent(event)
        end
        return true
    end
    return false
end

local function addEventWatcher(frame)
	frame:SetScript("OnEvent", function(self, event, ...) 
		if tableHasKey(self,event) then
			self[event](self,event,...) 
		end
	end)
end
addEventWatcher(StatTracker)

local function updateBaseAS()
	local result = 2
	local link = GetInventoryItemLink("player", 16)
	local speedstring = ShamanHUD_GetTooltipLines(link)[6]
	local speed = tonumber(strsub(speedstring, 7))
	if speed then
		result = speed
	end
	StatTracker.ASEditBox:SetText(result)
end

local function updateStats()
	local maxEPVal = 0
	local totalEP = 0
	for k,v in pairs(stats) do
		v.value = v.call()
		if v.value > maxEPVal then maxEPVal = v.value end
	end
	for k,v in pairs(stats) do
		local s = StatTracker[k]
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
	StatTracker:UpdateInfo()
end	

function StatTracker.UpdateInfo(self)
	local str = "Attack Speed"
	local mainSpeed, offSpeed = UnitAttackSpeed("player")
	if mainSpeed then
		str = str .. " ".. round(mainSpeed,2)
		self.Statusbar:SetValue(mainSpeed)
		if mainSpeed < 1.5 then
			if mainSpeed < 1.4 then
				self.Statusbar:SetStatusBarColor(255/255,76/255,76/255,0.5)
			else
				self.Statusbar:SetStatusBarColor(255/255,0/255,0/255,0.5)
			end
		else
			local r,g,b = unpack(stats["Haste Rating"].color)
			local q = (1-(mainSpeed-1.5)/(o.EBnum-1.5))*255
			r = r-q
			b = b-q
			self.Statusbar:SetStatusBarColor(r/255,g/255,b/255,0.5)
		end
	end
	if offSpeed then
		str = str .. " / "..round(offSpeed,2)
	end
	self.MainText:SetText(str)
	if tableHasKey(o.penalty,mainSpeed) then
		local AS = round(mainSpeed, 3)
		local p = o.penalty[mainSpeed]
		local pnorm = p/o.penalty[1.5]
		str = "WF multiplier = "..round(pnorm,2)
		local pbarval = pnorm*o.penalty[1.6]
		StatTracker.PenaltyBar:SetValue(pbarval*100)
		local r = 1-pbarval
		local g = pbarval
		local b = 0
		StatTracker.PenaltyBar:SetStatusBarColor(r,g,b,1)
	else
		str = "Penalty not found"
	end
	StatTracker.SecondText:SetText(str)
end

local StatTracker_OnLoad = function(self, event)
	self:UnregisterEvent("VARIABLES_LOADED")
	
	if not ST_SV then ST_SV = {} end
	o = ST_SV
	if ST_SV.EBnum then
		StatTracker.ASEditBox:SetText(o.EBnum or 2.6)
	end
	if not o.penalty then
		o.penalty = {}
		--print(select("#", AS))
		for i = 1,701 do
			o.penalty[AS[i]] = ASPEN[i]
		end
	end

	updateStats()
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
		updateBaseAS()
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
StatTracker:SetHeight(2*STAT_BAR_HEIGHT)

-- element 1
StatTracker.MainText = newFontString(StatTracker, "TOPLEFT", FRAME_STATTRACKER_EDGESIZE, -FRAME_STATTRACKER_EDGESIZE*3/2)
-- element 2
StatTracker.ASEditBox = newEditBox(StatTracker)
StatTracker.ASEditBox:SetPoint("TOPRIGHT")
setStyle(StatTracker.ASEditBox)
-- element 3
StatTracker.Statusbar = CreateFrame("Statusbar", StatTracker:GetName().."_hasteBar", StatTracker)
StatTracker.Statusbar:SetPoint("TOPLEFT", StatTracker, "TOPLEFT", FRAME_STATTRACKER_EDGESIZE, -25)
StatTracker.Statusbar:SetPoint("BOTTOMRIGHT", StatTracker, "TOPRIGHT", -FRAME_STATTRACKER_EDGESIZE, -50)
StatTracker.Statusbar:SetOrientation("HORIZONTAL")
StatTracker.Statusbar:SetMinMaxValues(0,100)
StatTracker.Statusbar:EnableMouse(true)
StatTracker.Statusbar:SetStatusBarTexture(TEXTURE_BAR)
local r,g,b = unpack(stats["Haste Rating"].color)
StatTracker.Statusbar:SetStatusBarColor(r/255, g/255, b/255,0.5)
StatTracker.StatusbarBar = StatTracker.Statusbar:CreateTexture(nil, "OVERLAY")
StatTracker.StatusbarBar:SetHeight(10)
StatTracker.StatusbarBar:SetTexture(1 ,0.2, 0, 1)
-- element 4
StatTracker.SecondText = newFontString(StatTracker, "TOPLEFT", FRAME_STATTRACKER_EDGESIZE, -54)
-- element 5
StatTracker.PenaltyBar = CreateFrame("Statusbar", StatTracker:GetName().."_penaltyBar", StatTracker)
StatTracker.PenaltyBar:SetPoint("TOPLEFT", StatTracker.SecondText, "BOTTOMLEFT", 0, -FRAME_STATTRACKER_EDGESIZE)
StatTracker.PenaltyBar:SetHeight(25)
StatTracker.PenaltyBar:SetWidth(StatTracker:GetWidth()-2*FRAME_STATTRACKER_EDGESIZE)
StatTracker.PenaltyBar:SetOrientation("HORIZONTAL")
StatTracker.PenaltyBar:SetMinMaxValues(0,100)
StatTracker.PenaltyBar:EnableMouse(true)
StatTracker.PenaltyBar:SetStatusBarTexture(TEXTURE_BAR)
StatTracker.PenaltyBar:SetStatusBarColor(1,1,1,1)


setStyle(StatTracker)
StatTracker.toptext = StatTracker:CreateFontString(StatTracker:GetName().."_title", "OVERLAY", GameFontNormal)
StatTracker.toptext:SetFont(BOLD_FONT, 12)
StatTracker.toptext:SetPoint("BOTTOM", StatTracker, "BOTTOM", 0, STAT_BAR_HEIGHT+5)
StatTracker.toptext:SetText("ShamanHUD StatTracker")

local OptionsFrame = setStyle(CreateFrame("Frame", "SHUD_OptionsFrame", StatTracker))
OptionsFrame:EnableMouse(true)
OptionsFrame:SetScript("OnMouseDown", OptionsFrame.Hide)
OptionsFrame.L1 = newFontString(OptionsFrame, "TOPLEFT", FRAME_STATTRACKER_EDGESIZE*2, -FRAME_STATTRACKER_EDGESIZE*2)
OptionsFrame.show = function(self, t)
	self:SetPoint("TOPLEFT", self:GetParent(), "TOPRIGHT", FRAME_STATTRACKER_EDGESIZE, 0)
	self:SetWidth(150)
	self:SetHeight(150)
	self:Show()
end

local InfoFrame = setStyle(CreateFrame("Frame", "SHUD_InfoFrame", StatTracker))
InfoFrame:EnableMouse(true)
InfoFrame:SetScript("OnMouseDown", OptionsFrame.Hide)
InfoFrame.L1 = newFontString(InfoFrame, "TOPLEFT", FRAME_STATTRACKER_EDGESIZE*2, -FRAME_STATTRACKER_EDGESIZE*2)
InfoFrame.show = function(self, t)
	self:SetPoint("TOPLEFT", self:GetParent(), "TOPRIGHT", FRAME_STATTRACKER_EDGESIZE, 0)
	self:SetWidth(150)
	self:SetHeight(150)
	self:Show()
end

for k,v in pairs(stats) do
	local f = CreateFrame("StatusBar", StatTracker:GetName()..v.short, StatTracker)
	f:SetPoint("BOTTOMLEFT", f:GetParent(), "BOTTOMLEFT", FRAME_STATTRACKER_EDGESIZE+(STAT_BAR_WIDTH)*(v.nr - 1), 5)
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
	f.highlight:SetFont(BOLD_FONT, 16)
	f.highlight:SetPoint("TOP", f.title, "BOTTOM", 0, -10)
	f.highlight:SetText(v.short)

	f.valuetext = f:CreateFontString(f:GetName().."_valuetext", "OVERLAY", GameFontNormal)
	f.valuetext:SetFont(BOLD_FONT, 14)
	f.valuetext:SetPoint("BOTTOM", f, "BOTTOM", 0, FRAME_STATTRACKER_EDGESIZE)
	f.valuetext:SetText(v.short)

	f.menuFrame = CreateFrame("Frame", f:GetName().."_menuFrame", UIParent, "UIDropDownMenuTemplate")
	setStyle(f.menuFrame)
	f:SetScript("OnMouseUp", function(self, button)
		if button == "LeftButton" then

		elseif button == "RightButton" then
			-- menu
			local menu = {
				{text = k, isTitle = true},
				{text = "Info", 
				func = function()
					InfoFrame.show(InfoFrame, v)
				end},
				{text = "Options",
				func = function()
					OptionsFrame.show(OptionsFrame, v)
				end}
			}
			EasyMenu(menu, self.menuFrame, "cursor", 0 , 0, "MENU")
		end
	end)
	StatTracker[k] = f
end