local addon, ns = ...

ns.bar = ns.bar or CreateFrame("StatusBar", "vStayFocusedBarFrame", UIParent)

function ns.bar.Create()
	ns.bar:SetStatusBarTexture(ns.dbpc.texture)
	ns.bar:SetMinMaxValues(0, ns.status.max_power)
	ns.bar:SetValue(0)

	ns.bar.backdrop = ns.bar.backdrop or ns.bar:CreateTexture(nil, "BACKGROUND", ns.bar)
	ns.bar.backdrop:SetPoint("TOPLEFT", -1, 1)
	ns.bar.backdrop:SetPoint("BOTTOMRIGHT", 1, -1)
	ns.bar.backdrop:SetTexture(0, 0, 0, ns.dbpc.backdrop_alpha)

	ns.bar:SetPoint(ns.dbpc.point, "UIParent", ns.dbpc.relativePoint, ns.dbpc.xOfs, ns.dbpc.yOfs)
	ns.bar:SetSize(ns.dbpc.width, ns.dbpc.height)

	ns.bar.value = ns.bar.value or ns.bar:CreateFontString(nil, "OVERLAY", ns.bar)
	ns.bar.value:SetPoint("CENTER")
	ns.bar.value:SetJustifyH("CENTER")
	ns.bar.value:SetFont([=[Fonts\ARIALN.ttf]=], ns.dbpc.font_size, ns.dbpc.font_outline and "OUTLINE" or "")
	ns.bar.value:SetTextColor(1, 1, 1)
end

function ns.bar.MaxPowerUpdated()
	ns.bar:SetMinMaxValues(0, ns.status.max_power)
end

local function getPwPercent(power, decimal, smart)
	if smart and (power == ns.status.max_power or power == 0) then return '' end

	local pc = power / ns.status.max_power * 100.0

	return smart and (decimal and string.format(' (%.1f%%)', pc) or string.format(' (%.0f%%)', pc))
		or (decimal and string.format('%.1f%%', pc) or string.format('%.0f%%', pc))
end

function ns.bar.FormattedPower()
	local style = ns.dbpc.style
	local power = ns.status.current_power

	if style == 1 then
		return power..getPwPercent(power, true, true)
	elseif style == 2 then
		return power..getPwPercent(power, false, true)
	elseif style == 3 then
		return power
	elseif style == 4 then
		return getPwPercent(power, true, false)
	elseif style == 5 then
		return getPwPercent(power, false, false)
	else
		return ''
	end
end

function ns.bar.PowerUpdated()
	-- color
	local color = ns.GetBarColor()
	ns.bar:SetStatusBarColor(color.r, color.g, color.b)

	-- values
	ns.bar:SetValue(ns.status.current_power)
	ns.bar.value:SetText(ns.bar.FormattedPower())

	-- alpha
	if ns.status.current_power == 0 then
		ns.bar:SetAlpha(ns.status.in_combat and ns.dbpc.alpha_zero or ns.dbpc.alpha_ooc_zero)
	elseif ns.status.current_power == ns.status.max_power then
		ns.bar:SetAlpha(ns.status.in_combat and ns.dbpc.alpha_maximum or ns.dbpc.alpha_ooc_maximum)
	else
		ns.bar:SetAlpha(ns.status.in_combat and ns.dbpc.alpha_normal or ns.dbpc.alpha_ooc_normal)
	end
end
