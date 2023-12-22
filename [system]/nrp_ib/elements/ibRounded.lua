local E_CLASS = "ibRounded"

local DEFAULT_VALUES = {
    visible     = true,
    disabled    = false,
    priority    = 0,

    px          = 0,
    py          = 0,
    sx          = 0,
    sy          = 0,
    color       = 0xFFFFFFFF,
    rotation    = 0,
    rotation_offset_x = 0,
    rotation_offset_y = 0,

    alpha           = 255,
    radius      = 5,
}

function ibRounded( self, resource )
    if type( self ) ~= "table" then
        outputDebugString( "Bad argument @ibRounded[1], expect table got ".. type( self ), 1 )
        return
    end
    local sourceResource = sourceResource or resource or _THIS_RESOURCE
    local element = ibCreateNewElementOfClass( self, E_CLASS, sourceResource )
    ibSetDefaultValues( self, DEFAULT_VALUES )

    triggerEvent( "ibOnElementCreate", element, self, E_CLASS, sourceResource )
    return element
end


local dxDrawImage          = dxDrawImage
local dxDrawRectangle      = dxDrawRectangle
local dxDrawImageSection   = dxDrawImageSection
local isElement            = isElement
local ConvertToForeignFile = ConvertToForeignFile
local ColorMulAlpha        = ColorMulAlpha
local math_floor           = math.floor
local dxDrawCircle         = dxDrawCircle

local function dxDrawRoundedRectangle (x, y, rx, ry, color, radius)
    local rx = rx - radius * 2
    local ry = ry - radius * 2
    local x = x + radius
    local y = y + radius

    if (rx >= 0) and (ry >= 0) then
        dxDrawRectangle(x, y, rx, ry, color)
        dxDrawRectangle(x, y - radius - 1, rx, radius+1, color)
        dxDrawRectangle(x, y + ry, rx, radius, color)
        dxDrawRectangle(x - radius, y - 1, radius, ry+1, color)
        dxDrawRectangle(x + rx, y-1, radius, ry+1, color)

        dxDrawCircle(x, y-1, radius, 180, 270, color, color, 64)
        dxDrawCircle(x + rx, y - 1, radius, 270, 360, color, color, 64)
        dxDrawCircle(x + rx, y + ry, radius, 0, 90, color, color, 64)
        dxDrawCircle(x, y + ry, radius, 90, 180, color, color, 64)
    end
end

local dxDrawRoundedRectangle = dxDrawRoundedRectangle

_RENDER_FUNCTIONS[ E_CLASS ] = function( element, data, parent_px, parent_py, mouse_px, mouse_py, alpha )
    local px, py    = parent_px + data.px, parent_py + data.py
    local alpha     = alpha * data.alpha
    local sx, sy    = data.sx, data.sy
    if alpha > 0 then
        dxDrawRoundedRectangle(
            px, py, sx, sy, 
            ColorMulAlpha( data.color, alpha ),
            data.radius
        )
    end

    return px, py, sx, sy, mouse_px + data.px, mouse_py + data.py, alpha
end