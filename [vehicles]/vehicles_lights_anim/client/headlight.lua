

----------------------------------------------------------------
	
	local tex_names = {

		front = {
			shader_headlight = 'head',
			tex_hwd0 = 'hwd',
		},

		rear = {
			tex_rwd0 = 'hwd',
		},

	}

----------------------------------------------------------------

	local shaders = {
		front = dxCreateShader('assets/shaders/progress.fx', 0, 0, true),
		rear = dxCreateShader('assets/shaders/progress_rear.fx', 0, 0, true),
	}

	dxSetShaderValue( shaders.front, 'progress', 4 )
	dxSetShaderValue( shaders.rear, 'progress', 4 )

----------------------------------------------------------------

	function toggleShader( vehicle, s_type, light_state )

		local func = light_state and engineApplyShaderToWorldTexture or engineRemoveShaderFromWorldTexture

		for tex_name, state in pairs( tex_names[ s_type ] or {} ) do

			if state == 'head' and light_state == 'head' then
				func( shaders[ s_type ], tex_name, vehicle )
			elseif state == 'hwd' then
				func( shaders[ s_type ], tex_name, vehicle )
			end

		end

	end

----------------------------------------------------------------

	function updateVehicleHeadlights( _vehicle )

		local vehicle = _vehicle or source

		local state = vehicle:getData('vehicleLightsState')
		local light_state = (state == 'head' or state == 'strobo') and 'head' or ( state == 'hwd' and 'hwd' or false )

		toggleShader( vehicle, 'front', light_state )
		toggleShader( vehicle, 'rear', light_state )

	end

----------------------------------------------------------------

	addEventHandler('onClientElementDataChange', root, function( dn, old, new )

		if dn == 'vehicleLightsState' and isElementStreamedIn( source ) and isElementOnScreen( source ) then

			updateVehicleHeadlights( source )

		end

	end)

----------------------------------------------------------------

	addEventHandler('onClientElementScreenStreamIn', root, updateVehicleHeadlights)

----------------------------------------------------------------

	addEventHandler('onClientResourceStart', resourceRoot, function()

		for _, vehicle in pairs( getElementsByType('vehicle', root, true) ) do

			if isElementOnScreen(vehicle) then
				updateVehicleHeadlights( vehicle )
			end

		end

	end)

----------------------------------------------------------------