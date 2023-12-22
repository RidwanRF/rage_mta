
function changeWindowSection(section)
	currentWindowSection = section
end

function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end

function closeWindow()
	setWindowOpened(false)
end

addEventHandler('onLoadingStart', root, function()
	openWindow('main')
end)

addEventHandler('onLoadingFinish', root, function()
	closeWindow()
end)

-- addCommandHandler('finish_loading', function()
-- 	finishLoading()
-- end)

function getLoadingState()
	return exports['engine']:getLoadingState()
end