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

function displayWindow( withdraw, maxSpeed, isNoPlate )

	if windowOpened then return end

	withdrawElement.data = { withdraw = withdraw, max_speed = maxSpeed, type = isNoPlate and 'no_plate' or 'speed_break', }

	openWindow('main')
	setTimer(closeWindow, 6000, 1)

end

addEvent('police_cameras.displayWindow', true)
addEventHandler('police_cameras.displayWindow', resourceRoot, displayWindow)

addCommandHandler('police_cameras_display', function()

	if exports.acl:isAdmin(localPlayer) then
		displayWindow( 1000, 100, true )
	end

end)