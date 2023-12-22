

addCommandHandler('set_clan_data', function( player, _, id, key, value )

	if exports.acl:isAdmin( player ) then

		id = tonumber(id)
		value = tonumber(value)

		if id and value then

			setTeamData( id, key, value )
			exports.chat_main:displayInfo( player, 'set_clan_data successfully', { 255,255,255 } )
			
		end


	end


end)

addCommandHandler('tm_getclans', function( player )

	if exports.acl:isAdmin( player ) then

		for id, team in pairs( teams ) do

			exports.chat_main:displayInfo( player, ('КЛАН %s - ID %s'):format( team.data.name, id ), { 255,255,255 } )

		end

	end


end)