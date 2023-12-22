function openWindow(section)
	currentWindowSection = section
	setWindowOpened(true)
end

function closeWindow()
	setWindowOpened(false)
end

addCommandHandler('used', function(_, section)
	if exports.acl:isAdmin(localPlayer) then
		openWindow(section or 'main')
	end
end)

addEventHandler('onClientElementDestroy', root, function()

	if windowOpened and source == localPlayer.vehicle and source:getData('used.data') then
		closeWindow()
	end

end)