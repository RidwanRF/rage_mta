loadstring( exports['core']:include('common'))()


local bd = Connection( "sqlite", ":databases/house_old.db" )
local bd1 = dbConnect('sqlite', ':databases/house.db')

addEventHandler( "onResourceStart", resourceRoot, function( ) 
	--[[local result = bd:query( "SELECT * FROM houses" ):poll( -1 )

	local data = { }

	for i, v in pairs( result ) do
		if i < 850 then

			local cost = v.cost
			local donate = v.donate

			table.insert( data, {
				id = i,
				cost = cost,
				donate = donate,
				lots = v.lots,
				default_lots = v.default_lots,
				pos = v.pos,
				interior = v.interior
			} )
		end
	end

	Timer( function( data ) 
		for i, v in pairs( data ) do
			bd1:exec( "INSERT INTO houses VALUES( ?, ?, ?, ?, ?, ?, ?, ?, ? )", v.id, "", v.cost, v.donate, v.pos, v.lots, v.default_lots, v.interior, "" )
		end
	end, 1500, 1, data)]]
end)

addCommandHandler( "deletehouses", function( ) 
	bd1:exec( "DELETE FROM houses" )
end)