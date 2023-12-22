function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end

function closeWindow()
	setWindowOpened(false)
end

addEventHandler('onClientEnableCamMode', resourceRoot, function()
	openWindow('main')
end)

addEventHandler('onClientDisableCamMode', resourceRoot, function()
	closeWindow()
end)

