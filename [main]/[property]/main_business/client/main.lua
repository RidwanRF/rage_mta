function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end

function closeWindow()
	setWindowOpened(false)
end

addCommandHandler('createbusiness', function()
	if exports.acl:isAdmin(localPlayer) then
		openWindow('creation')
	end
end)

addCommandHandler('cwar', function()
	if exports.acl:isAdmin(localPlayer) then
		openWindow('create_war')
	end
end)

