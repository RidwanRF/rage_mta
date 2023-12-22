

------------------------------------------------------------------------------------

	local TIRE_TEXTURE_NAME = { 'wheel_B' }

------------------------------------------------------------------------------------

	function toggleShader( vehicle, shader, flag )

		local elements = getAttachedElements( vehicle )

		local func = (
			flag and engineApplyShaderToWorldTexture
			or engineRemoveShaderFromWorldTexture
		)

		for _, element in pairs( elements ) do

			for _, texture_name in pairs( TIRE_TEXTURE_NAME ) do
				engineApplyShaderToWorldTexture( shader, texture_name, element )
			end

		end

	end

------------------------------------------------------------------------------------

	function updateWheelsTire( vehicle, old_tire_id )

		if old_tire_id then
			removeWheelsTire( vehicle, old_tire_id )
		end

		local tire_id = vehicle:getData('wheels_tire') or 0

		if tire_id > 0 then

			local shader_data = getTireTexture( tire_id )

			if shader_data and isElement( shader_data.shader ) then

				toggleShader( vehicle, shader_data.shader, true )
				shader_data.used_on[vehicle] = true

			end

		end

	end

------------------------------------------------------------------------------------

	function removeWheelsTire( vehicle, _tire_id )

		if not isElement(vehicle) then return end

		local tire_id = ( _tire_id ) or ( vehicle:getData('wheels_tire') or 0 )

		if tire_id > 0 then

			local shader_data = tireShaders[ tire_id ]

			if shader_data and isElement( shader_data.shader ) then

				toggleShader( vehicle, shader_data.shader, false )
				shader_data.used_on[vehicle] = nil

				if getTableLength(shader_data.used_on) <= 0 then
					clearTireTexture( tire_id )
				end

			end

		end


	end

------------------------------------------------------------------------------------

	addEventHandler('onClientElementStreamIn', root, function()

		if source.type == 'vehicle' then

			updateWheelsTire( source )

		end

	end)

	addEventHandler('onClientElementStreamOut', root, function()

		if source.type == 'vehicle' then

			removeWheelsTire( source )

		end

	end)

	addEventHandler('onClientElementDataChange', root, function(dn, old, new)

		if dn == 'wheels_tire' then

			updateWheelsTire( source, old or 0 )

		end

	end)

	addEventHandler('onClientResourceStart', resourceRoot, function()

		for _, vehicle in pairs( getElementsByType('vehicle', root, true) ) do

			updateWheelsTire( vehicle )

		end

	end)

------------------------------------------------------------------------------------