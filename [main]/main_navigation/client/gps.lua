
-------------------------------------------------------------

	GPSPoints = {
		
	}


	function createGPSPoint(pointId, coords, text, notify)

		removeGPSPoint(pointId)

		local x,y,z = unpack(coords)


		GPSPoints[pointId] = {
			blip = createBlip( x,y,z, 0 ),
			marker = createMarker( x,y,z, 'corona', 6, 0, 0, 0, 0 ),
			text = string.format('[%s]', text),

		}

		addEventHandler('onClientMarkerHit', GPSPoints[pointId].marker, function(player, mDim)
			if player == localPlayer and mDim then

				local pointId = source:getData('gps.pointId')
				local notify = source:getData('gps.notify')

				if pointId then

					removeGPSPoint(pointId)

					if notify ~= false then
						exports.hud_notify:notify('GPS', 'Маршрут завершен')
					end

				end
			end
		end)

		GPSPoints[pointId].marker:setData('gps.pointId', pointId)
		GPSPoints[pointId].marker:setData('gps.notify', notify)
		GPSPoints[pointId].marker:setData('controlpoint.3dtext', GPSPoints[pointId].text)

		GPSPoints[pointId].blip:setData('icon', 'target')

		return marker

	end

	function removeGPSPoint(pointId)

		if GPSPoints[pointId] then

			if isElement(GPSPoints[pointId].blip) then
				destroyElement( GPSPoints[pointId].blip )
			end

			if isElement(GPSPoints[pointId].marker) then
				destroyElement( GPSPoints[pointId].marker )
			end

		end

		GPSPoints[pointId] = nil

	end

	function getGPSPoint(pointId)
		return GPSPoints[pointId]
	end
