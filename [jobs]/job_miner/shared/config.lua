
Config = {}

Config.resourceName = getThisResource().name

Config.stations = {
	{ marker = { -1913.1, -1512.69, 29.04 },},
}

Config.money = {25,32}
Config.skin = 46

Config.orderHealth = 3

Config.orders = {
	{ -1934.8, -1530.24, 30.54 },
	{ -1946.11, -1518.85, 36.68 },
	{ -1939.8, -1505.52, 29.93 },
}

Config.destination = { -1914.44, -1520.8, 27.8, 0, }

function getConfigSetting(name)
	return Config[name]
end

function setConfigSetting(name, value)
	Config[name] = value
end
