local vehicleped = {}

addEventHandler("onClientVehicleStartEnter", root, function(_, seat)
    if seat == 0 and getVehicleType(source) == "Automobile" then
        if not isVehicleLocked(source) then
            triggerServerEvent("event:vehicle:destroy:ped", localPlayer, source)
        end
    end
end)

addEventHandler("onClientKey", root, function(button, press)
    local vehicle = getPedOccupiedVehicle(localPlayer)
    if vehicle and getVehicleController(vehicle) == localPlayer then
        if button == "arrow_l" and press then
            if getVehicleType(vehicle) == "Automobile" then
                setElementData(vehicle, "vehicle:wheel:position", "vehicle_left")
                toggleControl("vehicle_left", false)
                toggleControl("vehicle_right", false)
                setControlState("vehicle_right", false)
                setControlState("vehicle_left", true)
            end
        elseif button == "arrow_r" and press then
            if getVehicleType(vehicle) == "Automobile" then
                setElementData(vehicle, "vehicle:wheel:position", "vehicle_right")
                toggleControl("vehicle_left", false)
                toggleControl("vehicle_right", false)
                setControlState("vehicle_left", false)
                setControlState("vehicle_right", true)
            end
        elseif (button == "w" or button == "a" or button == "s" or button == "d") and press then
            if getElementData(vehicle, "vehicle:wheel:position") then
                setElementData(vehicle, "vehicle:wheel:position", nil)
            end
            setControlState("vehicle_left", false)
            setControlState("vehicle_right", false)
            toggleControl("vehicle_left", true)
            toggleControl("vehicle_right", true)
        end
    end
end)

addEventHandler("onClientElementStreamIn", root, function()
    if getElementType(source) == "ped" then
        local position = getElementData(source, "vehicle:wheel:position")
        if position then
            setPedControlState(source, position, true)
        end
    end
end)
