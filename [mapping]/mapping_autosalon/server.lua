
loadstring( exports.core:include('common') )()

-- createCustomChunkedObject( { position = {-2657.9219, 1409.7109, 6.72813}, objects = Config.objects } )


local object = createObject( 9582, -2657.9219, 1409.7109, 6.72813, 0, 0, 0 )
local lod = createObject( 9755, -2657.9219, 1409.7109, 6.72813, 0, 0, 0, true )

object.dimension = -1
lod.dimension = -1

setLowLODElement(object, lod)

-- object.scale = 1.05

-- local marker = createMarker( 0, 0, 3, 'cylinder', 3, 0, 0, 255, 150 )

-- setTimer(function()
-- 	marker:setData('controlpoint.3dtext', 'ПОЧТАЛЬОН')
-- end, 1000, 1)

-- restoreWorldModel( 9582, 44.946598, -2657.9219, 1409.7109, 14.82813, 0  )
-- restoreWorldModel( 9755, 44.946598, -2657.9219, 1409.7109, 14.82813, 0  )
removeWorldModel( 9582, 44.946598, -2657.9219, 1409.7109, 14.82813, 0  )
removeWorldModel( 9755, 44.946598, -2657.9219, 1409.7109, 14.82813, 0  )
