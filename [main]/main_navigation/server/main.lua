
addEventHandler('onPlayerLogin', root, function()

	local version = source.account:getData('version')

	if version ~= Config.currentVersion then
		triggerClientEvent(source, 'updates.openWindow', source)
		source.account:setData('version', Config.currentVersion)
	end


end, true, 'low-2')
