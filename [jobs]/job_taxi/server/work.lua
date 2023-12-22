
------------------------------------------------

	local orders = {}
	local orderTimers = {}

------------------------------------------------

	function createOrderTimer(player)

		if isTimer(orderTimers[player]) then
			killTimer(orderTimers[player])
		end

		orderTimers[player] = setTimer(function(player)

			if not isElement(player) then return end
			if exports.jobs_main:getPlayerWork(player) ~= Config.resourceName then return end

			local order = createOrder(player)
			if not order then createOrderTimer(player) end

		end, math.random( unpack(Config.waitTime) ), 1, player)

	end

------------------------------------------------

	function getPointByDistanceLimits(player, limits)

		local x,y,z = getElementPosition(player)
		local possiblePositions = {}

		for index, position in pairs( Config.orders ) do


			local px,py,pz = unpack(position)

			local distance = getDistanceBetweenPoints3D(x,y,z,px,py,pz)

			if isBetween( distance, unpack(limits) ) then
				table.insert(possiblePositions, position)
			end


		end

		if #possiblePositions == 0 then return end

		local position = possiblePositions[math.random(#possiblePositions)]

		return position

	end

------------------------------------------------

	function createOrder(player)

		local order = orders[player]
		if order then return end

		local order = getPointByDistanceLimits( player, Config.possibleLimits.order )
		if not order then return false end

		local x,y,z = unpack(order)

		local marker = createMarker( x,y,z, 'corona', 5, 0, 0, 0, 0, player )
		marker:setData('controlpoint.3dtext', '[Заберите пассажира]')

		local blip = createBlipAttachedTo(marker, 0, nil, nil, nil, nil, nil, nil, nil, player)
		blip:setData('icon', 'target')


		local ped = createElement('taxi-ped')
		local ped_data = {
			pos = { x,y,z+1, 0 },
			element = ped,
			model = getRandomValue(Config.pedModels),
		}
		
		triggerClientEvent(player, 'job_taxi.create_work_ped', resourceRoot, ped_data)

		orders[player] = {

			marker = marker,
			blip = blip,

			ped = ped,
			ped_data = ped_data,

			start_pos = {x,y,z},

		}

		exports.jobs_main:setPlayerSessionData(player, 'order', orders[player])

		exports['hud_notify']:notify(player, 'Такси', 'Заказ отмечен на карте')

		return orders[player]

	end

	addEventHandler('onMarkerHit', resourceRoot, function(player, mDim)

		if orders[player] and orders[player].marker == source and mDim
			and player.vehicle == exports.jobs_main:getPlayerSessionData(player, 'vehicle')
		then

			local order = orders[player]
			
			destroyElement(order.marker)
			destroyElement(order.blip)
			destroyElement(order.ped)

			order.marker = nil
			order.blip = nil
			order.ped = nil

			local x,y,z = getElementPosition(player)
			order.ped = createPed( order.ped_data.model, x,y,z, 0 )

			local vehicle = exports.jobs_main:getPlayerSessionData(player, 'vehicle')
			warpPedIntoVehicle(order.ped, vehicle, 1)

			createOrderDestination(player)

		end

	end)

------------------------------------------------

	function createOrderDestination(player)

		local order = orders[player]
		if not order then return end

		local pos = getPointByDistanceLimits( player, Config.possibleLimits.destination )
		local x,y,z = unpack(pos)

		order.destination = createMarker( x,y,z, 'corona', 2, 255, 0, 0, 0, player )
		order.destination:setData('controlpoint.3dtext', '[Отвезите пассажира]')

		order.blip = createBlipAttachedTo(order.destination, 0, nil, nil, nil, nil, nil, nil, nil, player)
		order.blip:setData('icon', 'target')

		exports.jobs_main:setPlayerSessionData(player, 'order', order)

		exports['hud_notify']:notify(player, 'Такси', 'Отвезите пассажира')

	end

	addEventHandler('onMarkerHit', resourceRoot, function(player, mDim)

		if orders[player] and orders[player].destination == source and mDim
			and player.vehicle == exports.jobs_main:getPlayerSessionData(player, 'vehicle')
		then

			local order = orders[player]

			local x1,y1,z1 = unpack(order.start_pos)
			local x2,y2,z2 = getElementPosition(source)

			local distance = getDistanceBetweenPoints3D( x1,y1,z1, x2,y2,z2 )
			local money = math.floor(distance * Config.costPerMeter)

			exports.jobs_main:addPlayerSessionMoney(player, money)

			exports.jobs_main:setPlayerSessionData(player, 'order', nil)
			exports.jobs_main:increasePlayerSessionData(player, 'orders', 1)
			exports.jobs_main:addPlayerStats(player, 'orders_passed', 1)

			exports['hud_notify']:notify(player, 'Такси', 'Заказ выполнен')

			clearTableElements(order)
			orders[player] = nil

			createOrderTimer(player)

		end

	end)

	addEventHandler('jobs.onJobFinish', root, function(data)

		if data.work == Config.resourceName then

			orders[source] = nil
			orderTimers[source] = nil

		end

	end)

------------------------------------------------
