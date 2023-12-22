
	
----------------------------------------------------------------

	local playersWork = {}

----------------------------------------------------------------

	local controls = {'jump', 'enter_exit'}

	function setPlayerControlStates(player, state)
		for _, control in pairs( controls ) do
			toggleControl(player, control, state)
		end
	end

----------------------------------------------------------------

	function setPlayerPickaxeState(player, state)
		
		player:setData('weapon.slot', 0)

		local inventoryConfig = exports.main_inventory:getConfigSetting('items')

		if state then
			exports.main_inventory:setPlayerCustomObject(player, inventoryConfig.job_miner_pickaxe)
		else
			exports.main_inventory:removePlayerCustomObject(player)
		end

	end

----------------------------------------------------------------

	function createPlayerWork(player)

		local work = playersWork[player]
		if work then return end

		player.model = Config.skin

		playersWork[player] = {}

		setPlayerPickaxeState(player, true)
		createPlayerOrder(player)

	end

----------------------------------------------------------------

	function createPlayerOrder(player)

		local work = playersWork[player]
		if not work then return end

		if work.order then return end

		local x,y,z = unpack( Config.orders[math.random(#Config.orders)] )

		local marker = createMarker(  x,y,z, 'corona', 4, 0, 0, 200, 150, player )
		local blip = createBlipAttachedTo( marker, 0, nil, nil, nil, nil, nil, nil, nil, player )

		marker:setData('controlpoint.3dtext', '[Добыча руды]')
		blip:setData('icon', 'target')

		work.order = {

			marker = marker,
			blip = blip,

			health = Config.orderHealth,

		}

		addEventHandler('onMarkerHit', marker, function( player, mDim )

			local work = playersWork[player]

			if work and work.order and work.order.marker == source and mDim and source.interior == player.interior then

				exports.hud_notify:notify(player, 'Шахта', 'Разрушьте камень')

			end

		end)

		triggerClientEvent(player, 'miner.createOrderBind', resourceRoot, marker)
		exports.hud_notify:notify(player, 'Шахта', 'Отправляйтесь за рудой')

	end

	function pickPlayerStone(player)

		local work = playersWork[player]
		if not work then return end

		if not work.order then return end

		setPedAnimation(player, "CARRY", "crry_prtial", 1, true, true, false)

		local x,y,z = getElementPosition(player)

		work.object = { object = createObject(3930, x,y,z) }
		exports['bone_attach']:attachElementToBone(work.object.object, player, 12, 0.25, 0.35, 0, 150, 0, 0)

		setPlayerControlStates(player, false)

	end

----------------------------------------------------------------

	local digAnimations = {
		{'baseball', 'bat_1'},
		{'baseball', 'bat_2'},
		{'baseball', 'bat_3'},
	}

	function doPlayerDig()

		local work = playersWork[client]
		if not work then return end

		if not work.order then return end

		local anim = digAnimations[math.random(#digAnimations)]
		local block, name = unpack(anim)

		setPedAnimation(client, block, name, 1, false, true)

		setTimer(function(client)

			if not isElement(client) then return end
			setPedAnimation(client)

			work.order.health = work.order.health - 1
			triggerClientEvent(client, 'miner.onStoneBreak', resourceRoot, work.order.marker, work.order.health <= 0)

		end, 1000, 1, client)

	end
	addEvent('miner.breakStone', true)
	addEventHandler('miner.breakStone', resourceRoot, doPlayerDig)

----------------------------------------------------------------

	
	function takeCore()

		local work = playersWork[client]
		if not work then return end

		if not work.order then return end

		pickPlayerStone(client)
		createDestination(client)

	end
	addEvent('miner.takeCore', true)
	addEventHandler('miner.takeCore', resourceRoot, takeCore)

----------------------------------------------------------------

	function createDestination(player)

		local work = playersWork[player]
		if not work then return end

		if not work.order then return end

		clearTableElements(work.order)
		work.order = nil

		local x,y,z = unpack(Config.destination)

		local marker = createMarker( x,y,z, 'cylinder', 2, 0, 0, 0, 0, player )
		local blip = createBlipAttachedTo( marker, 0, nil, nil, nil, nil, nil, nil, nil, player )

		marker:setData('controlpoint.3dtext', '[Несите руду]')
		blip:setData('icon', 'target')

		exports.hud_notify:notify(player, 'Вы добыли руду', 'Отнесите ее на базу')

		work.destination = {

			marker = marker,
			blip = blip,

		}

		addEventHandler('onMarkerHit', marker, function( player, mDim )

			local work = playersWork[player]

			if work and work.destination and work.destination.marker == source and mDim and source.interior == player.interior then

				completePlayerOrder( player )

			end

		end)

	end

	function completePlayerOrder(player)

		local work = playersWork[player]
		if not work then return end

		if not work.destination then return end

		clearTableElements(work.destination)
		clearTableElements(work.object)
		work.destination = nil

	    setPedAnimation(player, "CARRY", "putdwn", 1, false, true, false, true)

	    setTimer(setPedAnimation, 1000, 1, player, "ped", "IDLE_tired", -1, true, false, true, true)

	    setTimer(function(player)
	    	if isElement(player) then

	    		setPedAnimation(player)
			    setPlayerPickaxeState(player, true)

			    createPlayerOrder(player)
			    setPlayerControlStates(player, true)

	    	end
    	end, 2000, 1, player)

		exports.jobs_main:addPlayerSessionMoney(player, math.random(unpack(Config.money)))
		exports.jobs_main:addPlayerStats(player, 'orders_passed', 1)

	end

----------------------------------------------------------------

	function destroyPlayerWork(player)

		local work = playersWork[player]
		if not work then return end

		player.model = player:getData('character.skin') or 0

		setPlayerPickaxeState(player, false)
		setPlayerControlStates(player, true)

		clearTableElements(work)
		playersWork[player] = nil

	end

----------------------------------------------------------------

	addEventHandler('jobs.onJobFinish', root, function(data)

		if data.work == Config.resourceName then
			destroyPlayerWork(source)
		end

	end)

----------------------------------------------------------------