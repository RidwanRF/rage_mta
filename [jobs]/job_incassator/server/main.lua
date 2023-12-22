
-----------------------------------------------------------------

	function startWork(pos_id)

		if not client:getData('license.C') then
			return exports['hud_notify']:notify(client, 'Нет доступа', 'Получите категорию C')
		end

		if not exports.jobs_main:createPlayerSession(client) then return end

		local station = Config.positions[pos_id]

		local start = getRandomValue(station.vehicle)
		local x,y,z,r = unpack( start )
		local vehicle = createVehicle(Config.vehicle, x,y,z, 0, 0, r)

		exports.jobs_main:setPlayerSessionData(client, 'vehicle', vehicle)

		for k,v in pairs( Config.handling ) do
			vehicle:setHandling(k,v)
		end

		warpPedIntoVehicle(client, vehicle)

		vehicle:setData('fuel', 1000)
		vehicle:setData('plate', exports.vehicles_main:generatePlate('a'))
		vehicle:setData('coverType', 'default')

		vehicle:setData('tint_rear', 0.9)
		vehicle:setData('tint_side', 0.9)
		vehicle:setData('tint_front', 0.9)

		createPlayerSession(client, pos_id)

		vehicle:setData('paintjob',
			{
				{
					path = 'incassator_remap.png',
					x = 0, y = 0,
					w = 2048, h = 2048,
					r = 0,
					color = {170,170,170},
					id = 1,
				}
			}
		)

		exports['hud_notify']:notify(client, 'Начало работы', 'Маркер отмечен на карте')

	end
	addEvent('incassator.work.start', true)
	addEventHandler('incassator.work.start', resourceRoot, startWork)

	function finishWork(_player)

		local player = _player or client
 
		exports.jobs_main:finishPlayerSession(player)

	end
	addEvent('incassator.finish', true)
	addEventHandler('incassator.finish', resourceRoot, finishWork)

-----------------------------------------------------------------