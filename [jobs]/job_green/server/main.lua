
----------------------------------------------------

	function startWork(stationId)

		-- if not exports.acl:isAdmin(client) then return end

		if not exports.jobs_main:createPlayerSession(client) then return end

		local station = Config.stations[stationId]

		local start = getRandomValue(station.start)
		local x,y,z,r = unpack( start )
		local vehicle = createVehicle(Config.vehicle, x,y,z, 0, 0, r)

		exports.jobs_main:setPlayerSessionData(client, 'vehicle', vehicle)

		warpPedIntoVehicle(client, vehicle)

		setVehicleHandling(vehicle, 'tractionMultiplier', 0.5)
		setVehicleHandling(vehicle, 'maxVelocity', 80)
		setVehicleHandling(vehicle, 'engineAcceleration', 7)

		vehicle:setData('fuel', 100)

		createPlayerWork(client)

	end
	addEvent('green.start', true)
	addEventHandler('green.start', resourceRoot, startWork)

----------------------------------------------------

	function finishWork(_player)

		local player = _player or client

		exports.jobs_main:finishPlayerSession(player)

	end
	addEvent('green.finish', true)
	addEventHandler('green.finish', resourceRoot, finishWork)


----------------------------------------------------