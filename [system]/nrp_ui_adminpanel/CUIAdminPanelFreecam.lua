local speed = 0
local strafespeed = 0
local rotX, rotY = 0,0
local velocityX, velocityY, velocityZ

local options = {
	invertMouseLook = false,
	normalMaxSpeed = 1,
	slowMaxSpeed = 0.15,
	fastMaxSpeed = 12,
	smoothMovement = true,
	acceleration = 0.3,
	decceleration = 0.15,
	mouseSensitivity = 0.2,
	maxYAngle = 188,
	key_fastMove = "lshift",
	key_slowMove = "lalt",
	key_forward = "w",
	key_backward = "s",
	key_left = "a",
	key_right = "d"
}

local mouseFrameDelay = 0

local rootElement = getRootElement()

local getKeyState = getKeyState
do
	local mta_getKeyState = getKeyState
	function getKeyState(key)
		if isMTAWindowActive() then
			return false
		else
			return mta_getKeyState(key)
		end
	end
end

local function getCameraRotation ()
    local px, py, pz, lx, ly, lz = getCameraMatrix()
    local rotz = math.atan2 ((lx - px),(ly - py))
    local rotx = math.atan2 (lz - pz,getDistanceBetweenPoints2D(lx, ly, px, py))
    return rotz,rotx
end

local function freecamFrame ()
    local cameraAngleX,cameraAngleY = rotX,rotY
    local freeModeAngleZ = math.sin(cameraAngleY)
    local freeModeAngleY = math.cos(cameraAngleY) * math.cos(cameraAngleX)
    local freeModeAngleX = math.cos(cameraAngleY) * math.sin(cameraAngleX)
    local camPosX, camPosY, camPosZ = getCameraMatrix()
    local camTargetX = camPosX + freeModeAngleX * 100
    local camTargetY = camPosY + freeModeAngleY * 100
    local mspeed = options.normalMaxSpeed
    if getKeyState ( options.key_fastMove ) then
        mspeed = options.fastMaxSpeed
	elseif getKeyState ( options.key_slowMove ) then
		mspeed = options.slowMaxSpeed
    end
	
	if options.smoothMovement then
		local acceleration = options.acceleration
		local decceleration = options.decceleration
	    local speedKeyPressed = false
	    if getKeyState ( options.key_forward ) then
			speed = speed + acceleration 
	        speedKeyPressed = true
	    end
		if getKeyState ( options.key_backward ) then
			speed = speed - acceleration 
	        speedKeyPressed = true
	    end
	    local strafeSpeedKeyPressed = false
		if getKeyState ( options.key_right ) then
	        if strafespeed > 0 then
	            strafespeed = 0
	        end
	        strafespeed = strafespeed - acceleration / 2
	        strafeSpeedKeyPressed = true
	    end
		if getKeyState ( options.key_left ) then
	        if strafespeed < 0 then
	            strafespeed = 0
	        end
	        strafespeed = strafespeed + acceleration / 2
	        strafeSpeedKeyPressed = true
	    end
	    if speedKeyPressed ~= true then
			if speed > 0 then
				speed = speed - decceleration
			elseif speed < 0 then
				speed = speed + decceleration
			end
	    end
	    if strafeSpeedKeyPressed ~= true then
			if strafespeed > 0 then
				strafespeed = strafespeed - decceleration
			elseif strafespeed < 0 then
				strafespeed = strafespeed + decceleration
			end
	    end
	    if speed > -decceleration and speed < decceleration then
	        speed = 0
	    elseif speed > mspeed then
	        speed = mspeed
	    elseif speed < -mspeed then
	        speed = -mspeed
	    end
	    if strafespeed > -(acceleration / 2) and strafespeed < (acceleration / 2) then
	        strafespeed = 0
	    elseif strafespeed > mspeed then
	        strafespeed = mspeed
	    elseif strafespeed < -mspeed then
	        strafespeed = -mspeed
	    end
	else
		speed = 0
		strafespeed = 0
		if getKeyState ( options.key_forward ) then speed = mspeed end
		if getKeyState ( options.key_backward ) then speed = -mspeed end
		if getKeyState ( options.key_left ) then strafespeed = mspeed end
		if getKeyState ( options.key_right ) then strafespeed = -mspeed end
	end

	if getKeyState("lctrl") and prev_speed == 0 then return end
    local camAngleX = camPosX - camTargetX
    local camAngleY = camPosY - camTargetY
    local camAngleZ = 0
    local angleLength = math.sqrt(camAngleX*camAngleX+camAngleY*camAngleY+camAngleZ*camAngleZ)
    local camNormalizedAngleX = camAngleX / angleLength
    local camNormalizedAngleY = camAngleY / angleLength
    local camNormalizedAngleZ = 0
    local normalAngleX = 0
    local normalAngleY = 0
    local normalAngleZ = 1
    local normalX = (camNormalizedAngleY * normalAngleZ - camNormalizedAngleZ * normalAngleY)
    local normalY = (camNormalizedAngleZ * normalAngleX - camNormalizedAngleX * normalAngleZ)
    local normalZ = (camNormalizedAngleX * normalAngleY - camNormalizedAngleY * normalAngleX)
    camPosX = camPosX + freeModeAngleX * speed
    camPosY = camPosY + freeModeAngleY * speed
    camPosZ = camPosZ + freeModeAngleZ * speed
    camPosX = camPosX + normalX * strafespeed
    camPosY = camPosY + normalY * strafespeed
    camPosZ = camPosZ + normalZ * strafespeed
	velocityX = (freeModeAngleX * speed) + (normalX * strafespeed)
	velocityY = (freeModeAngleY * speed) + (normalY * strafespeed)
	velocityZ = (freeModeAngleZ * speed) + (normalZ * strafespeed)
    camTargetX = camPosX + freeModeAngleX * 100
    camTargetY = camPosY + freeModeAngleY * 100
    camTargetZ = camPosZ + freeModeAngleZ * 100
    setCameraMatrix ( camPosX, camPosY, camPosZ, camTargetX, camTargetY, camTargetZ )
    prev_speed = speed
end

local function freecamMouse (cX,cY,aX,aY)
	if isCursorShowing() or isMTAWindowActive() then
		mouseFrameDelay = 5
		return
	elseif mouseFrameDelay > 0 then
		mouseFrameDelay = mouseFrameDelay - 1
		return
	end
    local width, height = guiGetScreenSize()
    aX = aX - width / 2 
    aY = aY - height / 2
	if options.invertMouseLook then
		aY = -aY
	end
    rotX = rotX + aX * options.mouseSensitivity * 0.01745
    rotY = rotY - aY * options.mouseSensitivity * 0.01745
	local PI = math.pi
	if rotX > PI then
		rotX = rotX - 2 * PI
	elseif rotX < -PI then
		rotX = rotX + 2 * PI
	end
	if rotY > PI then
		rotY = rotY - 2 * PI
	elseif rotY < -PI then
		rotY = rotY + 2 * PI
	end
    if rotY < -PI / 2.05 then
       rotY = -PI / 2.05
    elseif rotY > PI / 2.05 then
        rotY = PI / 2.05
    end
end

function getFreecamVelocity()
	return velocityX,velocityY,velocityZ
end

function setFreecamEnabled (x, y, z)
	if isFreecamEnabled() then return end
	rotX,rotY = getCameraRotation()
	if x and y and z then
	    setCameraMatrix(x,y,z)
	else
		local x, y, z = getCameraMatrix()
		setCameraMatrix(x, y, z)
	end
	addEventHandler("onClientRender", rootElement, freecamFrame)
	addEventHandler("onClientCursorMove",rootElement, freecamMouse)
	freecam_enabled = true	
	return true
end

function setFreecamDisabled()
	if not isFreecamEnabled() then return end
	velocityX,velocityY,velocityZ = 0,0,0
	speed = 0
	strafespeed = 0
	removeEventHandler("onClientRender", rootElement, freecamFrame)
	removeEventHandler("onClientCursorMove",rootElement, freecamMouse)
	freecam_enabled = false
	return true
end

function isFreecamEnabled()
	return freecam_enabled
end

function getFreecamOption(theOption, value)
	return options[theOption]
end

function setFreecamOption(theOption, value)
	if options[theOption] ~= nil then
		options[theOption] = value
		return true
	else
		return false
	end
end

addEvent("doSetFreecamEnabled",true)
addEventHandler("doSetFreecamEnabled", rootElement, setFreecamEnabled)

addEvent("doSetFreecamDisabled",true)
addEventHandler("doSetFreecamDisabled", rootElement, setFreecamDisabled)

addEvent("onSpectateStop",true)
addEventHandler("onSpectateStop", rootElement, setFreecamDisabled)


addEvent("doSetFreecamOption",true)
addEventHandler("doSetFreecamOption", rootElement, setFreecamOption)
