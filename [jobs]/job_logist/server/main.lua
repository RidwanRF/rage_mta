
----------------------------------------------------

	function startWork(stationId, routeId)

		if not client:getData('license.C') then
			return exports['hud_notify']:notify(client, 'Нет доступа', 'Получите категорию C')
		end

		if not exports.jobs_main:createPlayerSession(client) then return end

		local station = Config.stations[stationId]
		local route = Config.routes[routeId]

		local start = getRandomValue(station.start)
		local x,y,z,r = unpack( start )
		local vehicle = createVehicle(Config.vehicle, x,y,z, 0, 0, r)

		exports.jobs_main:setPlayerSessionData(client, 'vehicle', vehicle)
		exports.jobs_main:setPlayerSessionData(client, 'route_id', routeId)

		for k,v in pairs( Config.handling ) do
			vehicle:setHandling(k,v)
		end

		warpPedIntoVehicle(client, vehicle)

		vehicle:setData('fuel', 1000)
		vehicle:setData('plate', exports.vehicles_main:generatePlate('a'))

		createPlayerRoute(client, routeId)

	end
	addEvent('logist.start', true)
	addEventHandler('logist.start', resourceRoot, startWork)


----------------------------------------------------

	function finishWork(_player)

		local player = _player or client
 
		exports.jobs_main:finishPlayerSession(player)

	end
	addEvent('logist.finish', true)
	addEventHandler('logist.finish', resourceRoot, finishWork)


----------------------------------------------------