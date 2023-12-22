


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

bindKey('tab', 'down', function()
	if localPlayer:getData('unique.login') and not isCursorShowing()
	and localPlayer.dimension == 0 then
		openWindow('main')
		localPlayer:setData('tab.opened', true, false)
	end
end)

bindKey('tab', 'up', function()
	closeWindow()
	localPlayer:setData('tab.opened', false, false)
end)

addEventHandler('onClientKey', root, function(button, state)
	if not windowOpened then return end
	if button == 'mouse_wheel_up' or button == 'mouse_wheel_down' then
		activeList = playersList
		scrollActiveList(button == 'mouse_wheel_up' and -1 or 1)
		cancelEvent()
	end
end)