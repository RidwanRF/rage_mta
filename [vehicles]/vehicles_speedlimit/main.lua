
loadstring( exports.core:include('common'))()

addEventHandler('onClientRender', root, function()
	if localPlayer.vehicle then
		local handling = getVehicleHandling(localPlayer.vehicle)

		if getElementSpeed(localPlayer.vehicle, 'kmh') > handling.maxVelocity then
			setElementSpeed(localPlayer.vehicle, 'kmh', handling.maxVelocity)
		end

	end
end)