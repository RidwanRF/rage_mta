

--------------------------------------------------------

	abilities = {}

--------------------------------------------------------

	local abilityClasses = {

		springboard = Springboard,
		impulse = Impulse,

	}

--------------------------------------------------------

	function resetVehicleAbility( vehicle, ability )

		local config = Config.abilities[ability]
		if not config then return end

		abilities[vehicle] = abilities[vehicle] or {}
		local vehicle_abilities = abilities[vehicle]

		vehicle_abilities[ ability ] = {
			reload = getRealTime().timestamp + config.reload_time,
		}

		local occupant = getVehicleOccupant( vehicle )

		if occupant then
			syncPlayerAbilities( occupant )
		end

	end

--------------------------------------------------------

	function usePlayerAbility( ability )

		local player = client

		if player.vehicleSeat ~= 0 then return end

		local vehicle = player.vehicle

		if not vehicle or (vehicle.model ~= 587) then return end

		local config = Config.abilities[ability]
		if not config then return end

		abilities[vehicle] = abilities[vehicle] or {}
		local vehicle_abilities = abilities[vehicle]

		if vehicle_abilities[ ability ] then

			if vehicle_abilities[ ability ].reload then

				if (getRealTime().timestamp < vehicle_abilities[ ability ].reload) then
					return
				end


			else

				return
					
			end

		end


		local fuel = vehicle:getData('fuel') or 0
		if fuel < config.fuel then return end

		increaseElementData( vehicle, 'fuel', -config.fuel )

		local Ability = abilityClasses[ability]

		vehicle_abilities[ ability ] = {

			start = getRealTime().timestamp,
			ability = Ability( { vehicle = vehicle } ),

		}

		syncPlayerAbilities( player )

	end
	addEvent('quadra.useAbility', true)
	addEventHandler('quadra.useAbility', resourceRoot, usePlayerAbility)

--------------------------------------------------------

	function syncPlayerAbilities( _player )

		local player = _player or client

		if player.vehicleSeat ~= 0 then return end

		local vehicle = player.vehicle

		if not vehicle or (vehicle.model ~= 587) then return end
		if not abilities[vehicle] then return end

		local timestamp = getRealTime().timestamp

		for key, ability in pairs( abilities[vehicle] ) do

			if ability.reload and ability.reload < timestamp then
				abilities[vehicle][key] = nil
			end

		end

		triggerClientEvent( player, 'quadra.syncAbilities', resourceRoot, abilities[vehicle] )

	end
	addEvent('quadra.syncAbilities', true)
	addEventHandler('quadra.syncAbilities', resourceRoot, syncPlayerAbilities)

--------------------------------------------------------
	
	addEventHandler('onElementDestroy', root, function()

		if abilities[source] then

			for id, ability in pairs( abilities[source] ) do
				if ability.ability then
					ability.ability:destroy()
				end
			end

			abilities[source] = nil

		end

	end)

--------------------------------------------------------

	addEventHandler('onPlayerVehicleEnter', root, function( vehicle, seat )

		if seat == 0 and vehicle.model == 587 then
			syncPlayerAbilities( source )
		end

	end)

--------------------------------------------------------