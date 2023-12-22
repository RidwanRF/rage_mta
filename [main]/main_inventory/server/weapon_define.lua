

addEventHandler('onResourceStart', resourceRoot, function()

	for _, item in pairs( Config.items ) do

		if item.type == 'weapon' and item.properties then

			for property, value in pairs( item.properties ) do
				setWeaponProperty( item.model, 'poor', property, value )
			end

		end

	end

end)