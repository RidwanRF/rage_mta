
--
-- Замена колёс на объекты, развал, толщина и радиус
--
-------------------------------------------------------

-- id моделей колёс
-- local wheelModels = {
-- 5371, 1032, 3924, 5084, 18628, 3801, 18624, 3518, 3945, 3923, 3090, 5083, 18627, 18617, 3915, 18630, 18618, 5089, 3785, 1036, 3916, 18625, 3063, 5374, 5086, 18620, 18621, 18622, 1038, 5370, 18623, 18624, 5369, 18626, 18616, 3074, 4192, 18615, 5088, 3519, 1033, 5087, 3803, 5372, 4637, 3112, 5351, 3914, 18619, 1035, 5366, 4636, 1011, 1012, 1013, 1017, 1026, 1027, 1030, 1031
-- }
local wheelModels = {
1001, 1107, 1015, 1024, 1025, 1049, 1051, 1052, 1053, 1054, 1055, 1056, 1057, 1058, 1059, 1060, 1061, 1062, 1063, 1064, 1065, 1066, 1067, 1068, 1069, 1070, 1071, 1072, 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 1086, 1087, 1088, 1089, 1090, 1091, 1092, 1093, 1094, 1095, 1096, 1097, 1098, 1099, 1100, 1102, 1103, 1104, 1105, 1106, 1150, 1084
}

-- Таблица заменённых колёс
local replacedVehicleWheels = {}

local function isFrontWheel(wheelName)
    return wheelName == "wheel_lf_dummy" or wheelName == "wheel_rf_dummy"
end

local function isLeftWheel(wheelName)
    return wheelName == "wheel_lf_dummy" or wheelName == "wheel_lb_dummy"
end

local function replaceWheel(vehicle, wheelName, id, radius, width, color, offset)
    if not id then
        id = 0
    end
    local vehicleWheels = replacedVehicleWheels[vehicle]
    if id == 0 then
        if vehicleWheels[wheelName] then
            local wheel = vehicleWheels[wheelName]
            if isElement(wheel.object) then
                destroyElement(wheel.object)
            end
            wheel.object = nil
        end
        vehicleWheels[wheelName] = nil
        -- Вылет стоковых колёс
        local x, y, z = getVehicleDefaultWheelPosition(vehicle, wheelName)
        vehicle:setComponentPosition(wheelName, x * (offset + 1), y, z)
    else
        if not wheelModels[id] then
            destroyVehicleWheels(vehicle)
            return
        end
        if not vehicleWheels[wheelName] then
            vehicleWheels[wheelName] = {}
            local x, y, z = getVehicleDefaultWheelPosition(vehicle, wheelName)
            vehicle:setComponentPosition(wheelName, x, y, z)
        end
        local wheel = vehicleWheels[wheelName]
        -- Создание объекта колеса при необходимости
        if not wheel.object then
            wheel.object = createObject(wheelModels[id], vehicle.position)
            -- Если dimension не совпадает, аттач ломается
            wheel.object.dimension = vehicle.dimension
            wheel.object:attach(vehicle)
            wheel.object:setCollisionsEnabled(false)
        else -- ...или просто обновить модель
            wheel.object.model = wheelModels[id]
        end
        wheel.object:setScale(width, radius, radius)
        -- Радиус используется для поднятия колеса по Z
        wheel.radius = radius
        if wheelsConfig.disableWheelsOffset[vehicle.model] then
            wheel.offsetDisabled = true
        end
        local defaultRadius = wheelsConfig.overrideWheelsRadius[vehicle.model] or wheelsConfig.defaultRadius
        local radiusMul = wheel.radius / defaultRadius
        -- Поднятие колеса вверх по Z при изменении радиуса
        wheel.radiusOffsetZ = -defaultRadius / 2 + wheel.radius / 2

        applyWheelColor(vehicle, wheel.object, {unpack(color)})
    end

    vehicle:setComponentVisible(wheelName, id == 0)
end

-- export-фукнция
function getVehicleDefaultWheelsRadius(vehicle)
    if not isElement(vehicle) then
        return false
    end
    return wheelsConfig.overrideWheelsRadius[vehicle.model] or wheelsConfig.defaultRadius
end

function clampValue(dataName, value)
    return math.clamp(
        value, 
        getWheelPropertyLimit(dataName, 'min'),
        getWheelPropertyLimit(dataName, 'max')
    )
end

-- Создание/обновление колёс автомобиля
function createVehicleWheels(vehicle)
    if not isElement(vehicle) then
        return
    end

    if getVehicleType(vehicle) ~= 'Automobile' then return end

    local wheels = vehicle:getData("wheels") or 0
    if not wheels then return end
    if not replacedVehicleWheels[vehicle] then
        replacedVehicleWheels[vehicle] = {}
    end

    -- Модель колёс
    -- Разные оси
    -- local frontWheels = vehicle:getData("wheels_f") or wheels or 0
    -- local rearWheels = vehicle:getData("wheels_r") or wheels or 0
    -- Радиус по умолчанию
    local radius = vehicle:getData("wheels_radius")

    if not radius then
        radius = getVehicleDefaultWheelsRadius(vehicle)
        vehicle:setData("wheels_radius", radius, false)
    end

    local radius_r = vehicle:getData("wheels_radius_r") or radius
    local radius_f = vehicle:getData("wheels_radius_f") or radius

    -- толщина
    local widthFront = vehicle:getData("wheels_width_f")
    if not widthFront then
        widthFront = wheelsConfig.defaultWidth
        vehicle:setData("wheels_width_f", widthFront, false)
    end
    local widthRear = vehicle:getData("wheels_width_r")
    if not widthRear then
        widthRear = wheelsConfig.defaultWidth
        vehicle:setData("wheels_width_r", widthRear, false)
    end
    -- Вылет по умолчанию
    if not vehicle:getData("wheels_offset_f") then
        vehicle:setData("wheels_offset_f", 0, false)
    end
    if not vehicle:getData("wheels_offset_r") then
        vehicle:setData("wheels_offset_r", 0, false)
    end
    local color = {getVehicleWheelsColor(vehicle)}
    -- Вылет колёс
    local offsetFront = vehicle:getData("wheels_offset_f") or 0
    local offsetRear = vehicle:getData("wheels_offset_r") or 0

    -- if radius < clampValue('wheels_radius', radius) then
    --     radius = getVehicleDefaultWheelsRadius(vehicle)
    -- end 
    
    widthFront = clampValue('wheels_width_f', widthFront)
    widthRear = clampValue('wheels_width_r', widthRear)

    -- Замена каждого колеса
    replaceWheel(vehicle, "wheel_rf_dummy", wheels, radius_f, widthFront, color, offsetFront)
    replaceWheel(vehicle, "wheel_lf_dummy", wheels, radius_f, widthFront, color, offsetFront)
    replaceWheel(vehicle, "wheel_lb_dummy", wheels, radius_r, widthRear,  color, offsetRear)
    replaceWheel(vehicle, "wheel_rb_dummy", wheels, radius_r, widthRear,  color, offsetRear)

    -- Костыль для скрытия задних колёс на Yosemite
    if vehicle.model == 554 then
        vehicle:setComponentVisible("extra_", false)
        vehicle:setComponentVisible("extra__", false)
    end
end

function destroyVehicleWheels(vehicle)
    if not vehicle or not replacedVehicleWheels[vehicle] then
        return
    end
    -- Удаление объектов колёс
    for name, wheel in pairs(replacedVehicleWheels[vehicle]) do
        if isElement(wheel.object) then
            destroyElement(wheel.object)
        end
    end
    replacedVehicleWheels[vehicle] = nil

    -- Удалить наложенный цвет
    removeVehicleShaders(vehicle)
end

setTimer(function()
    for vehicle, wheels in pairs(replacedVehicleWheels) do
        for name in pairs(wheels) do
            vehicle:setComponentVisible(name, false)
        end
    end
end, 1000, 0)

addEventHandler("onClientPreRender", root, function ()

    local frame_start = getTickCount()

    local wheels, vehicle
    for _, vehicle in pairs( getElementsByType('vehicle', root, true) ) do

        if isElementOnScreen(vehicle) and getVehicleType(vehicle) == 'Automobile' then

            wheels = replacedVehicleWheels[vehicle]

            local ovx, ovy, ovz = 0, 0, 0
            local ov = (overridedWheelsHide or {})[vehicle.model] or {}

            if wheels then

                if not isElement(vehicle) then
                    destroyVehicleWheels(vehicle)
                else
                    local wheelsHidden = vehicle == localPlayer.vehicle and getCameraViewMode() == 0
                    -- Угол развала
                    local razvalFront = vehicle:getData("wheels_razval_f") or 0
                    local razvalRear = vehicle:getData("wheels_razval_r") or 0
                    -- Вылет колёс
                    local offsetFront = vehicle:getData("wheels_offset_f") or 0
                    local offsetRear = vehicle:getData("wheels_offset_r") or 0

                    local height = clampValue( 'wheels_height', vehicle:getData("wheels_height") or 0 )

                    -- Вращение автомобиля
                    local vx, vy, vz = getElementRotation(vehicle)
                    local wy = math.cos(math.rad(vx))
                    local wz = math.sin(math.rad(vx))

                    for name, wheel in pairs(wheels) do
                        if wheelsHidden then
                            wheel.object.alpha = 0
                        else
                            local x, y, z

                            if ov[name] then
                                ovx, ovy, ovz = unpack(ov[name])
                            end
                            
                            -- if _overridedWheelsHide
                            -- and _overridedWheelsHide[name] then
                            --     x, y, z = unpack(_overridedWheelsHide[name])
                            -- else
                                x, y, z = getVehicleComponentPosition(vehicle, name)
                            -- end

                            local rx, ry, rz = getVehicleComponentRotation(vehicle, name)

                            local razval = razvalFront
                            local offset = offsetFront
                            -- Если колёса задние
                            if not isFrontWheel(name) then
                                razval = razvalRear
                                offset = offsetRear
                            end
                            if isLeftWheel(name) then
                                wheel.object:setRotation(rx, ry-vy+(-razval)*wy, rz+vz+(razval)*wz)
                            else
                                wheel.object:setRotation(rx, ry+vy+(-razval)*wy, rz+vz+(-razval)*wz)
                            end

                            x = x * (offset + 1)
                            if wheel.offsetDisabled then
                                offset = 1
                            end
                            -- Опускание колеса по Z при развале
                            local razvalOffsetZ = -math.sin(math.rad(razval)) * wheel.radius * 0.18
                            z = z + wheel.radiusOffsetZ + razvalOffsetZ + height
                            wheel.object:setAttachedOffsets(x + ovx, y + ovy, z + ovz)

                            wheel.object.dimension = vehicle.dimension
                            wheel.object.alpha = vehicle.alpha
                            wheel.object.interior = vehicle.interior
                        end
                    end
                end

            end

        end
    end

    local frame_finish = getTickCount()
    if isDebugModuleEnabled( 'wheels' ) then
        print( frame_finish, frame_finish - frame_start )
    end
    
end)
