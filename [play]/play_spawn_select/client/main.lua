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
addEvent('play.spawn_select.close', true)
addEventHandler('play.spawn_select.close', root, closeWindow)


addCommandHandler('spawn_select', function()
	if exports.acl:isAdmin(localPlayer) then
		openWindow('main')
	end
end)

addEvent('play.spawn_select.openWindow', true)
addEventHandler('play.spawn_select.openWindow', resourceRoot, function(section)

	openTimer = setTimer(function(section)

		if isCursorShowing() then return end

		openWindow(section)

		if isTimer(openTimer) then
			killTimer(openTimer)
		end

	end, 2000, 0, section)

end)
