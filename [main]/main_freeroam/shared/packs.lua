
Config.packs = {
	{

		name = 'Новичок',
		icon = 'assets/images/packs/1.png',

		color = {0, 0, 255},

		cost = 50,
		top_step = 35,

		items = {

			{
				name = 'BMW E70',
				icon = 'assets/images/packs/items/BMW_X5_E70.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 490)
				end,
				chance = 1,
				top = true,
				notify = true,

				img_scale = 1.3,

			},

			{
				name = 'BMW E60',
				icon = 'assets/images/packs/items/BMW_M5_E60.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 550)
				end,
				chance = 7,
				top = true,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'BMW E92',
				icon = 'assets/images/packs/items/BMW_M3_E92.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 562)
				end,
				chance = 8,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = '$50.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 50000)
				end,
				chance = 8,
			},

			{
				name = 'VIP 7 дней',
				icon = 'assets/images/packs/items/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400*7)
				end,
				chance = 12,
			},

			{
				name = 'Скидочный промокод 10%', 
				tooltip = '10%',
				icon = 'assets/images/packs/items/discount.png',
				give = function(player)
					addConvertPromo(player, nil, 10)
				end,
				chance = 17,
			},

			{
				name = '40.000$',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 40000)
				end,
				chance = 22,
			},

			{
				name = 'VIP 1 день',
				icon = 'assets/images/packs/items/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400*1)
				end,
				chance = 36,
			},

			{
				name = '$30.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 30000)
				end,
				chance = 36,
			},

			{
				name = 'VIP 12 часов',
				icon = 'assets/images/packs/items/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 3600*12)
				end,
				chance = 42,
			},

			{
				name = '$15.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 15000)
				end,
				chance = 60,
			},

			{
				name = '$5.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 5000)
				end,
				chance = 110,
			},


		},

		 hit = true,

	},

	{

		name = 'XRAGE',
		icon = 'assets/images/packs/2.png',
		color = {180, 70, 70},

		cost = 100,
		top_step = 29,

		items = {

			{
				name = 'BMW M8',
				icon = 'assets/images/packs/items/BMW_M8.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 555)
				end,
				chance = 1,
				top = true,
				notify = true,

				img_scale = 1.3,


			},

			{
				name = 'Porsche 911',
				icon = 'assets/images/packs/items/Porsche_911.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 541)
				end,
				chance = 2,
				top = true,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'Audi R8',
				icon = 'assets/images/packs/items/Audi_R8.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 439)
				end,
				chance = 4,
				top = true,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'Скин',
				icon = 'assets/images/packs/items/reggi.png',
				give = function(player)
					exports.main_clothes:addWardrobeClothes(player.account.name, 15, true)
				end,

				sellCost = 130000,

				chance = 5,
			},

			{
				name = '$100.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 100000)
				end,
				chance = 8,
			},

			{
				name = 'VIP 3 дня',
				icon = 'assets/images/packs/items/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400*3)
				end,
				chance = 13,
			},

			{
				name = '30 RC',
				icon = 'assets/images/donate.png',
				give = function(player)
					increaseElementData(player, 'bank.donate', 30)
				end,
				chance = 17,
			},

			{
				name = '$50.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 50000)
				end,
				chance = 25,
			},

			{
				name = 'VIP 3 часа',
				icon = 'assets/images/packs/items/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 3600*3)
				end,
				chance = 30,
			},

			{
				name = '$20.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 20000)
				end,
				chance = 65,
			},

			{
				name = '20 RC',
				icon = 'assets/images/donate.png',
				give = function(player)
					increaseElementData(player, 'bank.donate', 20)
				end,
				chance = 70,
			},

			{
				name = 'Билет х2',
				icon = 'assets/images/packs/items/ticket.png',
				give = function(player)
					increaseElementData(player, 'prison.tickets', 2)
				end,
				chance = 30,
			},


		},

		hit = true,

	},

	{

		name = 'Джуди',
		icon = 'assets/images/packs/3.png',
		color = {255,0,255},

		oldCost = 220,
		cost = 150,
		top_step = 150,

		items = {

			{
				name = '$3.000.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 3000000)
				end,
				chance = 10,
				top = true,
				notify = true,
			},

			{
				name = '350 RC',
				icon = 'assets/images/donate.png',
				give = function(player)
					increaseElementData(player, 'bank.donate', 350)
				end,
				chance = 3,
				notify = true,
			},

			{
				name = 'Абу Бандит',
				icon = 'assets/images/packs/6.png',
				give = function(player)
					exports.main_freeroam:givePlayerPack(player, 6, 1)
				end,
				chance = 6,
				notify = true,
			},

			{
				name = '200 RC',
				icon = 'assets/images/donate.png',
				give = function(player)
					increaseElementData(player, 'bank.donate', 200)
				end,
				chance = 9,
				notify = true,
			},

			{
				name = 'Nissan GT-R35',
				icon = 'assets/images/packs/items/r35.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 494)
				end,
				chance = 12,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'BMW M2',
				icon = 'assets/images/packs/items/m2.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 602)
				end,
				chance = 17,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'BMW E92',
				icon = 'assets/images/packs/items/e92.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 562)
				end,
				chance = 17,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'Nissan 370Z',
				icon = 'assets/images/packs/items/370z.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 451)
				end,
				chance = 40,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'Кейс RAGE',
				icon = 'assets/images/packs/2.png',
				give = function(player)
					exports.main_freeroam:givePlayerPack(player, 2, 1)
				end,
				chance = 45,
				notify = true,
			},

			{
				name = 'VIP 1 день',
				icon = 'assets/images/packs/items/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400)
				end,
				chance = 25,
			},

			{
				name = 'Билет x2',
				icon = 'assets/images/packs/items/ticket.png',
				give = function(player)
					increaseElementData(player, 'prison.tickets', 2)
				end,
				chance = 60,
			},

			{
				name = '$10.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 10000)
				end,
				chance = 60,
			},


		},

		hit = true,

	},

	{

		name = 'Королевский',
		icon = 'assets/images/packs/4.png',

		color = {255, 160, 0},

		cost = 225,
		top_step = 32,

		items = {

			{
				name = '$10.000.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 10000000)
				end,
				chance = 0,
				top = true,
				notify = true,
			},

			{
				name = '$5.000.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 5000000)
				end,
				chance = 0,
				top = true,
				notify = true,
			},

			{
				name = 'Ferrari Italia',
				icon = 'assets/images/packs/items/Ferrari_Italia.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 491)
				end,
				chance = 30,
				top = true,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = '100 RC',
				icon = 'assets/images/donate.png',
				give = function(player)
					increaseElementData(player, 'bank.donate', 100)
				end,
				chance = 7,
				notify = true,
			},

			{
				name = 'VIP 14 дней',
				icon = 'assets/images/packs/items/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400*14)
				end,
				chance = 10,
			},

			{
				name = 'Скин',
				icon = 'assets/images/packs/items/sead_kal.png',
				give = function(player)
					exports.main_clothes:addWardrobeClothes(player.account.name, 25, true)
				end,

				sellCost = 175000,

				chance = 15,
			},

			{
				name = 'VIP 7 дней',
				icon = 'assets/images/packs/items/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400*7)
				end,
				chance = 20,
			},

			{
				name = '$150.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 150000)
				end,
				chance = 28,
			},

			{
				name = '70 RC',
				icon = 'assets/images/donate.png',
				give = function(player)
					increaseElementData(player, 'bank.donate', 70)
				end,
				chance = 35,
			},

			{
				name = '$50.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 50000)
				end,
				chance = 58,
			},

			{
				name = '60 RC',
				icon = 'assets/images/donate.png',
				give = function(player)
					increaseElementData(player, 'bank.donate', 60)
				end,
				chance = 85,
			},

			{
				name = 'Билет х5',
				icon = 'assets/images/packs/items/ticket.png',
				give = function(player)
					increaseElementData(player, 'prison.tickets', 5)
				end,
				chance = 35,
			},


		},

		hit = true,

	},

	{

		name = 'Мажор',
		icon = 'assets/images/packs/5.png',
		color = {100, 100, 250},

		oldCost = 420,
		cost = 350,
		top_step = 23,

		items = {

			{
				name = 'SVJ',
				icon = 'assets/images/packs/items/Lamborghini_SVJ.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 542)
				end,
				chance = 1,
				top = true,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'RR Phantom',
				icon = 'assets/images/packs/items/Rolls_Royce_Phantom.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 604)
				end,
				chance = 7,
				top = true,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'RR Cullinan',
				icon = 'assets/images/packs/items/Rolls_Royce_Cullinan.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 566)
				end,
				chance = 7,
				top = true,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'Huracan',
				icon = 'assets/images/packs/items/Lamborghini_Huracan.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 415)
				end,
				chance = 7,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'McLaren P1',
				icon = 'assets/images/packs/items/McLaren_P1.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 402)
				end,
				chance = 7,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'VIP 30 дней',
				icon = 'assets/images/packs/items/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400*30)
				end,
				chance = 12,
			},

			{
				name = '$250.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 250000)
				end,
				chance = 22,
				notify = true,
			},

			{
				name = '300 RC',
				icon = 'assets/images/donate.png',
				give = function(player)
					increaseElementData(player, 'bank.donate', 300)
				end,
				chance = 12,
				notify = true,
			},

			{
				name = 'VIP 7 дней',
				icon = 'assets/images/packs/items/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400*7)
				end,
				chance = 27,
			},

			{
				name = '$180.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 180000)
				end,
				chance = 35,
			},

			{
				name = '$100.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 100000)
				end,
				chance = 40,
			},

			{
				name = '$80.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 80000)
				end,
				chance = 50,
			},


		},

		hit = true,

	},
	{

		name = 'Абу бандит',
		icon = 'assets/images/packs/6.png',
		color = {140, 140, 140},

		oldCost = 730,
		cost = 500,
		top_step = 40,

		items = {

			{
				name = '$15.000.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney( player, 15000000 )
				end,
				chance = 0,
				top = true,
				notify = true,
			},

			{
				name = 'Bugatti Divo',
				icon = 'assets/images/packs/items/divo.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 545)
				end,
				chance = 0,
				top = true,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'Chiron',
				icon = 'assets/images/packs/items/chiron.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 506)
				end,
				chance = 3,
				top = true,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'S63',
				icon = ':vehicles_shop/assets/images/vehicles/418.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 418)
				end,
				chance = 10,
				top = true,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'G500',
				icon = 'assets/images/packs/items/g500.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 405)
				end,
				chance = 12,
				top = true,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'Скидочный промокод 100%',
				tooltip = '100%',
				icon = 'assets/images/packs/items/discount.png',
				give = function(player)
					addConvertPromo(player, nil, 100)
				end,
				chance = 17,
			},

			{
				name = 'Audi RS6',
				icon = 'assets/images/packs/items/rs6.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 492)
				end,
				chance = 30,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = '$180.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 180000)
				end,
				chance = 45,
			},

			{
				name = '$100.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 100000)
				end,
				chance = 45,
			},

			{
				name = 'VIP 3 дня',
				icon = 'assets/images/packs/items/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400*3)
				end,
				chance = 70,
			},

			{
				name = 'Кейс RAGE',
				icon = 'assets/images/packs/2.png',
				give = function(player)
					exports.main_freeroam:givePlayerPack(player, 2, 1)
				end,
				chance = 70,
				notify = true,
			},

			{
				name = 'Новичок',
				icon = 'assets/images/packs/1.png',
				give = function(player)
					exports.main_freeroam:givePlayerPack(player, 1, 1)
				end,
				chance = 90,
				notify = true,
			},


		},
		
		hit = true,

	},
	{

		name = 'Бомжичок',
		icon = 'assets/images/packs/7.png',
		color = {200, 200, 0},

		oldCost = 95,
		cost = 80,
		top_step = 40,

		items = {

			{
				name = '$500.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney( player, 500000 )
				end,
				chance = 1,
				top = true,
				notify = true,
			},

			{
				name = 'Audi R8',
				icon = ':vehicles_shop/assets/images/vehicles/439.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 439)
				end,
				chance = 5,
				top = true,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'CLS 63',
				icon = ':vehicles_shop/assets/images/vehicles/467.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 467)
				end,
				chance = 15,
				top = true,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'SRT',
				icon = ':vehicles_shop/assets/images/vehicles/527.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 527)
				end,
				chance = 30,
				top = true,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'Camry 3.5',
				icon = ':vehicles_shop/assets/images/vehicles/426.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 426)
				end,
				chance = 5,
				notify = true,

				img_scale = 1.3,
			},


			{
				name = 'Скидочный промокод 20%',
				tooltip = '20%',
				icon = 'assets/images/packs/items/discount.png',
				give = function(player)
					addConvertPromo(player, nil, 20)
				end,
				chance = 12,
			},

			{
				name = 'Скин',
				icon = 'assets/images/packs/items/bomj.png',
				give = function(player)
					exports.main_clothes:addWardrobeClothes(player.account.name, 29, true)
				end,

				sellCost = 35000,
				chance = 10,

			},

			{
				name = 'Новичок',
				icon = 'assets/images/packs/1.png',
				give = function(player)
					exports.main_freeroam:givePlayerPack(player, 1, 1)
				end,
				chance = 10,
				notify = true,
			},

			{
				name = '$25.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 25000)
				end,
				chance = 25,
			},

			{
				name = 'VIP 1 день',
				icon = 'assets/images/packs/items/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400*1)
				end,
				chance = 30,
			},

			{
				name = 'Билет х2',
				icon = 'assets/images/packs/items/ticket.png',
				give = function(player)
					increaseElementData(player, 'prison.tickets', 2)
				end,
				chance = 40,
			},

			{
				name = '$10.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 10000)
				end,
				chance = 50,
			},


		},
		
		hit = true,

	},
	 {

		 name = 'MORGENSHTERN',
		 icon = 'assets/images/packs/8.png',
		 color = {200, 0, 0},

		 oldCost = 289,
		 cost = 249,
		 top_step = 35,

		 items = {

			 {
				 name = 'P1 «$»',

				 icon = ':vehicles_shop/assets/images/vehicles/402.png',
				 img_scale = 1.3,

				 give = function(player)

					 exports.vehicles_main:giveAccountVehicle(
						 player.account.name, 402,
						 {

							 unique_mark = 'milliondollar',

							 appearance_upgrades = {
								 color_1 = '#0095ff',
								 tuning_block = 1,
								 tuning = {
									 morgenshtern = 'morgenshtern_1'
								 },
							 },

						 }
					 )

				 end,

				 chance = 20,
				 top = true,
				 notify = true,

			 },

			 {
				 name = '$1.000.000',
				 icon = 'assets/images/bonuses/money.png',
				 give = function(player)
					 exports.money:givePlayerMoney(player, 1000000)
				 end,
				 chance = 30,
				 top = true,
				 notify = true,
			 },

			 {
				 name = 'Скин morgen',
				 icon = 'assets/images/packs/items/morgen.png',
				 give = function(player)
					 exports.main_clothes:addWardrobeClothes(player.account.name, 97, true)
				 end,

				 sellCost = 240000,

				 chance = 5,
			 },

			 {
				 name = 'Скин clown',
				 icon = 'assets/images/packs/items/clown.png',
				 give = function(player)
					 exports.main_clothes:addWardrobeClothes(player.account.name, 100, true)
				 end,

				 sellCost = 240000,

				 chance = 5,
			 },

			 {
				 name = 'Porsche «666»',

				 icon = ':vehicles_shop/assets/images/vehicles/541.png',
				 img_scale = 1.3,

				 give = function(player)

					 exports.vehicles_main:giveAccountVehicle(
						 player.account.name, 541,
						 {

							 unique_mark = 'n666',

							 appearance_upgrades = {
								 color_1 = '#ff8800',
								 tuning_block = 1,
								 tuning = {
									 morgenshtern = 'morgenshtern_1'
								 },
							 },

						 }
					 )

				 end,

				 chance = 50,
				 top = true,
				 notify = true,

			 },

			 {
				 name = '«пОСОси»',

				 icon = ':vehicles_shop/assets/images/vehicles/598.png',
				 img_scale = 1.3,

				 give = function(player)

					 exports.vehicles_main:giveAccountVehicle(
						 player.account.name, 598,
						 {

							 unique_mark = 'pososi',

							 appearance_upgrades = {
								 color_1 = '#ffffff',
								 tuning_block = 1,
								 tuning = {
									 trunk_badge = 'trunk_badge_2'
								 },
							 },

						 }
					 )

				 end,

				 chance = 70,
				 top = true,
				 notify = true,

			 },

			 {
				 name = '500 RC',
				 icon = 'assets/images/donate.png',
				 give = function(player)
					 increaseElementData(player, 'bank.donate', 500)
				 end,
				 chance = 10,
			 },

			 {
				 name = '$200.000',
				 icon = 'assets/images/bonuses/money.png',
				 give = function(player)
					 exports.money:givePlayerMoney(player, 200000)
				 end,
				 chance = 20,
			 },

			 {
				 name = '$100.000',
				 icon = 'assets/images/bonuses/money.png',
				 give = function(player)
					 exports.money:givePlayerMoney(player, 100000)
				 end,
				 chance = 25,
			 },

			 {
				 name = 'Бомжичок',
				 icon = 'assets/images/packs/7.png',
				 give = function(player)
					 exports.main_freeroam:givePlayerPack(player, 7, 1)
				 end,
				 chance = 17,
				 notify = true,
			 },

			 {
				 name = '$50.000',
				 icon = 'assets/images/bonuses/money.png',
				 give = function(player)
					 exports.money:givePlayerMoney(player, 50000)
				 end,
				 chance = 19,
			 },

			 {
				 name = 'VIP 2 дня',
				 icon = 'assets/images/packs/items/vip.png',
				 give = function(player)
					 exports.main_vip:giveVip(player.account.name, 86400*2)
				 end,
				 chance = 24,
			 },

		 },
		
		 hit = true,

	 },
	{

		name = 'EXCLUSIVE',
		icon = 'assets/images/packs/9.png',
		color = {100, 200, 150},

		oldCost = 900,
		cost = 800,
		top_step = 50,

		items = {

			{
				name = 'Sport',
				icon = ':vehicles_shop/assets/images/vehicles/506.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 518)
				end,
				chance = 1,
				top = true,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'SVJ',
				icon = ':vehicles_shop/assets/images/vehicles/542.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 542)
				end,
				chance = 5,
				top = true,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = '$2.500.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 2500000)
				end,
				chance = 2,
				notify = true,
				top = true,
			},

			{
				name = 'Divo',
				icon = ':vehicles_shop/assets/images/vehicles/545.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 545)
				end,
				chance = 18,
				top = true,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'Chiron',
				icon = ':vehicles_shop/assets/images/vehicles/506.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 506)
				end,
				chance = 18,
				top = true,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'McLaren',
				icon = ':vehicles_shop/assets/images/vehicles/402.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 402)
				end,
				chance = 18,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'S63',
				icon = ':vehicles_shop/assets/images/vehicles/418.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 418)
				end,
				chance = 22,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = '750 LI',
				icon = ':vehicles_shop/assets/images/vehicles/400.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 400)
				end,
				chance = 22,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'X5 G05',
				icon = ':vehicles_shop/assets/images/vehicles/579.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 579)
				end,
				chance = 22,
				notify = true,

				img_scale = 1.3,
			},
			{
				name = 'M3 G20',
				icon = ':vehicles_shop/assets/images/vehicles/546.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 546)
				end,
				chance = 21,
				notify = true,

				img_scale = 1.3,
			},

			--[[{
				name = 'VIP 14д.',
				icon = 'assets/images/packs/items/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400*14)
				end,
				chance = 21,
			},]]

			{
				name = '$150.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 150000)
				end,
				chance = 24,
			},

			{
				name = '$100.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 100000)
				end,
				chance = 14,
			},


		},
		
		hit = true,

	},
	{
		name = 'Новогодний',
		icon = 'assets/images/packs/ny1.png',

		color = {0, 0, 255},

		cost = 150,
		top_step = 35,

		items = {

			{
				name = 'Charger NY',
				icon = 'assets/images/packs/items/dodge_ny.png',
				give = function(player)

			exports['vehicles_main']:giveAccountVehicle(player.account.name, 474, {
				unique_mark = 'Dodge Charger NY',
				appearance_upgrades = {
					paintjob = {
						{
							path = 'charger_ny.png',
							x = 0, y = 0,
							w = 2048, h = 2048,
							r = 0,
							color = {100,100,100},
							id = 1,
						}
					},
				},
			})
				end,
				chance = 8,
				top = false,
				notify = true,

				img_scale = 1.3,

			},

			{
				name = 'Санта-Клаус',
				icon = 'assets/images/packs/items/nysk1.png',
				give = function(player)
					exports.main_clothes:addWardrobeClothes(player.account.name, 87, true)
				end,

				sellCost = 130000,

				chance = 12,
				top = true,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'BMW E92',
				icon = 'assets/images/packs/items/BMW_M3_E92.png',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 562)
				end,
				chance = 8,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = '$50.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 50000)
				end,
				chance = 8,
			},

			{
				name = 'VIP 7 дней',
				icon = 'assets/images/packs/items/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400*7)
				end,
				chance = 12,
			},

			{
				name = 'Скидочный промокод 10%', 
				tooltip = '10%',
				icon = 'assets/images/packs/items/discount.png',
				give = function(player)
					addConvertPromo(player, nil, 10)
				end,
				chance = 17,
			},

			{
				name = '40.000$',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 40000)
				end,
				chance = 22,
			},

			{
				name = 'VIP 1 день',
				icon = 'assets/images/packs/items/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400*1)
				end,
				chance = 36,
			},

			{
				name = '$30.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 30000)
				end,
				chance = 36,
			},

			{
				name = 'VIP 12 часов',
				icon = 'assets/images/packs/items/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 3600*12)
				end,
				chance = 42,
			},

			{
				name = '$15.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 15000)
				end,
				chance = 60,
			},

			{
				name = '$5.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 5000)
				end,
				chance = 110,
			},


		},

		 hit = true,

	},
	{

		name = 'Новогодний Premium',
		icon = 'assets/images/packs/ny2.png',

		color = {0, 0, 255},

		cost = 250,
		top_step = 35,

		items = {

			{
				name = 'Supra NY',
				icon = 'assets/images/packs/items/Supra_ny.png',
				give = function(player)

			exports['vehicles_main']:giveAccountVehicle(player.account.name, 429, {
				unique_mark = 'Toyota Supra NY',
				appearance_upgrades = {
					paintjob = {
						{
							path = 'supra_blood.png',
							x = 0, y = 0,
							w = 2048, h = 2048,
							r = 0,
							color = {100,100,100},
							id = 1,
						}
					},
				},
			})
				end,
				chance = 15,
				top = true,
				notify = true,

				img_scale = 1.3,

			},

			{
				name = 'Снегурочка',
				icon = 'assets/images/packs/items/nysk2.png',
				give = function(player)
					exports.main_clothes:addWardrobeClothes(player.account.name, 85, true)
				end,

				sellCost = 130000,

				chance = 5,
				top = true,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = 'Новогодний Эльф',
				icon = 'assets/images/packs/items/nysk3.png',
				give = function(player)
					exports.main_clothes:addWardrobeClothes(player.account.name, 84, true)
				end,

				sellCost = 130000,

				chance = 5,
				notify = true,

				img_scale = 1.3,
			},

			{
				name = '$50.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 50000)
				end,
				chance = 8,
			},

			{
				name = 'VIP 7 дней',
				icon = 'assets/images/packs/items/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400*7)
				end,
				chance = 12,
			},

			{
				name = 'Скидочный промокод 10%', 
				tooltip = '10%',
				icon = 'assets/images/packs/items/discount.png',
				give = function(player)
					addConvertPromo(player, nil, 10)
				end,
				chance = 17,
			},

			{
				name = '40.000$',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 40000)
				end,
				chance = 22,
			},

			{
				name = 'VIP 1 день',
				icon = 'assets/images/packs/items/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400*1)
				end,
				chance = 36,
			},

			{
				name = '$30.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 30000)
				end,
				chance = 36,
			},

			{
				name = 'VIP 12 часов',
				icon = 'assets/images/packs/items/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 3600*12)
				end,
				chance = 42,
			},

			{
				name = '$15.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 15000)
				end,
				chance = 60,
			},

			{
				name = '$5.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 5000)
				end,
				chance = 110,
			},


		},

		 hit = true,

	},

}

Config.packs_order = {
	9, 10, 1, 2, 7, 3, 4, 8, 5, 6
}

for index, pack in pairs( Config.packs ) do
	pack.index = index

	for iIndex, item in pairs( pack.items ) do
		item.index = iIndex
	end
end

function getPackExpire(pack)
	if not pack.expire then return false end
	local timestamp = getServerTimestamp()
	local days = math.floor( (pack.expire - timestamp.timestamp) / 86400 )
	return true, days
end

function getPacksCount(pack)
	local index = type(pack) == 'number' and pack or pack.index
	
	local packsCount = resourceRoot:getData('packs.balance') or {}
	return packsCount[index] or -1
end
