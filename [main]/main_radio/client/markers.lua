
addEventHandler('onClientResourceStart', resourceRoot, function()

	for _, markerData in pairs( Config.markers ) do

		local x,y,z = unpack(markerData)
		local marker

		if markerData.ped then


			exports.common_peds:createWorldPed({

				position = {
					coords = { x,y,z, 0 },
					int = markerData.int or 0,
					dim = markerData.dim or 0,
				},

				attachToLocalPlayer = true,
				
				text = markerData.ped.text,
				model = markerData.ped.skin,

			})

			marker = createMarker(
				x,y,z,
				'corona',
				markerData.size or 1.5,
				0, 0, 0, 0
			)

		else

			marker = createMarker(
				x,y,z-0.9,
				'cylinder',
				markerData.size or 1.5,
				100, 255, 200, 150
			)

		end

		marker.interior = markerData.int or 0
		marker.dimension = markerData.dim or 0


		marker:setData('casino.marker', true)
		marker:setData('casino.window', markerData.window)

		createBindHandler(marker, 'f', 'F - '..markerData.tooltip, function()
			openWindow(marker:getData('casino.window'))
		end)


	end

end)
