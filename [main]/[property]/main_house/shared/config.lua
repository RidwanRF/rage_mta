Config = {}

Config.donateConvertMul = exports['core']:getDonateConvertMul()

Config.sellMul = 0.5

Config.maxHouses = 3

Config.lotsExtend = {
	donate = { 100, 150, 200 },
	rub = { 200000, 250000, 300000 },
}

Config.maxLotsExtend = 3

Config.interiors = {
	{
		interior = 5,
		enter = { 2233.33, -1111.11, 1050.88, 0 },
		marker = { 2233.03, -1107.5, 1050.88 - 0.8 },
		exit = { 2233.64, -1114.33, 1050.88 - 0.8 },
		name = 'Обычный #1',
		crypt = { 2818.2158203125, -1165.8868408203, 1029.171875 },
	},
	{
		interior = 8,
		enter = { 2811.83, -1169.7, 1025.57, 79.54 },
		marker = { 2807.76, -1172.97, 1025.57 - 0.8 },
		exit = { 2812.16, -1169.8, 1025.57 - 0.8 },
		name = 'Средний #1',
		crypt = { 2818.2158203125, -1165.8868408203, 1029.171875 },
	},
	{
		interior = 12,
		enter = { 2317.53, -1147.69, 1050.7, 305.96 },
		marker = { 2324.25, -1143.41, 1050.49 - 0.8 },
		exit = { 2324.36, -1148.88, 1050.71 },
		name = 'Элитный #1',
		crypt = { 2818.2158203125, -1165.8868408203, 1029.171875 },
	},
	{
		interior = 5,
		enter = { 1264.61, -782.09, 1091.91, 276.01 },
		marker = { 1276.58, -790.12, 1089.94 - 0.8 },
		exit = { 1261.76, -785.87, 1091.91 - 0.8 },
		name = 'Донатный #1',
		crypt = { 2818.2158203125, -1165.8868408203, 1029.171875 },
	},
}

Config.houseExitKey = 'tab'

function getConfigSetting(name)
	return Config[name]
end