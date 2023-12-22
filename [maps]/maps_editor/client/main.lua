function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end

function closeWindow()
	setWindowOpened(false)
end

function toggleMapEditor()
	if (exports['acl']:isAdmin(localPlayer) or exports.acl:isPlayerInGroup(localPlayer, 'mapping'))
		and not localPlayer.vehicle
	then

		if windowOpened then
			closeWindow()
		else
			openWindow('main')
		end

	end
end