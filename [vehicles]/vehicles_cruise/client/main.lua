local cruiseSpeedKey = "lshift"

local cruiseSpeedEnabled, cruiseSpeed

function getCruiseSpeedEnabled()
	return cruiseSpeedEnabled
end

local function cruiseSpeedChecker ()
	local theVehicle = getPedOccupiedVehicle (localPlayer)
	local vX, vY, vZ = getElementVelocity (theVehicle)
	local iv = 1/math.sqrt (vX^2 + vY^2 + vZ^2)
	local mX, mY, mZ = vX * iv * cruiseSpeed, vY * iv * cruiseSpeed, vZ * iv * cruiseSpeed
	setElementVelocity (theVehicle, mX, mY, mZ)

	if not isVehicleOnGround(theVehicle) then

		local z = getGroundPosition( getElementPosition(theVehicle) )
		if math.abs( z - theVehicle.position.z ) > 0.3 then
			toggleCruiseSpeed()
		end

	end

end;

__cruiseSpeedCollisionChecker = {}
local function cruiseSpeedCollisionChecker (_, force)

    if source ~= localPlayer.vehicle then return end
    if force < 30 then return end

	__cruiseSpeedCollisionChecker()

end

function canVehicleUseCruiseControl(vehicle)
	return not ( not getElementData(vehicle, "id")
		or not getVehicleEngineState(vehicle)
		or getVehicleType(vehicle) ~= 'Automobile' )
end

function toggleCruiseSpeed ()
	if not cruiseSpeedEnabled then
		local theVehicle = getPedOccupiedVehicle (localPlayer);
		if not theVehicle then return end
		if not canVehicleUseCruiseControl(theVehicle) then
			return
		end
		for _, player in pairs(getVehicleOccupants(theVehicle)) do
			if getElementData(player, "isChased") or getElementData(player, "isChasing") then
				return
			end
		end
		
		local vX, vY, vZ = getElementVelocity (theVehicle)
		cruiseSpeed = math.sqrt (vX^2 + vY^2 + vZ^2)
		if cruiseSpeed < (10/180) then return end
		triggerServerEvent ("enableVehicleCruiseSpeed", theVehicle, true)
		addEventHandler ("onClientPreRender", root, cruiseSpeedChecker)
		addEventHandler ("onClientVehicleCollision", theVehicle, cruiseSpeedCollisionChecker)
		addCommandHandler ( "engine", toggleCruiseSpeed, false )

		bindKey ("accelerate", "down", toggleCruiseSpeed)
		bindKey ("brake_reverse", "down", toggleCruiseSpeed)
	else
		triggerServerEvent ("enableVehicleCruiseSpeed",  localPlayer.vehicle, false)
		removeEventHandler ("onClientPreRender", root, cruiseSpeedChecker)
		removeEventHandler ("onClientVehicleCollision", localPlayer.vehicle, cruiseSpeedCollisionChecker)
		removeCommandHandler ( "engine" )

		unbindKey ("accelerate", "down", toggleCruiseSpeed)
		unbindKey ("brake_reverse", "down", toggleCruiseSpeed)
	end

	cruiseSpeedEnabled = not cruiseSpeedEnabled


	local text = 'Круиз-контроль включен'
	if not cruiseSpeedEnabled then
		text = 'Круиз-контроль выключен'
	end
	
	exports.hud_notify:notify('Круиз-контроль', text, 2000)
end

setmetatable(__cruiseSpeedCollisionChecker, {__call = function() toggleCruiseSpeed() end})

local function onClientVehicleEnterHandler ()
	bindKey (cruiseSpeedKey, "down", toggleCruiseSpeed);
	cruiseSpeedEnabled = false

	if canVehicleUseCruiseControl(getPedOccupiedVehicle(localPlayer)) then
		-- exports.hud_notify:notify('Круиз-контроль', 'Левый Shift - включить круиз-контроль', 2000)
	end

end

addEventHandler ("onClientVehicleEnter", root, function (thePlayer, seat)
	if (thePlayer == localPlayer) and (seat == 0) and getElementDimension(localPlayer) == 0 then
		onClientVehicleEnterHandler()
	end
end)

addEventHandler ("onClientResourceStart", resourceRoot, function()
	if isPedInVehicle (localPlayer) then
		local theVehicle = getPedOccupiedVehicle (localPlayer)
		if getVehicleController (theVehicle) == localPlayer then
			onClientVehicleEnterHandler()
		end
	end
end)


addEventHandler ("onClientVehicleExit", root, function (thePlayer, seat)
	if (thePlayer == localPlayer) and (seat == 0) then
		unbindKey(cruiseSpeedKey, "down", toggleCruiseSpeed)
	end
end)

addEventHandler('onClientElementDataChange', root, function(dn, old, new)
	if dn == 'engine.disabled' and source == localPlayer.vehicle and new then
		if cruiseSpeedEnabled then
			toggleCruiseSpeed()
		end
	end
end)