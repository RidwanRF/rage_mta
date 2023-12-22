


function changeWindowSection(section, noAnim, fade)

	if fade then
		fadeCamera(false, 1)
	end

	if not noAnim then
		animate('dxGui.window-alpha', 0)

		setTimer(function(fade)
			if currentWindowSection then
				closeWindow()
				openWindow(section)
			end

			if fade then
				fadeCamera(true, 1)
			end

		end, 1000, 1, fade)
	else
		closeWindow()
		openWindow(section)
	end


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

bindKey(Config.key, 'down', function()
	local target = getCameraTarget(localPlayer)
	if not isCursorShowing() and (target or exports.hud_firstperson:getFPVEnabled())
		and not getKeyState( 'mouse2' )
	then
		openWindow('main')
		setCursorPosition(real_sx/2, real_sy/2)
	end
end)

bindKey(Config.key, 'up', function()
	if windowOpened then
		closeWindow()
		handleAction(actionId)
	end
end)

addEventHandler('onClientRestore', root, function()
	if windowOpened then
		closeWindow()
	end
end)

addEventHandler('onClientVehicleExit', root, function(player)

	if player == localPlayer and windowOpened then

		closeWindow()

	end

end)