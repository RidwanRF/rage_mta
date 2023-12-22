loadstring( exports.core:include('common'))()

--[[local bd = dbConnect('sqlite', ':databases/business.db')
local bd1 = dbConnect( "sqlite", "business.db" )

addCommandHandler( "createbb", function( ) 
	local result = bd1:query( "SELECT * FROM business" ):poll( -1 )

	local data = { }

	for i, v in pairs( result ) do
		local pos = split(v.pos, ",")

		table.insert( data, {
			id = i,
			cost = v.cost,
			pos = toJSON( { x = pos[ 1 ], y = pos[ 2 ], z = pos[ 3 ] } ),
			donate = 0,
			payment_sum = v.payout_amount,
		} )
	end
	
	Timer( function( data ) 
		bd:exec( "DELETE FROM business" )
		for i, v in pairs( data ) do
			local id, cost, pos, donate, payment_sum = v.id, v.cost, v.pos, v.donate, v.payment_sum

			bd:exec( "INSERT INTO business VALUES( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )", id, "", "Магазин", pos, cost, donate, 0, payment_sum, NULL, NULL, NULL, NULL )
		end
	end, 1000, 1, data)
end)]]