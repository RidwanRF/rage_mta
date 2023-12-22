
addEvent('jobs.onJobStart', true)
addEvent('work.onSessionUpdate', true)

local workSession

function getPlayerSessionData(player, key)

	if not workSession then return false end
	return workSession[key]

end

addEvent('work.session.receive', true)
addEventHandler('work.session.receive', resourceRoot, function(session)

	workSession = session

	if workSession then
		triggerEvent( 'work.onSessionUpdate', getResourceRoot(workSession.work), workSession )
	end


end)

function handleJobVisit()
	increaseElementData(localPlayer, 'visits.' .. sourceResource.name, 1)
end

function syncStats( data )

	for k,v in pairs(data) do
		localPlayer:setData(k,v,false)
	end

end
addEvent('work.syncStats', true)
addEventHandler('work.syncStats', resourceRoot, syncStats)