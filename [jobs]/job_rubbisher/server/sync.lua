

----------------------------------------------------

	sync_data = {}

----------------------------------------------------

	addEvent('rubbisher.syncManipulator', true)
	addEventHandler('rubbisher.syncManipulator', resourceRoot, function( anims, needed_vehicles )

		if anims and client.vehicle then
			sync_data[client.vehicle] = anims
		end

		if getTableLength(needed_vehicles or {}) > 0 then

			local data = {}

			for vehicle in pairs( needed_vehicles ) do

				if isElement(vehicle) and sync_data[vehicle] then
					data[vehicle] = sync_data[vehicle]
				end

			end

			triggerClientEvent(client, 'rubbisher.syncManipulator', resourceRoot, data)
			
		end

	end)

----------------------------------------------------

	addEventHandler('onElementDestroy', root, function()
		if sync_data[source] then

		end
	end)

----------------------------------------------------