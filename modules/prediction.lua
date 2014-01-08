local addon, ns = ...

if select(2, UnitClass("player")) ~= "HUNTER" then return end

local STEADY_SHOT = 56641
local COBRA_SHOT = 77767
local base_prediction = 14
local function getPredictionAdjustment()
	local adjustment = 0
	
	-- Account for MM Steady Focus buff 3 extra focus
	---- Contributed to by: osa - http://www.mmo-champion.com/threads/1169669-JSHB-The-future-and-MoP?p=17825521&viewfull=1#post17825521
	if (GetSpecialization() == 2) and select(1, UnitAura("player", GetSpellInfo(53220), nil, "HELPFUL")) then -- 53220 = Steady Focus (buff)
		adjustment = adjustment + 3
	end
	---- end osa

	return adjustment
end

ns.prediction = ns.prediction or CreateFrame("StatusBar", "vStayFocusedPredictionFrame", ns.bar)
	
function ns.prediction.Create()
	ns.prediction:SetParent(ns.bar)
	ns.prediction:ClearAllPoints()
	ns.prediction:SetStatusBarTexture(ns.dbpc.texture)
	ns.prediction:SetMinMaxValues(0, 1)
	ns.prediction:SetValue(1)
	ns.prediction:SetFrameLevel( ns.bar:GetFrameLevel() )
	ns.prediction:SetSize(10, 10)
	
	ns.RegisterEvent("UNIT_SPELLCAST_START",     ns.prediction.StartCasting)
	ns.RegisterEvent("UNIT_SPELLCAST_FAILED",    ns.prediction.StopCasting)
	ns.RegisterEvent("UNIT_SPELLCAST_STOP",      ns.prediction.StopCasting)
	ns.RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", ns.prediction.StopCasting)
end

function ns.prediction.StartCasting(event, ...)
	local sourceUnit, _, _, _, spellId = ...
	if (sourceUnit == "player") then			
		if spellId  == STEADY_SHOT or spellId == COBRA_SHOT then
			ns.status.player_is_casting = true
		end
	end
end

function ns.prediction.StopCasting(event, ...)
	local sourceUnit, _, _, _, spellId = ...	
	if (sourceUnit == "player") then		
		if spellId  == STEADY_SHOT or spellId == COBRA_SHOT then
			ns.status.player_is_casting = false
			ns.prediction:Hide()
		end
	end
end

function ns.prediction.MaxPowerUpdated()
end

function ns.prediction.PowerUpdated()
	if ns.status.player_is_casting then
		local prediction = base_prediction + getPredictionAdjustment()

		local color = ns.GetBarColor(prediction)
		ns.prediction:SetStatusBarColor(color.r, color.g, color.b)
		
		local bar_width = ns.bar:GetWidth()
		local bar_height = ns.bar:GetHeight()
		local pixel_per_point = bar_width / ns.status.max_power
		
		ns.prediction:SetSize(pixel_per_point * prediction, bar_height)

		ns.prediction:ClearAllPoints()
		ns.prediction:SetPoint("LEFT", ns.bar, "LEFT", bar_width / (select(2, ns.bar:GetMinMaxValues()) / ns.bar:GetValue()), 0)

		if (ns.status.current_power + prediction) > ns.status.max_power then
			ns.prediction:SetSize(pixel_per_point * (ns.status.max_power - ns.status.current_power), bar_height)			
		end
		
		if ((ns.status.max_power - ns.status.current_power ) > 0) and (not UnitIsDeadOrGhost("player")) then
			ns.prediction:SetAlpha(ns.bar:GetAlpha() * 0.6)
			ns.prediction:Show()
		else
			ns.prediction:Hide()
		end
	end
end