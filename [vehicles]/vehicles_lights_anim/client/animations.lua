local targetAnimData = {}
local curAnimData = {}

function setAnimData(key, time)
    targetAnimData[key] = {0, time}
    curAnimData[key] = 0
end

function removeAnimData(key)
    targetAnimData[key] = nil
    curAnimData[key] = nil
end

function animate(key, flag, asResult)
    if not targetAnimData[key] then return end
    local to = 0
    if flag then to = 1 end

    targetAnimData[key][1] = to
    targetAnimData[key][3] = getTickCount()

    if asResult then
        curAnimData[key] = to
    end

end

function getAnimData(key)
    return curAnimData[key], (targetAnimData[key] or {})[1]
end

function updateAnimationValues()
    for k,v in pairs(targetAnimData) do
        if v[1] and v[2] and v[3] then
            local tk = getTickCount()
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
end)