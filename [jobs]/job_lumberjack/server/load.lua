

------------------------------------------------------

	local controls = {'jump', 'enter_exit', 'sprint'}

	function setPlayerControlStates(player, state)
		for _, control in pairs( controls ) do
			toggleControl(player, control, state)
		end
	end

------------------------------------------------------

	function orderLogLoad()

		local work = playersWork[ client ]
		if not work then return end

		if work.load_order then return end

		local x,y,z = getElementPosition( client )

		work.load_order = {}

		work.load_order.object = createObject( 1171, x,y,z )

		exports['bone_attach']:attachElementToBone( work.load_order.object, client, 12, 0.22, 0.11, 0, 0, 0, 65 )
		setPedAnimation(client, "CARRY", "crry_prtial", 1, true, true, false)

		setPlayerControlStates(client, false)

		local vehicle = exports.jobs_main:getPlayerSessionData( client, 'vehicle' )

		local vx,vy,vz = getElementPosition( vehicle )
		local vrx,vry,vrz = getElementRotation( vehicle )

		work.load_order.marker = createMarker( vx,vy,vz, 'corona', 2, 0, 0, 0, 0, client )
		work.load_order.marker:setData('controlpoint.3dtext', '[Отнесите бревно]')

		work.load_order.blip = createBlipAttachedTo( work.load_order.marker, 0, nil, nil, nil, nil, nil, nil, nil, client )
		work.load_order.blip:setData( 'icon', 'target' )

		attachElements( work.load_order.marker, vehicle, 0, -3, 0 )

		triggerClientEvent( client, 'lumberjack.createLogHandler', resourceRoot, work.load_order.marker )

	end
	addEvent('lumberjack.orderLogLoad', true)
	addEventHandler('lumberjack.orderLogLoad', resourceRoot, orderLogLoad)

------------------------------------------------------

	addEvent('lumberjack.putLog', true)
	addEventHandler('lumberjack.putLog', resourceRoot, function( marker )

		if isElement(marker) then

			local work = playersWork[ client ]
			if not work then return end

			clearTableElements( work.load_order )
			work.load_order = nil

		    setPedAnimation(client, "CARRY", "putdwn", 1, false, true, false, true)

		    setTimer(setPedAnimation, 1000, 1, client, "ped", "IDLE_tired", -1, true, false, true, true)

		    setTimer(function(client)

		    	if isElement(client) then

		    		setPedAnimation(client)

				    setPlayerControlStates(client, true)
				    setPlayerAxeState( client, true )

					insertVehicleLog(client)

		    	end

	    	end, 2000, 1, client)

		end

	end)


------------------------------------------------------

	local log_offsets = {
		{ -0.5, -2.25, 0.43 },
		{ -0.1, -2.3, 0.43 },
		{ 0.3, -2.3, 0.43 },
		{ -0.3, -2.4, 0.83 },
		{ 0.1, -2.4, 0.83 },
	}

	function insertVehicleLog( player )

		local work = playersWork[ player ]
		if not work then return end

		work.vehicle_logs = work.vehicle_logs or {}
		local index = (#work.vehicle_logs + 1)

		local vehicle = exports.jobs_main:getPlayerSessionData( player, 'vehicle' )
		local x,y,z = getElementPosition( vehicle )

		local object = createObject( 1171, x,y,z )

		local ox,oy,oz = unpack( log_offsets[index] or {0,0,0} )

		attachElements( object, vehicle, ox,oy,oz, 340, 5, -15 )
		table.insert( work.vehicle_logs, object )

	end


------------------------------------------------------

	addEventHandler('onVehicleStartEnter', resourceRoot, function( player )

		local work = playersWork[ player ]
		if not work then return end

		if work.load_order then
			cancelEvent(  )
		end

	end)

------------------------------------------------------
