Config = {}

Config.shops = {
	['car'] = {
		position = { -2629.68, 1420.19, 8.35 },
		exitPosition = { -2618.46, 1395.7, 7.1 },
		testdrive = { -2618.46, 1395.7, 7.1, 0 },
		size = 8,
		blip = 'carshop',

		preview = {
			vehicle = { -2658.49, 1413.88, 8.11, 0.2, 0.01, 253.03 },
			matrix = { -2651.01, 1415.89, 7.72, -2741.9, 1374.4, 3.77, 0, 70 },
			player = { -2631.62, 1420.7, 8.14 },
		},

		text = '[Автосалон]',

	},
	['water'] = {
		position = { -2257.88, 1683, 5.49 },
		exitPosition = { -2260.07, 1690.73, 7.39 },
		testdrive = { -2417.56, 1600.57, 0.26, 47.07 },
		size = 1,
		visible = true,
		blip = 'watershop',

		preview = {
			vehicle = { -2418.12, 1600.65, 0.31, 3.49, 1.73, 248.11 },
			matrix = { -2399.92, 1606.4, 7.25, -2485.82, 1570.15, -28.92, 0, 70 },
			player = { -2355.49, 1652.06, 7.38 },
		},

		text = '[Водный транспорт]',

	},
}

Config.colors = {
	{ 0, 0, 0 },
	{ 255, 255, 255 },
	{ 180, 70, 70 },
	{ 70, 70, 180, },
	{ 70, 180, 70, },
	{ 180, 180, 70, },
	{ 70, 180, 180, },
	{ 180, 180, 180, },
	{ 180, 70, 180, },
}

Config.testDriveTime = 5*60*1000

Config.gDiscount = 0

Config.finishTestDrive = 'r'

Config.maxVehiclesOfType = 2

Config.calcTestDriveCost = function(vehicleCost)
	return math.floor(vehicleCost*0.01)
end
