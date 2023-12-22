
------------------------------------------------------------------------

	houses = {}

	function createHouse( type, texture_pack, x,y,z, rx,ry,rz )

		local config = HouseConfig[type]
		if not config then return false end

		local object = createObject( config.model, x,y,z, rx,ry,rz )
		local lod = createObject( config.lod, x,y,z, rx,ry,rz, true )

		object:setData('house_data', { type = type, texture_pack = texture_pack, resource = sourceResource })
		houses[sourceResource] = houses[sourceResource] or {}
		houses[sourceResource][object] = { object = object, lod = lod }

		setLowLODElement(object, lod)

		return object, lod

	end


------------------------------------------------------------------------

	if localPlayer then

		addEventHandler('onClientResourceStop', root, function(resource)
			clearTableElements( houses[resource] or {} )
		end)

	else

		addEventHandler('onResourceStop', root, function(resource)
			clearTableElements( houses[resource] or {} )
		end)

	end

------------------------------------------------------------------------