function changeWindowSection(section)
	-- closeWindow()
	-- openWindow(section)
	currentWindowSection = section
end

function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end

function closeWindow()
	setWindowOpened(false)
end

addCommandHandler('createhouse', function()
	if exports['acl']:isAdmin(localPlayer) then
		openWindow('creation')
	end
end)


addCommandHandler('createflat', function()
	if exports['acl']:isAdmin(localPlayer) then
		openWindow('creation_flat')
	end
end)

