canOpenWindow = true

function openWindow(section)
	if not canOpenWindow then return end
	currentWindowSection = section
	setWindowOpened(true)
	animate(currentWindowSection .. '-anim', 1)
end

function closeWindow()
	animate(currentWindowSection .. '-anim', 0)
	setWindowOpened(false)
end

bindKey(Config.freeroamKey, 'down', function()
	if windowOpened then
		if not packsRoulette:isActive() then
			closeWindow()
		end
	else
		if localPlayer:getData('unique.login') and (localPlayer.dimension == 0 or localPlayer:getData('prison.time')) then
			openWindow('stats')
		end
	end
end)


bindKey(Config.reportKey, 'down', function()
	if not windowOpened and not isCursorShowing() then
		if localPlayer:getData('unique.login') and localPlayer.dimension == 0 then
			openWindow('report')
		end
	end
end)


