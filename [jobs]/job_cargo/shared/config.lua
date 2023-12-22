
Config = {}

Config.resourceName = getThisResource().name

Config.stations = {
	{ marker = { -2036.99, -123.71, 35.2 },},
}

Config.money = {24,32}
Config.skin = 43

Config.orders = {
	{ -2055.59, -191.19, 34.42 },
	{ -2065.76, -191.19, 34.42 },
	{ -2082.8, -191.19, 34.42 },
}

Config.destination = { -2087.07, -131.56, 34.42, 0, }

function getConfigSetting(name)
	return Config[name]
end

function setConfigSetting(name, value)
	Config[name] = value
end
