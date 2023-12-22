
---------------------------------------------

	function syncData( data )

		for k,v in pairs( data ) do
			localPlayer:setData(k,v, false)
		end

	end
	addEvent('save.syncData', true)
	addEventHandler('save.syncData', resourceRoot, syncData)

---------------------------------------------

	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

		if dn == 'unique.login' and new then
			setTimer(triggerServerEvent, 5000, 1, 'save.requireSyncData', resourceRoot)
		end

	end)

---------------------------------------------