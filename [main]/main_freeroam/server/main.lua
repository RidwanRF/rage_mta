

-------------------------------------------------------

	function changeNickname(newNick)

		if not checkInputSymbols(newNick) then
			return exports['hud_notify']:notify(client, 'Ошибка', 'Недопустимые символы')
		end

		newNick = clearColorCodes(newNick)

		local donate = client:getData('bank.donate') or 0
		local cost = exports.main_vip:isVip(client) and (Config.changeNicknameCost/2) or Config.changeNicknameCost

		if donate < cost then
			return exports['hud_notify']:notify(client, 'Ошибка', 'Недостаточно денег')
		end

		if not exports.main_nickname:isNicknameFree(newNick) then
			return exports['hud_notify']:notify(client, 'Ошибка', 'Никнейм уже занят')
		end

		increaseElementData(client, 'bank.donate', -cost)

		client:setData('character.nickname', newNick)

		exports['hud_notify']:notify(client, 'Успешно', 'Никнейм изменен')

		exports.logs:addLog(
			'[FREEROAM][NICKCHANGE]',
			{
				data = {
					player = client.account.name,
					nick = newNick,
					sum = cost,
				},	
			}
		)


	end
	addEvent('freeroam.changeNickname', true)
	addEventHandler('freeroam.changeNickname', resourceRoot, changeNickname)

-------------------------------------------------------

	function changeNicknameColor(newColor)

		local donate = client:getData('bank.donate') or 0
		local cost = Config.changeNicknameColorCost

		if donate < cost then
			return exports['hud_notify']:notify(client, 'Ошибка', 'Недостаточно денег')
		end

		increaseElementData(client, 'bank.donate', -cost)

		client:setData('character.nickname_color', newColor)

		exports['hud_notify']:notify(client, 'Успешно', 'Цвет изменен')

		exports.logs:addLog(
			'[FREEROAM][NICKCOLOR]',
			{
				data = {
					player = client.account.name,
					nick = newColor,
					sum = cost,
				},	
			}
		)


	end
	addEvent('freeroam.changeNicknameColor', true)
	addEventHandler('freeroam.changeNicknameColor', resourceRoot, changeNicknameColor)

-------------------------------------------------------

	function sendMoney(player, sum)

		if sum < 0 then return end

		if exports['acl']:isPlayerInGroup(client, 'press') then
			return exports['hud_notify']:notify(client, 'Ошибка', 'Пресс-аккаунт')
		end
		
		if exports['money']:getPlayerMoney(client) < sum then
			return exports['hud_notify']:notify(client, 'Ошибка', 'Недостаточно денег')
		end
		
		if not isElement(player) then
			return exports['hud_notify']:notify(client, 'Ошибка', 'Игрок не найден')
		end
		
		if sum > Config.sendLimit then
			return exports['hud_notify']:notify(client, 'Ошибка', 'Лимит операции - $' .. splitWithPoints( Config.sendLimit, '.' ))
		end

		exports['money']:takePlayerMoney(client, sum, false)
		exports['money']:givePlayerMoney(player, sum)

		exports['hud_notify']:notify(player, 'Перевод', string.format('%s передал вам $%s',
			clearColorCodes(client.name), splitWithPoints(sum, '.')
		))

		exports['hud_notify']:notify(client, 'Перевод', string.format('Вы перевели $%s',
			splitWithPoints(sum, '.')
		))

		exports.logs:addLog(
			'[FREEROAM][SEND]',
			{
				data = {
					player = client.account.name,
					receiver = player.account.name,
					sum = sum,
				},	
			}
		)

	end
	addEvent('freeroam.sendMoney', true)
	addEventHandler('freeroam.sendMoney', resourceRoot, sendMoney)


-------------------------------------------------------

	local possibleSymbols = 'qwertyuiopasdfghjklzxcvbnm_1234567890'

	local function checkInputSymbols(str)
		local _str = utf8.lower(str)

		for _, symbol in pairs( string.split(possibleSymbols) ) do
			_str = utf8.gsub(_str, symbol, '')
		end

		return #_str == 0
	end



	function changePassword(old, new)

		if not client.account then return end

		if old == new then
			return exports.hud_notify:notify(client, 'Ошибка', 'Пароли совпадают')
		end

		if new == client.account.name then
			return exports.hud_notify:notify(client, 'Ошибка', 'Пароль и логин совпадают')
		end

		local oldPassword = decode(old)
		local newPassword = decode(new)

		if not checkInputSymbols(newPassword) then
			return exports.hud_notify:notify(client, 'Ошибка нового пароля', 'Недопустимые символы')
		end

		if not getAccount(client.account.name, oldPassword) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Старый пароль неверный')
		end

		setAccountPassword(client.account, newPassword)

		increaseElementData(client, 'password.changes', 1)

		exports.hud_notify:notify(client, 'Успешно', 'Пароль изменен')

		exports.logs:addLog(
			'[FREEROAM][PASSWORD]',
			{
				data = {
					player = client.account.name,
					serial = client.serial,
				},	
			}
		)

	end
	addEvent('freeroam.changePassword', true)
	addEventHandler('freeroam.changePassword', resourceRoot, changePassword)

-------------------------------------------------------
