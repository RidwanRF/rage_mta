
addEventHandler('onClientResourceStart', resourceRoot, function()

	for _, markerData in pairs( Config.markers ) do

		local x,y,z,r = unpack(markerData)
		local marker = createMarker(
			x,y,z,
			'corona',
			markerData.size or 1.5,
			0, 0, 0, 0
		)

		-- if markerData.blip then
			local blip = createBlipAttachedTo(marker)
			blip:setData('icon', 'bank')
		-- end

		local object = createObject(2942, x, y, z, 0, 0, r)
		setObjectBreakable(object, false)

		marker:setData('bank.marker', true)

		createBindHandler(marker, 'f', 'Открыть банкомат', function()
			openWindow('main')
		end)

		addEventHandler('onClientMarkerLeave', marker, function(player, mDim)
			if player == localPlayer and mDim and player.interior == source.interior then
				closeWindow()
			end
		end)


	end

end)
