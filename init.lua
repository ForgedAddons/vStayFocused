local addon, ns = ...

ns.status = {
	in_combat = false,
	current_power = 0,
	max_power = 0
}

ns.update_handlers = {}

function ns.GetBarColor(prediction)
	local o = ns.dbpc

	if not prediction then prediction = 0 end

	if ns.status.main_spell_cost and ((ns.status.current_power + prediction) < ns.status.main_spell_cost) then
		return o.low_color
	else
		return o.class_colored and RAID_CLASS_COLORS[select(2, UnitClass("player"))] or {r = o.color.r, g = o.color.g, b = o.color.b}
	end
end
