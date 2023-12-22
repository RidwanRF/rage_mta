
addEventHandler('onClientResourceStart', resourceRoot, function()

	for id, position in pairs( Config.positions ) do

		local x,y,z = unpack(position.position)
		local marker = createMarker(x,y,z, 'cylinder', 1.5, 30, 150, 255, 150)

		marker:setData('3dtext', '[Работа инкассатора]')
		marker:setData('incassator.id', id)

		local blip = createBlipAttachedTo(marker, 0)
		blip:setData('icon', 'incassator')

		createBindHandler(marker, 'f', 'открыть окно', function(marker)

			if windowOpened then return end

			currentJobMarker = marker

			local currentWork = exports.jobs_main:getPlayerWork(localPlayer)

			if currentWork and currentWork ~= Config.resourceName then
				return exports['hud_notify']:notify('Ошибка', 'Завершите другую работу')
			end

			if currentWork == Config.resourceName then

				dialog('Инкассатор', {
					'Вы действительно хотите',	
					'завершить работу?',	
				}, function(result)
					if result then
						triggerServerEvent('incassator.finish', resourceRoot)
					end
				end)

			else
				
				openWindow('main')
				exports.jobs_main:handleJobVisit()

			end	


		end)

	end

end)
