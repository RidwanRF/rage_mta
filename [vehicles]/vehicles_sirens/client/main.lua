
----------------------------------------------------------------------

    sirens = {}

----------------------------------------------------------------------

    function getVehicleSize(vehicle, ignore_properties)

        if not ignore_properties then
            local size = exports.vehicles_main:getVehicleProperty( vehicle, 'size' )

            if size then
                return unpack( size )
            end
        end

        local _,_,rz = getElementRotation(vehicle)
        local x,y,z = getElementPosition(vehicle)

        local x1,y1 = getPointFromDistanceRotation(x,y, 30, -rz)
        local x2,y2 = getPointFromDistanceRotation(x,y, 30, -rz+180)

        local bC1, cx1,cy1 = processLineOfSight(
            x1,y1,z, x,y,z,
            false, true, false, false, true, true, true
        )

        local bC2, cx2,cy2 = processLineOfSight(
            x2,y2,z, x,y,z,
            false, true, false, false, true, true, true
        )

        local height = {
            cx1 and getDistanceBetweenPoints2D( cx1, cy1, x, y ) or 0,
            cx1 and getDistanceBetweenPoints2D( cx2, cy2, x, y ) or 0,
        }

        local x1,y1 = getPointFromDistanceRotation(x,y, 30, -rz+90)
        local x2,y2 = getPointFromDistanceRotation(x,y, 30, -rz+180+90)

        local bC1, cx1,cy1, _, _, xx,yy,zz = processLineOfSight(
            x1,y1,z, x,y,z,
            false, true, false, false, true, true, true
        )

        local bC2, cx2,cy2 = processLineOfSight(
            x2,y2,z, x,y,z,
            false, true, false, false, true, true, true
        )

        local width = {
            cx1 and getDistanceBetweenPoints2D( cx1, cy1, x, y ) or false,
            cx1 and getDistanceBetweenPoints2D( cx2, cy2, x, y ) or false,
        }

        return width, height

    end

----------------------------------------------------------------------

    function renderSirens()

        for vehicle, siren in pairs( sirens ) do

        	if isElement(vehicle) and isElementOnScreen(vehicle) then

	            siren.object.dimension = vehicle.dimension
	            siren.object.interior = vehicle.interior

	            local state = vehicle:getData('sirens.state')

            	siren.marker.interior = vehicle.interior
            	siren.marker.dimension = vehicle.dimension

            	local sin = 0.3 * getEasingValue( math.abs( math.sin( getTickCount() * 0.005 ) ), 'InOutQuad' )

            	local cr,cg,cb = interpolateBetween( 40,100,255, 255,255,255, sin, 'Linear' )
            	setMarkerSize(siren.marker, 0.2 + sin)
            	setMarkerColor(siren.marker, cr,cg,cb, state and 150 or 0)

            	if isElement( siren.sound ) then

	            	siren.sound.interior = vehicle.interior
	            	siren.sound.dimension = vehicle.dimension

            		local x,y,z = getElementPosition( vehicle )
            		setElementPosition( siren.sound, x,y,z )
            		
            	end

        	end


        end

    end

    addEventHandler('onClientRender', root, renderSirens)

----------------------------------------------------------------------

    function createVehicleSiren(vehicle)

        local siren = vehicle:getData('sirens')
        local model = Config.sirens[siren]

        if not model then return end

        local x,y,z = getElementPosition(vehicle)
        local object = createObject(model, x,y,z)

        sirens[vehicle] = {

            object = object,
            marker = createMarker( x,y,z, 'corona', 0.2, 40,100,255,150 ),

        }

        attachElements( sirens[vehicle].marker, sirens[vehicle].object, 0, 0, 0.05 )

        object.dimension = vehicle.dimension
        object.interior = vehicle.interior

        updateVehicleSiren(vehicle)

    end

    function removeVehicleSiren(_vehicle)

        local vehicle = _vehicle or source

        local siren = sirens[vehicle]
        if not siren then return end

        if siren then
            clearTableElements(siren)
        end 

        sirens[vehicle] = nil

    end

----------------------------------------------------------------------

    function updateVehicleSiren(vehicle)

        local siren = sirens[vehicle]
        if not siren then return end

        local vx,vy,vz = getElementPosition( vehicle )
        local vrx,vry,vrz = getElementRotation( vehicle )

        local position_str = vehicle:getData('sirens_position') or '0_0_0_0'
        local _x,_y,_z,_r = unpack( splitString(position_str, '_') )

        local x,y,z,r = tonumber(_x), tonumber(_y), tonumber(_z) or 0, tonumber(_r) or 0

        local width,height = getVehicleSize(vehicle)
        if width[1] == false then return end

        if x > 0 then x = width[2] * x else x = width[1] * x end
        if y > 0 then y = height[2] * y else y = height[1] * y end

        local rightDoor = vehicle:getComponentPosition('door_rf_dummy')
        local leftDoor = vehicle:getComponentPosition('door_lf_dummy')

        x = math.clamp( x, leftDoor.x+0.1, rightDoor.x-0.1 )
        y = math.clamp( y, -height[1]+0.2, height[2]-0.2 )

        attachElements( siren.object, vehicle, x,y,z+0.11, 45*r, 0, 0 )

        setSirensState( vehicle, vehicle:getData('sirens.state') )

    end

----------------------------------------------------------------------

    addEventHandler('onClientElementDataChange', root, function(dn, old, new)

        if dn == 'sirens' then

            removeVehicleSiren(source)

            if isElementStreamedIn(source) then
	            createVehicleSiren(source)
            end

        elseif dn == 'sirens_position' then

            if isElementStreamedIn(source) then
	            updateVehicleSiren(source)
            end

        end

    end)

    addEventHandler('onClientElementStreamIn', root, function()

        if source.type == 'vehicle' and source:getData('sirens') then
            createVehicleSiren(source)
        end

    end)

    addEventHandler('onClientElementDestroy', root, removeVehicleSiren)
    addEventHandler('onClientElementStreamOut', root, removeVehicleSiren)

    addEventHandler('onClientResourceStart', resourceRoot, function()

        for _, vehicle in pairs( getElementsByType('vehicle', root, true) ) do
            createVehicleSiren(vehicle)
        end

    end)

----------------------------------------------------------------------

	function setSirensState(vehicle, state)

		local siren = sirens[vehicle]
		if not siren then return end

		if isElement(siren.sound) then
			destroyElement(siren.sound)
		end

		if state and localPlayer:getData('settings.siren_sounds') then

			local x,y,z = getElementPosition(vehicle)
			siren.sound = playSound3D('assets/sounds/sound.mp3', x,y,z, true)

			setSoundVolume(siren.sound, 1)
			setSoundMaxDistance(siren.sound, 60)

		end

	end

	addEventHandler('onClientElementDataChange', root, function(dn, old, new)

		if dn == 'sirens.state' and source.type == 'vehicle' then

			if new and not isElementStreamedIn(source) then return end
			setSirensState(source, new)

		end

	end)

	addEventHandler('onClientElementStreamIn', root, function()
		if source:getData('sirens.state') then
			setSirensState(source, true)
		end
	end)

----------------------------------------------------------------------

    addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

        if dn == 'settings.siren_sounds' then

            for vehicle in pairs(sirens) do
                setSirensState( vehicle, vehicle:getData('sirens.state') )
            end

        end

    end)

----------------------------------------------------------------------

    addCommandHandler('sirens_resetconfig', function()
        
        if exports.acl:isAdmin(localPlayer) then

            local coords = { 0, 0, 3, 0, 0, 0 }

            local vehicles = exports.vehicles_main:getVehiclesList()

            local index = 1

            for model, data in pairs( vehicles ) do

                setTimer(function( model, data )

                    local x,y,z,rx,ry,rz = unpack(coords)

                    local vehicle = createVehicle( model, x,y,z,rx,ry,rz )

                    setTimer(function()

                        vehicles[model].properties.size = { getVehicleSize(vehicle, true) }
                        destroyElement(vehicle)

                    end, 1000, 1)

                end, index*2000, 1, model, data)

                index = index + 1

            end

            setTimer(function()
                setClipboard( inspect( vehicles ) )
            end, index*2000, 1)

        end

    end)

----------------------------------------------------------------------