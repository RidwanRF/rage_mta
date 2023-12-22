Config = {}

Config.casinoInterior = {

	position = { 0, 0, 1000 },

	dimension = 10,
	interior = 10,

	exit = { 2017.95, 1017.92, 996.88 },
	exit_player = { 2026.47, 1007.68, 10.82 },

	enter = { 2020.85, 1007.9, 10.82 },
	enter_player = { 2008.65, 1017.63, 994.47 },
	-- enter_player = { 0.04, -43.3, 1001.42 },

	exchange = { 1953.34, 1018.62, 992.47 },
	-- exchange = { -0.02, -35.85, 1001.01 },

}

Config.exchange = {
	
	chips = {

		buy = 100,
		sell = 90,

		valute = 'money',

	},

	vip_tickets = {
		buy = 99,
		valute = 'bank.donate',
	},

}

function getConfigSetting(name)
	return Config[name]
end

function setConfigSetting(name, value)
	Config[name] = value
end
