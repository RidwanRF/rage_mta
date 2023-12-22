
addEventHandler('onClientResourceStart', resourceRoot, function()

	for _, station in pairs( Config.stations ) do

		for _, markerData in pairs( station.pumps ) do

			local marker = createMarker(
				markerData.x,
				markerData.y,
				markerData.z-0.9,
				'cylinder',
				markerData.size or 2,
				255, 70, 80, 150
			)

			marker:setData('fuel.station', true)
			marker:setData('3dtext', '[АЗС]')
			marker:setData('3dtext.zAdd', 1)
			marker:setData('3dtext.size', 2)

			createBindHandler(marker, 'f', 'открыть окно', function()

				if bVehicleExiting then return end

				if localPlayer.vehicleSeat == 0 then
					if localPlayer.vehicle.frozen then return end
					openWindow('main')
				end
				
				increaseElementData(localPlayer, 'visits.fuel_station', 1)

			end, true)
			
			-- addEventHandler('onClientMarkerHit', marker, function(player, mDim)
			-- 	if player == localPlayer and mDim and player.vehicle then
			-- 		openWindow('main')
			-- 		increaseElementData(localPlayer, 'visits.fuel_station', 1)
			-- 	end
			-- end)
		end

		local x,y,z =
			station.blip.x,
			station.blip.y,
			station.blip.z
		
		local blip = createBlip(x,y,z, 0)
		blip:setData('icon', 'fuel_station')
		blip:setData('size', 1)

	end


end)


bVehicleExiting = false

addEventHandler('onClientVehicleStartExit', root, function(player)

	if player == localPlayer then
		bVehicleExiting = true
	end

end)

addEventHandler('onClientVehicleExit', root, function(player)

	if player == localPlayer then
		bVehicleExiting = false
	end

end)
