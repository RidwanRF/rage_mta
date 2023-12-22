
------------------------------------------------------------

	currentClansTop = {}

	function updateClansTop()

		local teams = getElementsByType('team', resourceRoot)

		table.sort(teams, function(a,b)
			return getClanRating(a) > getClanRating(b)
		end)

		local top = {}

		for _, team in pairs( teams ) do

			local team_data = team:getData('team.data') or {}
			local rating, calc_data = getClanRating(team)

			table.insert(top, {

				name = team.name,
				rating = splitWithPoints( rating, '.' ),
				areas = calc_data.areas,
				members = calc_data.members,
				hours = calc_data.hours,
				bank = splitWithPoints( calc_data.bank, '.' ),

			})

		end

		currentClansTop = top
		top_updated = {}

	end

------------------------------------------------------------

	top_updated = {}

	function returnClansTop()

		if top_updated[client] then return end
		top_updated[client] = true

		triggerClientEvent(client, 'teams.receiveClansTop', resourceRoot, currentClansTop)

	end
	addEvent('teams.returnClansTop', true)
	addEventHandler('teams.returnClansTop', resourceRoot, returnClansTop)

	addEventHandler('onPlayerQuit', root, function()

		if top_updated[source] then
			top_updated[source] = nil
		end

	end)

------------------------------------------------------------

	setTimer( updateClansTop, 15*60*1000, 0 )

------------------------------------------------------------

	addEventHandler('onElementDataChange', root, function( dn, old, new )

		if dn == 'level' and new and source.team and old and ( new - old ) == 1 then
			increaseTeamStats( source.team, 'hours', 1 )
		end

	end)

------------------------------------------------------------