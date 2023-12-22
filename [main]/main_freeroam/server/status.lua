

--------------------------------------------------------

	exports.save:addParameter('statuses', true, true)
	exports.save:addParameter('status.current', nil, true)

--------------------------------------------------------

	function giveStatus( login, status )

		local account = getAccount( login )
		if not account then return end

		if account.player then
			return givePlayerStatus( account.player, status )
		end

		local statuses = fromJSON( account:getData('statuses') or '[[]]' ) or {}
		statuses[status] = true

		account:setData('statuses', toJSON(statuses))

	end

	function givePlayerStatus( player, status )

		local statuses = player:getData('statuses') or {}
		statuses[status] = true

		player:setData('statuses', statuses)
		updatePlayerAchievments(player)

	end

	addCommandHandler('fr_givestatus', function( player, _, login, status )

		if exports.acl:isAdmin( player ) then

			giveStatus(login, status)

		end

	end)

--------------------------------------------------------

	function takeStatus( login, status )

		local account = getAccount( login )
		if not account then return end

		if account.player then
			return takePlayerStatus( account.player, status )
		end

		local statuses = fromJSON( account:getData('statuses') or '[[]]' ) or {}
		statuses[status] = nil

		account:setData('statuses', toJSON(statuses))

		if account:getData('status.current') == status then
			account:setData('status.current', nil)
		end

	end 

	function takePlayerStatus( player, status )

		local statuses = player:getData('statuses') or {}
		statuses[status] = nil

		player:setData('statuses', statuses)

		if player:getData('status.current') == status then
			player:setData('status.current', nil)
		end

		updatePlayerAchievments(player)

	end

	addCommandHandler('fr_takestatus', function( player, _, login, status )

		if exports.acl:isAdmin( player ) then

			takeStatus(login, status)

		end

	end)

--------------------------------------------------------

	function setCurrentStatus( status )

		local statuses = client:getData('statuses') or {}

		if not statuses[status] then
			return exports.hud_notify:notify(client, 'Ошибка', 'Титул не получен')
		end

		client:setData('status.current', status)
		exports.hud_notify:notify(client, 'Успешно', 'Титул изменен')

		exports.logs:addLog(
			'[FREEROAM][STATUSCHANGE]',
			{
				data = {
					player = client.account.name,
					status = status,
				},	
			}
		)

	end
	addEvent('freeroam.setCurrentStatus', true)
	addEventHandler('freeroam.setCurrentStatus', resourceRoot, setCurrentStatus)

	function clearCurrentStatus( status )

		client:setData('status.current', false)
		exports.hud_notify:notify(client, 'Успешно', 'Титул сброшен')

		exports.logs:addLog(
			'[FREEROAM][STATUSCHANGE]',
			{
				data = {
					player = client.account.name,
					status = false,
				},	
			}
		)

	end
	addEvent('freeroam.clearCurrentStatus', true)
	addEventHandler('freeroam.clearCurrentStatus', resourceRoot, clearCurrentStatus)

--------------------------------------------------------

	exports.save:addParameter('status.reward', nil, true)

	addEventHandler('onServerDayCycle', root, function()

		for _, account in pairs( getAccounts() ) do
			account:setData('status.reward', 0)
		end

	end)

	addEventHandler('onPlayerLogin', root, function()

		setTimer(function(player)

			if isElement(player) then

				local status = player:getData('status.current')
				local statuses = player:getData('statuses') or {}

				if status and statuses[status] and player:getData('status.reward') == 0 then

					local config = Config.statusAssoc[status]
					if config.give then
						config.give(player)
						exports.hud_notify:notify(player, 'Бонус титула', config.bonus)
						player:setData('status.reward', 1)
					end

				elseif status and not statuses[status] then

					player:setData('status.current', nil)

				end

			end

		end, 5000, 1, source)

	end, true, 'low-10')

--------------------------------------------------------
