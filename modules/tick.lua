local addon, ns = ...

local classSpells = {
	HUNTER 		= { 40, 35, 15 }, -- Kill Command, Chimaera Shot, Explosive Shot
	--DISABLE ALL CLASSES FOR NOW
	--WARRIOR 	= { 12294, 23881,  2565 }, -- Mortal Strike, Blood Thirst, Shield Block
	--ROGUE		= { 1329,   1752,    53 }, -- Mutilate, Sinister Strike, Backstab
	--WARLOCK		= { 86121,   686, 29722 }, -- Soul Swap, Shadow Bolt, Incinerate -- prob better choices....
}

local playerClass = select(2, UnitClass("player"))
if classSpells[playerClass] == nil then return end

local function updateMainSpellCost()
	--local currentCost = select(4, GetSpellInfo(classSpells[playerClass][GetSpecialization() or 1]))
	local currentCost = classSpells[playerClass][GetSpecialization() or 1]
	if (currentCost ~= 0) then
		ns.status.main_spell_cost = currentCost
	end
	return ns.status.main_spell_cost
end

ns.tick = ns.tick or CreateFrame("Frame", "vStayFocusedTickFrame", ns.bar)

function ns.tick.Create()
	ns.tick:SetParent(ns.bar)
	ns.tick:ClearAllPoints()
	ns.tick:SetSize(6, ns.dbpc.height * 1.5)
	ns.tick.tex = ns.tick:CreateTexture(nil, "OVERLAY")
	ns.tick.tex:ClearAllPoints()
	ns.tick.tex:SetAllPoints(ns.tick)
	ns.tick.tex:SetTexture([=[Interface\CastingBar\UI-CastingBar-Spark]=])	
	ns.tick.tex:SetBlendMode("ADD")
	ns.tick:SetPoint("LEFT", ns.bar, "LEFT", 0, 0)
	ns.tick:Show()
	
	updateMainSpellCost()
end

function ns.tick.MaxPowerUpdated()
end

function ns.tick.PowerUpdated()
	updateMainSpellCost()
	
	local pixel_per_point = ns.bar:GetWidth() / ns.status.max_power;
	
	ns.tick:SetPoint("LEFT", ns.bar, "LEFT", ns.status.main_spell_cost * pixel_per_point - ns.tick:GetWidth()/2, 0)
end