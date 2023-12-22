local data = {}
data.ped = {}

addEvent("event:vehicle:destroy:ped", true)
addEventHandler("event:vehicle:destroy:ped", root, function(vehicle)
    if isElement(data.ped[vehicle]) then
        destroyElement(data.ped[vehicle])
        data.ped[vehicle] = nil
    end
end)

addEventHandler("onVehicleExit", root, function(_, seat)
    if seat == 0 and getVehicleType(source) == "Automobile" then
        local position = getElementData(source, "vehicle:wheel:position")
        if position then
            local x, y, z = getElementPosition(source)
            if not isElement(data.ped[source]) then
                data.ped[source] = createPed(0, x, y, z + 5)
                setElementAlpha(data.ped[source], 0)
            end
            setElementData(data.ped[source], "vehicle:wheel:position", position)
            warpPedIntoVehicle(data.ped[source], source)
            setVehicleDoorOpenRatio(source, (seat + 2), 0, 360)
        end
        if getVehicleEngineState(source) then
            setVehicleEngineState(source, false)
        end
    end
end)

addEventHandler("onElementDestroy", root, function()
    if data.ped[source] then
        destroyElement(data.ped[source])
        data.ped[source] = nil
    end
end)
