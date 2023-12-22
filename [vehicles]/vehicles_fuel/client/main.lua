
local previousVehiclePosition

function updateVehicleFuel()
	if localPlayer.vehicle then

		local x,y,z = getElementPosition(localPlayer.vehicle)

		local spendFuel = exports.vehicles_main:getVehicleProperty(localPlayer.vehicle, 'spend_fuel')

		local fuel = localPlayer.vehicle:getData('fuel') or 0

		local odometer = localPlayer.vehicle:getData('odometer') or 0
		local engineDisabled = localPlayer.vehicle:getData('engine.disabled')

		if fuel <= 0 and not engineDisabled then
			localPlayer.vehicle:setData('engine.disabled', false)
		end

		if not engineDisabled and fuel <= 0 and spendFuel ~= false then
			localPlayer.vehicle:setData('engine.disabled', true)
			return exports.hud_notify:notify('Автомобиль', 'У вас закончилось топливо', 3000)
		end

		if not localPlayer.vehicle:getEngineState() then return end

		if previousVehiclePosition then
			local px,py,pz = unpack(previousVehiclePosition)

			local fuelType = localPlayer.vehicle:getData('fuel_type') or '92'
			local fuelConfig = Config.fuelTypes[fuelType]

			local realDistance = getDistanceBetweenPoints3D(x,y,z, px,py,pz)
			local distance = realDistance/1000

			local consumption = exports.vehicles_main:getVehicleProperty(localPlayer.vehicle, 'fuel_consumption')
			local spent = distance * consumption
			spent = math.max(spent, 0.01)

			odometerAdd = distance

			if distance > 200 then
				spent = 0
			else
				odometer = odometer + realDistance/1000
			end

			if spendFuel == false then
				spent = 0
			end

			fuel = math.max(0, fuel - spent)

		end

		triggerServerEvent('fuel.use', resourceRoot, localPlayer.vehicle, fuel, odometer)

		previousVehiclePosition = {x,y,z}
	end
end

setTimer(updateVehicleFuel, 60000, 0)