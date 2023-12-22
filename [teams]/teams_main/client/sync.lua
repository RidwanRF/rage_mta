

------------------------------------------------------
	
	function synchronizeTeam( e_data )

		local data = fromJSON( base64Decode( e_data ), true )

		local _members = {}
		for member, m_data in pairs( data.members ) do
			_members[tostring(member)] = m_data
		end
		data.members = _members
		
		localPlayer.team:setData('team.data', data, false)

	end
	addEvent('teams.synchronizeData', true)
	addEventHandler('teams.synchronizeData', resourceRoot, synchronizeTeam)

------------------------------------------------------
