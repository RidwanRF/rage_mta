
--------------------------------------------------------------------------------

	exports.save:addParameter('messages.disabled')
	exports.save:addParameter('messages.disable_notify')
	exports.save:addParameter('messages.blacklist', true)

--------------------------------------------------------------------------------

	local lastNotifies = {}
	function notifyPlayer(player)

		if player:getData('messages.disable_notify') then
			return
		end

		if lastNotifies[player] and (getTickCount() - lastNotifies[player]) < 5000 then
			return
		end

		exports['hud_notify']:notify(player, 'Новое сообщение', 'Откройте F9')

		lastNotifies[player] = getTickCount(  )

	end

--------------------------------------------------------------------------------

	function sendPlayerMessage( player, message )

		local player_blacklist = player:getData('messages.blacklist') or {}
		local client_blacklist = client:getData('messages.blacklist') or {}

		if player_blacklist[client.account.name] then
	        return exports['hud_notify']:notify(client, 'Ошибка', 'Вы в черном списке')
		end

		if client_blacklist[player.account.name] then
	        return exports['hud_notify']:notify(client, 'Ошибка', 'Игрок находится в ЧС')
		end

		if player:getData('messages.disabled') then
	        return exports['hud_notify']:notify(client, 'Ошибка', 'Игрок отключил мессенджер')
		end

		if client:getData('messages.disabled') then
	        return exports['hud_notify']:notify(client, 'Ошибка', 'Включите ЛС')
		end

		triggerClientEvent( player, 'messages.receive', resourceRoot, {
			sender = client,
			message = message,
			chat = client,
			timestamp = getRealTime().timestamp,
		} )

		triggerClientEvent( client, 'messages.receive', resourceRoot, {
			sender = client,
			message = message,
			chat = player,
			timestamp = getRealTime().timestamp,
		} )

		notifyPlayer( player )

	end
	addEvent('messages.send', true)
	addEventHandler('messages.send', resourceRoot, sendPlayerMessage)

--------------------------------------------------------------------------------

	function setPlayerBlackListed(player, flag)

		if flag and not player.account then return end

		local blacklist = client:getData('messages.blacklist') or {}

		if flag then
			blacklist[player.account.name] = { name = player.name, timestamp = getRealTime().timestamp }
		else
			blacklist[player.account.name] = nil
		end

		client:setData('messages.blacklist', blacklist)

		exports['hud_notify']:notify(client, 'Мессенджер', flag and 'Игрок добавлен в ЧС' or 'Игрок удален из ЧС')

	end
	addEvent('messages.setBlackListed', true)
	addEventHandler('messages.setBlackListed', resourceRoot, setPlayerBlackListed)

--------------------------------------------------------------------------------