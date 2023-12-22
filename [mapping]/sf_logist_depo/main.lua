
addEventHandler('onResourceStart', resourceRoot, function()
	removeWorldModel( 11014, 10, -2076.4375,-107.9296875,36.96875 )
	removeWorldModel( 11372, 10, -2076.4375,-107.9296875,36.96875 )
end)

addEventHandler('onResourceStop', resourceRoot, function()
	restoreWorldModel( 11014, 10, -2076.4375,-107.9296875,36.96875 )
	restoreWorldModel( 11372, 10, -2076.4375,-107.9296875,36.96875 )
end)