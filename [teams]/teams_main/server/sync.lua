

------------------------------------------------------

	local queue = {}
	
	function q_synchronizeTeam( team, players )

		local t_data = base64Encode( toJSON( team:getData('team.data') or {} ) )
		triggerClientEvent(players, 'teams.synchronizeData', resourceRoot, t_data)

	end

------------------------------------------------------

	function synchronizeTeam( team, _player )

		local players

		if isElement(_player) then
			players = { _player }
		else
			players = team.players
		end

		queue[team] = queue[team] or { players = {} }

		for _, player in pairs( players ) do
			queue[team].players[player] = true
		end

	end

------------------------------------------------------

	setTimer(function()

		for team, data in pairs( queue ) do

			local players = {}

			for player in pairs( data.players ) do
				if isElement(player) then
					table.insert( players, player )
				end
			end

			if #players > 0 and isElement(team) then
				q_synchronizeTeam( team, players )
			end 

		end

		queue = {}

	end, 200, 0)

------------------------------------------------------

	addEvent('teams.sync_query', true)
	addEventHandler('teams.sync_query', resourceRoot, function()

		if client.team then
			synchronizeTeam( client.team, client )
		end

	end)

------------------------------------------------------