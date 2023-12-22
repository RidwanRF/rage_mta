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
addEvent('play.respawn.close', true)
addEventHandler('play.respawn.close', root, closeWindow)


addEventHandler('onClientElementDataChange', localPlayer, function(dataName, old, new)
	if dataName == 'respawn.next_timestamp' then
		if new and not source:getData ( 'is_on_event' ) then
			openWindow('main')
		else
			closeWindow()
		end
	end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
	if localPlayer:getData('respawn.next_timestamp') and not localPlayer:getData ( 'is_on_event' ) then
		openWindow('main')
	end
end)
