Config = {}

Config.derrick = {
	
	fix_cost = 200,

	course = {
		default = 1000,
		change_range = { 0, 20 },
		change_step = 1,
	},

	levels = {

		{
			health = 8,
			payment_mul = 1,
			cost = 0,
			name = 'Базовый',
		},

		{
			health = 10,
			payment_mul = 1.1,
			cost = 60000,
			name = 'Средний',
		},

		{
			health = 15,
			payment_mul = 1.2,
			cost = 130000,
			name = 'Высокий',
		},

		{
			health = 30,
			payment_mul = 1.5,
			cost = 300000,
			name = 'Магнат',
		},

	},

}



Config.fixTimeout = 1*60*1000

Config.maxOilDerricks = 1

Config.sellMul = 0.5

function getConfigSetting(name)
	return Config[name]
end