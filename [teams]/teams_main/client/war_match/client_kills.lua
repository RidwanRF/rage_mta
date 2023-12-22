

-------------------------------------------------------

	currentMatchKills = {}

	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

		if dn == 'team.match.data' then

			if not new then
				currentMatchKills = {}
			end

		end

	end)

	addEventHandler('onClientPlayerWasted', root, function( killer )

		if localPlayer:getData('team.match.data') and localPlayer.dimension > 0 then

			if isElement(killer) and killer.type == 'player' and killer.dimension == localPlayer.dimension then

				currentMatchKills[killer] = ( currentMatchKills[killer] or {kills = 0, deaths = 0} )
				currentMatchKills[killer].kills = currentMatchKills[killer].kills + 1

			end

			currentMatchKills[source] = ( currentMatchKills[source] or {kills = 0, deaths = 0} )
			currentMatchKills[source].deaths = currentMatchKills[source].deaths + 1
			
		end

	end)

-------------------------------------------------------

	function getPlayerMatchKills( player )
		return currentMatchKills[player] or {kills = 0, deaths = 0}
	end

-------------------------------------------------------