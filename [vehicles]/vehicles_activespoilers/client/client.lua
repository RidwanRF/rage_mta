
addEventHandler('onClientRender', root, function()
    updateAnimationValues()
    local model, curAnim
    for _, v in pairs( getElementsByType('vehicle', root, true) ) do
        model = getElementModel(v)

        if spoilersFunctions[model] then

            curAnim = getAnimData(v)
            if not curAnim then
                setAnimData(v, spoilersFunctions[model][1])
                animate(v, getElementData(v, 'spoilerActive') or false)
                curAnim = getAnimData(v)
            end

            if curAnim then
                local func = spoilersFunctions[model][2]
                func(v, curAnim)
            end

        end
    end
end)

addEventHandler('onClientElementDataChange', root, function(dn)
    if dn ~= 'spoilerActive' then return end
    local model = getElementModel(source)
    if not spoilersFunctions[model] then return end
    if not getAnimData(source) then
        setAnimData(source, spoilersFunctions[model][1])
    end
    animate(source, getElementData(source, dn) or false)
end)

setTimer(function()

    for _, vehicle in pairs( getElementsByType('vehicle', getResourceRoot('vehicles_main'), true) ) do
        local speed = getElementSpeed(vehicle, 'km\h')
        setElementData(vehicle, 'spoilerActive', speed >= 100, false)
    end

    for _, vehicle in pairs( getElementsByType('vehicle', getResourceRoot('vehicles_shop'), true) ) do
        local speed = getElementSpeed(vehicle, 'km\h')
        setElementData(vehicle, 'spoilerActive', speed >= 100, false)
    end

end, 1000, 0)