
Config = {}

Config.resourceName = getThisResource().name

Config.stations = {
	
	{ marker = { -2357.34, 1006.6, 50.9 }, start = {
		{ -2347.49, 982.2, 50.3, 6.73 },
		{ -2341.32, 983.35, 50.3, 9.23 },
		{ -2334.82, 984.3, 50.3, 9.6 },
	},
	},

}

Config.vehicle = 448
Config.skin = 45
Config.money = {90,130}

Config.orders = {

	{ vehicle = { -2164.47, 1257.8, 26.53, 90, }, deliver = { -2152.75, 1249.17, 24.7, 0, }, },
	{ vehicle = { -2013.74, 842.37, 44.45, 0, }, deliver = { -2017.84, 832.86, 44.45, 0, }, },
	{ vehicle = { -2641.52, 817.04, 48.98, 0, }, deliver = { -2652.7, 819.58, 48.99, 0, }, },
	{ vehicle = { -2852.39, 833.13, 39.96, 0, }, deliver = { -2858.22, 835.18, 39.12, 0, }, },
	{ vehicle = { -2716.99, -33.32, 3.34, 0, }, deliver = { -2724.65, -36.74, 5.86, 0, }, },
	{ vehicle = { -2614.46, -196.33, 3.34, 0, }, deliver = { -2621.24, -198.21, 3.34, 0, }, },
	{ vehicle = { -2233.57, 576.11, 34.17, 0, }, deliver = { -2240.83, 577.51, 34.17, 0, }, },
	{ vehicle = { -2276.37, 924.1, 65.65, 0, }, deliver = { -2281.47, 916.77, 65.65, 0, }, },
	{ vehicle = { -1768.74, 1176.49, 24.13, 0, }, deliver = { -1761.26, 1174.76, 24.13, 0, }, },
	{ vehicle = { -2105.29, 738.7, 68.56, 0, }, deliver = { -2111.67, 745.2, 68.56, 0, }, },
	{ vehicle = { -2592.72, 150.45, 3.34, 0, }, deliver = { -2586.6, 148.23, 3.34, 0, }, },
	{ vehicle = { -2764.55, 21.13, 6.02, 0, }, deliver = { -2778.39, 21.04, 6.18, 0, }, },
	{ vehicle = { -2758.38, -115.64, 5.95, 0, }, deliver = { -2777.38, -115.81, 6.18, 0, }, },
	{ vehicle = { -2462.99, -132.29, 24.68, 0, }, deliver = { -2455.42, -135.85, 25.14, 0, }, },
	{ vehicle = { -2244.76, 166.53, 34.32, 0, }, deliver = { -2242.66, 174.65, 34.32, 0, }, },
	{ vehicle = { -2014.04, 890.4, 44.45, 0, }, deliver = { -2016.1, 897.2, 44.45, 0, }, },
	{ vehicle = { -2276.32, 1100.93, 79.01, 0, }, deliver = { -2281.58, 1088.91, 79.3, 0, }, },
	{ vehicle = { -2374.07, 1344.61, 9.88, 0, }, deliver = { -2381.5, 1336.41, 11.72, 0, }, },
	{ vehicle = { -2897.22, 1174.7, 11.32, 0, }, deliver = { -2903.02, 1178.58, 12.59, 0, }, },
	{ vehicle = { -2718.42, 978.64, 53.46, 0, }, deliver = { -2711.39, 968.91, 53.46, 0, }, },


}

Config.race_orders = math.min( #Config.orders, 5 )

function getConfigSetting(name)
	return Config[name]
end

function setConfigSetting(name, value)
	Config[name] = value
end
