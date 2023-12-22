function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end

function closeWindow()
	setWindowOpened(false)
end

bindKey(Config.managerKey, 'down', function()
	if windowOpened then
		if currentWindowSection == 'main' then
			closeWindow()
		end
	else
		if isPlayerManagerCompatible() then
			openWindow('main')
		else
			exports.hud_notify:notify('Нельзя использовать F3', 'В данной зоне')
		end
	end
end)