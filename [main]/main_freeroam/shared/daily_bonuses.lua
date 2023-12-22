
Config.db_receiveTime = 30*60*1000

Config.dailyBonuses = {

	{
		rewards = {

			{

				name = 'Билет свободы x5',
				image = 'assets/images/packs/items/ticket.png',

				give = function(player, mul)
					increaseElementData( player, 'prison.tickets', 5*mul )
				end,

			},

		},
	},

	{
		rewards = {

			{

				name = '70 R-Coin',
				image = 'assets/images/donate.png',

				give = function(player, mul)

					increaseElementData(player, 'bank.donate', 70*mul)

				end,

			},

		},
	},

	{
		rewards = {

			{

				name = '$20.000',
				image = 'assets/images/bonuses/money.png',

				give = function(player, mul)
					exports.money:givePlayerMoney(player, 20000*mul)
				end,

			},

		},
	},

	{
		rewards = {

			{

				name = '$35.000',
				image = 'assets/images/bonuses/money.png',

				give = function(player, mul)
					exports.money:givePlayerMoney(player, 35000*mul)
				end,

			},

		},
	},

	{
		rewards = {

			{

				name = 'Кейс бомжичок',
				image = 'assets/images/packs/7.png',

				give = function(player, mul)
					givePlayerPack(player, 7, 1*mul)
				end,

			},

		},
	},

	{
		rewards = {

			{

				name = '30 R-Coin',
				image = 'assets/images/donate.png',

				give = function(player, mul)

					increaseElementData(player, 'bank.donate', 30*mul)

				end,

			},

			{

				name = 'VIP 1 день',
				image = 'assets/images/packs/items/vip.png',

				give = function(player, mul)
					exports.main_vip:giveVip( player.account.name, 86400*1*mul )
				end,

			},

		},
	},

	{
		rewards = {

			{

				name = '$40.000',
				image = 'assets/images/bonuses/money.png',

				give = function(player, mul)
					exports.money:givePlayerMoney(player, 40000*mul)
				end,

			},

		},
	},

	{
		rewards = {

			{

				name = 'Кейс Новичок',
				image = 'assets/images/packs/1.png',

				give = function(player, mul)
					givePlayerPack(player, 1, 1*mul)
				end,

			},


		},
	},

	{
		rewards = {

			{

				name = '$60.000',
				image = 'assets/images/bonuses/money.png',

				give = function(player, mul)
					exports.money:givePlayerMoney(player, 60000*mul)
				end,

			},

		},
	},

	{
		rewards = {

			{

				name = 'Скидочный 100%',
				image = 'assets/images/packs/items/discount.png',

				give = function(player, mul)

					for i = 1, 1*mul do
						addConvertPromo( player, nil, 100 )
					end

				end,

			},

		},
	},

}