
function getVehiclePlateText(vehicle)
	-- return vehicle:getData('plate')
	return vehicle:getData('plate') or 'empty'
end

function hasVehicleCurtain(vehicle)
	return (vehicle:getData('plate_curtain') or 0) > 0
end