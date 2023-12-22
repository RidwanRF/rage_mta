

--------------------------------------------------------------------------------

	function appendTeamHistory( team_id, row )

		local team = teams[team_id]
		if not team_id then return end

		local history = team.data.history

		if #history >= 20 then
			table.remove( history, #history )
		end

		table.insert( history, 1, { text = row, time = getRealTime().timestamp } )

		setTeamData(team_id, 'history', history)

	end

--------------------------------------------------------------------------------