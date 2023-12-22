
loadstring( exports.core:include('common') )()

local island_pos = {-2269.81, 1777.96, -70.61}

createCustomChunkedObject( { position = island_pos, objects = Config.objects } )

-- local marker = createMarker( 0, 0, 3, 'cylinder', 3, 0, 0, 255, 150 )

-- setTimer(function()
-- 	marker:setData('controlpoint.3dtext', 'ПОЧТАЛЬОН')
-- end, 1000, 1)

for i = 1, 19999 do
	removeWorldModel( i, 100, -2408.82, 1551.38, 8.07, 0  )
end


for _, house in pairs( Houses ) do

	local ix,iy,iz = unpack(island_pos)
	local x,y,z,rx,ry,rz = unpack( house.position )

	exports.mapping_houses:createHouse( house.type, house.texture_pack, x+ix,y+iy,z+iz,
		math.deg(rx),
		math.deg(ry),
		math.deg(rz)
	)


end

exports.mapping_houses:createHouse( 3, 1, -2322.78, 1731.48, 9.08, 0, 0, 345 )
exports.mapping_houses:createHouse( 4, 2, -2321.74, 1753.82, 10.48, 0, 0, 96.8 )
exports.mapping_houses:createHouse( 5, 4, -2337.82, 1772.49, 9.24, 0, 0, 72.7 )


-- local x,y,z = unpack(island_pos)
-- createObject( 1000, x+7.41496,y-41.8811,z+76.8109-1, 0, 0, 1.74 ).scale = 1.1