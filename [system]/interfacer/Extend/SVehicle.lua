Import( "ShVehicle" )

Vehicle.Delete = function( self )
	exports.vehicles_main:wipeVehicle( self:GetID( ) )
end