
addEventHandler('onClientResourceStart', resourceRoot, function()

	for _, markerData in pairs( Config.markers ) do

		local x,y,z = unpack(markerData.position)

		local marker

		if markerData.window == 'vinils' then

			marker = createMarker(
				x,y,z-0.5,
				'cylinder',
				markerData.size or 2,
				255, 0, 0, 100
			)

			marker:setData('3dtext', '[Винил-студия]')

		else

			marker = createMarker(
				x,y,z-0.5,
				'cylinder',
				markerData.size or 2,
				130, 130, 240, 100
			)

			marker:setData('3dtext', '[Тюнинг-центр]')

		end

		if markerData.blip then
			local blip = createBlipAttachedTo(marker)
			blip:setData('icon', 'tuning')
		end


		marker:setData('3dtext.size', 1.5)
		marker:setData('3dtext.zAdd', 1.8)
		marker:setData('3dtext.maxDist', 40)
		marker:setData('tuning.window', markerData.window or 'main')

		marker.interior = markerData.int or 0
		marker.dimension = markerData.dim or 0

		marker:setData('tuning.marker', true)
		marker:setData('tuning.exit', markerData.exit)

		createBindHandler(marker, 'f', 'продолжить', function(marker)
			if localPlayer.vehicle and localPlayer.vehicleSeat == 0 then
				if localPlayer.vehicle:getData('owner') == localPlayer:getData('unique.login') then
					enterTuning(marker)
				end
			end
		end, true)

	end

end)