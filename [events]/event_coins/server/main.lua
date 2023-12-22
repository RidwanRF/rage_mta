

--------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		saver:addSaveKey('event_coins.coins', 'number', true)

	end)
	
--------------------------------------------------------

	function farmCoins( amount, hash )

		if hash ~= md5( ('%s_%s_%s'):format( Config.farm_key, amount, client.name ) ) then
			return
		end

		increaseElementData(client, 'event_coins.coins', amount, false)
		triggerClientEvent(client, 'event_coins.receiveClientCoins', resourceRoot, client:getData('event_coins.coins') or 0)

	end

	addEvent('event_coins.farmCoins', true)
	addEventHandler('event_coins.farmCoins', resourceRoot, farmCoins)

--------------------------------------------------------

	-- setTimer(function()

	-- 	for _, player in pairs( getElementsByType('player') ) do

	-- 		local amount = player:getData('event_coins.coins') or 0
	-- 		if amount > 0 then
	-- 			saver:savePlayerData( player, 'event_coins.coins', amount )
	-- 		end

	-- 	end

	-- end, 60000, 0)

--------------------------------------------------------