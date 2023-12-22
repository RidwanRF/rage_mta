
bindKey('delete', 'down', function()

	local prisonTime = localPlayer:getData('prison.time')
	if not prisonTime then return end

	triggerServerEvent('prison.useTicket', resourceRoot)

end)