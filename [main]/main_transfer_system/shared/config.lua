
Config = {}

Config.freeLevel = 5

Config.positions = {
	
	{

		from = { -2553.06, 1434.13, 3.06, name = 'Лакшери' },
		to = { -2357.03, 1644.29, 6.38, name = 'Сан-Фиерро' },

		cost = 1000,
		blip = true,

		type = 'water',
		
	},

}

function getConfigSetting(index)
	return Config[index]
end
