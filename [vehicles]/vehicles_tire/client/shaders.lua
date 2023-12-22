
------------------------------------------------------------------------------------

	tireShaders = {}

------------------------------------------------------------------------------------

	function getTireTexture( tire_id )

		if tireShaders[ tire_id ] then
			return tireShaders[ tire_id ]
		end

		local shader = dxCreateShader( 'assets/shaders/texreplace.fx', 0, 0, true )
		local texture = dxCreateTexture( ('assets/textures/%s.dds'):format( tire_id ), 'dxt1' )

		dxSetShaderValue( shader, 'gTexture', texture )

		tireShaders[ tire_id ] = {

			texture = texture,
			shader = shader,

			used_on = {},

		}

		return tireShaders[ tire_id ]

	end

------------------------------------------------------------------------------------
	
	function clearTireTexture( tire_id )

		if tireShaders[ tire_id ] then
			clearTableElements( tireShaders[ tire_id ] )
		end

		tireShaders[ tire_id ] = nil

	end

------------------------------------------------------------------------------------