
-- addEventHandler('onClientPreRender', root, function()
-- 	for _, vehicle in pairs( getElementsByType('vehicle', root, true) ) do
-- 		if isElementOnScreen(vehicle) then

-- 			local state = vehicle:getData('steering.state')
-- 			local occupant = getVehicleOccupant(vehicle)

-- 			if not isElement(occupant) then


-- 				local handling = getVehicleHandling(vehicle)

-- 				local mul = state == 'left' and 1 or -1
-- 				if not state then mul = 0 end

-- 				local angle = handling.steeringLock * mul

-- 				local components = {'wheel_rf_dummy', 'wheel_lf_dummy'}
-- 				for _, component in pairs(components) do
-- 					local x,y,z = vehicle:getComponentRotation(component)
-- 					vehicle:setComponentRotation(component, 0,0,0)
-- 				end

-- 			end


-- 		end
-- 	end
-- end)