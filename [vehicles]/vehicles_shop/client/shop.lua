
function enterShop(shopId, preselectModel)
	currentPreselectModel = preselectModel
	currentShopId = shopId or 'car'
	fadeCamera(false, 0.5)

	enterTimer = setTimer(function()
		fadeCamera(true, 0.5)

		local x,y,z,r = unpack(Config.shops[currentShopId].exitPosition)

		localPlayer:setData('autoshop.savedPos', {
			pos = { x,y,z },
			r = r,
		})

		localPlayer:setData('speed.hidden', true, false)
		localPlayer:setData('hud.hidden', true, false)
		localPlayer:setData('radar.hidden', true, false)
		-- localPlayer:setData('notify.hidden', true, false)

		createPreview()
		openWindow('main')

		increaseElementData(localPlayer, 'visits.shop.'..currentShopId, 1)


	end, 1000, 1)
end

addEvent('vehicles_shop.onExit')

function exitShop()
	fadeCamera(false, 0.5)

	setTimer(function()
		fadeCamera(true, 0.5)

		finishPreview()

		local data = localPlayer:getData('autoshop.savedPos') or {}
		setElementPosition(localPlayer, unpack(data.pos))
		setElementRotation(localPlayer, 0, 0, data.r or 0)

		localPlayer:setData('autoshop.savedPos', false)

		localPlayer:setData('speed.hidden', false, false)
		localPlayer:setData('hud.hidden', false, false)
		localPlayer:setData('radar.hidden', false, false)
		-- localPlayer:setData('notify.hidden', false, false)

		currentShopId = false

		setTimer(function()
			triggerEvent('vehicles_shop.onExit', root)
		end, 1000, 1)


	end, 1000, 1)

end

---------------------------------------

	addEventHandler('onClientKey', root, function()
		if windowOpened or isTimer(enterTimer) then cancelEvent() end
	end)

---------------------------------------

	addEventHandler('onClientElementStreamIn', resourceRoot, function()
		exports.vehicles_tuning:updateVehicleTuning(source)
	end)

---------------------------------------

