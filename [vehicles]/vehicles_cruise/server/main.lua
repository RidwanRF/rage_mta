addEvent("enableVehicleCruiseSpeed", true)
addEventHandler("enableVehicleCruiseSpeed", root, function (state)
	if state then 
		setElementSyncer (source, getVehicleController (source));
	else 		
		setElementSyncer (source, true);
	end
end)