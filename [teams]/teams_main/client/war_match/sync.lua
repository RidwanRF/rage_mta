
------------------------------------------

	function synchronizeMatchData( data )
		localPlayer:setData('team.match.data', data, false)
	end	
	addEvent('teams.synchronizeMatchData', true)
	addEventHandler('teams.synchronizeMatchData', resourceRoot, synchronizeMatchData)

------------------------------------------