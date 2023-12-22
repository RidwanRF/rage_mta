
local smokeVehicles = {}

local MIN_DRIFT_ANGLE = 5
local MAX_DRIFT_ANGLE = 65

local function detectVehicleDrift(vehicle)

	if localPlayer:getData('tuning.selpainttype') == 5
	and vehicle == localPlayer.vehicle then
		return 5.1
	end

	local occupant = getVehicleOccupant(vehicle)
	if occupant then
		if getPedControlState(occupant, 'accelerate') and getPedControlState(occupant, 'brake_reverse') then
			return 60
		end
	end

	local velocity = vehicle.velocity
	local direction = vehicle.matrix.forward

	if velocity.length < 0.12 then 
		return 0, false
	end
	velocity = velocity:getNormalized()

	local angle = math.abs(math.deg(math.acos(velocity:dot(direction) / (velocity.length * direction.length))))
	if angle > MIN_DRIFT_ANGLE and angle < 110 then
		return angle
	end
	return false
end

local function checkVehicleOnGround(vehicle)
	local ox, oy, oz = getVehicleComponentPosition(vehicle, "wheel_lb_dummy")
	local vehicleMatrix = vehicle.matrix
	local centerPosition1 = vehicleMatrix:transformPosition(0, oy, oz)
	local centerPosition2 = vehicleMatrix:transformPosition(0, oy, oz - 0.5)
	return not isLineOfSightClear(centerPosition1, centerPosition2, true, false, false, true, false)
end

local step = 0
local function update()
	if not localPlayer:getData('settings.smoke') then return end
	step = step + 1
	for vehicle, emitters in pairs(smokeVehicles) do
		-- Left wheel
		-- local vehicleMatrix = vehicle.matrix
		-- local leftPosition = vehicleMatrix:transformPosition(ox, oy, oz)						
		-- setEmitterPosition(emitters.leftEmitter, leftPosition.x, leftPosition.y, leftPosition.z)
		-- Right wheel
		-- local rightPosition = vehicleMatrix:transformPosition(ox, oy, oz)
		-- setEmitterPosition(emitters.rightEmitter, rightPosition.x, rightPosition.y, rightPosition.z)

		if (step % 2) == 0 then
			local ox, oy, oz = getVehicleComponentPosition(vehicle, "wheel_lb_dummy", "world")
			setEmitterPosition(emitters.leftEmitter, ox, oy, oz)
		else
			local ox, oy, oz = getVehicleComponentPosition(vehicle, "wheel_rb_dummy", "world")
			setEmitterPosition(emitters.rightEmitter, ox, oy, oz)
		end

		setEmitterOption(emitters.leftEmitter, "density", 0)
		setEmitterOption(emitters.rightEmitter, "density", 0)

		if vehicle.dimension == localPlayer.dimension and vehicle.onGround and checkVehicleOnGround(vehicle) then
			local driftAngle = detectVehicleDrift(vehicle)
			if driftAngle then
				local smokeMul = (driftAngle - MIN_DRIFT_ANGLE) / MAX_DRIFT_ANGLE
				if smokeMul > 1 then
					smokeMul = 1
				end
				local density = 0
				if smokeMul > 0 then
					density = 1
				end
				setEmitterOption(emitters.leftEmitter, "density", density)
				setEmitterOption(emitters.rightEmitter, "density", density)

				local sizeMul = 0.7 + smokeMul * 0.3
				local startSize = {1 * sizeMul, 2 * sizeMul}
				setEmitterOption(emitters.leftEmitter, "startSize", startSize)
				setEmitterOption(emitters.rightEmitter, "startSize", startSize)

				local endSize = {6 * sizeMul, 8 * sizeMul}
				setEmitterOption(emitters.leftEmitter, "endSize", endSize)
				setEmitterOption(emitters.rightEmitter, "endSize", endSize)

				local delay = 0.025 + (1 - smokeMul) * 0.03
				setEmitterOption(emitters.leftEmitter, "delay", delay)
				setEmitterOption(emitters.rightEmitter, "delay", delay)

				local alpha = smokeMul * 0.8 + 0.2 
				setEmitterOption(emitters.leftEmitter, "alpha", alpha)
				setEmitterOption(emitters.rightEmitter, "alpha", alpha)

				local color = {hexToRGB(vehicle:getData("color_smoke"))}
				if color then
					setEmitterOption(emitters.leftEmitter, "r", color[1])
					setEmitterOption(emitters.rightEmitter, "r", color[1])

					setEmitterOption(emitters.leftEmitter, "g", color[2])
					setEmitterOption(emitters.rightEmitter, "g", color[2])

					setEmitterOption(emitters.leftEmitter, "b", color[3])
					setEmitterOption(emitters.rightEmitter, "b", color[3])										
				end
			end
		end
	end
end

local function addVehicleSmoke(vehicle)
	if not isElement(vehicle) or smokeVehicles[vehicle] then
		return false
	end

	if getVehicleType(vehicle) ~= 'Automobile' then
		return
	end

	local options = {
		x = vehicle.position.x,
		y = vehicle.position.y,
		z = vehicle.position.z,

		density = 1,
		delay = 0.025,
		lifetime = {2, 3},
		fadeInAt = 0.1,

		startSize = 0,
		endSize = 0,

		forceZ = 1.2,
	}
	local leftEmitter = createEmitter(options)
	local rightEmitter = createEmitter(options)
	smokeVehicles[vehicle] = {
		leftEmitter = leftEmitter,
		rightEmitter = rightEmitter
	}
	return true
end

local function removeVehicleSmoke(vehicle)
	if not smokeVehicles[vehicle] then
		return false
	end
	destroyEmitter(smokeVehicles[vehicle].leftEmitter)
	destroyEmitter(smokeVehicles[vehicle].rightEmitter)
	smokeVehicles[vehicle] = nil
	return true
end

addEventHandler("onClientResourceStart", resourceRoot, function ()
	for i, v in ipairs(getElementsByType("vehicle")) do
		if isElementStreamedIn(v) then
			addVehicleSmoke(v)
		end
	end

	addEventHandler("onClientPreRender", root, update)
end)

addEventHandler("onClientElementStreamedIn", root, function ()
	outputChatBox("Streamed in")
	if source.type == "vehicle" then
		addVehicleSmoke(source)
	end
end)

addEventHandler("onClientElementStreamedOut", root, function ()
	if source.type == "vehicle" then
		removeVehicleSmoke(source)
	end
end)

addEventHandler("onClientElementDestroy", root, function ()
	if source.type == "vehicle" then
		removeVehicleSmoke(source)
	end
end)

addEvent("onClientElementDataChange", true)
addEventHandler("onClientElementDataChange", root, function (dataName, old, new)
	local vehicle = source
	if not old and new and dataName == 'id' and source.type == 'vehicle' then

		setTimer(function()
			if isElement(vehicle) and isElementStreamedIn(vehicle) then
				addVehicleSmoke(vehicle)
			end
		end, 1000, 1)
		
	end
end)
