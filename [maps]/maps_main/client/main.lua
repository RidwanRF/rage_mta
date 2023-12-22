
addEventHandler('onClientResourceStart', resourceRoot, function()

	setTimer(function()

		for _, object in pairs( getElementsByType('object', resourceRoot) ) do
			setObjectBreakable( object, false )
		end
		
	end, 3000, 1)


end)