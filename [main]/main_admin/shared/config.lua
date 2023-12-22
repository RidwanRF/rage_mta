Config = {}

Config.key = 'f10'

Config.searchTime = 1000

Config.moderatorSalary = 20000
Config.testerSalary = 30000

Config.accountData = {
	{ name = 'Деньги', key = 'money', type = 'number' },
	{ name = 'Банк', key = 'bank.rub', type = 'number' },
	{ name = 'R-Coin', key = 'bank.donate', type = 'number' },
	{ name = 'Никнейм', key = 'character.nickname', edit = false, copy = true, },
	{ name = 'Стаж', key = 'level', edit = false, copy = true },

	{ name = 'Serial', key = 'unique.serial',
		value = function(value)
			value = tostring(value)
			return value:sub(0, 6) .. '...' .. value:sub(-6)
		end,
		edit = false,
		copy = true,
	},
}

Config.propertyDisplay = {
	
	derrick = {
		{ name = 'Баланс', key = 'balance', type = 'number' },
		{ name = 'Владелец', key = 'owner', type = 'text' },
	},
	
	business = {
		{ name = 'Баланс', key = 'balance', type = 'number' },
		{ name = 'Владелец', key = 'owner', type = 'text' },
		{ name = 'Стоимость', key = 'cost', type = 'number' },
		{ name = 'Выплата', key = 'payment_sum', type = 'number' },
	},
	
	house = {
		{ name = 'Парковки', key = 'lots', type = 'number' },
		{ name = 'Владелец', key = 'owner', type = 'text' },
		{ name = 'Стоимость', key = 'cost', type = 'number' },
	},
	
	vehicle = {
		{ name = 'Владелец', key = 'owner', type = 'text' },
		{ name = 'Номер', key = 'plate', type = 'text' },
		{ name = 'Модель', key = 'model', type = 'number' },
	},
	
	number = {
		{ name = 'Номер', key = 'number', edit = false, type = 'text' },
		{ name = 'Владелец', key = 'owner', type = 'text' },
	},

}

Config.accountActions = {
	
	ban = {

		name = 'Забанить',

		confirm = true,

		action = function( login, resp, time, reason )

			local account = getAccount(login)
			if not account then return end

			local serial = account.player and account.player.serial or account.serial

			functions.ban( { serial = serial }, reason, tonumber(time), resp )

			exports.logs:addLog(
				'[ADMIN][BAN]',
				{
					data = {
						player = login,
						time = tonumber( time ),
						reason = reason or "",
						banner = resp,
					},	
				}
			)

		end,

		args = {
			{ type = 'number', name = 'Время в минутах' },
			{ type = 'text', name = 'Причина' },
		},

		right = 'moderator',
		is_offline = true,

	},

	wipe = {

		name = 'Обнулить',

		confirm = true,

		action = function( login, resp )

			local account = getAccount(login)
			if not account then return end

			wipeAccount(login)
			returnAccountData(resp, login)

			exports.logs:addLog(
				'[ADMIN][WIPE]',
				{
					data = {
						player = login,
						admin = resp,
					},	
				}
			)

		end,

		right = 'admin',
		is_offline = true,

	},
	
	spectate = {

		name = 'Слежка',

		action = function( login, resp )

			local account = getAccount(login)
			if not account then return end

			if account.player then

				setCameraTarget( resp, account.player )
				resp:setData('admin.spectate_target', account.player)
				exports.hud_notify:notify(resp, 'Нажмите B', 'Чтобы выйти из слежки')

				-- bindKey(resp, 'b', 'down', function(player)

				-- 	if then
				-- 		setCameraTarget( resp, resp )
				-- 	end

				-- end)

			end

		end,

		right = 'moderator',
		is_offline = false,

	},

	hours = {

		name = 'Выдать часы',

		action = function( login, resp, amount )

			giveLevel( login, amount )
			returnAccountData( resp, login )

			exports.logs:addLog(
				'[ADMIN][HOURSGVE]',
				{
					data = {
						player = login,
						admin = resp,
						amount = amount,
					},	
				}
			)

		end,

		args = {
			{ type = 'number', name = 'Время в часах' },
		},

		right = 'admin',
		is_offline = true,

	},

	licenses = {

		name = 'Выдать права',

		confirm = true,

		action = function( login, resp )

			giveLicenses( login )

			exports.logs:addLog(
				'[ADMIN][LICENSEGIVE]',
				{
					data = {
						player = login,
						admin = resp,
					},	
				}
			)

		end,

		right = 'admin',
		is_offline = true,

	},
	
	kill = {

		name = 'Убить',

		confirm = true,

		action = function( login, resp )

			local account = getAccount(login)
			if not account then return end

			if account.player then
				account.player.health = 0
				exports.hud_notify:notify(account.player, 'Убийство', string.format('Модератор %s убил вас', resp.name))
			end

		end,

		right = 'moderator',
		is_offline = false,

	},
	
	prison = {

		name = 'Тюрьма',

		action = function( login, resp, time, reason )

			local account = getAccount(login)
			if not account then return end

			if time == 0 then

				exports.logs:addLog(
				'[ADMIN][UNJAIL]',
					{
						data = {
							player = login,
							admin = resp,
							reason = reason or "",
						},	
					}
				)

				exports.police_prison:makePlayerFree(account.player)
				exports.hud_notify:notify(account.player, 'Освобождение из тюрьмы', resp.name .. ' освободил вас')

			else

				exports.police_prison:givePlayerPrison(account.player, time*60)
				displayModeratorsInfo( resp, 'prison', account.player, time, reason )

				exports.hud_notify:notify(account.player, 'Тюрьма', string.format('%s посадил вас на %sм',
					resp.name, time
				))

				exports.hud_notify:notify(account.player, 'Причина тюрьмы', reason)

				exports.logs:addLog(
				'[ADMIN][JAIL]',
					{
						data = {
							player = login,
							admin = resp,
							time = time*60,
							reason = reason
						},	
					}
				)
			end

		end,

		args = {
			{ type = 'number', name = 'Время в минутах' },
			{ type = 'text', name = 'Причина' },
		},

		right = 'moderator',
		is_offline = false,

	},
	
	kick = {

		name = 'Кикнуть',

		action = function( login, resp, reason )

			local account = getAccount(login)
			if not account then return end

			if account.player then
				displayModeratorsInfo( resp, 'kick', account.player, reason )
				kickPlayer( account.player, resp, reason )

				exports.logs:addLog(
					'[ADMIN][KICK]',
					{
						data = {
							player = login,
							admin = resp,
							reason = reason
						},	
					}
				)

			end

		end,

		args = {
			{ type = 'text', name = 'Причина' },
		},

		right = 'moderator',
		is_offline = false,

	},
	
	mute = {

		name = 'Мут',

		action = function( login, resp, time, reason )

			local account = getAccount(login)
			if not account then return end

			if time == 0 then

				exports.chat_main:removePlayerMute(account.player)

				exports.logs:addLog(
					'[ADMIN][UNMUTE]',
					{
						data = {
							player = login,
							admin = resp,
							reason = reason or ""
						},	
					}
				)

			else

				exports.chat_main:addPlayerMute(account.player, time*60)
				displayModeratorsInfo( resp, 'mute', account.player, time, reason )

				exports.logs:addLog(
					'[ADMIN][MUTE]',
					{
						data = {
							player = login,
							admin = resp,
							time = time*60,
							reason = reason
						},	
					}
				)

			end

		end,

		args = {
			{ type = 'number', name = 'Время в минутах' },
			{ type = 'text', name = 'Причина' },
		},

		right = 'moderator',
		is_offline = false,

	},
	
	parks = {

		name = 'Выдать парковки',

		confirm = true,

		action = function( login, resp, amount )

			local account = getAccount(login)
			if not account then return end

			if account.player then
				increaseElementData(account.player, 'parks.extended', amount)
				exports.vehicles_main:updatePlayerParkingLots(account.player)
			else
				increaseAccountData(account, 'parks.extended', amount)
			end

			exports.logs:addLog(
				'[ADMIN][PARKS]',
				{
					data = {
						player = login,
						admin = resp,
						amount = amount
					},	
				}
			)

		end,

		args = {
			{ type = 'number', name = 'Количество' },
		},

		right = 'admin',
		is_offline = true,

	},
	
	teleport = {

		name = 'Телепорт игрока к',

		action = function( login, resp, to )

			local account = getAccount( login )
			if not account then return end

			if not account.player then
				return exports.hud_notify:notify(resp, 'Ошибка', 'Игрок не найден')
			end
			
			if account.player.dimension ~= resp.dimension then
				return exports.hud_notify:notify(resp, 'Ошибка', 'Действие недоступно')
			end

			return teleport(account.player, to)

		end,

		args = function()

			local args = {}
			local list = {}

			table.insert(list, { name = localPlayer.name, data = localPlayer })

			for _, player in pairs( getElementsByType('player') ) do

				if localPlayer ~= player then
					table.insert(list, { name = player.name, data = player })
				end

			end

			table.insert(args, 
				{type = 'select', name = 'Выберите игрока', params = {
					selectElements = list,
				}}
			)

			return args

		end,

		right = 'moderator',
		is_offline = false,

	},
	
	teleport_to = {

		name = 'Телепорт к игроку',

		action = function( login, resp )

			local account = getAccount( login )
			if not account then return end

			if not account.player then
				return exports.hud_notify:notify(resp, 'Ошибка', 'Игрок не найден')
			end
			
			if account.player.dimension ~= resp.dimension then
				return exports.hud_notify:notify(resp, 'Ошибка', 'Действие недоступно')
			end

			return teleport(resp, account.player)

		end,

		right = 'moderator',
		is_offline = false,

	},
	
	change_nick = {

		name = 'Смена ника',

		action = function( login, resp, newNick )

			if utf8.len(newNick or '') < 3 then
				return exports.hud_notify:notify(resp, 'Ошибка', 'Слишком короткий ник')
			end

			local account = getAccount(login)
			if not account then return end

			if not exports.main_nickname:isNicknameFree(newNick) then
				return exports.hud_notify:notify(resp, 'Ошибка', 'Никнейм занят')
			end

			if account.player then
				account.player:setData('character.nickname', newNick)
				exports.hud_notify:notify(account.player, string.format('%s сменил ваш ник', resp.name), string.format('Новый - %s', newNick))
			else
				account:setData('character.nickname', newNick)
			end

			returnAccountData( resp, login )


		end,

		args = {
			{ type = 'text', name = 'Новый никнейм' },
		},

		right = 'admin',
		is_offline = true,

	},
	
	youtube = {

		name = 'Выдать Youtube',

		action = function( login, resp )

			giveLevel( login, 50 )
			giveLicenses( login )

			exports.acl:addGroup(login, 'youtube')
			exports.main_freeroam:giveStatus(login, 'youtube')

			exports.vehicles_main:giveAccountVehicle(login, 479)


		end,

		confirm = true,

		right = 'admin',
		is_offline = true,

	},

}


---------------------------------------------------------------------------

	function displayModeratorsInfo( resp, action, player, ... )

		local args = { ... }

		local r_role = 'Модератор'

		if exports.acl:isAdmin(resp) then
			r_role = 'Администратор'
		end

		local strings = {
			prison = {'%s %s посадил в тюрьму игрока %s на %sм по причине: %s', r_role, resp.name, player.name, args[1], args[2]},
			mute = {'%s %s замутил игрока %s на %sм по причине: %s', r_role, resp.name, player.name, args[1], args[2]},
			kick = {'%s %s кикнул игрока %s по причине: %s', r_role, resp.name, player.name, args[1]},
		}

		-- for _, _player in pairs( getElementsByType('player') ) do
			-- if exports.acl:isModerator(_player) or _player == player then
				-- exports.chat_main:displayInfo(_player, string.format( unpack(strings[action]) ), {255,0,0})
			-- end
		-- end

		exports.chat_main:displayInfo(root, string.format( unpack(strings[action]) ), {255,0,0})

	end

---------------------------------------------------------------------------