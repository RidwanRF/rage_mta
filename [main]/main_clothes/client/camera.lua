local MOUSE_LOOK_SPEED = 80
local MOUSE_LOOK_VERTICAL_MAX = 30
local MOUSE_LOOK_VERTICAL_MIN = 0

local MOUSE_LOOK_DISTANCE_DELTA = 0.25
local MOUSE_LOOK_DISTANCE_MIN = 3.7
local MOUSE_LOOK_DISTANCE_MAX = 3.75

local screenSize = Vector2(guiGetScreenSize())

local isActive = false
local mouseLookActive = false
local mouseWheelLookActive = false
local mouseScrollEnabled = true
local oldCursorPosition
local skipMouseMoveEvent = false

-- Состояние камеры
camera = {
    FOV = 30,
    centerOffset = 0.49998784065247,
    distance = 3.7,
    roll = 0,
    rotationHorizontal = -72.791554927826,
    rotationVertical = 1.4814352989197,
    targetPosition = Vector3(0,0,0),
    yOffset = 0,
}

setAnimData('tuning.camera.x', 0.15)
setAnimData('tuning.camera.y', 0.15)
setAnimData('tuning.camera.zoom', 0.05)
setAnimData('tuning.camera.fov', 0.05)
setAnimData('tuning.camera.centerOffset', 0.15, camera.centerOffset)
setAnimData('tuning.camera.yOffset', 0.15, camera.yOffset)

local function update(deltaTime)
    deltaTime = deltaTime / 1000

    -- setClipboard( inspect(camera) )

    -- Прикрепить камеру к автомобилю
    if isElement(currentPed) then
        camera.targetPosition = currentPed.position + Vector3(0, 0, 0.5)
    else
        camera.targetPosition = Vector3(0,0,0)
    end

    animate('tuning.camera.x', math.rad(camera.rotationVertical))
    animate('tuning.camera.y', math.rad(camera.rotationHorizontal))
    animate('tuning.camera.zoom', camera.distance)
    animate('tuning.camera.fov', camera.FOV)
    animate('tuning.camera.centerOffset', camera.centerOffset)
    animate('tuning.camera.yOffset', camera.yOffset)

    local pitch = getAnimData('tuning.camera.x')
    local yaw = getAnimData('tuning.camera.y')
    local zoom = getAnimData('tuning.camera.zoom')
    local fov = getAnimData('tuning.camera.fov')

    local centerOffset = getAnimData('tuning.camera.centerOffset')
    local yOffset = getAnimData('tuning.camera.yOffset')

    local cameraOffset = Vector3(math.cos(yaw) * math.cos(pitch), math.sin(yaw) * math.cos(pitch), math.sin(pitch))
    local rotationOffset = Vector3(math.cos(yaw - 90), math.sin(yaw - 90), 0) * centerOffset

    local s_vector = camera.targetPosition + cameraOffset * zoom
    local e_vector = camera.targetPosition + rotationOffset + Vector3( 0, 0, yOffset )

    -- local hit, hx,hy,hz = processLineOfSight(
    --     s_vector.x, s_vector.y, s_vector.z, 
    --     e_vector.x, e_vector.y, e_vector.z, 
    --     true, true, true, true, true, 
    --     false, false, false, 
    --     localPlayer.vehicle
    -- )

    -- if hit then
    --     s_vector = Vector3( hx,hy,hz )
    -- end

    setCameraMatrix(
        s_vector,
        e_vector,
        camera.roll,
        fov
    )

end

local function mouseMove(x, y)
    if not (mouseLookActive or mouseWheelLookActive) or isMTAWindowActive() then
        return
    end
    -- Пропустить первый эвент, чтобы избежать резкого дёргания камеры
    if skipMouseMoveEvent then
        skipMouseMoveEvent = false
        return
    end
    local mx = x - 0.5
    local my = y - 0.5

    if mouseLookActive then
        camera.rotationHorizontal = camera.rotationHorizontal - mx * MOUSE_LOOK_SPEED
        camera.rotationVertical = camera.rotationVertical + my * MOUSE_LOOK_SPEED

        if camera.rotationVertical > MOUSE_LOOK_VERTICAL_MAX then
            camera.rotationVertical = MOUSE_LOOK_VERTICAL_MAX
        elseif camera.rotationVertical < MOUSE_LOOK_VERTICAL_MIN then
            camera.rotationVertical = MOUSE_LOOK_VERTICAL_MIN
        end
    elseif mouseWheelLookActive then

        camera.yOffset = math.clamp(camera.yOffset + my * MOUSE_LOOK_SPEED * 0.5,
            -0.5, 0.2
        )
    end

end

local function handleKey(key, down)
    -- if down and mouseScrollEnabled and not hasHoveredElement then
    --     if key == "mouse_wheel_down" then
    --         camera.distance = camera.distance + MOUSE_LOOK_DISTANCE_DELTA
    --         if camera.distance > MOUSE_LOOK_DISTANCE_MAX then
    --             camera.distance = MOUSE_LOOK_DISTANCE_MAX
    --         end
    --     elseif key == "mouse_wheel_up" then
    --         camera.distance = camera.distance - MOUSE_LOOK_DISTANCE_DELTA
    --         if camera.distance < MOUSE_LOOK_DISTANCE_MIN then
    --             camera.distance = MOUSE_LOOK_DISTANCE_MIN
    --         end
    --     end
    --     local mul = (camera.distance - MOUSE_LOOK_DISTANCE_MIN) / (MOUSE_LOOK_DISTANCE_MAX - MOUSE_LOOK_DISTANCE_MIN)
    --     camera.FOV = 30 + mul * 40
    -- end

    if currentWindowSection ~= 'main' then return end

    if key == "mouse2" then
        -- Включить/выключить свободный обзор
        if down then
            -- Сохранить положение курсора
            oldCursorPosition = Vector2(getCursorPosition())
            -- Переместить курсор в центр, чтобы избежать дёргания камеры
            setCursorPosition(screenSize.x / 2, screenSize.y / 2)
            showCursor(false)
            mouseLookActive = true
            skipMouseMoveEvent = true
        else
            mouseLookActive = false
            showCursor(true)
            -- Восстановить положение курсора
            setCursorPosition(oldCursorPosition.x * screenSize.x, oldCursorPosition.y * screenSize.y)
        end
    end

    if key == "mouse3" then
        -- Включить/выключить свободный обзор
        if down then
            -- Сохранить положение курсора
            oldCursorPosition = Vector2(getCursorPosition())
            -- Переместить курсор в центр, чтобы избежать дёргания камеры
            setCursorPosition(screenSize.x / 2, screenSize.y / 2)
            showCursor(false)
            mouseWheelLookActive = true
            skipMouseMoveEvent = true
        else
            mouseWheelLookActive = false
            showCursor(true)
            -- Восстановить положение курсора
            setCursorPosition(oldCursorPosition.x * screenSize.x, oldCursorPosition.y * screenSize.y)
        end
    end
end

local function disableScroll()
    mouseScrollEnabled = false
end

local function enableScroll()
    mouseScrollEnabled = true
end

function startCamera(position)
    if isActive then
        return
    end
    showCursor(true)

    isActive = true
    mouseScrollEnabled = true
    addEventHandler("onClientPreRender", root, update)
    addEventHandler("onClientCursorMove", root, mouseMove)
    addEventHandler("onClientKey", root, handleKey)
    addEventHandler("onClientMouseEnter", root, disableScroll)
    addEventHandler("onClientMouseLeave", root, enableScroll)
    localPlayer:setData('tuning.camera', true, false)

    -- setAnimData('tuning.camera.x', 0.15, 0)
    -- setAnimData('tuning.camera.y', 0.15, 0)
    -- setAnimData('tuning.camera.zoom', 0.15, 0)
    -- setAnimData('tuning.camera.centerOffset', 0.15, camera.centerOffset)
    
end

function stopCamera()
    if not isActive then
        return
    end
    showCursor(false)

    isActive = false
    removeEventHandler("onClientPreRender", root, update)
    removeEventHandler("onClientCursorMove", root, mouseMove)
    removeEventHandler("onClientKey", root, handleKey)
    removeEventHandler("onClientMouseEnter", root, disableScroll)
    removeEventHandler("onClientMouseLeave", root, enableScroll)
    setCameraTarget(localPlayer)
    localPlayer:setData('tuning.camera', false, false)
end

