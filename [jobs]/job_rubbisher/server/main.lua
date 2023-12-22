
----------------------------------------------------

	function startWork(stationId)

		if not client:getData('license.C') then
			return exports['hud_notify']:notify(client, 'Нет доступа', 'Получите категорию C')
		end

		if not exports.jobs_main:createPlayerSession(client) then return end

		local station = Config.stations[stationId]

		local start = getRandomValue(station.start)
		local x,y,z,r = unpack( start )
		local vehicle = createVehicle(Config.vehicle, x,y,z, 0, 0, r)

		local r,g,b = hexToRGB( client:getData('character.nickname_color') or '#ffffff' )
		setVehicleColor(vehicle, r,g,b)

		exports.jobs_main:setPlayerSessionData(client, 'vehicle', vehicle)

		for k,v in pairs( Config.handling ) do
			vehicle:setHandling(k,v)
		end

		client.model = 78

		warpPedIntoVehicle(client, vehicle)

		vehicle:setData('fuel', 1000)
		vehicle:setData('plate', exports.vehicles_main:generatePlate('a'))
		vehicle:setData('nitroBlocked', true)

		createPlayerWork(client)

		exports.hud_notify:notify(client, 'Нажмите F', 'Для выхода из транспорта', 15000)
		exports.chat_main:displayInfo(client, 'Нажмите F для выхода из транспорта', {100,150,255})

	end
	addEvent('rubbisher.start', true)
	addEventHandler('rubbisher.start', resourceRoot, startWork)


----------------------------------------------------

	function finishWork(_player)

		local player = _player or client

		exports.jobs_main:finishPlayerSession(player)

	end
	addEvent('rubbisher.finish', true)
	addEventHandler('rubbisher.finish', resourceRoot, finishWork)


----------------------------------------------------