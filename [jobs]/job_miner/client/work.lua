

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

		createBindHandler(marker, 'mouse1', 'сломать камень', function(marker)

			if stoneDigging then return end

			local x,y = getElementPosition(localPlayer)
			local mx,my = getElementPosition(marker)

			local r = findRotation(x,y, mx,my)

			setElementRotation(localPlayer, 0, 0, r)

			triggerServerEvent('miner.breakStone', resourceRoot)

			stoneDigging = true


		end)

	end
	addEvent('miner.createOrderBind', true)
	addEventHandler('miner.createOrderBind', resourceRoot, createOrderBind)

	addEvent('miner.onStoneBreak', true)
	addEventHandler('miner.onStoneBreak', resourceRoot, function(marker, result)

		if result then

			removeBindHandler(marker)

			createBindHandler(marker, 'f', 'Взять руду', function(marker)
				triggerServerEvent('miner.takeCore', resourceRoot)
			end)

		end

		stoneDigging = false



	end)

	addEventHandler('onClientKey', root, function(button)
		if (button == 'mouse1' or button == 'rctrl' or button == 'lctrl' or button == 'lalt' or button == 'ralt')
		and exports['jobs_main']:getPlayerWork(localPlayer) == Config.resourceName
		then

			cancelEvent()

		end
	end)

--------------------------------------------------------------------------------------
