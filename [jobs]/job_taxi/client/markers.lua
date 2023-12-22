
addEventHandler('onClientResourceStart', resourceRoot, function()

	for id, station in pairs( Config.stations ) do

		local x,y,z = unpack(station.marker)
		local marker = createMarker(x,y,z, 'cylinder', 1, 150, 100, 150, 150)

		marker:setData('station.id', id)
		marker:setData('taxi.marker', id)
		marker:setData('3dtext', '[Станция такси]')
		marker:setData('3dtext.size', 1.3)

		local blip = createBlipAttachedTo(marker, 0)
		blip:setData('icon', 'job_taxi')

		addEventHandler('onClientMarkerHit', marker, function( player, mDim )

			if player == localPlayer and mDim and source.interior == localPlayer.interior and not localPlayer.vehicle then

				if windowOpened then return end

				currentStationId = source:getData('station.id')
				local currentWork = exports.jobs_main:getPlayerWork(localPlayer)

				if currentWork and currentWork ~= Config.resourceName then
					return exports['hud_notify']:notify('Ошибка', 'Увольтесь с другой работы')
				end

				if currentWork == Config.resourceName then

					dialog('Такси', {
						'Вы действительно хотите',	
						'завершить работу?',	
					}, function(result)
						if result then
							triggerServerEvent('taxi.finish', resourceRoot)
						end
					end)

				else
					
					openWindow('main')

					exports.jobs_main:handleJobVisit()

				end				

			end

		end)

		addEventHandler('onClientMarkerLeave', marker, function(player, mDim)

			if player == localPlayer and mDim and player.interior == source.interior and windowOpened then
				closeWindow()
			end

		end)

	end

end)

addEventHandler('onClientPlayerVehicleEnter', localPlayer, function()

	if windowOpened then
		closeWindow()
	end

end)