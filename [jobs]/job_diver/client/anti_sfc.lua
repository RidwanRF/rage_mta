

presses = 0

addEventHandler('onClientKey', root, function(button, state)

	if button == 'space' and state then
		presses = presses + 1
	end

end)

setTimer(function()

	if exports.jobs_main:getPlayerWork(localPlayer) == Config.resourceName then

		if presses > 40 then

			setElementPosition( localPlayer, 662.04, -1789.52, 12.48 )

			exports.hud_notify:notify('Использование стороннего ПО', 'Вы телепортированы')
			exports.chat_main:displayInfo(
				'Вы телепортированы за использование сторонних программ. Читы запрещены на сервере, за это вы можете получить бан',
				{255,0,0}
			)

		end
		
	end

	presses = 0

end, 3000, 0)