

---------------------------------------------

	function getTeamStats( team, stat )

		local data = team:getData('team.data') or {}
		return (data.stats or {})[stat] or 0

	end

	function increaseTeamStats( team, stat, amount )

		local data = team:getData('team.data') or {}

		data.stats = data.stats or {}
		data.stats[stat] = ( data.stats[stat] or 0 ) + ( amount or 1 )

		setTeamData( data.id, 'stats', data.stats )

	end


---------------------------------------------