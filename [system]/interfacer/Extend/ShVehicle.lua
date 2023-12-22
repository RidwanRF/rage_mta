Vehicle.GetID = function( self )
	return self:getData( "id" )
end

Vehicle.GetName = function( self )
	local vehicles_list, vehicles_properties = exports.vehicles_main:getVehiclesList( )

	if vehicles_list[ self.model ] then
		return ( vehicles_list[ self.model ].mark or "" ) .. vehicles_list[ self.model ].name
	end
end

Vehicle.GetOwner = function( self )
	return exports.vehicles_main:getVehicleDBData( self, "owner" ) or "nil"
end