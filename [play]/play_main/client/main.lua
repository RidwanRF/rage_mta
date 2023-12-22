setPlayerHudComponentVisible('all', false)
setPlayerHudComponentVisible('crosshair', true)


addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

	if dn == 'unique.login' and new and not old then
		triggerServerEvent('play_main.sendReady', resourceRoot)
	end

end)

addEventHandler('onClientResourceStart', resourceRoot, function()

	if localPlayer:getData('unique.login') and not getCameraTarget( localPlayer ) and localPlayer.dimension == 1 then
		triggerServerEvent('play_main.sendReady', resourceRoot)
	end

end)