

addEventHandler('onClientElementStreamIn', resourceRoot, function()

	if source.type == 'vehicle' then
		triggerServerEvent('vehicles.returnSyncData', resourceRoot, source)
	end

end, true, 'high+1000')

addEvent('vehicles.receiveSyncData', true)
addEventHandler('vehicles.receiveSyncData', resourceRoot, function(vehicle, data)

	for k,v in pairs( data ) do
		vehicle:setData(k,v, false)
	end

end)