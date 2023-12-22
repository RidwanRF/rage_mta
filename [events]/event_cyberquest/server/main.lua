

----------------------------------------------------

	function setAccountVip( login, state )
		setUserData( login, 'cyberquest.ticket', state and 'vip' or 'default' )
	end

----------------------------------------------------

	function givePlayerEnergy( player, amount )
		increaseElementData( player, 'cyberquest.energy', amount )
	end

----------------------------------------------------

	addCommandHandler('ec_giveenergy', function( player, _, login, amount_str )

		if exports.acl:isAdmin( player ) then

			local amount = tonumber( amount_str ) or 0
			if amount <= 0 then return end

			increaseUserData( login, 'cyberquest.energy', amount )

		end

	end)

----------------------------------------------------
	
	function buyEnergy( amount )

		local cost = amount * Config.energyCost

		if cost > ( client:getData('bank.donate') or 0 ) then
			return exports.hud_notify:notify( client, 'Ошибка', 'Недостаточно R-Coin' )
		end

		increaseElementData( client, 'bank.donate', -cost )
		givePlayerEnergy( client, amount )

		exports.hud_notify:notify( client, 'Успешно', 'Вы приобрели энергию' )

		exports.logs:addLog(
			'[CYBERQUEST][ENERGY]',
			{
				data = {
					player = client.account.name,
					amount = amount,
					cost = cost,
				},	
			}
		)

	end
	addEvent('cyberquest.buyEnergy', true)
	addEventHandler('cyberquest.buyEnergy', resourceRoot, buyEnergy)

----------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		local finish_timestamp = Config.start + Config.event_duration

		if finish_timestamp <= getRealTime().timestamp then
			stopResource(getThisResource())
		end

	end)

----------------------------------------------------