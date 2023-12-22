
------------------------------------

	VehiclesMatch_class = {

		init = function( self )
			self.vehicles = {}
		end,

		getFreeVehicle = function( self, match_team )

			self.vehicles[match_team] = self.vehicles[match_team] or {}

			local last_vehicle = self.vehicles[match_team][ #self.vehicles[match_team] ]

			if last_vehicle and getTableLength(last_vehicle.occupants) < 4 then
				return last_vehicle
			else

				local start_positions = self.map.start[match_team]

				local p_index = getTableLength( self.vehicles[match_team] ) + 1

				if not start_positions[p_index] then return false end

				local x,y,z,r = unpack( start_positions[p_index] )

				local models = { 405, 567, 597, 516 }
				local vehicle = createVehicle( models[math.random(#models)], x,y,z + 2, 0, 0, r )

				vehicle.dimension = self.dimension
				setVehicleColor( vehicle, 0, 0, 0 )

				vehicle:setData('fuel', 1000)

				vehicle:setData('tint_side', 0.8)
				vehicle:setData('tint_front', 0.8)
				vehicle:setData('tint_rear', 0.8)

				table.insert( self.vehicles[match_team], vehicle )

				return vehicle
				
			end


		end,

		addPlayer = function( self, player, match_team )

			if player.dimension ~= 0 then return end
			if player.interior ~= 0 then return end

			if isPedInVehicle( player ) then
				removePedFromVehicle( player )
			end

			self.players[match_team][player] = {

				prev_data = {
					pos = { getElementPosition(player) },
					dimension = player.dimension,
					interior = player.interior,
				},

			}
			player.health = 100

			local vehicle = self:getFreeVehicle( match_team )
			player.dimension = self.dimension

			warpPedIntoVehicle( player, vehicle, getTableLength(vehicle.occupants) )

			player:setData('hud.hidden', true)
			player:setData('drift.hidden', true)
			player:setData('respawn.suppressed', true)
			player:setData('binds.disabled', true)

			player.model = 19

			self:synchronize()

		end,


	}

	extendClass(VehiclesMatch_class, Match_class)

------------------------------------