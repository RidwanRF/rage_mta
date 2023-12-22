
animatedLightsModels = {}
animatedLights = {}

--------------------------------------------------------------------------------

    function renderLights()
        local curAnim, flag
        for _, vehicle in pairs( getElementsByType('vehicle', root, true) ) do
            if animatedLights[vehicle] then
                curAnim, flag = getAnimData(vehicle)
                if curAnim then
                    animatedLightsModels[vehicle.model].render(
                        vehicle, animatedLights[vehicle], curAnim, flag)
                end
            end
        end
    end
    addEventHandler('onClientRender', root, renderLights)

--------------------------------------------------------------------------------

    function setupAnimation(vehicle)
        if not getAnimData(vehicle) then
            local animSpeed = animatedLightsModels[vehicle.model].animationSpeed or 1000
            setAnimData(vehicle, animSpeed)
        end
    end

    function setupLights(vehicle)
        if animatedLightsModels[vehicle.model].setup then
            animatedLightsModels[vehicle.model].setup(vehicle)
        end

        setupAnimation(vehicle)
    end

    function removeLights(vehicle)
        if not animatedLights[vehicle] then return end
        
        if animatedLightsModels[vehicle.model].remove then
            animatedLightsModels[vehicle.model].remove(vehicle, animatedLights[vehicle])
        end

        animatedLights[vehicle] = nil
    end

--------------------------------------------------------------------------------

    function enableLights(vehicle)
        if not animatedLightsModels[vehicle.model] then return end

        if not animatedLights[vehicle] then
            setupLights(vehicle)
        end

        if animatedLightsModels[vehicle.model].enable then
            animatedLightsModels[vehicle.model].enable(vehicle, animatedLights[vehicle])
        end

        setupAnimation(vehicle)
        animate(vehicle, true)
    end

    function disableLights(vehicle)
        if not animatedLights[vehicle] then return end
        if animatedLightsModels[vehicle.model].disable then
            animatedLightsModels[vehicle.model].disable(vehicle, animatedLights[vehicle])
        end
        animate(vehicle, false)
    end

--------------------------------------------------------------------------------

    function updateLightsState(vehicle)
        local lightsState = getLightsState(vehicle)
        if lightsState then
            if lightsState ~= 0 then
                enableLights(vehicle)
                animate(vehicle, true, true)
            else
                disableLights(vehicle)
                animate(vehicle, false, true)
            end
        end
    end

--------------------------------------------------------------------------------

    function handleStreamIn()
        if not animatedLightsModels[source.model] then return end
        updateLightsState(source)
    end
    addEventHandler('onClientElementStreamIn', root, handleStreamIn)


    function handleStreamOut()
        if not animatedLightsModels[source.model] then return end
        removeLights(source)
    end
    addEventHandler('onClientElementStreamOut', root, handleStreamOut)
    addEventHandler('onClientElementDestroy', root, handleStreamOut)

    function onDataChange(dateName, oldValue)
        if dateName ~= 'vehicleLightsState' then return end
        if not animatedLightsModels[source.model] then return end

        local lightsState = getLightsState(source)
        if oldValue == 'off' and lightsState ~= 0 then
            enableLights(source)
        elseif lightsState == 0 then
            disableLights(source)
        end
    end
    addEventHandler('onClientElementDataChange', root, onDataChange)

    function onStart()
        for _, vehicle in pairs(getElementsByType('vehicle', root, true)) do
            if animatedLightsModels[vehicle.model] then
                setupLights(vehicle)
            end
        end
    end
    addEventHandler('onClientResourceStart', resourceRoot, onStart)

--------------------------------------------------------------------------------

    function debug.getAnimatedLightsToClipboard()
        local table = {}
        local count = 0
        for k,v in pairs(animatedLights) do
            table[tostring(k)] = true
            count = count + 1
        end
        -- setClipboard( toJSON(table) )
        outputChatBox(count)
    end
    addCommandHandler('getAnimatedLightsToClipboard', debug.getAnimatedLightsToClipboard)

--------------------------------------------------------------------------------