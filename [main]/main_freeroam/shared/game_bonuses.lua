
Config.game_bonuses = {
	
	{
		name = 'Silver BOX',
		image = 'assets/images/game_bonuses/silver.png',

		color = { 190, 190, 190 },

		play_hours = 3,
		id = 'silver',

		rewards = {

			{

				name = 'Скидочный промокод 10%',
				image = 'assets/images/packs/items/discount.png',
				data = { type = 'discount', percent = 10 },

			},

			{

				name = 'VIP 1 час',
				image = 'assets/images/packs/items/vip.png',
				data = { type = 'vip', amount = 3600 },

			},

			{

				name = 'Жетон для колеса фортуны',
				image = 'assets/images/bonuses/casino_default_ticket.png',
				data = { type = 'casino_default_ticket', amount = 1 },

			},

			{

				name = '$10.000',
				image = 'assets/images/bonuses/money.png',

				data = { type = 'money', amount = 10000 },

			},

			{

				name = '$5.000',
				image = 'assets/images/bonuses/money.png',

				data = { type = 'money', amount = 5000 },

			},

			{

				name = 'Кейс Бомжичок',
				image = 'assets/images/packs/7.png',

				data = { type = 'pack', pack = 7, amount = 1 },

			},

			{

				name = '3 билета свободы',
				image = 'assets/images/packs/items/ticket.png',

				data = { type = 'prison_ticket', amount = 3 },

			},

		},

	},
	
	{
		name = 'VIP BOX',
		image = 'assets/images/game_bonuses/vip.png',

		color = { 230, 160, 60 },

		play_hours = 6,
		id = 'vip',

		rewards = {

			{

				name = 'Кейс Новичок',
				image = 'assets/images/packs/1.png',

				data = { type = 'pack', pack = 1, amount = 1 },

			},

			{

				name = 'Жетон для VIP-колеса фортуны',
				image = 'assets/images/bonuses/casino_vip_ticket.png',
				data = { type = 'casino_vip_ticket', amount = 1 },

			},

			{

				name = 'Скидочный промокод 30%',
				image = 'assets/images/packs/items/discount.png',
				data = { type = 'discount', percent = 30 },

			},

			{

				name = '$20.000',
				image = 'assets/images/bonuses/money.png',

				data = { type = 'money', amount = 20000 },

			},

			{

				name = '$10.000',
				image = 'assets/images/bonuses/money.png',

				data = { type = 'money', amount = 10000 },

			},

			{

				name = 'VIP 3 часа',
				image = 'assets/images/packs/items/vip.png',
				data = { type = 'vip', amount = 3600*3 },

			},

		},

	},
	
	{
		name = 'Platinum BOX',
		image = 'assets/images/game_bonuses/platinum.png',

		color = { 130, 250, 170 },

		play_hours = 10,
		id = 'platinum',

		rewards = {

			{

				name = 'VIP 12 часов',
				image = 'assets/images/packs/items/vip.png',
				data = { type = 'vip', amount = 3600*12 },

			},

			{

				name = 'Жетон VIP-колеса фортуны x3',
				image = 'assets/images/bonuses/casino_vip_ticket.png',
				data = { type = 'casino_vip_ticket', amount = 3 },

			},

			{

				name = 'Скидочный промокод 50%',
				image = 'assets/images/packs/items/discount.png',
				data = { type = 'discount', percent = 50 },

			},

			{

				name = 'Кейс Новичок',
				image = 'assets/images/packs/1.png',

				data = { type = 'pack', pack = 1, amount = 1 },

			},

			{

				name = 'Кейс RAGE',
				image = 'assets/images/packs/2.png',

				data = { type = 'pack', pack = 2, amount = 1 },

			},

			{

				name = 'Кейс Королевский',
				image = 'assets/images/packs/4.png',

				data = { type = 'pack', pack = 4, amount = 1 },

			},

			{

				name = '$15.000',
				image = 'assets/images/bonuses/money.png',

				data = { type = 'money', amount = 15000 },

			},

			{

				name = '$40.000',
				image = 'assets/images/bonuses/money.png',

				data = { type = 'money', amount = 40000 },

			},

		},

	},

}

Config.game_bonuses_assoc = {}

for _, bonus in pairs( Config.game_bonuses ) do
	Config.game_bonuses_assoc[ bonus.id ] = bonus
end