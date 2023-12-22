

addEventHandler('onClientPreRender', root, function()

	if localPlayer.vehicle then
		setRadioChannel(0)
	end

end)