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
		
		if localPlayer:getData('unique.login') and not localPlayer:getData ( 'is_on_event' ) then

			currentInventoryMode = 'inventory'
			openWindow('main')
			
		end

	end

end)

