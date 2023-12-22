function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end

function closeWindow()
	setWindowOpened(false)
end

bindKey(Config.adsKey, 'down', function()
	if windowOpened then
		closeWindow()
	else
		if localPlayer:getData('unique.login') then
			openWindow('list')
		end
	end
end)


