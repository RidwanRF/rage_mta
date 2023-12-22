
------------------------------

	function openWindow(section, ...)

		currentWindowArgs = { ... }

		currentWindowSection = section
		setWindowOpened(true)

	end
	addEvent('event_shooter.openWindow', true)
	addEventHandler('event_shooter.openWindow', resourceRoot, openWindow)

	function closeWindow(section)

		if section then

			if currentWindowSection == section then
				setWindowOpened(false)
			end

		else

			setWindowOpened(false)
			
		end

	end
	addEvent('event_shooter.closeWindow', true)
	addEventHandler('event_shooter.closeWindow', resourceRoot, closeWindow)

------------------------------