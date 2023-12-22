local sx, sy = guiGetScreenSize()

local fps = false
local curFPS = 0
function getCurrentFPS()
    return fps
end
setTimer(function()
    curFPS = math.floor(getCurrentFPS())
end, 200, 0)

local function updateFPS(msSinceLastFrame)
    fps = (1 / msSinceLastFrame) * 1000
end
addEventHandler("onClientPreRender", root, updateFPS)

addEventHandler('onClientRender', root, function()
    if exports.acl:isAdmin(localPlayer) then
        dxDrawText('FPS: '..curFPS, 10, sy - 30,
            10, sy - 30, tocolor(255,255,255,255), 1, 1.4, 'arial_bold')
    end
end, true, 'low-100')
