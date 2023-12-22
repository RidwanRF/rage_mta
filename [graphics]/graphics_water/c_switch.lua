-- local CONFIG_PROPERTY_NAME = "graphics.reflections_water"

-- addEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource()),
-- 	function()		
-- 		triggerEvent("switchWaterShine", resourceRoot, true)
-- 		enableWaterShine()
-- 	end
-- )

-- addEvent("dpConfig.update", false)
-- addEventHandler("dpConfig.update", root, function (key, value)
-- 	if key == CONFIG_PROPERTY_NAME then
-- 		if value then
-- 			enableWaterShine()
-- 		else
-- 			disableWaterShine()
-- 		end
-- 	end

addEventHandler('onClientResourceStart', resourceRoot, function()

	if localPlayer:getData('settings.water') then
		enableWaterShine()
	else
		disableWaterShine()
	end

end)

addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

	if dn == 'settings.water' then
		if new then
			enableWaterShine()
		else
			disableWaterShine()
		end
	end


end)