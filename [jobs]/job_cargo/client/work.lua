

--------------------------------------------------------------------------------------

	currentOrders = {}

	function getFreeOrderPosition()
		local possiblePositions = {}

		local usedPositions = {}

		for _, position in pairs( currentOrders ) do
			usedPositions[position] = true
		end

		local positions = Config.orders

		for index in pairs( positions ) do
			if not usedPositions[index] then
				table.insert(possiblePositions, index)
			end
		end

		return possiblePositions[ math.random(#possiblePositions) ]
	end

	function createOrderBind(marker)

		if localPlayer.vehicle then return end
		
		createBindHandler(marker, 'f', 'Взять груз', function(marker)
			triggerServerEvent('cargo.takeBox', resourceRoot)
		end)

	end
	addEvent('cargo.createOrderBind', true)
	addEventHandler('cargo.createOrderBind', resourceRoot, createOrderBind)

	addEventHandler ( "onVehicleEnter", root, function(player) 
		if player == localPlayer then
			if exports.jobs_main:getPlayerWork(localPlayer) == 'job_cargo' then
				setElementPosition( localPlayer, unpack(getElementPosition(localPlayer)))
			end
		end
	end)


--------------------------------------------------------------------------------------
