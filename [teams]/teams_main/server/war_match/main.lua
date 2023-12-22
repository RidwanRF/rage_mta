

----------------------------------------

	matches = {}

----------------------------------------

	function getPlayerMatch( player )

		for _, match in pairs( matches ) do

			if match.players and (
				match.players.attackers[player] or match.players.defenders[player]
			) then
				return match
			end

		end

	end

------------------------------------------

	initClasses()

------------------------------------------