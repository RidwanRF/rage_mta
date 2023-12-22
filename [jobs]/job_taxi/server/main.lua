
----------------------------------------------------

	function startWork(stationId, vehicleId)

		if not vehicleId then

			if Config.lease.cost > exports.money:getPlayerMoney(client) then
				return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
			end

		end

		if not exports.jobs_main:createPlayerSession(client) then return end

		local station = Config.stations[stationId]

		local vehicle

		if vehicleId then
			vehicle = exports['vehicles_main']:doRespawnVehicle(client, vehicleId, 0)
		else

			exports.money:takePlayerMoney(client, Config.lease.cost)

			vehicle = createVehicle( Config.lease.model, 0, 0, 0 )
			vehicle:setData('fuel', 100)
			vehicle:setData('plate', exports.vehicles_main:generatePlate('a'))

		end

		if not isElement(vehicle) then
			exports.hud_notify:notify(client, 'Такси', 'Работа не началась')
			return finishWork(client)
		end

		exports.jobs_main:setPlayerSessionData(client, 'vehicle', vehicle)
		exports.jobs_main:setPlayerSessionData(client, 'work_type', vehicleId and 'own' or 'lease')
		exports.jobs_main:setPlayerSessionData(client, 'model', vehicle.model)

		local start = getRandomValue(station.start)
		local x,y,z,r = unpack( start )

		setElementPosition(vehicle, x,y,z)
		setElementRotation(vehicle, 0,0,r)

		warpPedIntoVehicle(client, vehicle)

		createOrderTimer(client)

	end
	addEvent('taxi.start', true)
	addEventHandler('taxi.start', resourceRoot, startWork)

----------------------------------------------------

	function finishWork(_player)

		local player = _player or client
 
		if exports.jobs_main:getPlayerSessionData(player, 'work_type') == 'own' then
	 		exports.jobs_main:setPlayerSessionData(player, 'vehicle', nil)
		end

		exports.jobs_main:finishPlayerSession(player)

	end
	addEvent('taxi.finish', true)
	addEventHandler('taxi.finish', resourceRoot, finishWork)

----------------------------------------------------

	addEventHandler('onElementDestroy', root, function()
		if source.type == 'vehicle' then

			local owner = source:getData('owner')

			if owner then

				local account = getAccount(owner)

				if account and account.player then

					local player = account.player

					if player:getData('work.current') == Config.resourceName then

						if exports.jobs_main:getPlayerSessionData(player, 'vehicle') == source then
							finishWork(player)
						end

					end

					
				end

			end


		end
	end)

----------------------------------------------------