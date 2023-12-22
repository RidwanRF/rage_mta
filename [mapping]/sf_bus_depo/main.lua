
addEventHandler('onResourceStart', resourceRoot, function()
	removeWorldModel( 11008, 50, -2037.7, 81.24, 32.74 )
	removeWorldModel( 11272, 50, -2037.7, 81.24, 32.74 )
	removeWorldModel( 11245, 50, -2037.7, 81.24, 32.74 )
end)

addEventHandler('onResourceStop', resourceRoot, function()
	restoreWorldModel( 11008, 50, -2037.7, 81.24, 32.74 )
	restoreWorldModel( 11272, 50, -2037.7, 81.24, 32.74 )
	restoreWorldModel( 11245, 50, -2037.7, 81.24, 32.74 )
end)