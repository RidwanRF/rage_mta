

Config.games = {


	russian = {

		-- timeout = 1*1000,
		timeout = 30*1000,
		comission = 5,

		table_limit = 5,

		markers = {
			{ 1929.72, 1044.14, 993.96, 90 },
		},

	},
	
	bones = {

		timeout = 30*1000,
		comission = 5,

		markers = {

			{ 1964.95, 1037.68, 991.96, 105 },
			{ 1962.17, 1044.02, 991.96, 129.2 },
			{ 1957.28, 1048.6, 991.97, 149.1 },
			{ 1951.24, 1051.15, 991.96, 174.2 },
			{ 1965, 997.89, 991.96, 79.4 },
			{ 1962.27, 991.67, 991.96, 53.8 },
			{ 1957.42, 987.16, 991.97, 33.2 },
			{ 1951.44, 984.66, 991.96, 14 },

		},

	},

	blackjack = {

		table_limit = 2,

		markers = {

			{ 1963.32, 1028.95, 992.02, 0 },
			{ 1963.32, 1009.15, 992.02, 0 },
			{ 1963.32, 1015.85, 992.02, 0 },
			{ 1963.32, 1022.35, 992.02, 0 },

		},

		random = {

			{ amount = { 12, 15 }, step = 10, },
			{ amount = { 16, 19 }, step = 4, },
			{ amount = { 22, 28 }, step = 8, },
			{ amount = { 19, 21 }, step = 3, },
			{ amount = { 16, 20 }, step = 1, },

		},

	},

	roulette = {

		markers = {

			{ 1940.05, 1015.98, 991.87, 90 },
			{ 1940.05, 1021.18, 991.87, 90 },
			{ 1940.05, 1026.18, 991.87, 90 },
			{ 1940.05, 1010.98, 991.87, 90 },

		},

		bet_limit = 4,
		timeout = 30*1000,

		bets = {

			['default'] = {
				mul = 35,
			},

			['1st_12'] = {
				mul = 3,
				win = { 1,2,3,4,5,6,7,8,9,10,11,12 },
				name = '1-12',
			},

			['2nd_12'] = {
				mul = 3,
				win = { 13,14,15,16,17,18,19,20,21,22,23,24 },
				name = '13-24',
			},

			['3rd_12'] = {
				mul = 3,
				win = { 25,26,27,28,29,30,31,32,33,34,35,36 },
				name = '25-36',
			},

			['1_row'] = {
				mul = 3,
				win = { 1,4,7,10,13,16,19,22,25,28,31,34, },
				name = '1-й ряд',
			},

			['2_row'] = {
				mul = 3,
				win = { 2,5,8,11,14,17,20,23,26,29,32,35, },
				name = '2-й ряд',
			},

			['3_row'] = {
				mul = 3,
				win = { 3,6,9,12,15,18,21,24,27,30,33,36, },
				name = '3-й ряд',
			},

			['1_to_18'] = {
				mul = 2,
				win = { 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18 },
				name = '1-18',
			},

			['19_to_36'] = {
				mul = 2,
				win = { 19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36 },
				name = '19-36',
			},

			['red'] = {
				mul = 2,
				win = { 1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36 },
				name = 'красное',
			},

			['black'] = {
				mul = 2,
				win = { 2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35 },
				name = 'черное',
			},

			['odd'] = {
				mul = 2,
				win = { 1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35 },
				name = 'нечетное',
			},

			['even'] = {
				mul = 2,
				win = { 2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36 },
				name = 'четное',
			},



		},

	},

	slots = {

		jackpot_percent = 1,
		jackpot_min = 1000,
		jackpot_step = 200,

		markers = {

			{ 1953.59, 990.9, 992.87, 210 },
			{ 1955.24, 991.91, 992.87, 210 },
			{ 1957.39, 994.24, 992.87, 240 },
			{ 1958.41, 996.17, 992.87, 240 },
			{ 1948.77, 1039.74, 992.87, 90 },
			{ 1948.77, 1043.98, 992.87, 90 },
			{ 1948.77, 1041.18, 992.87, 90 },
			{ 1948.77, 1042.58, 992.87, 90 },

		},

		prizes = {

			[1] = { mul = '1.5', chance = 12 },
			[2] = { mul = '2.0', chance = 9 },
			[3] = { mul = '2.5', chance = 5 },
			[4] = { mul = '3.0', chance = 3 },
			[5] = { mul = '0.0', },

		},

	},

	fortune = {

		button = 'f',
		default_cost = 500,

		vehicle = { 1993.81, 1017.9, 994.72, 300, model = 580 },

		markers = {
			{ 1980.51, 1017.4, 995.47, 90.39, type = 'vip' },
			{ 1972.97, 1043.41, 995.47,  30.5,  type = 'default' },
			{ 1972.83, 991.5, 995.47, 135.21,  type = 'default' },

		},

		prizes = {

			top_step = { default = 40, vip = 40, },

			default = {

				{
					data = { type = 'chips', amount = 800 },
					name = '800 фишек',
					chance = 14, notify = true,
				},

				{
					data = { type = 'ban' },
					name = 'Бан',
					chance = 6, notify = true,
				},

				{
					data = { type = 'skin', model = 23 },
					name = 'Скин Молодой Бизнесмен',
					chance = 1, top = true, notify = true,
					alt_cost = { valute = 'money', amount = 30000 },
				},

				{
					data = { type = 'chips', amount = 2500 },
					name = '2500 фишек',
					chance = 3, top = true, notify = true,
				},

				{
					data = { type = 'prison_ticket', amount = 3 },
					name = '3 билета свободы',
					chance = 12, notify = true,
				},

				{
					data = { type = 'chips', amount = 50 },
					name = '50 фишек',
					chance = 4, notify = true,
				},

				{
					data = { type = 'vip', amount = 3600*3 },
					name = 'VIP 3 часа',
					chance = 6, notify = true,
				},

				{
					data = { type = 'prison_ticket', amount = 10 },
					name = '10 билетов свободы',
					chance = 6, notify = true,
				},

				{
					data = { type = 'prison_ticket', amount = 5 },
					name = '5 билетов свободы',
					chance = 10, notify = true,
				},

				{
					data = { type = 'chips', amount = 1500 },
					name = '1500 фишек',
					chance = 7, top = true, notify = true,
				},

				{
					data = { type = 'vip', amount = 86400 },
					name = 'VIP 1 день',
					chance = 10, notify = true,
				},

				{
					data = { type = 'chips', amount = 150 },
					name = '150 фишек',
					chance = 12, notify = true,
				},
				
				{
					data = { type = 'pack', pack = 1, amount = 1 },
					name = 'Кейс Новичок',
					chance = 1, notify = true,
				},

				{
					data = { type = 'chips', amount = 1000 },
					name = '1000 фишек',
					chance = 9, notify = true,
				},

				{
					data = { type = 'pack', pack = 7, amount = 1 },
					name = 'Кейс Бомжичок',
					chance = 1, notify = true,
				},

				{
					data = { type = 'chips', amount = 500 },
					name = '500 фишек',
					chance = 14, notify = true,
				},




			},

			vip = {

				{
					data = { type = 'chips', amount = 200 },
					name = '200 фишек',
					chance = 10, notify = true,
				},

				{
					data = { type = 'vip', amount = 86400 },
					name = 'VIP 1 день',
					chance = 8, notify = true,
				},

				{
					data = { type = 'vehicle' },
					name = 'Автомобиль',
					chance = 1, top = true, notify = true,
				},

				{
					data = { type = 'pack', pack = 3, amount = 1 },
					name = 'Кейс Джуди',
					chance = 13, notify = true,
				},

				{
					data = { type = 'chips', amount = 1000 },
					name = '1000 фишек',
					chance = 17, notify = true,
				},

				{
					data = { type = 'money', amount = 20000 },
					name = '$20.000',
					chance = 8, notify = true,
				},

				{
					data = { type = 'skin', model = 31 },
					name = 'Скин Нефтяной Магнат',
					chance = 1,  notify = true,
				},

				{
					data = { type = 'pack', pack = 5, amount = 1 },
					name = 'Кейс Мажор',
					chance = 9, top = true, notify = true,
				},

				{
					data = { type = 'vip', amount = 86400*7 },
					name = 'VIP 7 дней',
					chance = 7, notify = true,
				},

				{
					data = { type = 'prison_ticket', amount = 1 },
					name = 'Билет свободы',
					chance = 2, notify = true,
				},

				{
					data = { type = 'chips', amount = 700 },
					name = '700 фишек',
					chance = 4, notify = true,
				},

				{
					data = { type = 'vip', amount = 86400*3 },
					name = 'VIP 3 дня',
					chance = 13, notify = true,
				},

				{
					data = { type = 'pack', pack = 2, amount = 1 },
					name = 'Кейс RAGE',
					chance = 7, notify = true,
				},

				{
					data = { type = 'chips', amount = 200 },
					name = '200 фишек',
					chance = 11, notify = true,
				},

				{
					data = { type = 'money', amount = 70000 },
					name = '$70.000',
					chance = 11, notify = true,
				},


				{
					data = { type = 'skin', model = 79 },
					name = 'Скин Араб',
					chance = 1, notify = true,
					alt_cost = { valute = 'bank.donate', amount = 99 },
				},


			},

		},

	},

}
