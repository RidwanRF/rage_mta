

addEventHandler('onElementDataChange', root, function(dn, old, new)

	if dn == 'vehicle.handbrake' and source.type == 'vehicle' then

		source.frozen = new

	end

end)