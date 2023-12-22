
------------------------------------------

	function synchronizeMatchData( data )
		localPlayer:setData('event_shooter.match.data', data, false)
	end	
	addEvent('event_shooter.synchronizeMatchData', true)
	addEventHandler('event_shooter.synchronizeMatchData', resourceRoot, synchronizeMatchData)

------------------------------------------