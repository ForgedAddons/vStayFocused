local myname, ns = ...

ns.RegisterEvent("ADDON_LOADED", function()
	ns.bar.Create()
	if ns.tick then ns.tick.Create() end
	if ns.prediction then ns.prediction.Create() end
	
	ns.RegisterEvent("PLAYER_REGEN_ENABLED", function()
		ns.status.in_combat = false
	end)
	
	ns.RegisterEvent("PLAYER_REGEN_DISABLED", function()
		ns.status.in_combat = true
	end)
	
	ns.RegisterEvent("PLAYER_SPECIALIZATION_CHANGED", function() ns.UPDATE_MAX_POWER() end)
end)

ns.RegisterEvent("PLAYER_ENTERING_WORLD", function() ns.UPDATE_MAX_POWER() end)
ns.RegisterEvent("UNIT_CONNECTION", function() ns.UPDATE_MAX_POWER() end)
ns.RegisterEvent("UNIT_MAXPOWER", function() ns.UPDATE_MAX_POWER() end)

function ns.UPDATE_MAX_POWER()
	max_power_new = UnitPowerMax("player")
	if max_power_new ~= ns.status.max_power then
		ns.status.max_power = max_power_new
		
		ns.bar.MaxPowerUpdated()
		if ns.tick then ns.tick.MaxPowerUpdated() end
		if ns.prediction then ns.prediction.MaxPowerUpdated() end
	end
end

local updater = CreateFrame("Frame")
local last_update = 0
updater:SetScript("OnUpdate", function(self, elapsed)
	last_update = last_update + elapsed
	if last_update > 0.07 then
		last_update = 0
		ns.status.current_power = UnitPower("player")
		
		ns.bar.PowerUpdated()
		if ns.tick then ns.tick.PowerUpdated() end
		if ns.prediction then ns.prediction.PowerUpdated() end
		
		--updateFrameAlpha()
		--updateFrameValue()
		--updateTickPosition()
		--updatePredictionValue()
		
		--for key, value in pairs(ns.update_handlers) do value(elapsed) end
	end
end)