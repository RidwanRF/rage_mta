
function createPreview()

	previewConfig = Config.shops[currentShopId].preview


	local x,y,z = unpack(previewConfig.player)
	setElementPosition(localPlayer, x,y,z)

	triggerServerEvent('vehicles.shop.updatePosition', resourceRoot, {
		pos = {x,y,z},
		dim = 10000 + ( localPlayer:getData('dynamic.id') or 0 ),
		int = 0
	})
	triggerServerEvent('vehicles.shop.preview.create', resourceRoot,
		localPlayer, currentShopId
	)

	localPlayer.dimension = 10000 + ( localPlayer:getData('dynamic.id') or 0 )
	localPlayer.interior = 0

	setCameraMatrix(unpack(previewConfig.matrix))

end

function finishPreview()

	setCameraTarget(localPlayer, localPlayer)
	destroyElement(currentVehicle)

	triggerServerEvent('vehicles.shop.updatePosition', resourceRoot, {
		dim = 0,
		int = 0,
	})
	triggerServerEvent('vehicles.shop.preview.finish', resourceRoot,
		localPlayer
	)
end

function setPreviewModel(model, color)
	triggerServerEvent('vehicles.shop.preview.setModel', resourceRoot, currentShopId, model, color)
end

addCommandHandler('carshop_setcolor', function(_, color)
	local r,g,b = hexToRGB(color)
	currentVehicle:setColor( r,g,b )
end)

addCommandHandler('carshop_setcover', function(_, cover, color)
	if cover then
		currentVehicle:setData('coverType', cover)
	end
	if color then
		currentVehicle:setData('cover_color', color)
	end
end)

addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)
	if dn == 'vehicles.shop.preview' then
		currentVehicle = new
	end

end)