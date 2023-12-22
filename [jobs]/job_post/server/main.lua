
----------------------------------------------------

	function startWork(stationId)

		if not exports.jobs_main:createPlayerSession(client) then return end

		local station = Config.stations[stationId]

		local start = getRandomValue(station.start)
		local x,y,z,r = unpack( start )
		local vehicle = createVehicle(Config.vehicle, x,y,z, 0, 0, r)

		exports.jobs_main:setPlayerSessionData(client, 'vehicle', vehicle)
		exports.jobs_main:setPlayerSessionData(client, 'station', stationId)

		warpPedIntoVehicle(client, vehicle)

		vehicle:setData('fuel', 1000)
		setVehicleColor(vehicle, 180, 70, 70, 180, 70, 70)

		createPlayerSession(client)

	end
	addEvent('post.start', true)
	addEventHandler('post.start', resourceRoot, startWork)

----------------------------------------------------

	function finishWork(_player)

		local player = _player or client
 
		exports.jobs_main:finishPlayerSession(player)

	end
	addEvent('post.finish', true)
	addEventHandler('post.finish', resourceRoot, finishWork)


----------------------------------------------------