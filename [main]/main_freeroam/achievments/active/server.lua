

--------------------------------------------------

	exports.save:addParameter('active_ach.series', nil, true)
	exports.save:addParameter('hour_ach.series', nil, true)

--------------------------------------------------

	function updateAccountsVisit()

		for _, account in pairs( getAccounts() ) do

			local visit = getUserData( account.name, 'active_ach.visit' )

			if visit == 0 then
				setUserData( account.name, 'active_ach.series', 0 )
			else
				increaseUserData( account.name, 'active_ach.series', 1 )
			end

			setUserData( account.name, 'active_ach.visit', 0 )

		end

	end

	addEventHandler('onServerDayCycle', root, updateAccountsVisit)

	addCommandHandler('fr_update_visits', function( player, _ )

		if exports.acl:isAdmin( player ) then
			updateAccountsVisit()
		end

	end)

--------------------------------------------------

	addEventHandler('onPlayerLogin', root, function()

		source.account:setData('active_ach.visit', 1)

	end)

--------------------------------------------------

	local playerSessions = {}

	addEventHandler('onPlayerLogin', root, function()

		playerSessions[source] = getRealTime().timestamp
		source:setData('hour_ach.series', 0)

	end)

	addEventHandler('onPlayerQuit', root, function()
		playerSessions[source] = nil
	end)

	addEventHandler('onResourceStart', resourceRoot, function()

		local real = getRealTime().timestamp

		for _, player in pairs( getElementsByType('player') ) do

			if player.account then
				playerSessions[player] = real
			end

		end

	end)

	setTimer(function()

		local real = getRealTime().timestamp

		for player, timestamp in pairs( playerSessions ) do

			if ( real - timestamp ) >= 3600 then

				increaseElementData( player, 'hour_ach.series', 1 )

				playerSessions[player] = real

				updatePlayerAchievments( player )

			end

		end

	end, 10000, 0)

--------------------------------------------------