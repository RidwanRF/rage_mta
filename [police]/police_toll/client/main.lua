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
addEvent('police.toll.closeWindow', true)
addEventHandler('police.toll.closeWindow', root, closeWindow)

addCommandHandler('toll', function()
	if exports.acl:isAdmin(localPlayer) then
		openWindow('main')
	end
end)