Config = {}


Config.resourceName = getThisResource().name

Config.starsPrisonTime = 5*60

Config.stars = {
	kill = 2,
}

function getConfigSetting(name)
	return Config[name]
end
