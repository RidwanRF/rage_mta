

------------------------------------------------------------

	local pneumo = {}
	local pneumo_move = {}

------------------------------------------------------------

	addEventHandler('onElementDataChange', root, function( dn, old, new )

		if dn == 'pneumo' and ( new or 0 ) > 0 and source.type == 'vehicle' then
			updateVehiclePneumo( source )
		end

	end)

	addEventHandler('onElementDestroy', root, function()

		if source.type == 'vehicle' then
			pneumo[source] = nil
		end

	end)

------------------------------------------------------------

	function updateVehiclePneumo( vehicle )

		local db_handling = vehicle:getData('handling')
		local handling = getModelHandling( vehicle.model )

		pneumo[vehicle] = {

			default = db_handling.suspensionLowerLimit or handling.suspensionLowerLimit,
			step = 0,
			bias_step = { front = 0, rear = 0 },

		}

	end

------------------------------------------------------------

	function togglePneumo( player )

		if not player.vehicle then return end
		if ( player.vehicle:getData('pneumo') or 0 ) <= 0 then return end

		local step = 0.01

		if not pneumo[player.vehicle] then updateVehiclePneumo( player.vehicle ) end
		local vehicle_pneumo = pneumo[player.vehicle]

		local p_step = vehicle_pneumo.step
		vehicle_pneumo.step = vehicle_pneumo.step > 0.5 and -Config.pneumoAmplitude or Config.pneumoAmplitude

		if p_step ~= vehicle_pneumo.step then

			if not pneumo_move[player] then

				pneumo_move[player] = {
					key = key,
					start = getTickCount(  ),
					acceleration = player.vehicle:getHandling().engineAcceleration,
				}

			end

			player.vehicle:setHandling('engineAcceleration', 0)
			setControlState( player, 'accelerate', true )

		else
			stopMovePneumo( player )
		end

		local value = math.clamp( vehicle_pneumo.default + (-vehicle_pneumo.step * step), -0.8, -0.01 )

		player.vehicle:setHandling( 'suspensionLowerLimit', value)

		triggerClientEvent( player, 'pneumo.displayAnim', resourceRoot, vehicle_pneumo.step )


	end

------------------------------------------------------------

	function movePneumo( player, key )

		local h_side = (
			key == 'num_1' or key == 'num_3'
		) and 'down' or ( (
			key == 'num_7' or key == 'num_9'
		) and 'up' or false )

		local v_side = (
			key == 'num_1' or key == 'num_7'
		) and 'front' or ( (
			key == 'num_3' or key == 'num_9'
		) and 'rear' or false )

		if not (v_side and h_side) then return end

		local step = 0.02

		if not player.vehicle then return end
		if ( player.vehicle:getData('pneumo') or 0 ) <= 0 then return end

		if not pneumo[player.vehicle] then updateVehiclePneumo( player.vehicle ) end
		local vehicle_pneumo = pneumo[player.vehicle]

		local p_step = vehicle_pneumo.step
		vehicle_pneumo.step = math.clamp(
			vehicle_pneumo.step + ( h_side == 'up' and 1 or -1 ),
			-Config.pneumoAmplitude, Config.pneumoAmplitude
		)

		local p_b_step = vehicle_pneumo.bias_step[v_side]
		vehicle_pneumo.bias_step[v_side] = math.clamp(
			vehicle_pneumo.bias_step[v_side] + ( h_side == 'up' and 1 or -1 ),
			-Config.pneumoAmplitude, Config.pneumoAmplitude
		)

		if (p_step ~= vehicle_pneumo.step) or (p_b_step ~= vehicle_pneumo.bias_step[v_side]) then

			if not pneumo_move[player] then
				pneumo_move[player] = {
					key = key,
					start = getTickCount(  ),
					acceleration = player.vehicle:getHandling().engineAcceleration,
				}
			end

			player.vehicle:setHandling('engineAcceleration', 0)
			setControlState( player, 'accelerate', true )

		else
			stopMovePneumo( player )
		end

		local value = math.clamp( vehicle_pneumo.default + (-vehicle_pneumo.step * step), -0.8, -0.01 )
		local bias_value = math.clamp( 0.5 + (vehicle_pneumo.bias_step.front * step) + (-vehicle_pneumo.bias_step.rear * step), 0.3, 0.7 )

		player.vehicle:setHandling( 'suspensionLowerLimit', value)
		player.vehicle:setHandling( 'suspensionFrontRearBias', bias_value)

		triggerClientEvent( player, 'pneumo.displayAnim', resourceRoot, vehicle_pneumo.bias_step[v_side] )

	end

	function stopMovePneumo( player )

		if pneumo_move[player] then

			local p_pneumo_move = pneumo_move[player]

			if player.vehicle then

				player.vehicle:setHandling('engineAcceleration', p_pneumo_move.acceleration)
				setControlState( player, 'accelerate', false )

			end

		end

		pneumo_move[player] = nil

	end

	setTimer(function()

		local tick = getTickCount(  )

		for player, data in pairs( pneumo_move ) do

			if (tick - data.start) > 300 then
				movePneumo( player, data.key )
			end

		end

	end, 200, 0)

------------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		for _, player in pairs( getElementsByType('player') ) do

			if player.vehicle and player.vehicleSeat == 0 and (
				( player.vehicle:getData('pneumo') or 0 ) > 0
			) then

				togglePlayerPneumo( player, true )

			end

		end

	end)

	addEventHandler('onElementDataChange', root, function(dn, old, new)

		if dn == 'pneumo' and ( new or 0 ) > 0 then

			local occupant = getVehicleOccupant( source )

			if occupant then

				togglePlayerPneumo( occupant, true )

			end

		end

	end)

	addEventHandler('onVehicleEnter', root, function( player, seat )

		if seat == 0 and (source:getData('pneumo') or 0) > 0 then

			togglePlayerPneumo( player, true )

		end

	end)

	addEventHandler('onVehicleExit', root, function( player, seat )

		if seat == 0 and (source:getData('pneumo') or 0) > 0 then

			togglePlayerPneumo( player, false )

		end

	end)

	addEventHandler('onElementDestroy', root, function( player, seat )

		if source.type == 'vehicle' and (source:getData('pneumo') or 0) > 0 then

			local occupant = getVehicleOccupant( source )

			if occupant then
				togglePlayerPneumo( occupant, false )
			end

		end

	end)

------------------------------------------------------------

	function togglePlayerPneumo( player, flag )

		local func = flag and bindKey or unbindKey

		func( player, 'num_1', 'down', movePneumo )
		func( player, 'num_7', 'down', movePneumo )
		func( player, 'num_3', 'down', movePneumo )
		func( player, 'num_9', 'down', movePneumo )

		func( player, 'num_1', 'up', stopMovePneumo )
		func( player, 'num_7', 'up', stopMovePneumo )
		func( player, 'num_3', 'up', stopMovePneumo )
		func( player, 'num_9', 'up', stopMovePneumo )

		func( player, 'num_5', 'down', togglePneumo )
		func( player, 'num_5', 'up', stopMovePneumo )

	end

------------------------------------------------------------
	
