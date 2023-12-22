Config = {}

Config.interiors = {

	
}


------------------------------------------------------------------------------

	local wshops = {

		{ 1368.65, -1279.7, 13.55, size = 1 },
		{ 2159.17, 943.08, 10.82, size = 1 },
		{ -2625.76, 208.67, 4.62, size = 1 },

	}

	for index, wshop in pairs( wshops ) do

		wshop[4] = 0
		wshop[3] = wshop[3] - 0.8

		table.insert(Config.interiors, {
			position = { coords = wshop, },
			teleport = { coords = { 285.76, -85.07, 1001.52, 0, size = 1 }, int = 4, dim = index, },
			inverse = true, blip = 'weapon_shop',
			text = '[Магазин оружия]',
			data = 'marker.weapon_shop',
		})

	end

------------------------------------------------------------------------------

	local water_derricks = {
		{ 477.28, -2585.51, 0, 0, type = 'corona', derrick = { 489.44, -2572.57, 14.84, 0, size = 1, }, offset = { -5, -5, 0, 0 } },
		{ 582.02, -2268.5, 0, 0, type = 'corona', derrick = { 492.68, -2215.49, 12.87, 0, size = 1, }, offset = { -5, -5, 0, 0 } },
		{ 915.02, -2318.25, 0, 0, type = 'corona', derrick = { 886.16, -2234.57, 26.89, 0, size = 1, }, offset = { -5, 5, 0, 0 } },
		{ 1034.89, -2616.65, 0, 0, type = 'corona', derrick = { 1030.07, -2691.64, 37.88, 0, size = 1, }, offset = { -10, -10, 0, 0 } },
		{ 1553.13, -2872.16, 0, 0, type = 'corona', derrick = { 1638.36, -2845.59, 27.51, 0, size = 1, }, offset = { 5, 5, 0, 0 } },
		{ 2317.34, -2819.64, 0, 0, type = 'corona', derrick = { 2247.34, -2844.62, 20.25, 0, size = 1, }, offset = { -10, -10, 0, 0 } },
		{ 2769.39, -2772.64, 0, 0, type = 'corona', derrick = { 2715.22, -2719.44, 27.99, 0, size = 1, }, offset = { -10, 5, 0, 0 } },
	}

	for index, water_derrick in pairs( water_derricks ) do

		table.insert(Config.interiors, {
			position = { coords = water_derrick, offset = water_derrick.offset },
			teleport = { coords = water_derrick.derrick, offset = { 2, 2, 0, 0 } },
			inverse = true,
			text = '[Нефтевышка]',
			color = {117,56,255,100},
		})

	end


------------------------------------------------------------------------------

for _, interior in pairs( Config.interiors ) do
	if interior.inverse then
		table.insert(Config.interiors,
			{
				position = interior.teleport,
				teleport = interior.position,
			}
		)
	end
end