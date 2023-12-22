function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end

function closeWindow()
	setWindowOpened(false)
end

addCommandHandler('wshop', function()
	if exports.acl:isAdmin(localPlayer) or root:getData('isTest') then
		openWindow('main')
	end
end)
