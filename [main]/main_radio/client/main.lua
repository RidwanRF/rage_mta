function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end

function closeWindow()
	setWindowOpened(false)
end

bindKey('m', 'down', function()

	if windowOpened then
		closeWindow()
	else
		if getLocalSoundElement() then
			openWindow('main')
		end
	end

end)
