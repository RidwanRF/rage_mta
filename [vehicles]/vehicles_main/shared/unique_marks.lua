
Config.uniqueMarks = {

	golden = {
		postfix = '«GOLDEN»',
		color = {250,232,70},
	},

	referal = {
		postfix = '«REFERAL»',
		color = {35,230,255},
	},

	abu_bandit = {
		postfix = '«АБУ»',
		color = {200,200,200},
	},

	d3 = {
		postfix = 'd3',
		color = {255,220,0},
	},

	pososi = {
		postfix = '«пОСОси»',
		color = {255,200,0},
	},

	n666 = {
		postfix = '«666»',
		color = {200,200,255},
	},

	milliondollar = {
		postfix = '«$»',
		color = {0,150,255},
	},

}

-- exports.vehicles_main:giveAccountVehicle('broker', 598, { unique_mark = 'pososi', appearance_upgrades = { tuning_block = 1, tuning = { trunk_badge = 'trunk_badge_2' } } })
-- exports.vehicles_main:giveAccountVehicle('broker', 402, { unique_mark = 'milliondollar', appearance_upgrades = { color_1 = '#0095ff', tuning_block = 1, tuning = { morgenshtern = 'morgenshtern_1' } } })
-- exports.vehicles_main:giveAccountVehicle('broker', 541, { unique_mark = 'n666', appearance_upgrades = { color_1 = '#ff8800', tuning_block = 1, tuning = { morgenshtern = 'morgenshtern_1' } } })

function getVehicleUniqueMark( mark )
	return Config.uniqueMarks[mark]
end