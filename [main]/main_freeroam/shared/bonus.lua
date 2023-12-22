Config.bonuses = {

	['REBORN'] = {

		name = 'REBORN',
		time = 5*3600,

		limit = 1000,

		initDB = function(self)
			self.db = self.db or dbConnect('sqlite', ':databases/reborn_bonus.db')

		end,

		disabled = true,

		check = function(self, player)

			self:initDB()

			local used = dbPoll( dbQuery(self.db, string.format('SELECT * FROM reborn_bonus WHERE bonus=1;')), -1 )

			if used and #used >= self.limit then
				exports.hud_notify:notify(player, 'Ошибка', 'Бонус-код истек')
				return false
			end

			local result = dbPoll( dbQuery(self.db, string.format('SELECT * FROM reborn_bonus WHERE serial="%s";',
				player.serial
			)), -1 )

			if result and result[1] then

				dbExec(self.db, string.format('UPDATE reborn_bonus SET bonus=1 WHERE id=%s;',
					result[1].id
				))

				return true

			end

			exports.hud_notify:notify(player, 'Ошибка', 'Доступно для игроков REBORN')

			return false

		end,

		give = function(player)

			exports['money']:givePlayerMoney(player, 20000)
			player:setData('license.all', true)
			exports.main_vip:giveVip(player.account.name, 86400*7)

		end,

	},

	['OBNOVA'] = {

		name = 'OBNOVA',
		time = 5*3600,

		disabled = true,

		give = function(player)
			exports['money']:givePlayerMoney(player, 30000)
		end,

	},

	['MARCH'] = {

		name = 'MARCH',
		time = 5*3600,

		disabled = true,

		give = function(player)
			exports['money']:givePlayerMoney(player, 30000)
		end,

	},

	['500'] = {

		name = '500',
		time = 5*3600,

		disabled = true,

		give = function(player)
			exports['money']:givePlayerMoney(player, 30000)
				exports.main_freeroam:givePlayerPack(player, 1, 1)
		end,

	},

	['RAGE'] = {

		name = 'RAGE',
		time = 1*30,


		give = function(player)
			exports['money']:givePlayerMoney(player, 20000)
			exports.main_freeroam:givePlayerPack(player, 1, 1)
			exports.main_freeroam:givePlayerPack(player, 3, 1)
			exports.main_vip:giveVip(player.account.name, 86400*1)
			exports.vehicles_main:giveAccountVehicle(player.account.name, 560)
		end,

	},

	['2SERVER'] = {

		name = '2SERVER',
		time = 5*3600,

		disabled = true,

		give = function(player)
			exports['money']:givePlayerMoney(player, 20000)
			exports.main_freeroam:givePlayerPack(player, 1, 1)
		end,

	},

	['KLAN'] = {

		name = 'KLAN',
		time = 7*3600,

		give = function(player)
			exports['money']:givePlayerMoney(player, 20000)
			exports.main_freeroam:givePlayerPack(player, 3, 1)
		end,

		disabled = true,

	},

	['KLAN2'] = {

		name = 'KLAN2',
		time = 7*3600,

		give = function(player)
			exports.main_freeroam:givePlayerPack(player, 7, 1)
			exports.main_freeroam:givePlayerPack(player, 8, 1)
		end,

		disabled = true,

	},

	['RAGE21'] = {

		name = 'RAGE21',
		time = 1*1,
		give = function(player)

			local rand = math.random(1,5)
			local prize_str

			if rand == 1 then
				exports['money']:givePlayerMoney(player, 50000)
				prize_str = '$50.000'
			elseif rand == 2 then
				exports.main_freeroam:givePlayerPack(player, 1, 1)
				prize_str = 'Кейс Новичок'
			elseif rand == 3 then
				exports.main_freeroam:givePlayerPack(player, 4, 1)
				prize_str = 'Кейс Джуди'
			elseif rand == 4 then
				exports.main_vip:giveVip(player.account.name, 86400*1)
				prize_str = 'VIP 1 день'
			elseif rand == 5 then
				exports.vehicles_main:giveAccountVehicle(player.account.name, 560)
				prize_str = 'Skoda Octavia'
			end

			if prize_str then
				exports.hud_notify:notify(player, 'Возмещение', 'Вы получили ' .. prize_str, 50000)
			end


		end,

	},

	['10K'] = {

		name = '10K',
		time = 7*3600,

		disabled = true,

		give = function(player)

			exports.main_freeroam:givePlayerPack(player, 8, 1)

			exports.main_inventory:addInventoryItem({

				player = player,
				count = 10,
				item = 'first_aid_kit',

			})

			exports.main_inventory:addInventoryItem({

				player = player,
				count = 1,
				item = 'weapon_m4',

			})

			exports.main_inventory:addInventoryItem({

				player = player,
				count = 120,
				item = 'ammo_2',

			})

		end,

	},

	['FSO'] = {

		name = 'FSO',
		time = 10*3600,

		give = function(player)

			exports.money:givePlayerMoney( player, 50000 )

		end,

		disabled = true,

	},

	['NEOBNOVA'] = {

		name = 'NEOBNOVA',
		time = 10*3600,

		give = function(player)

			exports.money:givePlayerMoney( player, 30000 )
			exports.main_vip:giveVip(player.account.name, 86400*3)
			exports.main_freeroam:givePlayerPack(player, 8, 1)

		end,

		disabled = true,

	},

	['CYBERQUEST'] = {

		name = 'CYBERQUEST',
		time = 10*3600,

		give = function(player)

			increaseElementData( player, 'casino.chips', 500 ) 
			exports.vehicles_main:giveAccountVehicle( player.account.name, 587, nil, 86400*14 )

		end,

		disabled = false,

	},

	['SORRY'] = {

		name = 'SORRY',
		time = 10*3600,

		give = function(player)

			increaseElementData( player, 'casino.chips', 800 ) 
			exports.main_freeroam:givePlayerPack(player, 1, 1)

		end,

		disabled = true,

	},

	['SUMMER'] = {

		name = 'SUMMER',
		time = 7*3600,

		disabled = true,

		give = function(player)

			exports.money:givePlayerMoney( player, 40000 )
			exports.main_freeroam:givePlayerPack(player, 8, 1)

		end,

	},

	['PEREEZD'] = {

		name = 'PEREEZD',
		time = 4*3600,

		disabled = true,

		give = function(player)

			exports.money:givePlayerMoney( player, 40000 )
			exports.main_freeroam:givePlayerPack(player, 8, 1)
			exports.main_vip:giveVip(player.account.name, 3600*2)

		end,

	},

	['RAGE2'] = {

		name = 'RAGE2',
		time = 5*3600,

		disabled = true,

		give = function(player)

			exports.money:givePlayerMoney( player, 40000 )
			exports.main_freeroam:givePlayerPack(player, 8, 1)
			exports.main_vip:giveVip(player.account.name, 3600*2)

		end,

	},

	["XRAGE"] = {
		name = "XRAGE",
		time = 0.1*3600,

		give = function( player )
			exports.money:givePlayerMoney( player, 150000 )
			exports.main_vip:giveVip( player.account.name, 86400*7 )
			exports.vehicles_main:giveAccountVehicle(player.account.name, 489)
		end,
	}

}