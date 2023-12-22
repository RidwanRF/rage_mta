function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end
addEvent('exchange.openWindow', true)
addEventHandler('exchange.openWindow', root, openWindow)

function closeWindow(section)
	if not section or section == currentWindowSection then
		setWindowOpened(false)
	end
end
addEvent('exchange.closeWindow', true)
addEventHandler('exchange.closeWindow', root, closeWindow)

addCommandHandler('ekh', function(_, section)
	if exports.acl:isAdmin(localPlayer) then
		openWindow(section or 'main')
	end
end)