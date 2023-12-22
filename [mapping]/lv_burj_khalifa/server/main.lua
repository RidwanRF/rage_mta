
loadstring( exports.core:include('common') )()

removeWorldModel( 9104, 10, 2323.6953125,1283.2265625,52.96875 )
removeWorldModel( 9105, 10, 2323.6953125,1283.2265625,52.96875 )

removeWorldModel( 8395, 10, 2323.6953125,1283.2265625,52.96875 )
removeWorldModel( 8701, 10, 2323.6953125,1283.2265625,52.96875 )

-- createWater(
-- 	344, 1230, 10,
-- 	384, 1230, 10,
-- 	344, 1337, 10,
-- 	384, 1337, 10
-- )

createCustomChunkedObject( { position = { 2315.64, 1282.63, 9.82,}, objects = Config.objects } )

removeWorldModel( 8464, 10, 2327.390625,1283.21875,9.8203125 )
removeWorldModel( 9157, 10, 2327.390625,1283.21875,9.8203125 )

loadstring([=[
	local obj = createObject( 8464, 2327.390625,1283.21875,9.8203125 )
	local lod = createObject( 9157, 2327.390625,1283.21875,9.8203125, 0, 0, 0, true )
	setLowLODElement(obj, lod)

]=])()