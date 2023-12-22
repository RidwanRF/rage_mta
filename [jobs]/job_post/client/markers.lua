
addEventHandler('onClientResourceStart', resourceRoot, function()

	for id, station in pairs( Config.stations ) do

		local x,y,z = unpack(station.marker)
		local marker = createMarker(x,y,z, 'cylinder', 1.5, 255, 100, 0, 150)

		marker:setData('station.id', id)
		marker:setData('bus.marker', id)
		marker:setData('3dtext', '[Почтовый офис]')

		local blip = createBlipAttachedTo(marker, 0)
		blip:setData('icon', 'job_post')

		addEventHandler('onClientMarkerHit', marker, function( player, mDim )

			if player == localPlayer and mDim and source.interior == localPlayer.interior then

				if windowOpened then return end

				currentStationId = source:getData('station.id')
				local currentWork = exports.jobs_main:getPlayerWork(localPlayer)

				if currentWork and currentWork ~= Config.resourceName then
					return exports['hud_notify']:notify('Ошибка', 'Увольтесь с другой работы')
				end

				openWindow('main')

				exports.jobs_main:handleJobVisit()

			end

		end)

	end

end)


