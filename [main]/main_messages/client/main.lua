function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end

function closeWindow()
	setWindowOpened(false)
end

bindKey(Config.key, 'down', function()
	if windowOpened then
		closeWindow()
	else

		if localPlayer.dimension == 0 and ( localPlayer:getData('prison.time') or 0 ) <= 0 then
			openWindow('main')
		end

	end
end)