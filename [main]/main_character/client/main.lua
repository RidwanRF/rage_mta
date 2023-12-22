function changeWindowSection(section)
	-- closeWindow()
	-- openWindow(section)
	currentWindowSection = section
end

function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end
addEvent('character_create.open', true)
addEventHandler('character_create.open', root, openWindow)

function closeWindow()
	setWindowOpened(false)
end
addEvent('character_create.close', true)
addEventHandler('character_create.close', root, closeWindow)

addCommandHandler('createchar', function()
	if exports.acl:isAdmin(localPlayer) then
		openWindow('main')
	end
end)