
------------------------------------------

	TeamMatch_class = {

		init = function( self, data )

			self.dimension = data.dimension
			self.type = data.type
			self.map_id = data.map_id
			self.bet = data.bet

			self.players = {
				team_1 = {},
				team_2 = {},
			}

			self.callback = data.callback

			self.kills = { team_1 = 0, team_2 = 0 }

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

			local start_positions = self.map.start[match_team]
			local p_index = getTableLength( self.players[match_team] ) + 1

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

			local p_team = self:getPlayerTeam( player )
			if not p_team then return end

			if player.vehicle then

				local vehicle = player.vehicle
				removePedFromVehicle( player )

				if isElement(vehicle) then
					destroyElement( vehicle )
				end

			end

			local player_data = self.players[p_team][player]

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

			self.players[p_team][player] = nil

			if (
				getTableLength( self.players[p_team] )
			) <= 0 then
				self:finish( p_team == 'team_1' and 'team_2' or 'team_1' )
			else
				self:synchronize()
			end

		end,

		getPlayerTeam = function( self, player )

			local p_team

			for team_name, team in pairs( self.players ) do

				if team[player] then
					return team_name
				end

			end

			return false

		end,

		start = function( self )

			self.started = getRealTime().timestamp
			self:synchronize()

			self.finishTimer = setTimer(function()

				local winner = false

				if self.kills.team_1 > self.kills.team_2 then
					winner = 'team_1'
				elseif self.kills.team_1 < self.kills.team_2 then
					winner = 'team_2'
				end

				self:finish( winner )


			end, Config.match.time * 1000, 1)

		end,

		finish = function( self, winner_team )

			if self.finished then return end
			self.finished = true

			if self.callback then
				self.callback( self, winner_team )
			end

			for _, team in pairs( self.players ) do

				for player in pairs( team ) do
					self:removePlayer( player )
				end

			end

			self:destroy()

		end,

		synchronize = function( self )
			self.synchronize_queue = true
		end,

		synchronizeQueue = function( self )

			local players = {}

			if not self.players then return end

			for _, team in pairs( self.players ) do

				for player in pairs( team ) do
					table.insert( players, player )
				end

			end

			local h_players = {}

			for team_name, team in pairs( self.players ) do

				h_players[team_name] = {}

				for player in pairs( team ) do
					h_players[team_name][player] = true
				end

			end

			local data = {

				team_1_count = getTableLength( self.players.team_1 ),
				team_2_count = getTableLength( self.players.team_2 ),

				started = self.started,
				type = self.type,
				map_id = self.map_id,

				colshape = self.colshape,
				mode = self.mode,

				players = h_players,

			}

			data.team_1_count = self.kills.team_1
			data.team_2_count = self.kills.team_2

			for _, player in pairs( players ) do
				if isElement(player) then
					data.match_team = self:getPlayerTeam( player )
					triggerClientEvent(player, 'event_shooter.synchronizeMatchData', resourceRoot, data)
				end
			end


		end,

	}

------------------------------------------