
----------------------------------------------------

	function startWork(stationId)

		if not exports.jobs_main:createPlayerSession(client) then return end

		createPlayerWork(client)

	end
	addEvent('cargo.start', true)
	addEventHandler('cargo.start', resourceRoot, startWork)

----------------------------------------------------

	function finishWork(_player)

		local player = _player or client
 
		exports.jobs_main:finishPlayerSession(player)

	end
	addEvent('cargo.finish', true)
	addEventHandler('cargo.finish', resourceRoot, finishWork)


----------------------------------------------------