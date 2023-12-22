Config = {}

Config.serverIndex = exports.core:getServerIndex()
Config.playersMax = 500

Config.serverNames = {
	'#1', '#2', '#3',
}

Config.serverName = string.format('SERVER %s', Config.serverNames[Config.serverIndex])
