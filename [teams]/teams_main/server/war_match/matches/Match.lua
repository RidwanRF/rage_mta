
------------------------------------------

	Match_class = {

		init = function( self, data )

			self.dimension = data.dimension

			self.players = {
				attackers = {},
				defenders = {},
			}

			self.callback = data.callback
			self.mode = data.mode

			if self.mode == 1 then
				self.kills = { attackers = 0, defenders = 0 }
			end

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

			local free_ids = {}

			for index, map in pairs( Config.war_maps ) do
				if map.mode == self.mode then
					table.insert( free_ids, index )
				end
			end


			if #free_ids == 0 then return false end

			self.map_id = free_ids[math.random( #free_ids )]
			self.map = table.copy(Config.war_maps[self.map_id], true)

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
			player:setData('drift.hidden', true)
			player:setData('respawn.suppressed', true)

			removePedJetPack( player )

			player.model = 19

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

			triggerClientEvent(player, 'teams.synchronizeMatchData', resourceRoot, nil)

			self.players[p_team][player] = nil

			if (
				getTableLength( self.players[p_team] )
			) <= 0 then
				self:finish( p_team == 'attackers' and 'defenders' or 'attackers' )
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

				if self.mode == 1 then

					if self.kills.attackers > self.kills.defenders then
						winner = 'attackers'
					end

				elseif self.mode == 3 then

					if self.players then

						local att_count = getTableLength( self.players.attackers or {} )
						local def_count = getTableLength( self.players.defenders or {} )

						if att_count > 0 and def_count <= 0 then
							winner = 'attackers'
						end

					end

				end

				self:finish( winner )


			end, self.map.time, 1)

		end,

		finish = function( self, winner_team )

			if self.finished then return end
			self.finished = true

			for _, team in pairs( self.players ) do

				for player in pairs( team ) do
					self:removePlayer( player )
				end

			end

			if self.callback then
				self.callback( self, winner_team or 'defenders' )
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

				attackers_count = getTableLength( self.players.attackers ),
				defenders_count = getTableLength( self.players.defenders ),

				started = self.started,
				map_id = self.map_id,

				colshape = self.colshape,
				mode = self.mode,

				base = self.base,

				players = h_players,

			}

			if self.mode == 1 then
				data.attackers_count = self.kills.attackers
				data.defenders_count = self.kills.defenders
			end

			for _, player in pairs( players ) do
				data.match_team = self:getPlayerTeam( player )
				triggerClientEvent(player, 'teams.synchronizeMatchData', resourceRoot, data)
			end


		end,

	}

------------------------------------------