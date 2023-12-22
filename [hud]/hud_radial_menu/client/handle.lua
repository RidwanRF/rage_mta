
local actions = {
	turns = {
		server = false,
		action = function()

			local vehicle = localPlayer.vehicle
			if not vehicle then return end

			local state = (
				exports.vehicles_turn_lights:getVehicleLightData(vehicle, 'turn_left')
				or
				exports.vehicles_turn_lights:getVehicleLightData(vehicle, 'turn_right')
			)

			exports.vehicles_turn_lights:setLocalLightsData('turn_left', not state)
			exports.vehicles_turn_lights:setLocalLightsData('turn_right', not state)
		end,
	},
	racing = {
		server = false,
		action = function()
			if (localPlayer.vehicleSeat == 0) then
				exports.main_racing:openWindow('main')
			end
		end,
	},
	transform = {
		server = false,
		action = function()
			if (localPlayer.vehicleSeat == 0) then
				localPlayer.vehicle:setData('transformActive', not localPlayer.vehicle:getData('transformActive'))
			end
		end,
	},
}


function handleAction(selected)
	if not selected then return end

	local clientAction = actions[selected]
	if clientAction then

		clientAction.action()

		if not clientAction.server then return end
	end

	triggerServerEvent('radmenu.handleAction', resourceRoot, selected)
end