
	
----------------------------------------------------------------

	local playerRoutes = {}

----------------------------------------------------------------

	function createPlayerRoute(player, routeId)

		local route = playerRoutes[player]
		if route then return end

		local routeData = Config.routes[routeId]

		playerRoutes[player] = {
			id = routeId,
		}

		createSource(player)

	end

----------------------------------------------------------------
	
	function createSource(player)

		local route = playerRoutes[player]
		if not route then return end

		local routeConfig = Config.routes[route.id]

		local x,y,z = unpack(routeConfig.source)

		local marker = createMarker(x,y,z, 'corona', 3, 0, 0, 0, 0, player)
		marker:setData('controlpoint.3dtext', '[Загрузите машину]')

		local blip = createBlipAttachedTo(marker, 0, nil, nil, nil, nil, nil, nil, nil, player)
		blip:setData('icon', 'target')

		route.source = { marker = marker, blip = blip }

		addEventHandler('onMarkerHit', marker, function(player, mDim)

			if playerRoutes[player] and playerRoutes[player].source and playerRoutes[player].source.marker == source and mDim
				and exports.jobs_main:getPlayerSessionData(player, 'vehicle') == player.vehicle
			then

				local route = playerRoutes[player]

				clearTableElements(route.source)
				route.source = nil

				createDestinations(player)

				exports.hud_notify:notify(player, 'Автомобиль загружен', 'Точки указаны на карте')

			end

		end)

		exports.hud_notify:notify(player, 'Загрузите товар', 'Точка указана на карте')


	end

----------------------------------------------------------------

	function createDestinations(player)

		local route = playerRoutes[player]
		if not route then return end

		local routeConfig = Config.routes[route.id]

		route.destinations = {}

		for _, position in pairs( routeConfig.destinations ) do

			local x,y,z = unpack(position)

			local marker = createMarker(x,y,z, 'corona', 3, 0, 0, 0, 0, player)
			marker:setData('controlpoint.3dtext', '[Отвезите груз]')

			local blip = createBlipAttachedTo(marker, 0, nil, nil, nil, nil, nil, nil, nil, player)
			blip:setData('icon', 'target')

			route.destinations[marker] = { marker = marker, blip = blip }

		end


	end

	addEventHandler('onMarkerHit', resourceRoot, function(player, mDim)

			if playerRoutes[player] and playerRoutes[player].destinations and playerRoutes[player].destinations[source] and mDim
			and exports.jobs_main:getPlayerSessionData(player, 'vehicle') == player.vehicle
		then

			local route = playerRoutes[player]
			local routeConfig = Config.routes[route.id]

			clearTableElements( route.destinations[source] )
			route.destinations[source] = nil

			if getTableLength(route.destinations) == 0 then

				clearTableElements( route.destinations )
				route.destinations = nil

				exports.hud_notify:notify(player, 'План выполнен', 'Вы развезли весь груз')
				createSource(player)

				exports.jobs_main:addPlayerSessionMoney(player, routeConfig.money)
				exports.jobs_main:addPlayerStats(player, 'routes_passed', 1)

			end

		end

	end)

----------------------------------------------------------------

	function destroyPlayerRoute(player)

		local route = playerRoutes[player]
		if not route then return end

		clearTableElements(route)
		playerRoutes[player] = nil

	end

----------------------------------------------------------------

	addEventHandler('jobs.onJobFinish', root, function(data)

		if data.work == Config.resourceName then
			destroyPlayerRoute(source)
		end

	end)

----------------------------------------------------------------