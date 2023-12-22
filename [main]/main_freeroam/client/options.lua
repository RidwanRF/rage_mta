
settingOptions = {
	
	['settings.farclip'] = function(value)
		setFarClipDistance(value)

		-- setFogDistance( math.min( getFarClipDistance(), 1000 )-1 )

	end,

}

addEventHandler('onClientElementDataChange', localPlayer, function(dataName, old, new)
	if settingOptions[dataName] then
		local func = settingOptions[dataName]
		func(new)
	end
end)