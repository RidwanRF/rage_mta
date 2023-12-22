function fuelUse(vehicle, fuel, odometer)
	if not isElement(vehicle) then return end
	vehicle:setData('fuel', fuel)
	vehicle:setData('odometer', odometer)
end
addEvent('fuel.use', true)
addEventHandler('fuel.use', resourceRoot, fuelUse)