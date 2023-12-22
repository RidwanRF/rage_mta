

--------------------------------------------------
	
	function handlePlayerKick(_player)

		local player = isElement(_player) and _player or source

		local match = getPlayerMatch(player)

		if match then

			local x,y,z = getElementPosition(player)
			spawnPlayer(player, x,y,z, 0, player.model, 0, 0, player.team )

			match:removePlayer( player )

		end

	end

	addEventHandler('onPlayerWasted', root, function( _, killer )

		local match = getPlayerMatch( source )

		if match then

			if match.kills then

				local team

				if match.type == 'team' then

					team = match:getPlayerTeam( source )

					local op_team = team == 'team_1' and 'team_2' or 'team_1'
					match.kills[op_team] = ( match.kills[op_team] or 0 ) + 1

				elseif match.type == 'mincer' then

					if isElement(killer) then
						match.kills[killer] = ( match.kills[killer] or 0 ) + 1
					end

					
				end

			end

			match:synchronize()

			setTimer(function(player, killer)

				if not isElement(player) then return end

				local match = getPlayerMatch(player)
				if not match then return end

				if match.finished then
					return
				end

				local x,y,z, start
				local team

				if match.type == 'team' then

					team = match:getPlayerTeam( player )
					start = match.map.start[team]

				elseif match.type == 'mincer' then

					start = match.map.start.mincer

				end

				x,y,z = unpack(start[ math.random(#start) ])
				spawnPlayer(player, x,y,z+1, 0, player.model, player.interior, player.dimension, player.team )

				player:setData('event_shooter.match.immortal', true)

				setTimer(function(player)

					if not isElement(player) then return end

					local match = getPlayerMatch(player)
					if not match then return end

					if match.finished then
						return
					end

					player:setData('event_shooter.match.immortal', false)

				end, 5000, 1, player)

				
			end, 3000, 1, source, killer)

		end

	end)

	addEventHandler('onPlayerQuit', root, handlePlayerKick, true, 'high+100')

--------------------------------------------------

	addEventHandler('onResourceStop', resourceRoot, function()
		for _, match in pairs( matches ) do

			if match.type == 'team' then

				for _, team in pairs( match.players ) do
					for player in pairs( team ) do
						match:removePlayer( player )
					end
				end

			elseif match.type == 'mincer' then

				for player in pairs( match.players ) do
					match:removePlayer( player )
				end

			end

		end
	end)

--------------------------------------------------

	addEventHandler('onElementDataChange', root, function( dn, old, new )

		if dn == 'event_shooter.match.immortal' then
			source.alpha = new and 128 or 255
		end

	end)

--------------------------------------------------