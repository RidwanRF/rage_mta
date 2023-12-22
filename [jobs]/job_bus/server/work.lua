
	
----------------------------------------------------------------

	local playerRoutes = {}

----------------------------------------------------------------

	function createPlayerRoute(player, routeId)

		local route = playerRoutes[player]
		if route then return end

		local routeData = Config.routes[routeId]

		playerRoutes[player] = {

			route = routeId,
			money = routeData.money,
			index = 0,

		}

		createNextWaypoint(player)

	end

----------------------------------------------------------------
	
	function createNextWaypoint(player)

		local route = playerRoutes[player]
		if not route then return end

		route.index = route.index + 1

		local routeData = Config.routes[route.route]
		local waypointIndex = route.index % (#routeData.waypoints)
		if waypointIndex == 0 then waypointIndex = #routeData.waypoints end

		local x,y,z = unpack( routeData.waypoints[waypointIndex] )

		local marker = createMarker(x,y,z, 'cylinder', 3, 0, 0, 0, 0, player)
		marker:setData('controlpoint.3dtext', routeData.waypoints[waypointIndex].stop and '[Остановка]' or '[Маршрут]')

		local blip = createBlipAttachedTo(marker, 0, nil, nil, nil, nil, nil, nil, nil, player)
		blip:setData('icon', 'target')

		route.marker = marker
		route.blip = blip

		exports.jobs_main:setPlayerSessionData(player, 'route', route)

	end

	addEventHandler('onMarkerHit', resourceRoot, function(player, mDim)

		if playerRoutes[player] and playerRoutes[player].marker == source and mDim
			and exports.jobs_main:getPlayerSessionData(player, 'vehicle') == player.vehicle
		then

			local route = playerRoutes[player]

			clearTableElements(route)
			createNextWaypoint(player)

			exports.jobs_main:addPlayerSessionMoney(player, route.money)
			
			exports.jobs_main:addPlayerStats(player, 'routes_passed', 1)

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