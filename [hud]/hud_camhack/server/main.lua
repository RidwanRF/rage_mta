
addEvent('onPlayerCamhack')

function setPlayerCamHackEnabled( thePlayer, state )
	triggerEvent( 'onPlayerCamhack', thePlayer )
	return triggerClientEvent( thePlayer,"onClientEnableCamMode", root, state )
end

function setPlayerCamHackDisabled( thePlayer )
	return triggerClientEvent( thePlayer,"onClientDisableCamMode", root )
end

addEventHandler( "onResourceStop", resourceRoot, 
	function( )
		for i,thePlayer in pairs( getElementsByType( "player" ) ) do
			if getElementData( thePlayer, "isPlayerInCamHackMode" ) then 
				setElementAlpha( thePlayer, 255 )
				setElementFrozen( thePlayer, false ) 
				setElementCollisionsEnabled( thePlayer, true ) 	
			end
		end
	end
)

function toggleControls(player, flag)

	local controls = {
		'backwards', 'forwards', 'left', 'right', 'jump', 'fire', 
	}

	for _, control in pairs( controls ) do
		toggleControl(player, control, flag)
	end

end

function camhack( thePlayer )

	if getElementDimension(thePlayer) > 1 and not exports.acl:isAdmin(thePlayer)
		then return end

	if getPedOccupiedVehicle(thePlayer) then return end

	if isPedInVehicle( thePlayer ) then
		if getVehicleOccupant( getPedOccupiedVehicle( thePlayer ) ) ~= thePlayer then
			if getElementData( thePlayer, "isPlayerInCamHackMode" ) then 
				setElementAlpha( thePlayer, 255 )
				setPlayerCamHackDisabled( thePlayer )
			else
				setElementAlpha( thePlayer, 0 )
				setPlayerCamHackEnabled( thePlayer, false )
			end
		end
	else
		if getElementData( thePlayer, "isPlayerInCamHackMode" ) then 
			local x, y, z = getElementVelocity(thePlayer)
			local speed = math.sqrt(x^2 + y^2 + z^2) * 180
			if (speed > 5) then return end	-- Если человек двигается, то не включать камхак
			-- setElementAlpha( thePlayer, 255 )
			setPlayerCamHackDisabled( thePlayer )
			setElementFrozen( thePlayer, false ) 
			toggleControls(thePlayer, true)
		else
			-- setElementAlpha(thePlayer, 127)
			setPlayerCamHackEnabled( thePlayer, true )
			setElementFrozen( thePlayer, true )
			toggleControls(thePlayer, false)
		end
	end
end

addCommandHandler( "camhack", camhack)
addEventHandler('onPlayerLogin', root, function()
	bindKey(source, 'k', 'down', camhack)
end)

addEventHandler('onResourceStart', resourceRoot, function()

	for _, player in pairs( getElementsByType('player') ) do
		bindKey(player, 'k', 'down', camhack)
	end

end)

addEvent('hud_camhack.toggle', true)
addEventHandler('hud_camhack.toggle', root, function()
	camhack( client )
end)