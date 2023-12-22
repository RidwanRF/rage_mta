


addEventHandler('onClientResourceStart', resourceRoot, function()

	if localPlayer:getData('settings.shading') then
		enableAO()
	else
		disableAO()
	end

end)

addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

	if dn == 'settings.shading' then
		if new then
			enableAO()
		else
			disableAO()
		end
	end


end)