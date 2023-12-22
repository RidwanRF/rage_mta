Config = {}

local index = exports.core:getServerIndex()

local bonuses = {

	{

		name = '$10.000 и скутер',

		give = function(player)

			exports.money:givePlayerMoney(player, 10000)
			exports.vehicles_main:giveAccountVehicle(player.account.name, 462)

		end,
	
	},

	{

		name = '$10.000 и скутер',

		give = function(player)

			exports.money:givePlayerMoney(player, 10000)
			exports.vehicles_main:giveAccountVehicle(player.account.name, 462)

		end,

	},

}
	
Config.startBonus = bonuses[index]