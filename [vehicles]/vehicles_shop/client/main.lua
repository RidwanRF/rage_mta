function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end

function closeWindow()
	setWindowOpened(false)
end

addCommandHandler('openshop', function(_, type)
	if exports['acl']:isAdmin(localPlayer) then
		-- openWindow('main')
		enterShop(type or 'car')
	end
end)

addEvent('vehicles.shop.close', true)
addEventHandler('vehicles.shop.close', root, function()
	exitShop()
	closeWindow()
end)

addEvent('vehicles.shop.open', true)
addEventHandler('vehicles.shop.open', root, function(...)
	enterShop(...)
end)