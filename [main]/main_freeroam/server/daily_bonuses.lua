---------------------------------------------------------------------------

	exports.save:addParameter('bonus.receive_time', nil, true)
	exports.save:addParameter('bonus.state', nil, true)
	exports.save:addParameter('bonus.day', nil, true)

---------------------------------------------------------------------------

	function takeDailyBonus()

		if client:getData('bonus.state') == 'received' then
			return exports['hud_notify']:notify(client, 'Ошибка', 'Бонус уже получен')
		end

		if (client:getData('bonus.receive_time') or 0) > 0 then
			return exports['hud_notify']:notify(client, 'Ошибка', 'Отыграйте оставшееся время')
		end

		local bonusDay = client:getData('bonus.day') or 1

		local bonuses = Config.dailyBonuses
		if not bonuses[bonusDay] then return end

		local rewards = bonuses[bonusDay].rewards

		for _, reward in pairs( rewards ) do
			reward.give( client, exports.main_vip:isVip(client) and 2 or 1 )
		end

		client:setData('bonus.state', 'received')

		exports['hud_notify']:notify(client, 'Успешно', 'Вы забрали бонус')

		exports.logs:addLog(
			'[FREEROAM][DAILYBONUS]',
			{
				data = {
					player = client.account.name,
					day = bonusDay,
				},	
			}
		)

	end
	addEvent('freeroam.takeDailyBonus', true)
	addEventHandler('freeroam.takeDailyBonus', resourceRoot, takeDailyBonus)

---------------------------------------------------------------------------

	local updateTime = 60000

	local function updatePlayerBonus(player)
		if not player.account then return end
		if player.account.guest then return end

		local receiveTime = player:getData('bonus.receive_time') or 0
		local bonusState = player:getData('bonus.state')

		if bonusState ~= 'received' then

			if receiveTime > 0 then

				increaseElementData(player, 'bonus.receive_time', -updateTime, false)
				triggerClientEvent(player, 'dailyBonus.receiveCurrentTime', resourceRoot, player:getData('bonus.receive_time'))

			else 

				player:setData('bonus.state', 'receive_ready')

			end

		end

	end

	setTimer(function()

		for _, player in pairs( getElementsByType('player') ) do
			updatePlayerBonus(player)
		end

	end, updateTime, 0)

---------------------------------------------------------------------------

	local function updatePlayerBonusNotify(player)

		if not player.account then return end
		if player.account.name == 'guest' then return end

		local receiveTime = player:getData('bonus.receive_time') or 0
		local bonusState = player:getData('bonus.state')

		if bonusState == 'receive_ready' then

			if receiveTime <= 0 then

				exports['hud_notify']:notify(player, 'Заберите бонус', 'F1 >> Награды')
				exports.main_sounds:playSound( player, 'bonus' )

			end

		end

	end

	setTimer(function()

		for _, player in pairs( getElementsByType('player') ) do
			updatePlayerBonusNotify(player)
		end

	end, 10*60*1000, 0)

---------------------------------------------------------------------------

	addEventHandler('onPlayerLogin', root, function()

		local receiveTime = source:getData('bonus.receive_time') or 0
		local receiveState = source:getData('bonus.state') or 0

		if receiveTime <= 0 and receiveState == 'not_received' then
			source:setData('bonus.receive_time', Config.db_receiveTime)
		end

	end, true, 'low-200')

	function updateAccountBonus(account)

		local timestamp = getRealTime().timestamp
		local bonusDays = #Config.dailyBonuses

		local lastSeen = account:getData('lastSeen') or 0
		local bonusDay = account:getData('bonus.day') or 0
		local bonusState = account:getData('bonus.state')

		if (timestamp - lastSeen) < (86400*2) then

			if bonusState == 'received' then
				bonusDay = bonusDay + 1

				if bonusDay > bonusDays then
					bonusDay = 1
				end
			else
				bonusDay = 1
			end

		else
			bonusDay = 1
		end

		account:setData('bonus.state', 'not_received')
		account:setData('bonus.day', bonusDay)
		account:setData('bonus.receive_time', 0)

	end

	addEventHandler('onServerDayCycle', root, function()
		for _, account in pairs( getAccounts() ) do
			updateAccountBonus(account)
		end
	end)

	addEventHandler('onAccountRegister', root, function(account)
		updateAccountBonus(account)
	end)

	addEventHandler('onAccountWipe', root, function(account)
		updateAccountBonus(account)
	end)

---------------------------------------------------------------------------