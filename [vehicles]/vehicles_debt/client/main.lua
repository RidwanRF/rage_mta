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
		openWindow('main')
	end
end)