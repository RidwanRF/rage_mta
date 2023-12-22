
local targetAnimData = {}
local curAnimData = {}

function setAnimData(key, time)
    targetAnimData[key] = {0, time}
    curAnimData[key] = 0
end

function animate(key, flag)
    local to = 0
    if flag then to = 1 end
    targetAnimData[key][1] = to
    targetAnimData[key][3] = getTickCount()
end

function getAnimData(key)
    return curAnimData[key], (targetAnimData[key] or {})[1]
end

function updateAnimationValues()
    local tk = getTickCount()
    for k,v in pairs(targetAnimData) do
        if v[1] and v[2] and v[3] then
            if v[1] == 1 then
                curAnimData[k] = (tk - v[3])/v[2]
                if curAnimData[k] > 1 then
                    curAnimData[k] = 1 
                end
            else
                curAnimData[k] = 1 - (tk - v[3])/v[2]
                if curAnimData[k] < 0 then
                    curAnimData[k] = 0 
                end
            end
        end
    end
end

addEventHandler('onClientRender', root, function()
    updateAnimationValues()
    local model, curAnim, targetAnim
    for k,v in pairs(getElementsByType('vehicle', root, true)) do

        model = getElementModel(v)

        if animationsData[model] then

            curAnim, targetAnim = getAnimData(v)

            if curAnim and targetAnim then
                handleMovpart(v, curAnim, model)
            end

        end

    end
end)

local dataNames = {
    ['transformActive']=true,
}

addEventHandler('onClientElementDataChange', root, function(dn)
    if not dataNames[dn] then return end
    local model = getElementModel(source)
    local anim = getAnimData(v)

    if not anim then
        setAnimData(source, transformData[model] or defaultSpeed)
    end

    animate(source, getElementData(source, 'transformActive'))
end)


function isVehicleTransformable(vehicle)

    if not isElement(vehicle) then return end

    local data = animationsData[vehicle.model]
    if data then

        for component in pairs( data.components ) do
            if not getVehicleComponentVisible(vehicle, component) then return false end
        end

        return true, animationsData[vehicle.model].name or 'трансформация'
    end

end