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
