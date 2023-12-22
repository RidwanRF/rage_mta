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

addCommandHandler('branch', function(_, section)
	if exports.acl:isAdmin(localPlayer) then
		openWindow(section or 'main')
	end
end)