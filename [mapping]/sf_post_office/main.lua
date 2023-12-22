
addEventHandler('onResourceStart', resourceRoot, function()
	removeWorldModel( 9526, 50, -2337.7578, 1000.2813, 52.80469 )
	removeWorldModel( 9525, 50, -2337.7578, 1000.2813, 52.80469 )
	removeWorldModel( 9527, 100, -2337.7578, 1000.2813, 52.80469 )
	removeWorldModel( 9528, 100, -2337.7578, 1000.2813, 52.80469 )
	removeWorldModel( 9898, 100, -2337.7578, 1000.2813, 52.80469 )


end)

addEventHandler('onResourceStop', resourceRoot, function()
	restoreWorldModel( 9526, 50, -2337.7578, 1000.2813, 52.80469 )
	restoreWorldModel( 9525, 50, -2337.7578, 1000.2813, 52.80469 )
	restoreWorldModel( 9527, 100, -2337.7578, 1000.2813, 52.80469 )
	restoreWorldModel( 9528, 100, -2337.7578, 1000.2813, 52.80469 )
	restoreWorldModel( 9898, 100, -2337.7578, 1000.2813, 52.80469 )
end)