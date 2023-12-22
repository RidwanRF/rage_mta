
					

-- for i = 1, 19999 do
-- 	restoreWorldModel( i, 500, 218.2265625,-1434.5625,24.640625 )
-- end

removeWorldModel( 1259, 10, 218.2265625,-1434.5625,24.640625 )
removeWorldModel( 6350, 50, 218.2265625,-1434.5625,24.640625 )

removeWorldModel( 1268, 10, 218.2265625,-1434.5625,24.640625 )

removeWorldModel( 1226, 10, 202.54, -1428.64, 12.47 )
					

-- for i = 1, 19999 do
-- 	restoreWorldModel( i, 500, 520.52, -1307.68, 31.2 )
-- end

-- for i = 1250, 1270 do
-- 	removeWorldModel( i, 10, 520.52, -1307.68, 31.2 )
-- end

-- for i = 6340, 6360 do
-- 	removeWorldModel( i, 100, 519.11, -1310.87, 35.99 )
-- end

removeWorldModel( 6497, 10, 227.7890625,-1423.03125,18.609375 )
removeWorldModel( 6498, 10, 227.7890625,-1423.03125,18.609375 )

local x,y,z = 227.7890625 + 0.00679,-1423.03125 + 0.001465,18.609375 - 6.23795 
local object = createObject(6497, x,y,z)
local lod = createObject( 6498, x,y,z, 0, 0, 0, true )
setLowLODElement( object, lod )
