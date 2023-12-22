Config = {}

Config.markers = {
	{ position = { 1393.78, 686.46, 9.82 }, blip = true },
	{ position = { 1393.78, 697.66, 9.82 }, },
	{ position = { 1393.78, 692.16, 9.82 }, },
	{ position = { 194.73, -1440.59, 12.12, 315, }, blip = true },
	{ position = { 202.64, -1448.5, 12.12, 315, }, },
	{ position = { 198.72, -1444.58, 12.12, 315, }, },
}

Config.defaultRepositorySize = 10
Config.maxRepositorySize = 20


Config.expandCost = 100

Config.minResetCost = 30000

Config.resetCost = 50000
Config.resetCost2 = 100000

Config.clearCost = 30000
Config.clearCost2 = 100000

Config.expireTime = 30*86400

Config.clearFlagCost = 100000

Config.numberHints = {
	['a'] = 'Англ. прописные символы',
	['k'] = 'Англ. прописные символы',
	['e'] = 'Англ. заглавные символы',
	['f'] = 'Англ. заглавные символы',
	['g'] = 'Англ. заглавные символы',
	['h'] = 'Англ. символы',
	['m'] = 'Англ. символы',
	['n'] = 'Англ. символы',
	['j'] = 'Англ. прописные символы',
	['o'] = 'Англ. прописные символы',
	['p'] = 'Англ. прописные символы',
	['q'] = 'Англ. прописные символы',
}

function getConfigSetting(name)
	return Config[name]
end