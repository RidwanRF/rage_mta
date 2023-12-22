
	
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

	function disableCar(player)
		if player.vehicle and exports.jobs_main:getPlayerWork(player) == 'job_cargo' then
			exports.hud_notify:notify(player, 'Грузчик', 'Транспорт запрещен!')
			player.vehicle = nil
			local x,y,z = getElementPosition( player )
			setElementPosition( player, x+2, y+2, z )
		end
	end
	
	function createPlayerWork(player)

		local work = playersWork[player]
		if work then return end

		player.model = Config.skin

		playersWork[player] = {}

		createPlayerOrder(player)

		disableCar(player)

		addEventHandler ( "onVehicleEnter", root, disableCar)

	end

----------------------------------------------------------------

	function createPlayerOrder(player)

		local work = playersWork[player]
		if not work then return end

		if work.order then return end

		local x,y,z = unpack( Config.orders[math.random(#Config.orders)] )

		local marker = createMarker(  x,y,z, 'corona', 2, 0, 0, 0, 0, player )
		local blip = createBlipAttachedTo( marker, 0, nil, nil, nil, nil, nil, nil, nil, player )

		marker:setData('controlpoint.3dtext', '[Груз]')
		blip:setData('icon', 'target')

		work.order = {

			marker = marker,
			blip = blip,

		}

		addEventHandler('onMarkerHit', marker, function( player, mDim )

			if player.vehicle then return end

			local work = playersWork[player]

			if work and work.order and work.order.marker == source and mDim and source.interior == player.interior then

				exports.hud_notify:notify(player, 'Грузчик', 'Возьмите груз')

			end

		end)

		triggerClientEvent(player, 'cargo.createOrderBind', resourceRoot, marker)
		exports.hud_notify:notify(player, 'Грузчик', 'Отправляйтесь за грузом')

	end

	function pickPlayerBox(player)

		local work = playersWork[player]
		if not work then return end

		if not work.order then return end

		setPedAnimation(player, "CARRY", "crry_prtial", 1, true, true, false)

		local x,y,z = getElementPosition(player)

		work.object = { object = createObject(3014, x,y,z) }
		exports['bone_attach']:attachElementToBone(work.object.object, player, 12, 0.12, 0.22, 0.1, -90, 15, 0)

		setPlayerControlStates(player, false)

	end

----------------------------------------------------------------
	
	function takeBox()

		local work = playersWork[client]
		if not work then return end

		if not work.order then return end

		pickPlayerBox(client)
		createDestination(client)

	end
	addEvent('cargo.takeBox', true)
	addEventHandler('cargo.takeBox', resourceRoot, takeBox)

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

		marker:setData('controlpoint.3dtext', '[Несите груз]')
		blip:setData('icon', 'target')

		exports.hud_notify:notify(player, 'Вы подняли груз', 'Погрузите его')

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

		setPlayerControlStates(player, true)
		setPedAnimation(player)

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