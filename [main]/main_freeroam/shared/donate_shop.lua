

Config.donateShop = {

	{
		name = "CyberQuest",
		cost = 589,
		oldCost = 1299,
		image = "assets/images/shop/rich.png",
		content = {
			"VIP-Пропуск CyberQuest",
			"Quadra V-TECH",
		},

		item_id = "cyberquest_remap",

		give = function( player )
			local current_ticker = getUserData( player.account.name, "cyberquest.ticket" ) or "default"
			if current_ticker == "vip" then
				exports.hud_notify:notify( player, "Ошибка", "У вас уже есть VIP-Пропуск" )
				return false
			end

			exports['vehicles_main']:giveAccountVehicle(player.account.name, 587 )
			exports.event_cyberquest:setAccountVip( player.account.name, true )
			return true
		end,
	},

	{

		name = 'Cullinan «D3»',

		cost = 2000,
		oldCost = 3000,
		image = 'assets/images/shop/cullinan_remap.png',

		content = {
			'Rolls-Royce Cullinan',
			'Уникальный винил',
		},

		item_id = 'cullinan_remap',

		give = function(player)

			exports['vehicles_main']:giveAccountVehicle(player.account.name, 566, {
				unique_mark = 'd3',
				appearance_upgrades = {
					paintjob = {
						{
							path = 'cullinan_remap.dat',
							x = 0, y = 0,
							w = 2048, h = 2048,
							r = 0,
							color = {100,100,100},
							id = 1,
						}
					},
				},
			})

			return true

		end,

	},

	{

		name = 'Camaro Z28 «Bumblebee»',

		cost = 1500,
		oldCost = 2000,
		image = 'assets/images/shop/rx7_remap.png',

		content = {
			'Chevrolet Camaro Z28',
			'Уникальный винил',
		},

		item_id = 'Camaro_remap',

		give = function(player)

			exports['vehicles_main']:giveAccountVehicle(player.account.name, 412, {
				appearance_upgrades = {
					paintjob = {
						{
							path = 'camaro_remap.png',
							x = 0, y = 0,
							w = 2048, h = 2048,
							r = 0,
							color = {100,100,100},
							id = 1,
						}
					},
				},
			})

			return true

		end,

	},


	{

		name = 'Taycan «Литвин»',

		cost = 2500,
		oldCost = 2900,
		image = 'assets/images/shop/f90_spring.png',

		content = {
			'Porsche Taycan',
			'Уникальный винил',
		},

		item_id = 'Camaro_remap',

		give = function(player)

			exports['vehicles_main']:giveAccountVehicle(player.account.name, 409, {
				appearance_upgrades = {
					paintjob = {
						{
							path = 'taycan_remap.png',
							x = 0, y = 0,
							w = 2048, h = 2048,
							r = 0,
							color = {100,100,100},
							id = 1,
						}
					},
				},
			})

			return true

		end,

	},

	{

		name = '«Неплохое начало»',

		cost = 350,
		oldCost = 390,
		image = 'assets/images/shop/complect4.png',

		item_id = 'starter',

		content = {
			'BMW M3 E92',
			'VIP 3 дня',
			'$80.000',
		},

		give = function(player)

			exports.main_vip:giveVip( player.account.name, 3*86400 )
			exports.money:givePlayerMoney( player, 80000 )

			exports.vehicles_main:giveAccountVehicle( player.account.name, 562 )


			return true

		end,

	},

	{

		name = 'Билет Свободы х5',

		cost = 50,
		oldCost = 60,
		image = 'assets/images/shop/prison_ticket.png',

		title_text = 'Описание набора',
		numbering = false,

		content = {
			'Билет свободы помогает',
			'сэкономить время в тюрьме',
			'Используйте его, и вы',
			'мгновенно выйдете из тюрьмы',
		},

		item_id = 'prison_ticket',

		give = function(player)

			increaseElementData( player, 'prison.tickets', 5 )

			return true

		end,

	},

	{

		name = 'Немецкая тройка',

		cost = 2400,
		oldCost = 2800,
		image = 'assets/images/shop/germany3.png',

		content = {
			'BMW M4',
			'Audi RS7',
			'Mercedes S63',
		},

		item_id = 'germany3',

		give = function(player)

			exports.vehicles_main:giveAccountVehicle( player.account.name, 419 )
			exports.vehicles_main:giveAccountVehicle( player.account.name, 534 )
			exports.vehicles_main:giveAccountVehicle( player.account.name, 418 )

			return true

		end,

	},

	{

		name = 'Американский боец',

		cost = 398,
		oldCost = 620,
		image = 'assets/images/shop/usaweapon.png',

		content = {
			'FN SCAR + 300 патронов',
			'MK 14 EBR + 120 патронов',
			'Аптечка x10',
		},

		item_id = 'usaweapon',

		give = function(player)

			exports.main_inventory:addInventoryItem({
				player = player,	
				item = 'first_aid_kit',
				count = 10,
			})

			exports.main_inventory:addInventoryItem({
				player = player,	
				item = 'weapon_mk14',
				count = 1,
			})

			exports.main_inventory:addInventoryItem({
				player = player,	
				item = 'weapon_m4',
				count = 1,
			})

			exports.main_inventory:addInventoryItem({
				player = player,	
				item = 'ammo_2',
				count = 300,
			})

			exports.main_inventory:addInventoryItem({
				player = player,	
				item = 'ammo_6',
				count = 120,
			})

			return true

		end,

	},

	{

		name = 'Абу Бандит',

		cost = 2900,
		oldCost = 3700,
		image = 'assets/images/shop/abu_x10.png',

		content = {
			'Кейс Абу Бандит х10',
		},

		item_id = 'abu_x10',

		give = function(player)
			givePlayerPack(player, 6, 10)
			return true
		end,

	},

	{

		name = 'Королевский',

		cost = 1490,
		oldCost = 1800,
		image = 'assets/images/shop/king_x10.png',

		content = {
			'Кейс Королевский х10',
		},

		item_id = 'king_x10',

		give = function(player)
			givePlayerPack(player, 4, 10)
			return true
		end,

	},

	{

		name = 'Мажор',

		cost = 2390,
		oldCost = 2800,
		image = 'assets/images/shop/major_x10.png',

		content = {
			'Кейс Мажор х10',
		},

		item_id = 'major_x10',

		give = function(player)
			givePlayerPack(player, 5, 10)
			return true
		end,

	},

	{

		name = 'Эксклюзив',

		cost = 3299,
		oldCost = 4000,
		image = 'assets/images/shop/excl_x5.png',

		content = {
			'Кейс EXCLUSIVE х5',
		},

		item_id = 'excl_x5',

		give = function(player)
			givePlayerPack(player, 8, 5)
			return true
		end,

	},

	{

		name = '«Богач»',

		cost = 2500,
		image = 'assets/images/shop/rich.png',

		-- expire = 1614292324 + 7*86400,

		item_id = 'rich',

		content = {
			'$1.000.000',
			'30 дней VIP',
		},

		give = function(player)

			exports.money:givePlayerMoney(player, 1000000)
			exports.main_vip:giveVip(player.account.name, 86400*30)

			return true

		end,

	},

	{

		name = '«Новичок»',

		cost = 149,
		oldCost = 200,
		image = 'assets/images/shop/complect1.png',

		item_id = 'starter',

		content = {
			'Права на весь транспорт',
			'VIP 3 дня',
			'$30.000',
			'BMW M5 E39',
		},

		give = function(player)

			player:setData('license.all', true)
			exports.main_vip:giveVip( player.account.name, 3*86400 )
			exports.money:givePlayerMoney( player, 30000 )

			exports.vehicles_main:giveAccountVehicle( player.account.name, 420 )

			increaseElementData(player, 'vehicles_autoschool.licenses_bought', 1)

			return true

		end,

	},

	{

		name = '«Что-то среднее»',

		cost = 449,
		oldCost = 550,
		image = 'assets/images/shop/complect2.png',

		item_id = 'middle',

		give = function(player)

			player:setData('license.all', true)
			increaseElementData(player, 'parks.extended', 1)

			givePlayerPack( player, 2, 3 )

			exports.vehicles_main:giveAccountVehicle( player.account.name, 426 )

			increaseElementData(player, 'vehicles_autoschool.licenses_bought', 1)

			return true

		end,

		content = {
			'Права на весь транспорт',
			'Toyota Camry 3.5 + слот',
			'Кейс RAGE x3',
		},

	},
	{

		name = '«МАЖОР»',

		cost = 550,
		oldCost = 700,
		image = 'assets/images/shop/complect3.png',

		item_id = 'rich',

		give = function(player)

			player:setData('license.all', true)
			increaseElementData(player, 'parks.extended', 1)

			exports.vehicles_main:giveAccountVehicle( player.account.name, 598 )
			exports.money:givePlayerMoney( player, 100000 )

			increaseElementData(player, 'vehicles_autoschool.licenses_bought', 1)

			return true

		end,

		content = {
			'Права на весь транспорт',
			'Mercedes E63S + слот',
			'$100.000',
		},


	},

	-- {

	-- 	name = 'Sead Kolasinac',

	-- 	cost = 199,
	-- 	oldCost = 600,
	-- 	image = 'assets/images/shop/skin1.png',
	-- 	benefit = 300,

	-- 	item_id = 'sead',

	-- 	give = function(player)

	-- 		local wardrobe = player:getData('wardrobe') or {}

	-- 		if wardrobe[25] then

	-- 			exports.hud_notify:notify( player, 'Ошибка', 'Вы уже купили этот скин' )
	-- 			return false

	-- 		end


	-- 		exports.main_clothes:addWardrobeClothes( player.account.name, 25, true )
	-- 		return true

	-- 	end,

	-- 	content = {
	-- 		'Скин Sead Kolasinac',
	-- 	},

	-- },

}