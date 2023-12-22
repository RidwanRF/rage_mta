Config = {}


Config.defaultCoords = {
	{ -2360.26, 1743.92, 7.09 },
	{ -2363.02, 1742.58, 7.09 },
	{ -2363.97, 1739.33, 7.09 },
}

Config.defaultSkin = 22

function getConfigSetting(name)
	return Config[name]
end