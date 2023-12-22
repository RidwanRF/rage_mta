function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end

function closeWindow()
	setWindowOpened(false)
end

bindKey(Config.windowKey, 'down', function()
	if windowOpened then
		closeWindow()
	else
		openWindow('main')
	end
end)

-- addEvent('updates.openWindow', true)
-- addEventHandler('updates.openWindow', root, function()
-- 	if isTimer(stateUpdateTimer) then killTimer(stateUpdateTimer) end
-- 	stateUpdateTimer = setTimer(function()
-- 		if not isCursorShowing() and getCameraTarget(localPlayer) == localPlayer then
-- 			killTimer(stateUpdateTimer)
-- 			openWindow('last_update')
-- 		end
-- 	end, 1000, 0)
-- end)

addCommandHandler('navigation', function(_, section)

	if exports.acl:isAdmin(localPlayer) then
		openWindow(section or 'last_update')
	end

end)