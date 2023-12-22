
------------------------------------------------

	addEventHandler('onPlayerQuit', root, function()

		if workSessions[source] then

			local name = workSessions[source].work
			local money = finishPlayerSession(source)

			if (money or 0) > 0 then
				exports.main_alerts:addAccountAlert( source.account.name, 'info', Config.jobNames[name] or name,
					string.format('Работа завершена при выходе,\nваш заработок составил #cd4949$%s',
						splitWithPoints(money, '.')
					)
				)
			end

		end
	end)


	addEventHandler('onPlayerWasted', root, function()
		if workSessions[source] then
			finishPlayerSession(source)
		end
	end)

------------------------------------------------

	addEventHandler('onVehicleStartEnter', root, function( player, seat )

		if not source:getData('id') and source.parent.parent.id:find('job_') then

			if exports.jobs_main:getPlayerSessionData(player, 'vehicle') ~= source then
				cancelEvent()
			end

		end

	end)

------------------------------------------------

	addEventHandler('onResourceStop', root, function(resource)
		if resource == getThisResource() then

			for player in pairs( workSessions ) do
				finishPlayerSession(player)
			end

		elseif getResourceOrganizationalPath(resource) == '[resources]/[jobs]' then

			for player, session in pairs( workSessions ) do
				if session.work == resource.name then
					finishPlayerSession(player)
				end
			end

		end
	end)

------------------------------------------------


	local exitTimers = {}

	function resetFinishTimer(player)
		if isTimer(exitTimers[player]) then killTimer(exitTimers[player]) end
	end

	function createFinishTimer(player, time)
		resetFinishTimer(player)
		exitTimers[player] = setTimer(function(player)

			if isElement(player) then

				exports['hud_notify']:notify(player, 'Вы покинули транспорт', 'Работа завершена')

				finishPlayerSession(player)
			end

		end, time*60*1000, 1, player)
	end

	addEventHandler('onVehicleExit', root, function(player)
		if getPlayerSessionData(player, 'vehicle') == source
		then

			local config = Config.vehicleRemoveTimers[getPlayerSessionData(player, 'work')]
			if not config then return end

			local time = 1

			if type(config) == 'table' and config.time then
				time = math.floor( config.time / 120 )
			end

			createFinishTimer(player, time)
			exports['hud_notify']:notify( player, 'Вернитесь в транспорт', ('Он исчезнет через %s мин.'):format( time ) )

		end
	end)

	addEventHandler('onPlayerWasted', root, function()

		local config = Config.vehicleRemoveTimers[getPlayerSessionData(player, 'work')]
		if not config then return end
		
		local time = 1

		if type(config) == 'table' and config.time then
			time = math.floor( config.time / 60 )
		end

		createFinishTimer(player, time)
		exports['hud_notify']:notify( player, 'Вернитесь в транспорт', ('Он исчезнет через %s мин.'):format( time ) )

	end)

	addEventHandler('onVehicleEnter', root, function(player)
		if Config.vehicleRemoveTimers[getPlayerSessionData(player, 'work')] and getPlayerSessionData(player, 'vehicle') == source then
			resetFinishTimer(player)
		end
	end)

------------------------------------------------