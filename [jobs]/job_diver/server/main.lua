
----------------------------------------------------

	function startWork(stationId)

		--if not exports.acl:isAdmin(client) then return end

		if not exports.jobs_main:createPlayerSession(client) then return end
		createPlayerWork(client)

	end
	addEvent('diver.start', true)
	addEventHandler('diver.start', resourceRoot, startWork)

----------------------------------------------------

	function finishWork(_player)

		local player = _player or client

		exports.jobs_main:finishPlayerSession(player)

	end
	addEvent('diver.finish', true)
	addEventHandler('diver.finish', resourceRoot, finishWork)


----------------------------------------------------