function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end

function closeWindow()
	setWindowOpened(false)
end

bindKey(Config.key, 'down', function()
	if windowOpened then
		closeWindow()
	else
		if localPlayer:getData('unique.login') then

			local alerts = localPlayer:getData('alerts') or {}

			if #alerts > 0 then
				openWindow('main')
			end

		end
	end
end)


