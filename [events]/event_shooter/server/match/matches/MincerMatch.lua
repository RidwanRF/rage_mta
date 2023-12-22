
------------------------------------------

	MincerMatch_class = {

		init = function( self, data )

			self.dimension = data.dimension
			self.type = data.type
			self.map_id = data.map_id
			self.bet = data.bet

			self.players = {}
			self.kills = {}

			self.callback = data.callback

			self:generateMap()

			matches[ self.dimension ] = self

			self.syncQueueTimer = setTimer(function()

				if self.synchronize_queue then
					self:synchronizeQueue()
				end

			end, 500, 0)

			self.colshape = createColRectangle( unpack( self.map.colshape ) )
			self.colshape:setData('render', true)

			self.colshape.dimension = self.dimension

		end,

		generateMap = function( self )
		
			self.map = table.copy(Config.maps[self.map_id], true)

			if self.map.mapping then

				self.mapping = {}

				for _, object in pairs( self.map.mapping ) do

					local object_element = createObject(
						object.model,
						object.x, object.y, object.z,
						object.rx, object.ry, object.rz
					) 

					object_element.dimension = self.dimension

					table.insert( self.mapping, object_element )
				end

			end

		end,

		destroy = function( self )

			matches[ self.dimension ] = nil
			clearTableElements( self )

		end,

		addPlayer = function( self, player )

			if player.dimension ~= 0 then return end
			if player.interior ~= 0 then return end

			if isPedInVehicle( player ) then
				removePedFromVehicle( player )
			end

			self.players[player] = {

				prev_data = {
					pos = { getElementPosition(player) },
					dimension = player.dimension,
					interior = player.interior,
				},

			}

			local start_positions = self.map.start.mincer
			local p_index = getTableLength( self.players ) + 1

			if not start_positions[p_index] then p_index = 1 end

			local x,y,z = unpack( start_positions[p_index] )
			player.health = 100

			spawnPlayer(player, x,y,z+1, 0, player.model, 0, self.dimension, player.team)

			player:setData('hud.hidden', true)
			player:setData('isAFK', false)

			-- player:setData('radar.hidden', true)
			player:setData('respawn.suppressed', true)

			removePedJetPack( player )

			self:synchronize()

		end,

		removePlayer = function( self, player )

			if player.vehicle then

				local vehicle = player.vehicle
				removePedFromVehicle( player )

				if isElement(vehicle) then
					destroyElement( vehicle )
				end

			end

			local player_data = self.players[player]
			local prev_data = player_data.prev_data


			if isPedDead( player ) then

				local x,y,z = unpack( prev_data.pos )
				spawnPlayer(player, x,y,z+1, 0, player.model, 0, 0, player.team)
				player.dimension = prev_data.dimension
				player.interior = prev_data.interior

			else

				local x,y,z = unpack( prev_data.pos )
				setElementPosition( player, x,y,z )

				player.dimension = prev_data.dimension
				player.interior = prev_data.interior

			end

			player:setData('respawn.suppressed', false)
			player:setData('team.match.immortal', false)
			player:setData('hud.hidden', false)
			player:setData('drift.hidden', false)
			player:setData('binds.disabled', false)
			-- player:setData('radar.hidden', false)

			player.model = player:getData('character.skin') or 0

			triggerClientEvent(player, 'event_shooter.synchronizeMatchData', resourceRoot, nil)

			self.players[player] = nil
			self.kills[player] = nil

			if (
				getTableLength( self.players )
			) <= 3 then

				self:finish()

			else
				self:synchronize()
			end

		end,

		start = function( self )

			self.started = getRealTime().timestamp
			self:synchronize()

			self.finishTimer = setTimer(function()

				self:finish()

			end, Config.match.time * 1000, 1)

		end,

		finish = function( self )

			if self.finished then return end
			self.finished = true

			local t_players = {}

			for player, kills in pairs( self.kills ) do
				table.insert( t_players, { player = player, kills = kills } )
			end

			table.sort( t_players, function( a,b )
				return a.kills > b.kills
			end )
			
			if self.callback then
				self.callback( self, table.slice( t_players, 0, 3 ) )
			end

			for player in pairs( self.players ) do
				self:removePlayer( player )
			end


			self:destroy()

		end,

		synchronize = function( self )
			self.synchronize_queue = true
		end,

		synchronizeQueue = function( self )

			if not self.players then return end

			local data = {

				started = self.started,
				type = self.type,
				map_id = self.map_id,

				colshape = self.colshape,
				mode = self.mode,

				players = self.players,
				kills = self.kills,

			}

			for player in pairs( self.players ) do
				triggerClientEvent(player, 'event_shooter.synchronizeMatchData', resourceRoot, data)
			end

		end,

	}

------------------------------------------