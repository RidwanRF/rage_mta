


function changeWindowSection(section, noAnim, fade)
	currentWindowSection = section
end

function openWindow(section)

	if windowOpened then
		if currentWindowSection ~= section then
			changeWindowSection(section, true)
		end
		return
	end

	currentWindowSection = section
	setWindowOpened(true)

end

function closeWindow()
	setWindowOpened(false)
end


addEventHandler('onClientPlayerVehicleEnter', localPlayer, function()
	openWindow('main')
end)

addEventHandler('onClientPlayerVehicleExit', localPlayer, function()
	closeWindow()
end)

addEventHandler('onClientElementDataChange', localPlayer, function(dn,old,new)
	if dn == 'speed.hidden' then
		if new then
			closeWindow() 
		elseif localPlayer.vehicle then
			openWindow('main')
		end
	end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
	if localPlayer.vehicle then
		openWindow('main')
	end
end, true, 'low')