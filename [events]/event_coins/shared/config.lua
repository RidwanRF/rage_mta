Config = {}

Config.key = 'f4'

Config.farm_key = 'df09egj9845'

Config.coinsLimit = 1000000

Config.seasons = {
	
	[1] = { start_at = '28.02' },
	[2] = { start_at = '05.03' },
	[3] = { start_at = '10.03' },

}

Config.upgrades = {
	
	{

		name = 'Курсор',

		limit = 20,
		add = 1,

		cost = 500,

		farm_type = 'active',

		color = {180,70,70},

	},
	
	{

		name = 'Кликан',

		limit = 20,
		add = 2,

		cost = 1000,

		farm_type = 'active',

		color = {80, 60, 150},

	},
	
	{

		name = 'Квантовик',

		limit = 20,
		add = 3,

		cost = 1500,

		farm_type = 'active',

		color = {120, 50, 90},

	},
	
	{

		name = 'Сервер RAGE',

		limit = 20,
		add = 4,

		cost = 500,

		farm_type = 'passive',

		color = {180, 70, 70},

	},
	
	{

		name = 'Видеокарта',

		limit = 20,
		add = 5,

		cost = 1000,

		farm_type = 'passive',

		color = {80, 60, 150},

	},
	
	{

		name = 'Датацентр',

		limit = 20,
		add = 6,

		cost = 1500,

		farm_type = 'passive',

		color = {120, 50, 90},

	},

}

Config.prizes = {
	
	{ prize = '3.000 рублей на эл. кошелек', give = function( login )
		increaseUserData( login, 'referal.balance', 3000 )
	end },
	
	{ prize = '2.000 рублей на эл. кошелек', give = function( login )
		increaseUserData( login, 'referal.balance', 2000 )
	end },
	
	{ prize = '1.000 рублей на эл. кошелек', give = function( login )
		increaseUserData( login, 'referal.balance', 1000 )
	end },
	
	{ prize = 'BMW X5 2020', give = function( login )
		exports.vehicles_main:giveAccountVehicle( login, 477 )
	end },
	
	{ prize = 'BMW M5 F90', give = function( login )
		exports.vehicles_main:giveAccountVehicle( login, 479 )
	end },
	
	{ prize = 'Mercedes E63S', give = function( login )
		exports.vehicles_main:giveAccountVehicle( login, 598 )
	end },
	
	{ prize = '$150.000', give = function( login )
		increaseUserData( login, 'money', 150000 )
	end },
	
	{ prize = '$100.000', give = function( login )
		increaseUserData( login, 'money', 100000 )
	end },
	
	{ prize = 'BMW G20', give = function( login )
		exports.vehicles_main:giveAccountVehicle( login, 546 )
	end },
	
	{ prize = 'Кейс Абу Бандит x2', give = function( login )
		exports.main_freeroam:giveAccountPack( getAccount(login), 6, 2 )
	end },
	
	{ prize = 'Кейс Мажор x2', give = function( login )
		exports.main_freeroam:giveAccountPack( getAccount(login), 5, 2 )
	end },
	
	{ prize = 'Кейс Королевский x2', give = function( login )
		exports.main_freeroam:giveAccountPack( getAccount(login), 4, 2 )
	end },
	
	{ prize = 'Кейс Джуди x2', give = function( login )
		exports.main_freeroam:giveAccountPack( getAccount(login), 3, 2 )
	end },
	
	{ prize = 'Кейс RAGE x2', give = function( login )
		exports.main_freeroam:giveAccountPack( getAccount(login), 2, 2 )
	end },
	
	{ prize = 'Кейс Новичок x2', give = function( login )
		exports.main_freeroam:giveAccountPack( getAccount(login), 1, 2 )
	end },
	
	{ prize = 'VIP 14 дней', give = function( login )
		exports.main_vip:giveVip( login, 86400*14 )
	end },
	
	{ prize = 'VIP 7 дней', give = function( login )
		exports.main_vip:giveVip( login, 86400*7 )
	end },
	
	{ prize = '$60.000', give = function( login )
		increaseUserData( login, 'money', 60000 )
	end },
	
	{ prize = '$50.000', give = function( login )
		increaseUserData( login, 'money', 50000 )
	end },
	
	{ prize = 'VIP 3 дня', give = function( login )
		exports.main_vip:giveVip( login, 86400*3 )
	end },

}