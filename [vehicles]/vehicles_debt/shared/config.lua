Config = {}

Config.key = '0'
Config.discount = 30

function getConfigSetting(name)
	return Config[name]
end

function setConfigSetting(name, value)
	Config[name] = value
end