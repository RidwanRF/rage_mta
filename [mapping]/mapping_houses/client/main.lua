
------------------------------------------------

	houseShaders = {}

------------------------------------------------

	function replaceHouseModels()

		local txd = ':mapping_houses/assets/models/house'

		for house_type, data in pairs( HouseConfig ) do

			exports.engine:replaceModel(':mapping_houses/assets/models/' .. house_type, data.model )
			exports.engine:replaceModel(':mapping_houses/assets/models/' .. house_type, data.lod )

			engineSetModelLODDistance( data.lod, 1000 )
			engineSetModelLODDistance( data.model, 200 )

		end

	end

------------------------------------------------

	function createHouseTextures()

		for house_type, data in pairs( HouseConfig ) do

			for texture_pack, t_data in pairs( data.textures ) do

				for texture_name, texture_data in pairs( t_data ) do

					if not houseShaders[texture_data.path] then

						local shader = dxCreateShader( 'assets/shaders/texreplace.fx' )
						local texture = dxCreateTexture( string.format('assets/textures/%s', texture_data.path) )

						dxSetShaderValue(shader, 'gTexture', texture)

						houseShaders[texture_data.path] = shader

					end

					texture_data.shader = houseShaders[texture_data.path]

				end

			end

		end

	end

------------------------------------------------

	function loadHouseTextures( object, type, texture_pack )

		for texture_name, texture_data in pairs( HouseConfig[type].textures[texture_pack] ) do
			engineApplyShaderToWorldTexture( texture_data.shader, texture_name, object )
		end

	end

------------------------------------------------

	addEventHandler('onClientElementDataChange', resourceRoot, function(dn, old, new)

		if dn == 'house_data' then
			setTimer(loadHouseTextures, 100, 1, source, new.type, new.texture_pack)
		end

	end)

------------------------------------------------

	addEventHandler('onClientElementStreamIn', resourceRoot, function()

		local house_data = source:getData('house_data')
		
		if house_data then
			loadHouseTextures( source, house_data.type, house_data.texture_pack )
		end		

	end)

	function refreshHouseTex()

		for _, object in pairs( getElementsByType('object', resourceRoot, true) ) do

			local house_data = object:getData('house_data')
			
			if house_data then
				loadHouseTextures( object, house_data.type, house_data.texture_pack )
			end

		end

	end

	setTimer(refreshHouseTex, 3000, 0)

------------------------------------------------

	addEventHandler('onClientResourceStart', resourceRoot, function()

		replaceHouseModels()
		createHouseTextures()

		for _, object in pairs( getElementsByType('object', resourceRoot) ) do

			local house_data = object:getData('house_data')
			
			if house_data then
				loadHouseTextures( object, house_data.type, house_data.texture_pack )
			end

		end

	end)

------------------------------------------------