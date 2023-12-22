
addEventHandler('onClientResourceStart', resourceRoot, function()

	for id, station in pairs( Config.stations ) do

		local x,y,z = unpack(station.marker)
		local marker = createMarker(x,y,z, 'cylinder', 1, 70, 200, 50, 150)

		marker:setData('station.id', id)
		marker:setData('cargo.marker', id)
		marker:setData('3dtext', '[Лесоруб]')
		marker:setData('3dtext.size', 1.3)

		local blip = createBlipAttachedTo(marker, 0)
		blip:setData('icon', 'job_lumberjack')

		addEventHandler('onClientMarkerHit', marker, function( player, mDim )

			if player == localPlayer and mDim and source.interior == localPlayer.interior then

				if windowOpened then return end

				currentStationId = source:getData('station.id')
				local currentWork = exports.jobs_main:getPlayerWork(localPlayer)

				if currentWork and currentWork ~= Config.resourceName then
					return exports['hud_notify']:notify('Ошибка', 'Увольтесь с другой работы')
				end

				if currentWork == Config.resourceName then

					dialog('Лесоруб', {
						'Вы действительно хотите',	
						'завершить работу?',	
					}, function(result)
						if result then
							triggerServerEvent('lumberjack.finish', resourceRoot)
						end
					end)

				else
					
					openWindow('main')

					exports.jobs_main:handleJobVisit()

				end				

			end

		end)

	end

end)


