
----------------------------------------------------

	function startWork(stationId)

		if not exports.jobs_main:createPlayerSession(client) then return end

		createPlayerWork(client)

	end
	addEvent('miner.start', true)
	addEventHandler('miner.start', resourceRoot, startWork)

----------------------------------------------------

	function finishWork(_player)

		local player = _player or client
 
		exports.jobs_main:finishPlayerSession(player)

	end
	addEvent('miner.finish', true)
	addEventHandler('miner.finish', resourceRoot, finishWork)


----------------------------------------------------