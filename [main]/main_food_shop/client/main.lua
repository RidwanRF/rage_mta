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

addCommandHandler('food', function()
	if exports.acl:isAdmin(localPlayer) then
		openWindow('main')
	end
end)

addEventHandler('onClientPlayerVehicleEnter', localPlayer, function()

	if windowOpened then
		closeWindow()
	end

end)