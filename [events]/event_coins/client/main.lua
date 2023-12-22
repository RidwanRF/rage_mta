
------------------------------

	function openWindow(section)
		currentWindowSection = section
		setWindowOpened(true)
	end

	function closeWindow()
		setWindowOpened(false)
	end

------------------------------

	bindKey(Config.key, 'down', function()
		if windowOpened then
			closeWindow()
		else

			-- if exports.acl:isAdmin( localPlayer ) then
				openWindow('main')
			-- end

		end
	end)


------------------------------