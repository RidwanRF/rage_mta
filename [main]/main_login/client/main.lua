function changeWindowSection(section)
	-- closeWindow()
	-- openWindow(section)
	currentWindowSection = section
end

function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end

function closeWindow()
	setWindowOpened(false)
end
addEvent('authpanel.close', true)
addEventHandler('authpanel.close', root, closeWindow)

addEventHandler('onLoadingFinish', root, function()
	if not localPlayer:getData('unique.login') and not windowOpened then
		openWindow('login')
	end
end)

startTimer = setTimer(function()
	if exports.engine:getLoadingState() == 1 then
		if not localPlayer:getData('unique.login') and not windowOpened then
			openWindow('login')
			killTimer(startTimer)
		end
	end
end, 1000, 0)

addCommandHandler('openlogin', function()
	if exports.acl:isAdmin(localPlayer) then
		openWindow('login')
	end
end)
