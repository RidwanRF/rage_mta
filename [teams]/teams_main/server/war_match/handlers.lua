

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

			if match.mode ~= 3 then

				local team = match:getPlayerTeam( source )

				if match.kills then

					local op_team = team == 'attackers' and 'defenders' or 'attackers'
					match.kills[op_team] = ( match.kills[op_team] or 0 ) + 1

				end

				match:synchronize()

				setTimer(function(player)

					if not isElement(player) then return end

					local match = getPlayerMatch(player)
					if not match then return end

					if match.finished then
						return
					end

					local team = match:getPlayerTeam( player )
					local start = match.map.start[team]

					local x,y,z = unpack(start[ math.random(#start) ])

					spawnPlayer(player, x,y,z+1, 0, player.model, player.interior, player.dimension, player.team )

					player:setData('team.match.immortal', true)

					setTimer(function(player)

						if not isElement(player) then return end

						local match = getPlayerMatch(player)
						if not match then return end

						if match.finished then
							return
						end

						player:setData('team.match.immortal', false)

					end, 5000, 1, player)

				end, 3000, 1, source)


			else
				handlePlayerKick( source )
			end

		end

	end)

	addEventHandler('onPlayerQuit', root, handlePlayerKick, true, 'high+100')

--------------------------------------------------

	addEventHandler('onResourceStop', resourceRoot, function()
		for _, match in pairs( matches ) do
			for _, team in pairs( match.players ) do
				for player in pairs( team ) do
					match:removePlayer( player )
				end
			end
		end
	end)

--------------------------------------------------

	addEventHandler('onElementDataChange', root, function( dn, old, new )

		if dn == 'team.match.immortal' then
			source.alpha = new and 128 or 255
		end

	end)

--------------------------------------------------