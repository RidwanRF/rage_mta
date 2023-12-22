

------------------------------------------------------------

    vehiclesFSO = {}

------------------------------------------------------------
    
    local gAnimSpeed = 0.3

------------------------------------------------------------

    function createVehicleFSO( _vehicle )

        local vehicle = _vehicle or source

        if vehiclesFSO[vehicle] then
            destroyVehicleFSO(vehicle)
        end

        local fso = vehicle:getData('fso') or 0

        if fso > 0 then

            local fsoModel = Config.FSOModels[ fso ]

            local fx = getVehicleComponentPosition( vehicle, 'fso_dummy' )

            if not fx then
                return
            end

            local x,y,z = getElementPosition( vehicle )

            local objects = {
                createObject( fsoModel, x,y,z ),
                createObject( fsoModel, x,y,z ),
            }

            local markers = {
                createMarker( x,y,z, 'corona', 1, 255,255,255,0 ),
                createMarker( x,y,z, 'corona', 1, 255,255,255,0 ),
            }

            attachElements( markers[1], objects[1], 0, -0.1, 0 )
            attachElements( markers[2], objects[2], 0, -0.1, 0 )

            local shaders = {}

            shaders[1] = dxCreateShader( 'assets/shaders/fso.fx' )
            shaders[2] = dxCreateShader( 'assets/shaders/fso.fx' )

            for index, shader in pairs( shaders ) do

                shader:applyToWorldTexture( '910203', objects[index] )
                shader:setValue( 'progress', 0.5 )

            end

            if fso == 2 then

                shaders[1]:setValue( 'color', {1,0,0} )
                shaders[2]:setValue( 'color', {0,0,1} )

                setMarkerColor( markers[1], 255, 0, 0, 0 )
                setMarkerColor( markers[2], 0, 0, 255, 0 )

            end

            local anims = { {}, {} }

            setAnimData( anims[1], gAnimSpeed )
            setAnimData( anims[2], gAnimSpeed )

            vehiclesFSO[vehicle] = {
                objects = objects,
                markers = markers,
                shaders = shaders,
                anims = anims,
            }

            updateVehicleFSO( vehicle )

        end

    end

------------------------------------------------------------

    function updateVehicleFSO( vehicle )

        local fso = vehiclesFSO[vehicle]
        if not fso then return end

        local fx,fy,fz = getVehicleComponentPosition( vehicle, 'fso_dummy' )
        local frx,fry,frz = getVehicleComponentRotation( vehicle, 'fso_dummy' )

        local objects = fso.objects

        local position_str = vehicle:getData('fso_position') or '0_0_0_0'
        local _y,_z,_offset,_r = unpack( splitString(position_str, '_') )

        _y = -(_y or 0)*0.2
        _z = (_z or 0)*0.2
        _r = (_r or 0)*30

        _offset = (_offset or 0)
        _offset = ((_offset + 1.5)/4.5)*0.27

        attachElements( objects[1], vehicle, fx + ( _offset or 0 ), fy-0.03 + (_y or 0), fz + ( _z or 0 ), frx + _r,-1,frz+180 )
        attachElements( objects[2], vehicle, -fx - ( _offset or 0 ), fy-0.03 + (_y or 0), fz + ( _z or 0 ), frx + _r,-1,frz+180 )

    end

------------------------------------------------------------

    function destroyVehicleFSO( _vehicle )

        local vehicle = _vehicle or source

        local fso = vehiclesFSO[vehicle]

        if fso then
            clearTableElements( fso )
        end

        vehiclesFSO[vehicle] = nil

    end

------------------------------------------------------------
    
    function renderVehicleFSO( vehicle )

        local fso = vehiclesFSO[ vehicle ]

        if fso then

            local anims = {}
            anims[1] = getAnimData( fso.anims[1] )
            anims[2] = getAnimData( fso.anims[2] )

            for index, animData in pairs( anims ) do

                local x,y,z = getElementPosition( fso.markers[index] )
                local cx,cy,cz = getCameraMatrix(  )

                local r,g,b = getMarkerColor( fso.markers[index] )

                if isLineOfSightClear( x,y,z, cx,cy,cz,
                    true, true, true, true, true, false, false
                ) then
                    setMarkerColor( fso.markers[index], r,g,b,255*animData )
                else
                    setMarkerColor( fso.markers[index], r,g,b,0 )
                end

                setMarkerSize( fso.markers[index], 3*(1-animData) )

                fso.shaders[index]:setValue( 'progress', 0.5 + 2*animData )

                fso.objects[index].dimension = vehicle.dimension
                fso.objects[index].interior = vehicle.interior

                fso.markers[index].dimension = vehicle.dimension
                fso.markers[index].interior = vehicle.interior

            end

        end

    end

    addEventHandler('onClientRender', root, function()

        for vehicle, fso in pairs( vehiclesFSO ) do

            if isElement(vehicle) and isElementStreamedIn( vehicle )
                and isElementOnScreen( vehicle )
                and getDistanceBetween( vehicle, localPlayer ) < 50
            then
                renderVehicleFSO( vehicle )
            end

        end

    end)

------------------------------------------------------------

    function blimFSO()

        for vehicle, fso in pairs( vehiclesFSO ) do

            if isElement(vehicle) and isElementStreamedIn( vehicle )
                and isElementOnScreen( vehicle )
                and getDistanceBetween( vehicle, localPlayer ) < 50
            then

                if vehicle:getData('fso.state') and fso.anims then

                    setAnimData( fso.anims[1], gAnimSpeed, 1 )

                    animate( fso.anims[1], 0, function()
                        
                        if fso.anims then
                            setAnimData( fso.anims[2], gAnimSpeed, 1 )
                            animate( fso.anims[2], 0 )
                        end

                    end )

                end

            end

        end

    end


    setTimer(function()

        blimFSO()

        setTimer( blimFSO, 400, 1 )

    end, 1300, 0)

------------------------------------------------------------

    addEventHandler('onClientElementDataChange', root, function(dn,old,new)

        if source.type == 'vehicle' then

            if dn == 'fso' then
                createVehicleFSO( source )
            elseif dn == 'fso_position' then
                updateVehicleFSO( source )
            end

        end

    end)

------------------------------------------------------------

    addEventHandler('onClientElementStreamIn', root, createVehicleFSO)

    addEventHandler('onClientElementStreamOut', root, destroyVehicleFSO)
    addEventHandler('onClientElementDestroy', root, destroyVehicleFSO)

------------------------------------------------------------

    addEventHandler('onClientResourceStart', resourceRoot, function()

        for _, vehicle in pairs( getElementsByType('vehicle', root, true) ) do
            createVehicleFSO( vehicle )
        end

    end)

------------------------------------------------------------