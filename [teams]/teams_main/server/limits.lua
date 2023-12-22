

---------------------------------------------

	function getTeamLimit( team, limit )

		local data = team:getData('team.data') or {}
		return (data.limits or {})[limit] or 0

	end

	function increaseTeamLimit( team, limit )

		local data = team:getData('team.data') or {}

		data.limits = data.limits or {}
		data.limits[limit] = ( data.limits[limit] or 0 ) + 1

		setTeamData( data.id, 'limits', data.limits )

	end

---------------------------------------------

	addEventHandler('onServerDayCycle', root, function()

		setTimer(function()

			for id, team in pairs( teams ) do
				setTeamData( id, 'limits', {} )
			end

		end, 3000, 1)

	end)

---------------------------------------------

	addCommandHandler('tm_restore_limit', function( player, _, team_id )

		if exports.acl:isAdmin( player ) then

			team_id = tonumber(team_id)
			setTeamData( team_id, 'limits', {} )

			exports.chat_main:displayInfo( player, 'tm_restore_limit successfully', {255,255,255} )

		end

	end)

	addCommandHandler('tm_restore_all_limits', function( player )

		if exports.acl:isAdmin( player ) then

			for id, team in pairs( teams ) do
				setTeamData( id, 'limits', {} )
			end

			exports.chat_main:displayInfo( player, 'tm_restore_all_limits successfully', {255,255,255} )

		end

	end)

---------------------------------------------