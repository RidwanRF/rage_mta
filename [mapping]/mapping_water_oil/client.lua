

addEventHandler('onClientResourceStart', resourceRoot, function()

	for index, object in pairs( _chunked ) do
		exports.engine:replaceModel( ':mapping_water_oil/objects/'..index, object.model, { txd = ':mapping_water_oil/objects/main' } )

		exports.engine:replaceModel( ':mapping_water_oil/objects/'..index, object.lod, { txd = ':mapping_water_oil/objects/main' } )
		engineSetModelLODDistance(object.lod, 1000)
	end

end)