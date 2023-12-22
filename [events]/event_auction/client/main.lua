function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end

function closeWindow()
	setWindowOpened(false)
end

addCommandHandler('auction_wnd', function()
	if exports.acl:isAdmin(localPlayer) then
		openWindow('main')
	end
end)
