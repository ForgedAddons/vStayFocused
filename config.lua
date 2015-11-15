local addon, ns = ...

--ns.dbpcname = 'vStayFocusedDBPC'
ns.dbpc = {
	class_colored = true,
	style = 3,
	texture = [=[Interface\AddOns\vStayFocused\statusbar]=],
	color = {r = 1, g = 1, b = 1},
	low_color = {r = 1, g = 0, b = 0},

	backdrop_alpha = 1,

	alpha_ooc_zero = 1,
	alpha_ooc_maximum = 1,
	alpha_ooc_normal = 1,
	alpha_zero = 1,
	alpha_maximum = 1,
	alpha_normal = 1,

	font_size = 16,
	font_outline = true,

	width = 250,
	height = 13,

	point = "CENTER", 
	relativePoint = "CENTER",
	xOfs = 0, 
	yOfs = -162,
}
