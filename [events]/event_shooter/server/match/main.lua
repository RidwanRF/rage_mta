

----------------------------------------

	matches = {}

----------------------------------------

	function getPlayerMatch( player )

		for _, match in pairs( matches ) do

			if match.players and (
				match.players[player] or match.players.team_1[player] or match.players.team_2[player]
			) then
				return match
			end

		end

	end

------------------------------------------

	initClasses()

------------------------------------------