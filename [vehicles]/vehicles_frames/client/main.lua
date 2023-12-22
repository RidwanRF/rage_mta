

------------------------------------------------------------

    vehiclesFrames = {}

------------------------------------------------------------

    cachedTextures = {}

    function getFrameTexture( path, vehicle )

        local texture

        if cachedTextures[path] and isElement(cachedTextures[path].texture) then
            texture = cachedTextures[path].texture
        else

            cachedTextures[path] = cachedTextures[path] or {}
            cachedTextures[path].texture = dxCreateTexture( path, 'argb' )

        end

        cachedTextures[path].vehicles = cachedTextures[path].vehicles or {}
        cachedTextures[path].vehicles[ vehicle ] = true

        texture = cachedTextures[path].texture
        return texture

    end

    function unsetTextureVehicle( path, vehicle )

        local texture_data = cachedTextures[ path ]

        if texture_data and texture_data.vehicles then
            texture_data.vehicles[vehicle] = nil
        end

    end

    setTimer( function()

        for path, data in pairs( cachedTextures ) do

            if isElement(data.texture) and getTableLength( data.vehicles or {} ) <= 0 then

                destroyElement( data.texture )
                cachedTextures[path] = nil

            end

        end

    end, 20000, 0 )

------------------------------------------------------------

    function createVehicleFrame( _vehicle )

        local vehicle = _vehicle or source

        if vehiclesFrames[vehicle] then
            destroyVehicleFrame(vehicle)
        end

        local license_frame = tonumber( vehicle:getData('license_frame') ) or 0

        if license_frame and license_frame >= 0 then

            local filepath = ('assets/frames/%s.png'):format( license_frame )

            if not fileExists( filepath ) then return end

            local shader = dxCreateShader( 'assets/shaders/frame.fx', 1 )
            local texture = getFrameTexture( filepath, vehicle )

            shader:setValue( 'gTexture', texture )
            shader:applyToWorldTexture( 'ramka', vehicle )

            local anim = {}

            setAnimData( anim, 0.3, 0 )

            vehiclesFrames[vehicle] = {

                shader = shader,
                anim = anim,

                texture_path = filepath,

            }

        end

    end

------------------------------------------------------------

    function destroyVehicleFrame( _vehicle )

        local vehicle = _vehicle or source

        local frame = vehiclesFrames[vehicle]

        if frame then

            removeAnimData( frame.anim )
            clearTableElements( frame )

            unsetTextureVehicle( frame.texture_path, vehicle )

        end

        vehiclesFrames[vehicle] = nil

    end

------------------------------------------------------------
    
    function renderVehicleFrame( vehicle )

        local frame = vehiclesFrames[ vehicle ]

        if frame then

            animate( frame.anim, vehicle.overrideLights == 2 and 1 or 0 )

            local animData = getAnimData( frame.anim )
            frame.shader:setValue( 'progress', animData )

        end

    end

    addEventHandler('onClientRender', root, function()

        for vehicle, frame in pairs( vehiclesFrames ) do

            if isElement( vehicle ) and isElementOnScreen( vehicle ) then
                renderVehicleFrame( vehicle )
            end

        end

    end)

------------------------------------------------------------

    addEventHandler('onClientElementDataChange', root, function(dn,old,new)

        if dn == 'license_frame' and source.type == 'vehicle' then
            createVehicleFrame( source )
        end

    end)

------------------------------------------------------------

    addEventHandler('onClientVehicleScreenStreamIn', root, createVehicleFrame)

    addEventHandler('onClientElementStreamOut', root, destroyVehicleFrame)
    addEventHandler('onClientElementDestroy', root, destroyVehicleFrame)

------------------------------------------------------------

    addEventHandler('onClientResourceStart', resourceRoot, function()

        for _, vehicle in pairs( getElementsByType('vehicle', root, true) ) do
            createVehicleFrame( vehicle )
        end

    end)

------------------------------------------------------------