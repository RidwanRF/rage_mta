

---------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		saver:addSaveKey('event_coins.account_id', 'number', true)
		saver:addSaveKey('event_coins.coins_limit', 'number', true)

	end)

---------------------------------------------

	addEventHandler('onServerDayCycle', root, function()

		dbExec(saver.db,string.format( 'UPDATE players_data SET value=%s WHERE key="event_coins.coins_limit";', Config.coinsLimit))

	end)

---------------------------------------------

	function getAccountFromId( id )

		for _, player in pairs( getElementsByType('player') ) do

			if player:getData('event_coins.account_id') == id then
				return player
			end

		end

		return false

	end

---------------------------------------------

	function sendAccountCoins( account_id, amount )

		if (client:getData('event_coins.coins') or 0) < amount then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно коинов')
		end

		local player = getAccountFromId( account_id )

		if not isElement(player) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Игрок не найден')
		end

		if player == client then
			return exports.hud_notify:notify(client, 'Ошибка', 'Нельзя перевести себе')
		end

		local limit = client:getData('event_coins.coins_limit') or 0

		if ( limit - amount ) < 0 then
			return exports.hud_notify:notify(client, 'Ошибка перевода', 'Лимит в сутки - ' .. splitWithPoints( Config.coinsLimit, '.' ))
		end

		increaseElementData(player, 'event_coins.coins', amount)
		increaseElementData(client, 'event_coins.coins', -amount)

		increaseElementData(client, 'event_coins.coins_limit', -amount)

		exports.hud_notify:notify(client, 'Успешно', 'Средства переведены')
		exports.hud_notify:notify(player, 'Перевод коинов', string.format('%s перевел вам %s',
			client.name, splitWithPoints(amount, '.')
		))

		exports.logs:addLog(
			'[COINS][SEND]',
			{
				data = {

					player = client.account.name,
					receiver = player.account.name,

					amount = amount,
					account_id = account_id,

				},	
			}
		)

	end
	addEvent('event_coins.sendAccountCoins', true)
	addEventHandler('event_coins.sendAccountCoins', resourceRoot, sendAccountCoins)

---------------------------------------------


	addEventHandler('onResourceStart', resourceRoot, function()

		for index, account in pairs( getAccounts() ) do

			if not account:getData('event_coins.id') then
				account:setData('event_coins.id', index)
			end

		end

	end)

---------------------------------------------

	function generateAccountId(player)

		if not player.account then return end
		local id = player.account:getData('event_coins.id')

		if id then
			return 400000 + id
		end

	end

	setTimer(function()

		for _, player in pairs( getElementsByType('player') ) do

			if not player:getData('event_coins.account_id') then

				local id = generateAccountId(player)

				if id then
					player:setData('event_coins.account_id', id)
				end

			end

		end

	end, 5000, 0)

---------------------------------------------
