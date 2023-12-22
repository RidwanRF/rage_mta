

	function createPreview(player, currentShopId, model, _color)

		local previewConfig = Config.shops[currentShopId].preview

		local r,g,b = unpack(_color or {0, 0, 0})

		local currentVehicle = createVehicle(model or 400, 0, 0, 3)
		setVehicleColor(currentVehicle, r,g,b,r,g,b)

		-- setVehicleOverrideLights(currentVehicle, 2)
		-- setVehicleHeadLightColor(currentVehicle, 0, 0, 0)
		setTimer(function(vehicle)
			exports.vehicles_controls:setHeadlightsState(vehicle, 'hwd')
		end, 100, 1, currentVehicle)
		-- currentVehicle:setColor(0,0,0)
		-- currentVehicle:setData('coverType', 'mat')

		currentVehicle.dimension = 10000 + (player:getData('dynamic.id') or 0)
		currentVehicle:setData('spoilerActive', true)

		local x,y,z, rx,ry,rz = unpack(previewConfig.vehicle)
		setElementPosition(currentVehicle, x,y,z)
		setElementRotation(currentVehicle, rx,ry,rz)

		player:setData('vehicles.shop.preview', currentVehicle)

	end
	addEvent('vehicles.shop.preview.create', true)
	addEventHandler('vehicles.shop.preview.create', resourceRoot, createPreview)

	function finishPreview(player)

		local vehicle = player:getData('vehicles.shop.preview')
		if isElement(vehicle) then
			player:setData('vehicles.shop.preview', false)
			destroyElement(vehicle)
		end
	end
	addEvent('vehicles.shop.preview.finish', true)
	addEventHandler('vehicles.shop.preview.finish', resourceRoot, finishPreview)

	function setModel(currentShopId, model, color)

		finishPreview(client)
		createPreview(client, currentShopId, model, color)


	end
	addEvent('vehicles.shop.preview.setModel', true)
	addEventHandler('vehicles.shop.preview.setModel', resourceRoot, setModel)

------------------------------------------------------------

	function updatePosition(data)

		if data.pos then
			client:setPosition(unpack(data.pos))
		end

		client.dimension = data.dim or 0
		client.interior = data.int or 0
		
	end
	addEvent('vehicles.shop.updatePosition', true)
	addEventHandler('vehicles.shop.updatePosition', resourceRoot, updatePosition)