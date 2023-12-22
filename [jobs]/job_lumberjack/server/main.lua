
----------------------------------------------------

	function startWork(stationId)

		if not client:getData('license.B') then
			return exports['hud_notify']:notify(client, 'Нет доступа', 'Получите категорию B')
		end

		if not exports.jobs_main:createPlayerSession(client) then return end

		local station = Config.stations[stationId]

		local start = getRandomValue(station.start)
		local x,y,z,r = unpack( start )
		local vehicle = createVehicle(Config.vehicle, x,y,z, 0, 0, r)

		exports.jobs_main:setPlayerSessionData(client, 'vehicle', vehicle)

		for k,v in pairs( Config.handling ) do
			vehicle:setHandling(k,v)
		end

		client.model = Config.skin

		warpPedIntoVehicle(client, vehicle)

		vehicle:setData('fuel', 1000)
		vehicle:setData('plate', exports.vehicles_main:generatePlate('a'))
		vehicle:setData('nitroBlocked', true)

		createPlayerWork(client)

	end
	addEvent('lumberjack.start', true)
	addEventHandler('lumberjack.start', resourceRoot, startWork)


----------------------------------------------------

	function finishWork(_player)

		local player = _player or client

		exports.jobs_main:finishPlayerSession(player)

	end
	addEvent('lumberjack.finish', true)
	addEventHandler('lumberjack.finish', resourceRoot, finishWork)


----------------------------------------------------