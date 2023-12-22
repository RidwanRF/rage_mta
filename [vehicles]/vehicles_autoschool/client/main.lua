------------------------------------

	function openWindow(section)
		currentWindowSection = section
		setWindowOpened(true)
	end

	function closeWindow()
		setWindowOpened(false)
	end

	addCommandHandler('autoschool', function(_, section)
		if exports.acl:isAdmin(localPlayer) then
			openWindow(section or 'main')
		end
	end)


------------------------------------

	addEvent('vehicles_autoschool.onLicenseBuy')

	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

		if dn == 'vehicles_autoschool.licenses_bought' then
			triggerEvent('vehicles_autoschool.onLicenseBuy', root)
		end

	end)

------------------------------------