_SCREEN_X,      _SCREEN_Y      = guiGetScreenSize( )
_SCREEN_X_HALF, _SCREEN_Y_HALF = _SCREEN_X / 2, _SCREEN_Y / 2

local _SCREEN_X,      _SCREEN_Y      = _SCREEN_X,      _SCREEN_Y
local _SCREEN_X_HALF, _SCREEN_Y_HALF = _SCREEN_X_HALF, _SCREEN_Y_HALF

local _IB_RESOURCE_NAME   = "nrp_ib"

local pairs               = pairs
local string_sub          = string.sub
local math_floor          = math.floor
local getElementParent    = getElementParent
local addEventHandler     = addEventHandler
local call                = call
local unpack              = unpack
local getResourceFromName = getResourceFromName
local triggerEvent        = triggerEvent
local dxGetTextWidth      = dxGetTextWidth
local getElementType      = getElementType
local destroyElement      = destroyElement
local getElementChildren  = getElementChildren
local getElementByID      = getElementByID
local bitReplace          = bitReplace
local bitExtract          = bitExtract
local getRealTime         = getRealTime

COLOR_WHITE = 0xFFFFFFFF
COLOR_BLACK = 0xFF000000

local function adapt( value, round )
    return round and ( value * ( _SCREEN_X / 1920 ) * 1 ) or math.floor( value * ( _SCREEN_X / 1920 ) * 1 )
end

-- Поиск ресурса ib в случае рестарта или потери
local _IB_RESOURCE
do
    function ibLookForActiveResource( )
        local resource = getResourceFromName( _IB_RESOURCE_NAME )
        if resource and getResourceState( resource ) == "running" then
            ibRecreateResourceCache( resource )
        else
            setTimer( ibLookForActiveResource, 250, 1 )
        end
    end

    function ibRecreateResourceCache( resource )
        _IB_RESOURCE = resource or getResourceFromName( _IB_RESOURCE_NAME )
        addEventHandler( "onClientElementDestroy", getResourceRootElement( _IB_RESOURCE ), ibLookForActiveResource, false )
    end

    ibRecreateResourceCache( )
end

-- Функции, работабщие через экспорт
local _EXPORTED_FUNCS = {
    "ibButton",
    "ibLabel",
    "ibImage",
    "ibEdit",
    "ibScrollbarV",
    "ibScrollbarH",
    "ibRenderTarget",
    "ibArea",
    "ibBrowser",
    "ibLine",
    "ibWebEdit",
    "ibWebMemo",

    "ibCreatePreloader",

    "ibMove",
    "ibResize",
    "ibRotate",
    "ibAlpha",
    "ibScroll",
    "ibColor",

    "ibGetData",
    "ibGetHoveredElement",
    "ibGetStyle",
    "ibGetAllData",

    "ibRounded",
}

for i, v in pairs( _EXPORTED_FUNCS ) do
    _G[ v ] = function( ... )
        return call( _IB_RESOURCE, v, ... )
    end
end

-- Функции, работающие через ивенты
local _EXPORTED_FUNCS_VIA_EVENTS = {
    "ibSetData",
    "ibSetBatchData",
}

for i, v in pairs( _EXPORTED_FUNCS_VIA_EVENTS ) do
    _G[ v ] = function( ... )
        triggerEvent( v, localPlayer, ... )
    end
end

-- Динамические шрифты
if not ibFonts then
    local _FONTS_DEFAULT = { } -- Таблица классических шрифтов
    local _FONTS_REAL = { } -- Таблица фотошопных шрифтов
    local _IB_FONTS_REAL
    local _IB_FONTS_ADAPT
    local _FONTS_TYPES = { 
        regular = "OpenSans/OpenSans-Regular.ttf",
        bold = "OpenSans/OpenSans-Bold.ttf",
        extrabold = "OpenSans/OpenSans-ExtraBold.ttf",
        light = "OpenSans/OpenSans-Light.ttf",
        semibold = "OpenSans/OpenSans-SemiBold.ttf",
        italic = "OpenSans/OpenSans-Italic.ttf",
        bolditalic = "OpenSans/OpenSans-BoldItalic.ttf",
        oxaniumbold = "Oxanium/Oxanium-Bold.ttf",
        oxaniumextrabold = "Oxanium/Oxanium-ExtraBold.ttf",
        oxaniumregular = "Oxanium/Oxanium-Regular.ttf",
    }
    ibFonts = { }

    function GetFontNameFromPointer( pointer )
        for i, v in pairs( _FONTS_REAL ) do if v == pointer then return i end end
        for i, v in pairs( _FONTS_DEFAULT ) do if v == pointer then return i end end
        for i, v in pairs( _FONTS_ADAPT ) do if v == pointer then return i end end
    end

    function ibUseRealFonts( state )
        _IB_FONTS_REAL = state
    end

    function ibUseAdaptFonts ( state )
        _IB_FONTS_ADAPT = state
    end

    function ibIsUsingAdaptFonts( )
        return _IB_FONTS_ADAPT
    end

    function ibIsUsingRealFonts( )
        return _IB_FONTS_REAL
    end

    function ibClearFontsCache_handler( )
        _FONTS_REAL = { }
        _FONTS_DEFAULT = { }
    end
    addEventHandler( "ibClearFontsCache", root, ibClearFontsCache_handler )

    setmetatable( 
        ibFonts,
        {
            __newindex = function( _, k, v )
                local input_table = _IB_FONTS_REAL and _FONTS_REAL or _IB_FONTS_ADAPT and _FONTS_ADAPT or  _FONTS_DEFAULT
                input_table[ k ] = v
            end,
            __index = function( _, k )
                local input_table = _IB_FONTS_REAL and _FONTS_REAL or _IB_FONTS_ADAPT and _FONTS_ADAPT or _FONTS_DEFAULT

                local font = input_table[ k ]
                if font then
                    return font

                else
                    local font_type, font_size = string.match( k, "(%a+)_(%d+)" )
                    local font_size = tonumber( font_size )

                    if _IB_FONTS_REAL then font_size = math_floor( font_size / 1.25 + 0.5 ) end
                    if _IB_FONTS_ADAPT then font_size = adapt ( font_size, true ) end

                    local font = exports.nrp_fonts:DXFont( _FONTS_TYPES[ font_type ], font_size, false, "antialiased" )
                    if font then
                        input_table[ k ] = font
                        return font
                    
                    else
                        outputDebugString( "Error reading font: " .. tostring( k ), 1 )

                    end
                end
            end
        }
    )
end

--------------------------
--- Базовый функционал ---
--------------------------
Element.isib = function( self )
    return string_sub( getElementType( self ), 1, 2 ) == "ib"
end

Element.isibRoot = function( self )
    return getElementID( self ) == "ibRoot"
end

Element.ibConnectScrollbarH = function( self, scrollbar )
    return ibSetData( self, "connectedScrollbarH", scrollbar or false )
end

Element.ibConnectScrollbarV = function( self, scrollbar )
    return ibSetData( self, "connectedScrollbarV", scrollbar or false )
end

Element.AdaptHeightToContents = function( self )
    triggerEvent( "ibRenderTargetAdaptHeightToContents", self )
    return self
end

Element.UpdateScrollbarVisibility = function( self, rt )
	return self:ibData( "visible", rt:ibData( "sy" ) > rt:ibData( "viewport_sy" ) )
end

Element.ibData = function( self, key, value )
    if value == nil then
        return call( _IB_RESOURCE, "ibGetData", self, key )
    else
        triggerEvent( "_FAST_ibSetData", self, key, value )
        return self
    end
end

Element.ibDeepSet = function( self, key, value )
    triggerEvent( "_FAST_ibSetData", self, key, value )
    if getElementChildrenCount( self ) > 0 then
        for i, v in pairs( getElementChildren( self ) ) do
            v:ibDeepSet( key, value )
        end
    end
    return self
end

Element.ibBatchData = function( self, list )
    triggerEvent( "_FAST_ibSetBatchData", self, list )
    return self
end

Element.ibDeepBatchSet = function( self, list )
    triggerEvent( "_FAST_ibSetBatchData", self, list )
    if getElementChildrenCount( self ) > 0 then
        for i, v in pairs( getElementChildren( self ) ) do
            v:ibDeepSet( key, value )
        end
    end
    return self
end

Element.center = function( self, ox, oy )
    local parent = getElementParent( self )
    local px, py = _SCREEN_X, _SCREEN_Y
    local sx, sy = ibGetData( self, "viewport_sx" ) or ibGetData( self, "sx" ), ibGetData( self, "viewport_sy" ) or ibGetData( self, "sy" )
    if parent and not parent:isibRoot() then
        px, py = ibGetData( parent, "sx" ), ibGetData( parent, "sy" )
    end
    ibSetBatchData( self, { px = math_floor( px / 2 - sx / 2 + ( ox or 0 ) ), py = math_floor( py / 2 - sy / 2 + ( oy or 0 ) ) } )
    return self
end

Element.center_x = function( self, ox )
    local parent = getElementParent( self )
    local px = _SCREEN_X
    local sx = ibGetData( self, "viewport_sx" ) or ibGetData( self, "sx" )
    if parent and not parent:isibRoot() then px = ibGetData( parent, "sx" ) end
    ibSetData( self, "px", math_floor( px / 2 - sx / 2 + ( ox or 0 ) ) )
    return self
end

Element.center_y = function( self, oy )
    local parent = getElementParent( self )
    local py = _SCREEN_Y
    local sy = ibGetData( self, "viewport_sy" ) or ibGetData( self, "sy" )
    if parent and not parent:isibRoot() then py = ibGetData( parent, "sy" ) end
    ibSetData( self, "py", math_floor( py / 2 - sy / 2 + ( oy or 0 ) ) )
    return self
end

Element.width = function( self )
    --if not self:isib() then return end
    if getElementType( self ) == "ibLabel" then
        local text = ibGetData( self, "text" )
        local font = ibGetData( self, "font" )
        local scale = ibGetData( self, "scale_x" )
        local colored = ibGetData( self, "colored" )
        if colored then text = utf8.gsub( text, "#%x%x%x%x%x%x", "" ) end
        return dxGetTextWidth( text, scale, font )
    else
        return ibGetData( self, "viewport_sx" ) or ibGetData( self, "sx" )
    end
end

Element.height = function( self )
    if getElementType( self ) == "ibLabel" then
        local font = ibGetData( self, "font" )
        local scale = ibGetData( self, "scale_y" )
        return dxGetFontHeight( scale, font )
    else
        return ibGetData( self, "viewport_sy" ) or ibGetData( self, "sy" )
    end
end

Element.ibGetAfterX = function( self, additional_offset )
    if getElementType( self ) == "ibLabel" then
        local width = self:width( )
        local align_x = ibGetData( self, "align_x" )
        if align_x == "center" then
            width = width / 2
        elseif align_x == "right" then
            width = 0
        end
        return ibGetData( self, "px" ) + width + ( additional_offset or 0 )
    else
        return ibGetData( self, "px" ) + self:width( ) + ( additional_offset or 0 )
    end
end
Element.ibGetBeforeX = function( self, additional_offset )
    return self:ibGetAfterX( additional_offset ) - self:width( )
end

Element.ibGetCenterX = function( self, additional_offset )
    if getElementType( self ) == "ibLabel" then
        local width = self:width( )
        local align_x = ibGetData( self, "align_x" )
        if align_x == "left" then
            width = width / 2
        elseif align_x == "center" then
            width = 0
        elseif align_x == "right" then
            width = -width / 2
        end
        return ibGetData( self, "px" ) + width + ( additional_offset or 0 )
    else
        return ibGetData( self, "px" ) + self:width( ) / 2 + ( additional_offset or 0 )
    end
end


Element.ibGetAfterY = function( self, additional_offset )
    if getElementType( self ) == "ibLabel" then
        local height = self:height( )
        local align_y = ibGetData( self, "align_y" )
        if align_y == "center" then
            height = height / 2
        elseif align_y == "bottom" then
            height = 0
        end
        return ibGetData( self, "py" ) + height + ( additional_offset or 0 )
    else
        return ibGetData( self, "py" ) + self:height( ) + ( additional_offset or 0 )
    end
end

Element.ibGetBeforeY = function( self, additional_offset )
    return self:ibGetAfterY( additional_offset ) - self:height( )
end

Element.ibGetCenterY = function( self, additional_offset )
    if getElementType( self ) == "ibLabel" then
        local height = self:height( )
        local align_y = ibGetData( self, "align_y" )
        if align_y == "top" then
            height = height / 2
        elseif align_y == "center" then
            height = 0
        elseif align_y == "bottom" then
            height = -height / 2
        end
        return ibGetData( self, "py" ) + height + ( additional_offset or 0 )
    else
        return ibGetData( self, "py" ) + self:height( ) / 2 + ( additional_offset or 0 )
    end
end

Element.Navigate = function( self, url, post, encoded )
    local browser = ibGetData( self, "browser" )
    if browser then
        loadBrowserURL( browser, url, post, encoded )
    end
    return self
end

Element.JS = function( self, js )
    local browser = ibGetData( self, "browser" )
    if browser then
        executeBrowserJavascript( browser, js )
    end
    return self
end

Element.ibBrowserCSS = function( self, css )
    triggerEvent( "ibBrowserInjectCSS", self, css )
end

Element.ibBrowserHTML = function( self, id, html )
    triggerEvent( "ibBrowserSetElementHTML", self, id, html )
end

Element.ibBrowserParameter = function( self, id, parameter, value )
    triggerEvent( "ibBrowserSetElementParameter", self, id, parameter, value )
end

Element.ibBrowserValue = function( self, id, value )
    triggerEvent( "ibBrowserSetElementValue", self, id, value )
end

Element.Back = function( self )
    local browser = ibGetData( self, "browser" )
    if browser then
        navigateBrowserBack( browser )
    end
    return self
end

Element.Forward = function( self )
    local browser = ibGetData( self, "browser" )
    if browser then
        navigateBrowserForward( browser )
    end
    return self
end

Element.ibSimulateClick = function( self, key, state )
    triggerEvent( "ibSimulateClick", self, key, state )
    return self
end

Element.ibGetTextureSize = function( self, key )
    local texture_path = ibGetData( self, key or "texture" )
    local texture = exports.nrp_ib:ConvertToForeignFile( self, texture_path )
    if texture then
        return dxGetMaterialSize( texture )
    end
end

Element.ibSetRealSize = function( self, key, max_sx, max_sy )
    local texture_path = ibGetData( self, key or "texture" )
    local texture = exports.nrp_ib:ConvertToForeignFile( self, texture_path )
    if texture then
        local sx, sy = dxGetMaterialSize( texture )
        ibSetBatchData( self, { sx = sx, sy = sy } )
    end
    return self
end

Element.ibSetInBoundSize = function( self, max_sx, max_sy )
    local sx, sy = ibGetData( self, "sx" ), ibGetData( self, "sy" )

    local max_sx = max_sx or sx
    local max_sy = max_sy or sy

    if sx ~= 0 and sy ~= 0 then
        local scale = math.min( max_sx / sx, max_sy / sy )
        if scale >= 1 then return self end
        sx, sy = sx * scale, sy * scale
    end

    ibSetBatchData( self, { sx = sx, sy = sy } )
    return self
end

Element.ibAttachToCursor = function( self, ox, oy )
    local function update_position( )
        local cur_x, cur_y = getCursorPosition( )
        self:ibBatchData( { px = cur_x * _SCREEN_X + ox, py = cur_y * _SCREEN_Y + oy } )
    end
    update_position( )
    return self:ibOnRender( update_position )
end

Element.ibAttachTooltip = function( self, text, priority, align_x, align_y )
    local tooltip

    local function updateTooltip( _, _, pos_x, pos_y )
        if isElement( tooltip ) then
            local box_s_x = tooltip:ibData( "sx" )
            if pos_x + box_s_x > _SCREEN_X then
                pos_x = _SCREEN_X - box_s_x
            end

            tooltip:ibBatchData( { px = pos_x - 5, py = pos_y - tooltip:ibData( "sy" ) - 5 } )
        end
    end

    local function destroyTooltip( )
        removeEventHandler( "onClientCursorMove", root, updateTooltip )
        if isElement( tooltip ) then destroyElement( tooltip ) end
        tooltip = nil
    end
    
    self
        :ibOnHover( function( )
            local fonts_real = ibIsUsingRealFonts( )
            ibUseRealFonts( false )

            local x, y = guiGetScreenSize( )
            if isElement( TOOLTIP ) then destroyElement( TOOLTIP ) end

            local __, line_break_count = string.gsub( text, "\n", "" )
            local title_len = dxGetTextWidth( text, 1, ibFonts.bold_10 ) + 15
            local box_s_x = title_len
            local box_s_y = 35 + line_break_count * 17

            local pos_x, pos_y = getCursorPosition( )
            pos_x, pos_y = pos_x * x, pos_y * y

            tooltip = ibCreateImage( pos_x - 5, pos_y - box_s_y - 5, box_s_x, box_s_y, nil, nil, 0xCC000000 ):ibData( "alpha", 0 )
            if priority then tooltip:ibData( "priority", priority ) end

            ibCreateLabel( align_x == "left" and 10 or 0, box_s_y / 2, box_s_x, 0, text, tooltip ):ibBatchData( { font = ibFonts.bold_10, align_x = align_x or "center", align_y = align_y or "center" })
            
            tooltip:ibAlphaTo( 255, 350 ):ibDeepSet( "disabled", true )
            addEventHandler( "onClientCursorMove", root, updateTooltip )

            ibUseRealFonts( fonts_real )
        end )
        :ibOnLeave( destroyTooltip )
        :ibOnDestroy( destroyTooltip )

    return self, tooltip
end

--------------------------
----- Общие элементы -----
--------------------------
ibCreateButton = function( x, y, width, height, parent, defimg, selimg, cliimg, defcolor, selcolor, clicolor, iCallbackFunction )
	if not selimg then
		-- (если не указана картинка при наведении)
		-- Использовать одну картинку для всех состояний
		selimg = defimg
		cliimg = defimg

	elseif selimg == true then
		-- (если картинка при наведении не указана, но установлено "true")
		-- Использовать приставку и автоматически добавить окончание по всем состояниям картинки у кнопки
		cliimg = defimg .."_c.png"
		selimg = defimg .."_h.png"
		defimg = defimg .."_i.png"
	end

    local btn = ibButton(
        {
            px = x, py = y, sx = width, sy = height,
            parent = parent,
            texture = defimg, texture_hover = selimg, texture_click = cliimg,
            color = defcolor or 0xFFFFFFFF, color_hover = selcolor or 0xFFFFFFFF, color_click = clicolor or 0xFFFFFFFF,
        }
    )

    local iCallbackFunction = iCallbackFunction or false
    if iCallbackFunction then
        btn:ibOnClick( function( key, state ) 
            if key == 'left' and state == 'up' then
                iCallbackFunction( )
            end
        end)
    end

    return btn
end

ibCreateImage = function( x, y, width, height, texture, parent, color, texture_surface )
    return ibImage(
        {
            px = x, py = y, sx = width, sy = height,
            parent = parent,
            texture = texture, color = color,
            texture_surface = texture_surface,
        }
    )
end

ibCreateRounded = function( x, y, width, height, parent, color, radius )
    return ibRounded( {
        px = x, py = y, sx = width, sy = height,
        color = color,
        radius = radius,
        parent = parent
    } )
end

ibCreateArea = function( x, y, width, height, parent )
    return ibArea(
        {
            px = x, py = y, sx = width, sy = height,
            parent = parent,
        }
    )
end

ibCreateDummy = function( parent )
    return ibArea(
        {
            px = 0, py = 0, sx = 0, sy = 0,
            parent = parent,
        }
    )
end

ibCreateBrowser = function( x, y, width, height, parent, is_local, is_transparent )
    return ibBrowser(
        {
            px = x, py = y, sx = width, sy = height,
            parent = parent,
            is_local = is_local, is_transparent = is_transparent,
        }
    )
end

ibCreateLabel = function( x, y, width, height, text, parent, color, scale_x, scale_y, align_x, align_y, font )
    return ibLabel(
        {
            px = x, py = y, sx = width, sy = height,
            parent = parent,
            text = text, color = color,
            scale_x = scale_x, scale_y = scale_y,
            align_x = align_x, align_y = align_y,
            font = font,
        }
    )
end

ibCreateLine = function( px, py, target_px, target_py, color, width, parent )
    local target_px = target_px or px
    local target_py = target_py or py
    return ibLine(
        {
            px = px, py = py,
            target_px = target_px, target_py = target_py,
            parent = parent,
            color = color,
            width = width,
        }
    )
end

ibCreateWindow = function( blur_level, windowed )
    local main_bg = ibCreateImage( 0, 0, _SCREEN_X, _SCREEN_Y ):ibBatchData( { blur = true, blur_level = blur_level } )

    if windowed then
        ibCreateImage( 0, 0, _SCREEN_X, _SCREEN_Y, nil, main_bg, tocolor( 0, 0, 0, 220 ) )
    end


    return main_bg
end

ibCreateBackground = function( color, destroy_fn, ignore_removal, escape_close, ignore_first_person )
    if not ignore_removal then
        for i, v in pairs( getElementChildren( getElementByID( "ibRoot" ) ) ) do
            if v:ibData( "is_background" ) then
                destroyElement( v )
            end
        end
    end

    local element = ibCreateImage( 0, 0, _SCREEN_X, _SCREEN_Y, nil, nil, color or 0x50000000 )

    element:ibData( "is_background", not ignore_removal and destroy_fn )
    element:ibData( "is_background_real", true )
    
    if destroy_fn then
        element:ibData( "can_destroy", true )

        local function onDestroyElement()
            localPlayer:setData( "open_back", (math.max( 0, localPlayer:getData( "open_back" ) or 0) - 1), false )
            
            triggerEvent( "onClientChangeInterfaceState", root, false, { other_menu = true } )
            local data = element:ibData( "can_destroy" )
            if isElement( element ) and (data or not escape_close) then
                if data then element:ibData( "can_destroy", false ) end
                destroy_fn()
            end
        end
        addEventHandler( "onClientElementDestroy", element, onDestroyElement, false )
        
        if escape_close then
            ibAddKeyAction( _, _, element, function()
                if isElement( element ) and element:ibData( "can_destroy" ) then
                    element:ibData( "can_destroy", false )
                    destroy_fn()
                end
            end )
        end
    else
        local function onDestroyElement()
            localPlayer:setData( "open_back", (math.max( 0, localPlayer:getData( "open_back" ) or 0) - 1), false )
        end
        addEventHandler( "onClientElementDestroy", element, onDestroyElement, false )
    end
    
    if localPlayer:getData( "bFirstPerson" ) and not ignore_first_person then
        setCursorAlpha( 255 )
        triggerEvent( "onClientChangeInterfaceState", root, true, { other_menu = true } )
    end
    
    localPlayer:setData( "open_back", (localPlayer:getData( "open_back" ) or 0) + 1, false )

    -- Новогодняя рамка окон c 24.12 до 21.01
    local timestamp = getRealTimestamp( )
    if timestamp > 1608757200 and timestamp < 1611176400 then
        local sizes = {
            [ 1024 ] = { px = -49, py = -36, sy = 768, },
            [ 800  ] = { px = -53, py = -38, sy = 600, },
            [ 600  ] = { px = -53, py = -67, sy = 400, },
            [ 520  ] = { px = -47, py = -51, sy = 238, },
        }

        _ibCreateImage = _ibCreateImage or ibCreateImage
        ibCreateImage = function( ... )
            local bg = _ibCreateImage( ... )

            -- Таймер на случай, если размеры устанавливаются через ibSetRealSize
            local timer = setTimer( function( )
                local width, height = bg:width( ), bg:height( )
                local data = sizes[ width ]
                if not data then return end

                local border = _ibCreateImage( data.px, data.py, 0, 0, ":nrp_shared/img/newyear_border/" .. width .. "/img.png", bg )
                    :ibSetRealSize( )
                    :ibBatchData( { priority = math.huge, disabled = true } )

                if data.sy - height > 20 then
                    border:ibData( "section", { px = 0, py = 0, sx = border:width( ), sy = border:height( ) - ( data.sy - height ) } )
                end
            end, 0, 1 )
            
            bg:ibOnDestroy( function( )
                if isTimer( timer ) then
                    killTimer( timer )
                end 
            end, false )

            ibCreateImage = _ibCreateImage

            return bg
        end
    end

    return element
end

ibCreateEdit = function( px, py, sx, sy, text, parent, color, bg_color, caret_color )
    return ibEdit(
        {
            px = px, py = py, sx = sx, sy = sy,
            parent = parent,
            text = text or "",
            color = color, bg_color = bg_color, caret_color = caret_color
        }
    )
end

ibCreateWebEdit = function( px, py, sx, sy, text, parent, color, bg_color )
    return ibWebEdit(
        {
            px = px, py = py, sx = sx, sy = sy,
            parent = parent,
            text = text or "",
            color = color, bg_color = bg_color
        }
    )
end

ibCreateWebMemo = function( px, py, sx, sy, text, parent, color, bg_color )
    return ibWebMemo(
        {
            px = px, py = py, sx = sx, sy = sy,
            parent = parent,
            text = text or "",
            color = color, bg_color = bg_color
        }
    )
end
ibCreateMemo = ibCreateWebMemo

ibCreateRenderTarget = function( px, py, sx, sy, parent )
    return ibRenderTarget(
        {
            px = px, py = py, sx = sx, sy = sy,
            parent = parent,
        }
    )
end

ibCreateScrollbarV = function( px, py, sx, sy, parent, bg_px, bg_py, bg_sx, bg_texture, bg_color, handle_px, handle_py, handle_sx, handle_sy, handle_texture, handle_lower_limit, handle_upper_limit )
    return ibScrollbarV(
        {
            px = px, py = py, sx = sx, sy = sy,
            parent = parent,

            bg_px = bg_px, bg_py = bg_py, bg_sx = bg_sx, bg_color = bg_color, bg_texture = bg_texture,

            handle_px = handle_px, handle_py = handle_py, handle_sx = handle_sx, handle_sy = handle_sy,
            handle_lower_limit = handle_lower_limit, handle_upper_limit = handle_upper_limit,
            handle_texture = handle_texture,
        }
    )
end

ibCreateScrollbarH = function( px, py, sx, sy, parent, bg_px, bg_py, bg_sx, bg_texture, bg_color, handle_px, handle_py, handle_sx, handle_sy, handle_texture, handle_lower_limit, handle_upper_limit )
    return ibScrollbarH(
        {
            px = px, py = py, sx = sx, sy = sy,
            parent = parent,

            bg_px = bg_px, bg_py = bg_py, bg_sx = bg_sx, bg_color = bg_color, bg_texture = bg_texture,

            handle_px = handle_px, handle_py = handle_py, handle_sx = handle_sx, handle_sy = handle_sy,
            handle_lower_limit = handle_lower_limit, handle_upper_limit = handle_upper_limit,
            handle_texture = handle_texture,
        }
    )
end

ibCreateScrollpane = function( px, py, sx, sy, parent, conf )
    local conf = conf or { }

    local render_target = ibRenderTarget(
        {
            px = px, py = py, sx = sx, sy = sy,
            parent = parent,
        }
    )

    local scrollbar
    if conf.horizontal then
        local conf = type( conf.horizontal ) == "table" and conf.horizontal or conf
        conf.scroll_px = conf.scroll_px or 0
        conf.scroll_py = conf.scroll_py or -10
        conf.scroll_sx = conf.scroll_sy or 0
        scrollbar = ibScrollbarH(
            {
                px = px + conf.scroll_px,
                py = py + sy + conf.scroll_py,
                sx = sx, sy = conf.scroll_sy,
                parent = parent,
            }
        )
        scrollbar:ibSetStyle( "default" )
        ibSetBatchData( scrollbar, conf or { } )

        render_target:ibConnectScrollbarH( scrollbar )
    end

    if not conf.horizontal or conf.vertical then
        local conf = type( conf.vertical ) == "table" and conf.vertical or conf
        conf.scroll_px = conf.scroll_px or 20
        conf.scroll_py = conf.scroll_py or 0
        conf.scroll_sx = conf.scroll_sx or 14
        conf.disabled = true
        scrollbar = ibScrollbarV(
            {
                px = px + sx + conf.scroll_px,
                py = py + conf.scroll_py,
                sx = conf.scroll_sx, sy = sy,
                parent = parent,
            }
        )
        scrollbar:ibSetStyle( "default" )
        ibSetBatchData( scrollbar, conf or { } )

        render_target:ibConnectScrollbarV( scrollbar )
    end
    
    -- render_target:AdaptHeightToContents( )

    return render_target, scrollbar
end

ibCreateSlider = function( x, y, parent, func_ChgState, active, type )
    local sizes = {
        [ "big" ] = {
            btn_size = 30,
            bg_size = { 60, 30 },
            move = 30,
        },
        [ "small" ] = {
            btn_size = 20,
            bg_size = { 36, 20 },
            move = 16,
        },
    }

    type = type or "big"

	local area_bg = ibCreateImage( x, y, sizes[ type ].bg_size[ 1 ], sizes[ type ].bg_size[ 2 ], ":nrp_shared/img/slider/" .. type .. "/bg.png", parent )
    local active = active or false

    area_bg:ibData( "active", active )

	local on_img = ibCreateImage( active and sizes[ type ].move or 0, 0, sizes[ type ].btn_size, sizes[ type ].btn_size, ":nrp_shared/img/slider/" .. type .. "/on.png", area_bg ):ibData( "alpha", active and 255 or 0 )
	local off_img = ibCreateImage( active and sizes[ type ].move or 0, 0, sizes[ type ].btn_size, sizes[ type ].btn_size, ":nrp_shared/img/slider/" .. type .. "/off.png", area_bg ):ibData( "alpha", active and 0 or 255 )

	area_bg:ibOnClick( function( key, state )
		if source ~= area_bg and getElementParent( source ) ~= area_bg then return end
		if key ~= "left" or state ~= "up" then return end

		active = not active
        area_bg:ibData( "active", active )
        func_ChgState( active  )

		if active then
			on_img:ibAlphaTo( 255, 100 ):ibMoveTo( sizes[ type ].move, 0, 100 )
            off_img:ibAlphaTo( 0, 100 ):ibMoveTo( sizes[ type ].move, 0, 100 )
		else
            on_img:ibAlphaTo( 0, 100 ):ibMoveTo( 0, 0, 100 ) 
            off_img:ibAlphaTo( 255, 100 ):ibMoveTo( 0, 0, 100 )
		end
	end, true )

    return area_bg
end

ibConfirm = function( conf )
    local fonts_real = ibIsUsingRealFonts( )
    ibUseRealFonts( false )
    
    local self = conf or { }
    
	self.elements = { }

	self.title = self.title or "ПОДТВЕРЖДЕНИЕ"
	self.text = self.text or "Измени self.text, бро"

	self.sx, self.sy = self.sx or 520, self.sy or 238
	self.px, self.py = self.px or _SCREEN_X_HALF - self.sx / 2, self.py or _SCREEN_Y_HALF - self.sy / 2

    self.elements.black_bg  = ibCreateBackground( conf.black_bg, _, true ):ibBatchData( { priority = conf.priority or 0, alpha = 0 } ):ibAlphaTo( 255, 400 )
    self.elements.bg 	    = ibCreateImage( self.px, self.py - 100, self.sx, self.sy, ":nrp_shared/img/confirm_bg.png", self.elements.black_bg )
    self.elements.bg:ibData( "alpha", 0 ):ibMoveTo( self.px, self.py, 500 ):ibAlphaTo( 255, 400 )

	-- "Закрыть"
	self.elements.btn_close	= ibCreateButton(	467, 26, 22, 22, self.elements.bg,
                                                ":nrp_shared/img/confirm_btn_close.png", ":nrp_shared/img/confirm_btn_close.png", ":nrp_shared/img/confirm_btn_close.png",
                                                0xFFFFFFFF, 0xFFCCCCCC, 0xFF808080 )
	:ibOnClick( function( key, state )
		if key ~= "left" or state ~= "up" then return end
		if self.fn_cancel then self:fn_cancel() end
		self:destroy()
	end, false )

    -- Заголовок
	self.elements.title = ibCreateLabel( self.sx / 2, 26, 0, 0, self.title, self.elements.bg, 0xFFFFFFFF )
    self.elements.title:ibBatchData( { font = ibFonts.semibold_14, align_x = "center" } )

    -- Текст
	self.elements.text = ibCreateLabel( 30, 100, self.sx - 60, 0, self.text, self.elements.bg, 0xFFBBBBBB )
    self.elements.text:ibBatchData( { font = ibFonts.regular_12, align_x = "center", align_y = "center", wordbreak = true } )

    -- Стоимость
    if self.cost then
        local text_sx, text_sy, text = dxGetTextSize( self.text, self.sx - 60, 1, ibFonts.regular_12, true )
        self.elements.text:ibBatchData( { text = text, py = 100 - ( text_sy + 29 ) * 0.5, align_y = "top" } )

        self.elements.cost_area = ibCreateArea( 0, text_sy + 17, 0, 0, self.elements.text )
        self.elements.cost_lbl = ibCreateLabel( 0, 0, 0, 0, format_price( self.cost ), self.elements.cost_area, COLOR_WHITE, 1, 1, "left", "center", ibFonts.bold_16 )
        self.elements.cost_money_img = ibCreateImage( self.elements.cost_lbl:ibGetAfterX( 8 ), -14, 28, 28, ":nrp_shared/img/".. ( self.cost_is_soft and "" or "hard_" ) .."money_icon.png", self.elements.cost_area )
        self.elements.cost_area:ibData( "sx", self.elements.cost_money_img:ibGetAfterX( ) ):center_x( )
    end

    -- Кнопка "ОК"
	self.elements.btn_ok = ibCreateButton(	127, 146, 127, 54, self.elements.bg,
											":nrp_shared/img/confirm_btn_ok.png", ":nrp_shared/img/confirm_btn_ok.png", ":nrp_shared/img/confirm_btn_ok.png",
											0xFFFFFFFF, 0xFFCCCCCC, 0xFF808080)
	:ibOnClick( function( key, state )
		if key ~= "left" or state ~= "up" then return end
		if self.fn then self:fn( ) end
	end, false )

    -- Кнопка "Отмена"
	self.elements.btn_cancel = ibCreateButton(	267, 146, 127, 54, self.elements.bg,
                                                ":nrp_shared/img/confirm_btn_cancel.png", ":nrp_shared/img/confirm_btn_cancel.png", ":nrp_shared/img/confirm_btn_cancel.png",
												   0xFFFFFFFF, 0xFFCCCCCC, 0xFF808080)
	:ibOnClick( function( key, state )
		if key ~= "left" or state ~= "up" then return end
		if self.fn_cancel then self:fn_cancel() end
		self:destroy()
	end, false )

    -- Удаление
	self.destroy = function( self )
		if isElement( self.elements.black_bg ) then destroyElement( self.elements.black_bg ) end
		setmetatable( self, nil )
    end
    
    -- Закрытие по ESC
    if self.escape_close then
        self.elements.black_bg:ibData( "can_destroy", true )
        local function DestroyBackground()
            if self.elements.black_bg:ibData( "can_destroy" ) then
                self.elements.black_bg:ibData( "can_destroy", false )
                if self.fn_cancel then self:fn_cancel() end
                self:destroy()
            end
        end
        ibAddKeyAction( _, 9999, self.elements.black_bg, DestroyBackground )
    end

    ibUseRealFonts( fonts_real )

	return self
end

ibInfo = function( conf )
    local fonts_real = ibIsUsingRealFonts( )
    ibUseRealFonts( false )

	local self = conf or { }

	self.elements = { }
    self.escape_close = conf.escape_close ~= nil and conf.escape_close or true

	self.title = self.title or "ИНФОРМАЦИЯ"
	self.text = self.text or "Измени self.text, бро"

	self.sx, self.sy = self.sx or 520, self.sy or 238
	self.px, self.py = self.px or _SCREEN_X_HALF - self.sx / 2, self.py or _SCREEN_Y_HALF - self.sy / 2

    self.elements.black_bg  = ibCreateBackground( _, _, true ):ibData( "priority", conf.priority or 10 )
    self.elements.bg 	    = ibCreateImage( self.px, self.py - 100, self.sx, self.sy, ":nrp_shared/img/confirm_bg.png", self.elements.black_bg )
    self.elements.bg:ibData( "alpha", 0 )
    self.elements.bg:ibMoveTo( self.px, self.py, 500 ):ibAlphaTo( 255, 400 )
	-- "Закрыть"
	self.elements.btn_close	= ibCreateButton(	467, 26, 22, 22, self.elements.bg,
                                                ":nrp_shared/img/confirm_btn_close.png", ":nrp_shared/img/confirm_btn_close.png", ":nrp_shared/img/confirm_btn_close.png",
												0xFFFFFFFF, 0xFFCCCCCC, 0xFF808080 )
	:ibOnClick( function( key, state )
		if key ~= "left" or state ~= "up" then return end
		if self.fn then self:fn( ) end
		self:destroy()
	end, false )

    -- Заголовок
	self.elements.title = ibCreateLabel( self.sx / 2, 26, 0, 0, self.title, self.elements.bg, 0xFFFFFFFF )
    self.elements.title:ibBatchData( { font = ibFonts.bold_14, align_x = "center" } )

    -- Текст
	self.elements.text = ibCreateLabel( 30, 80, self.sx - 60, 0, self.text, self.elements.bg, 0xFFBBBBBB )
    self.elements.text:ibBatchData( { font = ibFonts.regular_12, align_x = "center", wordbreak = true } )

    -- Кнопка "ОК"
	self.elements.btn_ok = ibCreateButton(	196, 146, 127, 54, self.elements.bg,
												":nrp_shared/img/confirm_btn_ok.png", ":nrp_shared/img/confirm_btn_ok.png", ":nrp_shared/img/confirm_btn_ok.png",
												0xFFFFFFFF, 0xFFCCCCCC, 0xFF808080)
	:ibOnClick( function( key, state )
		if key ~= "left" or state ~= "up" then return end
        if self.fn then self:fn( ) end
        self:destroy()
	end, false )

    -- Удаление
	self.destroy = function( self )
		if isElement( self.elements.black_bg ) then destroyElement( self.elements.black_bg ) end
		setmetatable( self, nil )
	end

    -- Закрытие по ESC
    if self.escape_close then
        self.elements.black_bg:ibData( "can_destroy", true )
        local function DestroyBackground()
            if self.elements.black_bg:ibData( "can_destroy" ) then
                self.elements.black_bg:ibData( "can_destroy", false )
                if self.fn then self:fn( ) end
                self:destroy()
            end
        end        
        ibAddKeyAction( _, 9999, self.elements.black_bg, DestroyBackground )
    end

    ibUseRealFonts( fonts_real )

	return self
end


ibInput = function( conf )
    local fonts_real = ibIsUsingRealFonts( )
    ibUseRealFonts( false )

	local self = conf or { }

	self.elements = { }
    self.escape_close = conf.escape_close ~= nil and conf.escape_close or true

	self.title = self.title or "Измени self.title, бро"
    self.text = self.text or ""
    self.edit_text = self.edit_text or "Измени self.edit_text, бро"
    self.edit_right_text = self.edit_right_text or ""
    self.edit_value = self.edit_value or ""
    self.btn_text = self.btn_text or "self.btn_text"

	self.sx, self.sy = self.sx or 520, self.sy or 338
	self.px, self.py = self.px or _SCREEN_X_HALF - self.sx / 2, self.py or _SCREEN_Y_HALF - self.sy / 2

    self.elements.black_bg  = ibCreateBackground( conf.black_bg, _, true ):ibBatchData( { priority = conf.priority or 0, alpha = 0 } ):ibAlphaTo( 255, 400 )
    self.elements.bg 	    = ibCreateImage( self.px, self.py - 100, self.sx, self.sy, ":nrp_shared/img/input_bg.png", self.elements.black_bg )
    self.elements.bg:ibData( "alpha", 0 ):ibMoveTo( self.px, self.py, 500 ):ibAlphaTo( 255, 400 )

	-- "Закрыть"
	self.elements.btn_close	= ibCreateButton(	467, 26, 22, 22, self.elements.bg,
                                                ":nrp_shared/img/confirm_btn_close.png", ":nrp_shared/img/confirm_btn_close.png", ":nrp_shared/img/confirm_btn_close.png",
												0xFFFFFFFF, 0xFFCCCCCC, 0xFF808080 )
	:ibOnClick( function( key, state )
		if key ~= "left" or state ~= "up" then return end
		if self.fn_cancel then self:fn_cancel() end
		self:destroy()
	end, false )

	self.elements.title = ibCreateLabel( 36, 28, 0, 0, self.title, self.elements.bg, 0xFFFFFFFF ):ibBatchData( { font = ibFonts.bold_14 } )
	self.elements.text = ibCreateLabel( 36, 102, self.sx - 60, 0, self.text, self.elements.bg, 0xFFBBBBBB ):ibBatchData( { font = ibFonts.regular_12, align_x = "left", wordbreak = true } )
    self.elements.edit_text = ibCreateLabel( 58, 166, self.sx - 60, 0, self.edit_text, self.elements.bg, 0xFFBBBBBB ):ibBatchData( { font = ibFonts.regular_10 } )
    self.elements.edit_right_text = ibCreateLabel( self.sx - 52, 166, 0, 0, self.edit_right_text, self.elements.bg, 0xFFBBBBBB ):ibBatchData( { font = ibFonts.regular_10, align_x = "right" } )
    self.elements.edit = ibCreateEdit( 58, 190, 420, 27, self.edit_value, self.elements.bg, 0xffffffff, 0x00000000, 0xffffffff ):ibBatchData( { font = ibFonts.bold_12 } )
	self.elements.btn_ok = ibCreateButton(	200, 264, 120, 44, self.elements.bg,
											":nrp_shared/img/btn_bg.png", ":nrp_shared/img/btn_bg_hover.png", ":nrp_shared/img/btn_bg_hover.png",
											0xFFFFFFFF, 0xFFCCCCCC, 0xFF808080)
	:ibOnClick( function( key, state )
		if key ~= "left" or state ~= "up" then return end
		if self.fn then self:fn( self.elements.edit:ibData( "text" ) ) end
    end, false )
    self.elements.btn_ok_text = ibCreateLabel( 0, 0, 0, 0, self.btn_text, self.elements.btn_ok, 0xFFDDDDDD ):ibBatchData( { font = ibFonts.bold_12, align_x = "center", align_y = "center", disabled = true } ):center( )

    -- Удаление
	self.destroy = function( self )
		if isElement( self.elements.black_bg ) then destroyElement( self.elements.black_bg ) end
		setmetatable( self, nil )
    end

    if self.is_sum then
        self.elements.edit_lbl = ibCreateLabel( 60, 205, 0, 0, "", self.elements.bg, 0xFFFFFFFF, 1, 1, "left", "center" ):ibData( "font", ibFonts.bold_12 )
        self.elements.edit
            :ibBatchData( { color = 0x00000000, max_length = 14 } )
            :ibOnDataChange( function( key, value )
                if key == "text" then
                    local visible_value = value
                    if tonumber( value ) then
                        visible_value = format_price( value ) 
                        self.elements.edit:ibData( "px", 60 + (string.len( visible_value ) - string.len( value )) * 5 )
                    end
                    self.elements.edit_lbl:ibData( "text", visible_value )
                end
            end )
    end

    -- Закрытие по ESC
    if self.escape_close then
        self.elements.black_bg:ibData( "can_destroy", true )
        local function DestroyBackground()
            if self.elements.black_bg:ibData( "can_destroy" ) then
                self.elements.black_bg:ibData( "can_destroy", false )
                if self.fn_cancel then self:fn_cancel() end
                self:destroy()
            end
        end        
        ibAddKeyAction( _, 9999, self.elements.black_bg, DestroyBackground )
    end
    
    ibUseRealFonts( fonts_real )

	return self
end


function ibCreateSelector( conf )
    local fonts_real = ibIsUsingRealFonts( )
    ibUseRealFonts( false )

    local self = conf

    self.elements = { }

    self.parent = self.parent
    self.selected = self.selected or 1
    self.font = self.font or "default"

    self.px, self.py = self.px or 0, self.py or 0
    self.sx, self.sy = self.sx or 70, self.sy or 30
    self.gap = self.gap or 2

    self.destroy = function( self )
        for i, v in pairs( self.elements ) do
            if isTimer( v ) then killTimer( v ) end
            if isElement( v ) then destroyElement( v ) end
        end
        setmetatable( self, nil )
    end

    self.refreshView = function( self )
        for i = 1, self.total_numbers do
            if i == self.selected then
                self.elements[ "item_bg_" .. i ]:ibData( "color", 0xff6b7079 )
            else
                self.elements[ "item_bg_" .. i ]:ibData( "color", 0xff414753 )
            end
        end
    end

    self.getSelectedItem = function( self )
        local n = 0
        for _, s in pairs( self.values ) do
            for i, value in pairs( s ) do
                n = n + 1
                if n == self.selected then
                    local value_real = value
                    if type( value ) == "table" then
                        value_real = value.value_return or value.value
                    end
                    return value_real
                end
            end
        end
    end

    self.total_numbers = 0
    for i, v in pairs( self.values ) do for i, v in pairs( v ) do self.total_numbers = self.total_numbers + 1 end end

    local item_number, py = 0, self.py
    for row_number, row in pairs( self.values ) do
        local px = self.px
        local icon = self.icon
        for value_number, value in pairs( row ) do
            item_number = item_number + 1

            local this_item_number = item_number

            local sx, sy = self.sx, self.sy
            local value_real = value
            if type( value ) == "table" then
                value_real = value.value
                sx = value.sx or sx
                sy = value.sy or sy
                icon = value.icon or icon
            end

            self.elements[ "item_bg_" .. item_number ] = ibCreateImage( px, py, sx, sy, false, self.parent )

            local text_width = dxGetTextWidth( value_real, 1, self.font )
            local total_width = text_width
            if icon then
                total_width = total_width + icon.sx + icon.gap

                local icon_direction = icon.direction or "left"

                if icon_direction == "left" then
                    local icon_position = px + sx / 2 - total_width / 2
                    self.elements[ "item_icon_" .. item_number ]    = ibCreateImage( icon_position, py + sy / 2 - icon.sy / 2, icon.sx, icon.sy, icon.texture, self.parent )
                    self.elements[ "item_label_" .. item_number ]   = ibCreateLabel( icon_position + icon.sx + icon.gap, py, 0, sy, value_real, self.parent )
                    self.elements[ "item_label_" .. item_number ]:ibBatchData( { font = self.font, align_y = "center" } )
                else
                    local text_position = px + sx / 2 - total_width / 2
                    self.elements[ "item_label_" .. item_number ]   = ibCreateLabel( text_position, py, 0, sy, value_real, self.parent )
                    self.elements[ "item_label_" .. item_number ]:ibBatchData( { font = self.font, align_y = "center" } )
                    self.elements[ "item_icon_" .. item_number ]    = ibCreateImage( text_position + text_width + icon.gap , py + sy / 2 - icon.sy / 2, icon.sx, icon.sy, icon.texture, self.parent )
                end
            else
                self.elements[ "item_label_" .. item_number ]   = ibCreateLabel( px + sx / 2 - total_width / 2, py, 0, sy, value_real, self.parent )
                self.elements[ "item_label_" .. item_number ]:ibBatchData( { font = self.font, align_y = "center" } )
            end

            self.elements[ "item_btn_" .. item_number ] = ibCreateButton( px, py, sx, sy, self.parent, nil, nil, nil, 0x00000000, 0x00000000, 0x00000000 )
            :ibOnClick( function( key, state )
                if key ~= "left" or state ~= "up" then return end
                self.selected = this_item_number
                self:refreshView()
            end, false )

            px = px + sx + self.gap
        end
        py = py + self.gap + self.sy
    end

    self:refreshView()

    ibUseRealFonts( fonts_real )

    return self
end

function ibLoading( conf )
    local fonts_real = ibIsUsingRealFonts( )
    ibUseRealFonts( false )

	local conf = conf or { }
	conf.text = conf.text or "Загрузка..."
	conf.font = conf.font or ibFonts.regular_12

    local layers_mul = {
        [ 1 ] = 0.7,
        [ 2 ] = 0.9,
        [ 3 ] = 1.1,
    }

    local layers_colors = {
        [ 1 ] = 0xff1e2832 * 2,
        [ 2 ] = 0xff303a45 * 2,
        [ 3 ] = 0xff3e4853 * 2,
    }

    local animation_bg = ibCreateImage( 0, 0, _SCREEN_X, _SCREEN_Y, nil, nil, conf.bg_color or 0x99000000 )
        :ibData( "priority", conf.priority or 0 )
        :ibData( "disabled", conf.disabled or false )

    if isElement( conf.parent ) then
        local sx, sy = conf.parent:ibData( "sx" ), conf.parent:ibData( "sy" )
        animation_bg:ibBatchData( { sx = sx, sy = sy } )
        animation_bg:setParent( conf.parent )
    end

    for i = 1, #layers_mul do
        local rotor = ibCreateImage( 0, 0, 148, 148, ":nrp_shared/img/loading/l" .. i ..".png", animation_bg, layers_colors[ i ] ):center( )
            :ibData( "disabled", conf.disabled or false )
            :ibOnRender( function( )
                this:ibData( "rotation", getTickCount( ) / 2 * layers_mul[ i ] )
            end )
    end

    ibCreateLabel( 0, 0, 0, 0, conf.text, animation_bg, layers_colors[ 3 ], _, _, "center", "center", conf.font ):center( )

    ibUseRealFonts( fonts_real )

    return animation_bg
end

ibInfoPressKey = function( conf )
    local fonts_real = ibIsUsingRealFonts( )
    ibUseRealFonts( false )

	local self = conf or { }

	self.elements = { }

    self.text = self.text or "*ОДИН ИЗ РАЗРАБОТЧИКОВ ДУРАК И ЗАБЫЛ ВСТАВИТЬ СЮДА ТЕКСТ*"
    self.key_text = self.key_text or utf8.upper( self.key or "f1" )

	self.px, self.py = self.px or 0, self.py or _SCREEN_Y_HALF / 2

	self.elements.black_bg  = ibCreateBackground( conf.black_bg or 0xa0000000, _, true ):ibData( "priority", 0 )
	if not self.no_fade_in then
		self.elements.black_bg:ibData( "alpha", 0 ):ibAlphaTo( 255, 1000 )
	end

	self.do_text = self.do_text or ( self.hold and "Удерживай" or "Нажми" )
	local ft_text_len = dxGetTextWidth( self.do_text, 1, ibFonts.regular_18 )
	local st_text_len = dxGetTextWidth( self.text, 1, ibFonts.regular_18 )
	local key_bg_sx = math.max( 36, 34 + dxGetTextWidth( self.key_text, 1, ibFonts.regular_18 ) )
	local key_img = nil

	if self.key == "mouse1" then
		self.key_text = "ЛКМ"
		key_bg_sx = 102 --17 + 17 + 10 + 51 + 17
		key_img = ":nrp_shared/img/icon_mouse_left.png"

	elseif self.key == "mouse2" then
		self.key_text = "ПКМ"
		key_bg_sx = 102
		key_img = ":nrp_shared/img/icon_mouse_right.png"
    elseif self.key == "mouse3" then
		self.key_text = "СКМ"
		key_bg_sx = 102
		key_img = ":nrp_shared/img/icon_mouse_middle.png"
	end

	self.elements.area_bg = ibCreateArea( 0, 0, 0, 0, self.elements.black_bg )

	self.elements.ft_text = ibCreateLabel( 0, 0, 0, 0, self.do_text, self.elements.area_bg, 0xFFFFFFFF ):ibBatchData( { font = ibFonts.regular_18, align_x = "left", align_y = "center", outline = true } )
	self.elements.key_bg = ibCreateImage( self.elements.ft_text:ibGetAfterX( 15 ), 0, key_bg_sx, 36, _, self.elements.area_bg, 0xd8212b36 ):center_y( )

	self.elements.key_text = ibCreateLabel( 0, 0, 0, 0, self.key_text, self.elements.key_bg, 0xFFFFFFFF ):ibBatchData( { font = ibFonts.bold_18, align_x = "center", align_y = "center" } )
	if key_img then
		self.elements.key_img = ibCreateImage( 12, 0, 17, 24, key_img, self.elements.key_bg ):center_y( )
		self.elements.key_text:ibBatchData( { px = self.elements.key_img:ibGetAfterX( 10 ), align_x = "left" } ):center_y(  )
	else
		self.elements.key_text:center( )
	end

	self.elements.st_text = ibCreateLabel( self.elements.key_bg:ibGetAfterX( 15 ), 0, 0, 0, self.text, self.elements.area_bg, 0xFFFFFFFF ):ibBatchData( { font = ibFonts.regular_18, align_x = "left", align_y = "center", outline = true } )

	self.elements.area_bg:ibData( "sx", self.elements.st_text:ibGetAfterX( ) ):center( self.px, self.py )

	self.destroy = function( )
		if isElement( self.elements.black_bg ) then destroyElement( self.elements.black_bg ) end
        if self.key == "mouse3" then
            unbindKey( "mouse_wheel_up", "both", self.bind_handler )
            unbindKey( "mouse_wheel_down", "both", self.bind_handler )
        else
            unbindKey( self.key, "both", self.bind_handler )
        end
		setmetatable( self, nil )
	end

	self.protect_destroy = function( )
		if self.key_handler then
			self:key_handler( )
		end

		if not self.no_auto_destroy then
			self.destroy( )
		end
	end

	self.bind_handler = function( key, state )
		if self.hold then
			if state == "down" then
				if not isElement( self.elements.key_hold_bg ) then
					local times = self.hold_time or 1000
					self.elements.key_hold_bg = ibCreateImage( 0, 0, 0, 36, _, self.elements.key_bg, 0x80547FAF )
						:ibData( "priority", -1 )
						:ibResizeTo( self.elements.key_bg:ibData( "sx" ), 36, times, "Linear" )
						:ibTimer( self.protect_destroy, times, 1 )
				end
			else
				if isElement( self.elements.key_hold_bg ) then
					destroyElement( self.elements.key_hold_bg )
				end
			end
		elseif state == ( self.key_state or "up" ) then
			self.protect_destroy( )
		end
	end
    
    if self.key == "mouse3" then
	    bindKey( "mouse_wheel_up", "both", self.bind_handler )
        bindKey( "mouse_wheel_down", "both", self.bind_handler )
    else
        bindKey( self.key, "both", self.bind_handler )
    end


    ibUseRealFonts( fonts_real )

	return self
end

ibInfoPressKeyProgress = function( conf )
	conf.no_auto_destroy = true
	conf.key_state = "down"
	conf.click_count = conf.click_count or 4

	local self = ibInfoPressKey( conf )

	self.elements.progress_bg = ibCreateImage( self.elements.ft_text:ibGetBeforeX( -30 ), 0, 10, 120, _, self.elements.area_bg, 0xff364754 ):center_y( )
	self.elements.progress_border = ibCreateImage( 1, 1, 8, 118, _, self.elements.progress_bg, 0xff5a6672 )
	self.elements.progress_bar = ibCreateImage( 1, 119, 8, 0, _, self.elements.progress_bg, 0xffe3ca41 )

    self.float_sy = 0
	self.key_handler = function( )
        self.float_sy = self.float_sy + ( 118 / self.click_count ) * -1
        if conf.click_handler then
            conf:click_handler( )
        end 
		if self.float_sy <= -118 then
			if conf.end_handler then
				conf:end_handler( )
			end

			self.destroy( )

			return
        else
            self.elements.progress_bar:ibData( "sy", math.ceil( self.float_sy ) )
		end
    end

	if self.timeout then
		self.elements.progress_bar:ibTimer( function( )
            self.float_sy = math.min( 0, self.float_sy + 50 / self.timeout * 118 / self.click_count )
            self.elements.progress_bar:ibData( "sy", math.ceil( self.float_sy ) )
		end, 50, 0 )
	end

	return self
end

ibInfoPressKeyZone = function( conf )
	conf.no_auto_destroy = true
	conf.key_state = "down"
	conf.click_count = conf.click_count or 10
	conf.line_time = conf.line_time or 1500
	conf.click_timeout = conf.click_timeout or 500

	local self = ibInfoPressKey( conf )

	local zone_pos = math.random( 10, 170 )
	self.elements.zone_bg = ibCreateImage( self.elements.ft_text:ibGetBeforeX( -30 ), 0, 14, 220, _, self.elements.area_bg, 0x80212b36 ):center_y( )
	self.elements.zone = ibCreateImage( 1, zone_pos, 12, 40, _, self.elements.zone_bg, 0xFFe3ca41 )
	self.elements.click_line = ibCreateImage( -4, 0, 22, 2, _, self.elements.zone_bg, 0xFFFFFFFF )

	local func_interpolate = function( )
		self.elements.click_line:ibInterpolate( function( self )
			if not isElement( self.element ) then return end
			self.element:ibData( "py", 10 + 200 * self.easing_value )
		end, self.line_time, "SineCurve" )
	end
	func_interpolate( )
	self.elements.click_line:ibTimer( func_interpolate, self.line_time, 0 )

	local click_count = 0
	local last_click_tick = getTickCount( )
	self.key_handler = function( )
		if last_click_tick > getTickCount( ) then return end
		last_click_tick = getTickCount( ) + self.click_timeout

		local py = self.elements.click_line:ibData( "py" )
		if py >= zone_pos and py <= ( zone_pos + 40 ) then
			click_count = click_count + 1

			ibCreateImage( 20, 0, 106, 52, ":nrp_shared/img/good.png", self.elements.zone_bg ):ibAlphaTo( 255, 250 )
				:ibTimer( function( self )
					self:ibAlphaTo( 0, 250 )
				end, 500, 1 )

			local line = ibCreateImage( 0, py, 14, 2, _, self.elements.zone_bg, 0xff22dd22 ):ibAlphaTo( 0, 6000 )
			line:ibTimer( destroyElement, 6000, 1, line )

			if self.click_handler then
				self:click_handler( )
			end

			if click_count >= self.click_count then
				if self.end_handler then
					self:end_handler( )
				end

				self.destroy( )
			end
		else
			ibCreateImage( 20, 0, 88, 50, ":nrp_shared/img/bad.png", self.elements.zone_bg, 0xFFFFFFFF ):ibAlphaTo( 255, 250 )
				:ibTimer( function( self )
					self:ibAlphaTo( 0, 250 )
				end, 500, 1 )

			local line = ibCreateImage( 0, py, 14, 2, _, self.elements.zone_bg, 0xffdd2222 ):ibAlphaTo( 0, 6000 )
			line:ibTimer( destroyElement, 6000, 1, line )
		end
	end

	return self
end

ibInfoPressKeyCircle = function( conf )
	conf.no_auto_destroy = true
	conf.key_state = "down"
	conf.line_time = conf.line_time or 1000
	conf.click_timeout = conf.click_timeout or 500

	local self = ibInfoPressKey( conf )

	self.elements.circle_bg = ibCreateImage( 0, -130, 98, 98, ":nrp_shared/img/circle_click_bg.png", self.elements.area_bg ):center_x( )
	self.elements.circle_line = ibCreateImage( 0, 0, 0, 0, ":nrp_shared/img/circle_click_line.png", self.elements.circle_bg )

	local func_interpolate = function( )
		self.elements.circle_line:ibInterpolate( function( self )
			if not isElement( self.element ) then return end
			self.element:ibBatchData( { sx = 18 + 80 * self.easing_value, sy = 18 + 80 * self.easing_value } ):center( )
		end, self.line_time, "SineCurve" )
	end
	func_interpolate( )
	self.elements.circle_line:ibTimer( func_interpolate, self.line_time, 0 )

	local last_click_tick = getTickCount( )
	self.key_handler = function( )
		if last_click_tick > getTickCount( ) then return end
		last_click_tick = getTickCount( ) + self.click_timeout

		local sx = self.elements.circle_line:ibData( "sx" )
		if sx >= 66 and sx <= 86 then
			if self.end_handler then
				self:end_handler( )
			end

			self.destroy( )
		else
			ibCreateImage( 0, -50, 88, 50, ":nrp_shared/img/bad.png", self.elements.circle_bg, 0xFFFFFFFF ):center_x( ):ibData( "alpha", 0 ):ibAlphaTo( 255, 250 )
				:ibTimer( function( self )
					self:ibAlphaTo( 0, 250 )
				end, 500, 1 )
		end
	end

	return self
end

-- Удержание мышки в регионе (ibCreateMouseKeyHoldInRegion)
ibInfoHoldArrowInRegion = function( conf )
    local fonts_real = ibIsUsingRealFonts( )
    ibUseRealFonts( false )

    local self = conf or { }
    self.elements = { }

    self.text = self.text or "*ОДИН ИЗ РАЗРАБОТЧИКОВ ДУРАК И ЗАБЫЛ ВСТАВИТЬ СЮДА ТЕКСТ*"
	self.px, self.py = self.px or 0, self.py or 0
    self.time_hold_in_region = self.time_hold_in_region or 80000

    self.elements.bckg  = ibCreateBackground( conf.black_bg or 0xa0000000, _, true ):ibData( "priority", 0 )
	if not self.no_fade_in then
		self.elements.bckg:ibData( "alpha", 0 ):ibAlphaTo( 255, 1000 )
	end

    self.elements.circle_area = ibCreateArea( 0, 154, 330, 166, self.elements.bckg ):center( self.px, self.py )
    self.elements.circle_bg_img = ibCreateImage( 0, 0, 330, 166, ":nrp_shared/img/arrow_hold/bg.png", self.elements.circle_area )
    self.elements.circle_region = ibCreateImage( 0, -6, 68, 23, ":nrp_shared/img/arrow_hold/region.png", self.elements.circle_area ):center_x( ):ibData( "alpha", 150 )
    self.elements.circle_arrow  = ibCreateImage( 0, 15, 66, 276, ":nrp_shared/img/arrow_hold/arrow.png", self.elements.circle_area ):center_x( )
    self.elements.circle_center = ibCreateImage( 0, 140, 45, 45, ":nrp_shared/img/arrow_hold/center.png", self.elements.circle_area ):center_x( 2 )

    self.elements.progress_text = ibCreateLabel( 0, self.elements.circle_bg_img:ibGetAfterY( 7 ), 40, 0, "0%", self.elements.circle_area, 0xFFf4f4f5 )
        :center_x( ):ibBatchData( { font = ibFonts.regular_14, align_x = "center", outline = true } )

    self.elements.st_text = ibCreateLabel( 0, self.elements.circle_bg_img:ibGetAfterY( 35 ), 0, 0, self.text, self.elements.circle_area, 0xFFFFFFFF )
        :center_x( ):ibBatchData( { font = ibFonts.regular_16, align_x = "center", outline = true } )
    
    self.time = 0
    self.progress = 0
    self.is_first_step = true
    self.elements.circle_bg_img:ibOnRender(function()
        if self.end_operation then return end
        --Установка курсора в область взаимодействия с полукругом
        if self.is_first_step then self.is_first_step = false setCursorPosition(300, 100) end
        
        local cursor_x, _ = getCursorPosition()
        cursor_x = cursor_x * _SCREEN_X
        --Деление полукруга по-полам и сдвиг стрелки влево/вправо
        if cursor_x < 325 then
            cursor_x = cursor_x - math.sin(getTickCount())*12
        else
            cursor_x = cursor_x + math.sin(getTickCount())*12
        end

        --Если стрелка вышла из зоны взаимодейтсивия возвращаем назад
        if cursor_x > 775 then  cursor_x = 770  end
        setCursorPosition(cursor_x, 100)
        
        --Получаем ротацию относительно курсора и основания полукруга, поворачиваем стрелку
        local rotation = -math.deg(math.atan2(-216, cursor_x - 330))
        local rotate = rotation - 90
        self.elements.circle_arrow:ibBatchData( { rotation =  rotation > 90 and rotate * -1 or math.abs(rotate), rotation_offset_y = 10 } )
        
        --Если стрелка находится в заданном интервале, то изменяем прогресс
        if rotation < 100 and rotation > 80 then
            if self.sound_path and not isElement( self.sound ) then
                self.sound = playSound( self.sound_path )
                setSoundVolume( self.sound, 0.5 )
            end
            self.elements.circle_region:ibData( "alpha", 255 )
            
            if self.prev_time then
                self.time = self.time + getTickCount() - self.prev_time
                
                local progress = math.floor( self.time / self.time_hold_in_region * 100 )
                self.elements.progress_text:ibData( "text", progress .. "%" )
                
                if progress >= 100 then
                    self.elements.circle_arrow:ibBatchData( { rotation =  0, rotation_offset_y = 10 } )

                    self:destroy()
                    self.callback()
                end
            else
                if isElement( self.sound ) then
                    stopSound( self.sound )
                end
                self.prev_time = getTickCount()
            end
        else
            --иначе сбрасываем время
            self.elements.circle_region:ibData( "alpha", 155 )
            self.prev_time = nil
        end
    end )

    self.destroy = function()
        setCursorAlpha( 255 )
        if isElement( self.elements.bckg ) then
            self.elements.bckg:destroy()
        end
    end

    setCursorAlpha( 0 )

    ibUseRealFonts( fonts_real )

    return self
end

-------------------------
-- Полезный функционал --
-------------------------

function ibIsAnyWindowActive( )
    for i, v in pairs( getElementChildren( getElementByID( "ibRoot" ) ) ) do
        if v:ibData( "is_background_real" ) then
            return true
        end
    end
end

function DestroyTableElements( tbl )
    for i, v in pairs( tbl or { } ) do
        if isElement( v ) then destroyElement( v ) end
        if isTimer( v ) then killTimer( v ) end
        if type( v ) == "table" then
            if v.destroy then
                v:destroy( )
            else
                DestroyTableElements( v )
            end
        end
    end
end

function CleanResourceTextures( )
    DestroyTableElements( getElementsByType( "texture", resourceRoot ) )
end

function ibGetAlpha( percentage )
    return math_floor( percentage / 100 * 255 )
end

function ibApplyAlpha( color, percentage )
    color = color and color or COLOR_WHITE
    return percentage == 100 and color or bitReplace( color, bitExtract( color, 24, 8 ) * percentage / 100, 24, 8 )
end

function ibAttachAutoclose( fn )
    addEvent( "ibOnAutocloseCall" )
    addEventHandler( "ibOnAutocloseCall", root, fn )
end

function ibAutoclose( )
    triggerEvent( "ibOnAutocloseCall", resourceRoot )
end

local KEY_ACTIONS = {}

function ibAddKeyAction( key, priority, parent, callback )

    for k, v in pairs( KEY_ACTIONS ) do
        if v.parent == parent then
            ibRemoveKeyAction( parent )
        end
    end

    local self = 
    {
        callback = callback,
        remove_after = remove_after,
        parent = parent,
    }
    
    self.destroy = function()
        ibRemoveKeyAction( parent )
    end

    table.insert( KEY_ACTIONS, self )
    triggerEvent( "OnAddKeyAction", resourceRoot, parent, key, priority )
    
    addEventHandler( "onClientElementDestroy", parent, function()
        ibRemoveKeyAction( source )
    end, false ) 

    return self
end

function ibRemoveKeyAction( parent )
    for k, v in pairs( KEY_ACTIONS ) do
        if v.parent == parent then
            table.remove( KEY_ACTIONS, k )
            triggerEvent( "OnRemoveKeyAction", resourceRoot, parent )
            break
        end
    end
end

function OnAddKeyActionCallback_handler( parent )
    for k, v in pairs( KEY_ACTIONS ) do
        if v.parent == parent then
            v.callback()
            break
        end
    end
end
addEvent( "OnAddKeyActionCallback" )
addEventHandler( "OnAddKeyActionCallback", root, OnAddKeyActionCallback_handler )

Element.ibKeyAction = ibKeyAction

-----------
-- Звуки --
-----------

ibClick = function( sound_num, sound_volume, format )
    --[[local sound_num = sound_num or 1
    local sound_volume = sound_volume or 0.5
    local format = format or "wav"
    local sound = playSound( ":nrp_shared/sfx/fx/click" .. sound_num .. "." .. format )
    setSoundVolume( sound, sound_volume )]]
    return exports.main_sounds:playSound( 'checkbox' )
end

ibError = function( sound_num, sound_volume, format )
    local sound_num = sound_num or 1
    local sound_volume = sound_volume or 0.5
    local format = format or "wav"
    local sound = playSound( ":nrp_shared/sfx/fx/error" .. sound_num .. "." .. format )
    setSoundVolume( sound, sound_volume )
    return sound
end

ibVoiceLine = function( name, sound_volume )
    local sound_volume = sound_volume or 0.8
    local sound = playSound( ":nrp_shared/sfx/voice/" .. name .. ".wav" )
    setSoundVolume( sound, sound_volume )
end

ibSoundFX = function( name, sound_volume )
    local sound_volume = sound_volume or 0.8
    local sound = playSound( ":nrp_shared/sfx/fx/" .. name .. ".wav" )
    setSoundVolume( sound, sound_volume )
end

-- ЗВуки открытия интерфейсов

ibWindowSound = function( sound_volume )
    sound_volume = sound_volume or 0.5
    local sound = playSound( ":nrp_shared/sfx/fx/windows_open.wav" )
    setSoundVolume( sound, sound_volume )
    return sound
end

ibOverlaySound = function( sound_volume )
    sound_volume = sound_volume or 1
    local sound = playSound( ":nrp_shared/sfx/fx/overlay_open.wav" )
    setSoundVolume( sound, sound_volume )
    return sound
end

ibInterfaceSound = function( sound_volume )
    sound_volume = sound_volume or 0.5
    local sound = playSound( ":nrp_shared/sfx/fx/interface_open.wav" )
    setSoundVolume( sound, sound_volume )
    return sound
end

-- Звуки покупки

ibBuyProductSound = function( sound_volume )
    sound_volume = sound_volume or 0.5
    local sound = playSound( ":nrp_shared/sfx/fx/buy_product.wav" )
    setSoundVolume( sound, sound_volume )
    return sound
end

ibBuyDonateSound = function( sound_volume )
    sound_volume = sound_volume or 0.5
    local sound = playSound( ":nrp_shared/sfx/fx/buy.wav" )
    setSoundVolume( sound, sound_volume )
    return sound
end


ibGetRewardSound = function( sound_volume )
    sound_volume = sound_volume or 0.5
    local sound = playSound( ":nrp_shared/sfx/fx/reward_get.wav" )
    setSoundVolume( sound, sound_volume )
    return sound
end

-----------------------
------ АНИМАЦИИ -------
-----------------------
ibMoveTo = function( element, px, py, duration, easing, relative_to_position )
    if relative_to_position then
        px = px + ibGetData( element, "px" )
        py = py + ibGetData( element, "py" )
    end

    return element, ibMove(
        {
            element = element,
            px = px, py = py,
            duration = duration,
            easing = easing,
        }
    )
end

ibAlphaTo = function( element, alpha, duration, easing )
    return element, ibAlpha(
        {
            element = element,
            alpha = alpha,
            duration = duration,
            easing = easing,
        }
    )
end

ibResizeTo = function( element, sx, sy, duration, easing )
    return element, ibResize(
        {
            element = element,
            sx = sx, sy = sy,
            duration = duration,
            easing = easing,
        }
    )
end

ibColorTo = function( element, r, g, b, duration, easing )
    return element, ibColor(
        {
            element = element,
            r = r, g = g, b = b,
            duration = duration,
            easing = easing,
        }
    )
end

ibRotateTo = function( element, rotation, duration, easing )
    return element, ibRotate(
        {
            element = element,
            rotation = rotation,
            duration = duration,
            easing = easing,
        }
    )
end

ibScrollTo = function( element, position, duration, easing )
    return element, ibScroll(
        {
            element = element,
            position = position,
            duration = duration,
            easing = easing,
        }
    )
end

Element.ibMoveTo = ibMoveTo
Element.ibAlphaTo = ibAlphaTo
Element.ibResizeTo = ibResizeTo
Element.ibRotateTo = ibRotateTo
Element.ibScrollTo = ibScrollTo
Element.ibColorTo = ibColorTo

Element.ibInterpolate = function( element, fn, duration, easing, fn_finish, ... )
    --if not element:isib() then return end

    local self = { }

    self.tick_start = getTickCount()
    self.element = element
    self.duration = duration or 500
    self.easing = easing or "InOutQuad"
    self.args = { ... }

    local function onDestroy( )
        self:destroy( )
    end

    function self.fn_wrapped( )
        local progress = ( getTickCount() - self.tick_start ) / self.duration
        progress = progress > 1 and 1 or progress < 0 and 0 or progress

        self.progress = progress
        self.easing_value = getEasingValue( progress, self.easing )

        fn( self, unpack( self.args ) )
        
        if progress >= 1 then self:destroy( ) end
    end

    function self.destroy( self )
        if type( fn_finish ) == "function" then fn_finish( self, unpack( self.args ) ) end
        removeEventHandler( "onClientRender", root, self.fn_wrapped )
        removeEventHandler( "onClientElementDestroy", element, onDestroy )
        setmetatable( self, nil )
    end

    addEventHandler( "onClientElementDestroy", element, onDestroy, false )
    addEventHandler( "onClientRender", root, self.fn_wrapped )

    return self
end

------------
-- Ивенты --
------------

local _EVENTS_LIST = {
    ibOnElementMouseClick    = "ibOnClick",
    ibOnElementMouseEnter    = "ibOnHover",
    ibOnElementMouseLeave    = "ibOnLeave",
    ibOnElementDataChange    = "ibOnDataChange",
    onClientElementDestroy   = "ibOnDestroy",
    ibOnBrowserCreated       = "ibOnCreated",
    ibOnBrowserLoadingStart  = "ibOnLoadingStart",
    ibOnBrowserDocumentReady = "ibOnDocumentReady",
    ibOnBrowserNavigate      = "ibOnNavigate",
    ibOnRender               = "ibOnRender",
    ibOnAnyClick             = "ibOnAnyClick",
    ibOnWebInputFocusChange  = "ibOnFocusChange",
    ibOnWebInputTextChange   = "ibOnTextChange",
}

local _EVENT_LIST_PROPAGATION_DEFAULT = {
    ibOnRender   = true,
    ibOnAnyClick = true,
}

for i, v in pairs( _EVENTS_LIST ) do
    Element[ v ] = function( self, fn, is_propagated )
        if is_propagated == nil then is_propagated = _EVENT_LIST_PROPAGATION_DEFAULT[ i ] or false end
        addEventHandler( i, self, fn, is_propagated )
        return self
    end
end

-------------
-- Таймеры --
-------------

Element.ibTimer = function( self, fn, duration, calls, ... )
    local timer = setTimer( fn, duration, calls, self, ... )
    if timer then
        local list = getElementData( self, "ibTimers" ) or { }
        table.insert( list, timer )
        setElementData( self, "ibTimers", list, false )

        addEventHandler( "onClientElementDestroy", self, function( )
            if isTimer( timer ) then
                killTimer( timer )
            end 
            source:ibCleanTimers( )
        end, false )

        return self, timer
    end
end

Element.ibCleanTimers = function( self )
    local list = getElementData( self, "ibTimers" ) or { }
    local list_new = { }
    for i, v in pairs( list ) do
        if isTimer( v ) then
            table.insert( list_new, v )
        end
    end
    if #list_new > 0 then
        setElementData( self, "ibTimers", list_new, false )
    elseif #list > 0 then
        setElementData( self, "ibTimers", false, false )
    end
    return list_new
end

Element.ibKillTimer = function( self, index )
    local timer = ( self:ibCleanTimers( ) or { } )[ index or 1 ]
    local result = isTimer( timer )
    if result then killTimer( timer ) end
    self:ibCleanTimers( )
    return self, result
end

Element.ibKillTimers = function( self )
    local result = true

    while result do
        self, result = self:ibKillTimer( )
    end
    return self
end

Element.ibGetTimer = function( self, index )
    return ( self:ibCleanTimers( ) or { } )[ index or 1 ]
end

---------------------
-- Стили элементов --
---------------------

Element.ibCreateStyle = function( self, id, tbl_style )
    ibSetData( self, "style_" .. id, tbl_style )
    return self
end

Element.ibSetStyle = function( self, id )
    local tbl_style = ibGetData( self, "style_" .. id ) or ibGetStyle( self, id ) or { }

    -- Ищем старые сохраненные данные (в 2 экземплярах)
    local old_values_backup = ibGetData( self, "style_old_values" ) or { }
    local old_values = ibGetData( self, "style_old_values" ) or { }

    -- Записываем новые сохраненные данные с учетом старых
    for i, v in pairs( tbl_style ) do
        if old_values[ i ] == nil then
            old_values_backup[ i ] = ibGetData( self, i ) or false
        end
        old_values[ i ] = v
    end

    -- Применяем стиль с восстановлением прошлых данных
    ibSetBatchData( self, old_values )

    -- Зачищаем позапрошлые значения и сохраняем измененные по стилю
    for i, v in pairs( old_values ) do
        if old_values_backup[ i ] == v then
            old_values_backup[ i ] = nil
        end
    end
    ibSetData( self, "style_old_values", old_values_backup )
    ibSetData( self, "style", id )

    return self
end

Element.ibGetStyle = function( self )
    return ibGetData( self, "style" )
end

----------------------------------------
-- Дамп элемента и подгрузка из дампа --
----------------------------------------

Element.ibDump = function( self, path )
    local function dump( node, element )
        local element_type = getElementType( element )
        local element_data = ibGetAllData( element ) or { }

        element_data.type          = nil
        element_data.resource_name = nil
        element_data.creation_id   = nil
        element_data.real_px       = nil
        element_data.real_py       = nil
        element_data.font          = GetFontNameFromPointer( element_data.font )

        local child = xmlCreateChild( node, element_type )

        for i, v in pairs( element_data or { } ) do
            if type( v ) == "table" then v = toJSON( v, true ) end
            if type( v ) == "string" or type( v ) == "number" then
                xmlNodeSetAttribute( child, i, v )
            end
        end

        local children = getElementChildren( element )
        for i, v in pairs( children ) do
            dump( child, v )
        end
    end

    local file = xmlCreateFile( path, "ib_structure" )
    dump( file, self )
    xmlSaveFile( file )
    xmlUnloadFile( file )

    --iprint( "Dumped ib structure to", path )
end

ibLoad = function( path )
    local function tobool( str )
        if str == "true" then return true
        elseif str == "false" then return false
        end
    end

    local file = xmlLoadFile( path )
    if file then
        local parent_elements = { }

        local function load( node, parent )
            local name = xmlNodeGetName( node )
            local creation_fn, element = _G[ name ]
            if creation_fn then
                local attributes = xmlNodeGetAttributes( node )
                for i, v in pairs( attributes ) do
                    local final_value = fromJSON( v ) or tonumber( v )
                    if tobool( v ) ~= nil then
                        final_value = tobool( v )
                    else
                        final_value = final_value or v
                    end
                    attributes[ i ] = final_value
                end

                if attributes.font then
                    attributes.font = ibFonts[ attributes.font ]
                end

                element = creation_fn( attributes )
                if parent then
                    setElementParent( element, parent )
                else
                    table.insert( parent_elements, element )
                end
            end

            for i, v in pairs( xmlNodeGetChildren( node ) ) do
                load( v, element )
            end
        end

        load( file )
        xmlUnloadFile( file )

        --iprint( "Loaded", path, "with parent_elements", #parent_elements, parent_elements )

        return parent_elements
    end
end


-------------------------
-- Унификация контента --
-------------------------

ibCreateContentImage = function( x, y, width, height, content_type, content_id, parent )
    local image = ibImage(
        {
            px = x, py = y, sx = width, sy = height,
            parent = parent,
            color = 0x00000000,
        }
	)
	local loading = ibLoading( { parent = image, disabled = true } )

	triggerEvent( "RequestContentImageTexture", root, content_type, content_id, width, height, image, loading )

	return image
end

ibCreateUpdateImage = function( x, y, date, index, parent )
    local image = ibImage(
        {
            px = x, py = y, sx = 560, sy = 560,
			parent = parent,
            color = 0x00000000,
        }
	)
	local loading = ibLoading( { parent = image } )

	triggerEvent( "RequestUpdateImageTexture", root, date, index, image, loading )

	return image
end


--------------------------------------------------
-- Удалить после добавления этой функции в клиент --
--------------------------------------------------

function dxGetTextSize( text, max_sx, scale, font, wordbreak )
    local font_height = dxGetFontHeight( 1, font )
	text = string.gsub( text, "\n", " ` " )

	local strs = { }
	local line_sx = 0
	local lines_count = 1
	for word in string.gmatch( text, "%S+" ) do
		word = word == "`" and "" or ( word .. " " )
        local word_sx = word == "" and 0 or dxGetTextWidth( word, 1, font )
        line_sx = line_sx + word_sx
		if word == "" or line_sx > max_sx then
            lines_count = lines_count + 1
			strs[ #strs + 1 ] = "\n"
			strs[ #strs + 1 ] = word
			line_sx = word_sx
		else
            strs[ #strs + 1 ] = word
		end
	end
	
	return max_sx, lines_count * font_height, table.concat( strs )
end

ibCreateCustomButton = function ( px, py, sx, sy, text, parent, texture, hover, click, font, color )
    local hover = hover or texture
    local click = click or false
    local text = text or false
    local click_btn
    local font = font or ibFonts.regular_12
    local color = color or COLOR_WHITE

    local btn = ibCreateImage ( px, py, sx, sy, texture, parent )

    local alpha_btn = ibCreateImage ( 0, 0, sx, sy, hover, btn ):center ( ):ibBatchData ( { alpha = 0, disabled = true } )
    if hover == texture then
        alpha_btn:ibData ( 'color', tocolor( 200, 200, 200 ) )
    end

    if click then
        click_btn = ibCreateImage ( 0, 0, sx, sy, click, btn ):center ( ):ibBatchData ( { alpha = 0, disabled = true } )
    end

    if text then
        ibCreateLabel ( 0, 0, sx, sy, text, btn, color, 1, 1, 'center', 'center', font ):ibData ( 'disabled', true )
    end

    -- Таймер на случай если размеры устанавливаются через ibSetRealSize
    Timer ( function ( ) 
        alpha_btn:ibBatchData ( { sx = btn:width ( ), sy = btn:height ( ) } )
        if click then
            click_btn:ibBatchData ( { sx = btn:width ( ), sy = btn:height ( ) } )
        end
    end, 250, 1)

    btn:ibOnHover ( function ( ) 
        alpha_btn:ibAlphaTo ( 255, 500 )
    end)
    btn:ibOnLeave ( function ( ) 
        alpha_btn:ibAlphaTo ( 0, 500 )
    end)

    -- мега костыль при нажатии на кнопку
    btn:ibOnClick ( function ( key, state )
        if key == 'left' then
            if state == 'down' then
                if click then
                    btn:ibData ( 'alpha', 0 )
                    click_btn:ibData ( 'alpha', 255 )
                else
                    btn:ibData ( 'alpha', 135 )
                end
            elseif state == 'up' then
                if click then
                    click_btn:ibData ( 'alpha', 0 )
                    btn:ibData ( 'alpha', 255 )
                else
                    btn:ibData ( 'alpha', 255 )
                end
            end
        end
    end)

    return btn
end

local bShaders = {
    blur = {
        path = [[

        texture ScreenTexture; 

        float Angle = 0;  // Defines the blurring direction
        float BlurAmount = 0.001;  // Defines the blurring magnitude

        sampler ImageSampler = sampler_state
        {
            Texture = <ScreenTexture>;
        };


        float4 main( float2 uv : TEXCOORD) : COLOR
        {
            float4 output = 0;  // Defines the output color of a pixel
            float2 offset;  // Defines the blurring direction as a direction vector
            int count = 24;  // Defines the number of blurring iterations

            //First compute a direction vector which defines the direction of blurring. 
            //  This is done using the sincos instruction and the Angle input parameter, 
            //  and the result is stored in the offset variable. This vector is of unit 
            //  length. Multiply this unit vector by BlurAmount to adjust its length to 
            //  reflect the blurring magnitude.
            sincos(Angle, offset.y, offset.x);
            offset *= BlurAmount;

            // To generate the blurred image, we 
            //  generate multiple copies of the input image, shifted 
            //  according to the blurring direction vector, and then sum 
            //  them all up to get the final image.
            for(int i=0; i<count; i++)
                 {
                      output += tex2D(ImageSampler, uv - offset * i);
                 }
            output /= count; // Normalize the color

            return output;
        };

        technique MotionBlur
        {
            pass P1
            {
                PixelShader = compile ps_2_0 main();
            }
        }

        ]],
    },
}


for k, v in pairs( bShaders ) do
    if not v.shader or not isElement( v.shader ) then
        v.shader = dxCreateShader( v.path )
    end
end

ibCreateShader = function( self, conf )
    if not bShaders[ self ] then
        return false
    end

    local shader = bShaders[ self ].shader or nil
    if not isElement( shader ) then
        shader = dxCreateShader( bShaders[ self ].path )
        bShaders[ self ].shader = shader;
    end

    if conf then
        if type( conf ) == 'table' then
            for key, value in pairs( conf ) do
                dxSetShaderValue( shader, key, value )
            end
        else
            dxSetShaderValue( shader, conf[ 1 ], conf[ 2 ] )
        end
    end

    return shader, bShaders[ self ]
end

ibSetShader = function( self, bShaderName, conf )
    local shader = ibCreateShader( bShaderName or 'blur', conf )
    if isElement( shader ) then
        self:ibData( 'bShader', shader )
    end
    return self;
end

Element.ibShader = ibSetShader

function gs( value )
    return value
end

function ibCreateButtonAlpha ( conf )
    local self = conf or { }
    self.px = gs ( self.px or 0 )
    self.py = gs ( self.py or 0 )
    self.sx = gs ( self.sx or 0 )
    self.sy = gs ( self.sy or 0 )
    self.text = self.text or false
    self.parent = self.parent or false
    self.texture = self.texture or nil
    self.hover = self.hover or self.texture
    self.color = self.color or COLOR_WHITE
    self.color1 = self.color1 or self.color
    self.fn = self.fn or false
    self.font = self.font or 'default-bold'
    self.text_color = self.text_color or COLOR_WHITE

    self.elements = { }

    self.elements.btn = ibCreateImage ( self.px, self.py, self.sx, self.sy, self.texture, self.parent, self.color )
    self.elements.alpha = ibCreateImage ( 0, 0, self.sx, self.sy, self.hover, self.elements.btn, self.color1 )
    :ibBatchData ( {
        alpha = 0,
        disabled = true,
        color = self.hover == self.texture and tocolor ( 200, 200, 200 ) or self.color1
    } )

    if self.realsize then
        self.elements.btn:ibSetRealSize( )
        self.elements.alpha:ibSetRealSize( )
    end

    if self.text then
        self.elements.text = ibCreateLabel ( 0, 0, self.sx, self.sy, self.text, self.elements.btn, self.text_color, 1, 1, 'center', 'center', self.font ):ibData ( 'disabled', true )
    end

    self.elements.btn
    :ibOnHover ( function ( ) 
        self.elements.alpha:ibAlphaTo ( 255, 750 )
    end)
    :ibOnLeave ( function ( ) 
        self.elements.alpha:ibAlphaTo ( 0, 750 )
    end)

    self.Get = function ( self, i )
        if i == 1 then
            return self.elements.btn
        elseif i == 2 then
            return self.elements.alpha
        elseif i == 3 then
            return self.elements.text
        end
        return false;
    end

    self.Destroy = function ( self )
        DestroyTableElements ( self.elements )
        setmetatable ( self, nil )

        self.elements = { }
        self = { }
    end

    self.Change = function ( self, i, value )
        if i == 'text' and self.text then
            self.elements.text:ibData ( 'text', tostring ( value ) );
        elseif i == 1 then
            self.elements.btn:ibData ( 'texture', value or nil );
        elseif i == 2 then
            self.elements.btn:ibAlphaTo ( tonumber ( value ), 750 );
        elseif i == 3 then
            self.elements.btn:ibAlphaTo ( tonumber ( value ), 750 );
        end
    end

    self.elements.btn:ibOnClick ( function ( key, state ) 
        if key == 'left' and state == 'up' then
            if self.fn then self:fn ( ) end
        end
    end)

    return self
end

Player.ShowInfo = function ( self, ... )
    return exports.hud_notify:notify ( 'Информация', ..., 3000 )
end

Player.ShowError = function ( self, ... )
    return exports.hud_notify:notify ( 'Ошибка', ..., 3000 )
end

Player.Notify = function ( self, ... )
    return exports.hud_notify:notify (  ... )
end

local __fonts = {}

mta_dxGetTextWidth = dxGetTextWidth
function dxGetTextWidth(text, scale, font, colored)
    if real_sx and sx then
        return mta_dxGetTextWidth( text, scale, getFontElement(font), colored ) * sx/real_sx
    else
        return mta_dxGetTextWidth( text, scale, getFontElement(font), colored )
    end
end

mta_dxGetFontHeight = dxGetFontHeight
function dxGetFontHeight(scale, font)
    if real_sx and sx then
        return mta_dxGetFontHeight( scale, getFontElement(font) ) * sx/real_sx
    else
        return mta_dxGetFontHeight( scale, getFontElement(font) )
    end
end

function clearFonts()
    for index, font in pairs(__fonts) do
        if isElement(font) then
            destroyElement(font)
            __fonts[index] = nil
        end
    end
end

function getFontElement(tbl)

    if isElement(tbl) or type(tbl) == 'string' then
        return tbl
    end

    local font, _scale, type, mtaDraw = unpack(tbl)

    local scale = _scale
    
    local fontIndex = font..scale..type
    if __fonts[fontIndex] then
        return __fonts[fontIndex]
    end

    __fonts[fontIndex] = exports.fonts:getFont(font, scale, type)
    return __fonts[fontIndex]
end

function getFont(...)
    if GUI_MODULE_UTILS then
        return {...}
    else
        return getFontElement({...})
    end
end

function ibCustomButton( conf )
    local self = conf or { }

    self.x = self.x or 0
    self.y = self.y or 0
    self.sx = self.sx or 0
    self.sy = self.sy or 0
    self.parent = self.parent or nil
    self.texture = self.texture or nil
    self.hover = self.hover or nil
    self.click = self.click or nil
    self.color = self.color or tocolor( 255, 255, 255, 255 )
    self.colorHover = self.activeColor or self.color

    self.elements = { }

    self.elements.btn = ibCreateImage( self.x, self.y, self.sx, self.sy, self.texture, self.parent, self.color )
    	
    if not self.empty_disabled then
    	ibCreateImage( 0, 0, 0, 0, self.empty or ":core/assets/images/gui_dialog/btn_empty_shadow.png", self.elements.btn, self.colorHover ):ibSetRealSize():center( ):ibData( "disabled", true )
    end

    if not self.shadow_disabled then
    	ibCreateImage( 0, 0, 0, 0, self.shadow or ":core/assets/images/gui_dialog/btn_shadow.png", self.elements.btn, self.colorHover ):ibSetRealSize():center( ):ibData( "disabled", true )
    end
    self.elements.active = ibCreateImage( 0, 0, self.sx, self.sy, self.hover, self.elements.btn, self.color ):center( ):ibData( "alpha", 0 ):ibData( "disabled", true )


    if self.realsize then
    	self.elements.btn:ibSetRealSize( )
    	self.elements.btn:ibBatchData( { px = self.x, py = self.y } )
    	self.elements.active:ibSetRealSize( )
    	self.elements.active:center( )
    end

    ibCreateLabel( 0, 0, self.sx, self.sy, self.btn_text or "Продолжить", self.elements.btn, COLOR_WHITE, 0.5, 0.5, "center", "center", getFont('montserrat_semibold', 21, 'light') ):ibData( "disabled", true )


    self.Destroy = function( self )
    	DestroyTableElements( self.elements )
    	setmetatable( self, nil )
	end

	self.elements.btn
	:ibOnHover( function( ) 
		self.elements.active:ibAlphaTo( 255, 500 )

		if self.hover == self.texture then
			self.elements.active:ibColorTo( self.colorHover )
		end
	end)
	:ibOnLeave( function( ) 
		self.elements.active:ibAlphaTo( 0, 500 )
	end)
	:ibOnClick( function( key, state ) 
		if key == "left" and state == "up" then
			if self.fn then self:fn( ) end
			ibClick()
		end
	end)

    return self.elements.btn
end

sx,sy = 1920, 1080
real_sx,real_sy = _SCREEN_X, _SCREEN_Y
local drawScale = 1

function px(value)
	return math.floor(value*(real_sx/sx)*drawScale)
end

function px_y(value)
	return math.floor(value*(real_sy/sy)*drawScale)
end

function ibDialog( conf )
	local self = conf or { }
	
	if not isCursorShowing( ) then
		showCursor( true )
		self.cursor = true
	end

	local padding_h = 0

	self.type = self.type or "input"

	self.elements = { }

	self.elements.background = ibCreateWindow( _, true ):ibData( "alpha", 0 ):ibAlphaTo( 255, 500 )

	self.elements.bg = ibCreateImage( 0, 0, 419, 241, ":core/assets/images/gui_dialog/bg.png", self.elements.background, tocolor( 24, 30, 66 ) ):center_x()
	self.elements.gradient = ibCreateImage( 0, 0, 419, 241, ":core/assets/images/gui_dialog/bg.png", self.elements.bg ):ibData( "gradient", true )

	self.elements.lbl_title = ibCreateLabel( 0, 20, 419, 35, self.title or "Информация", self.elements.bg, COLOR_WHITE, 0.5, 0.5, "center", "top", getFont('montserrat_semibold', 26, 'light') )
	:ibBatchData( { disabled = true, wordbreak = true } )
	self.elements.lbl_text = ibCreateLabel( 0, self.type == "confirm" and 65 or 57, 419, self.type == "confirm" and 65 or 57, self.text or "Это просто текст понял да?", self.elements.bg, COLOR_WHITE, 0.5, 0.5, "center", "top", getFont('montserrat_medium', 21, 'light') )
	:ibBatchData( { disabled = true, wordbreak = true } )

	Destroy = function( )
		DestroyTableElements( self.elements )
		setmetatable( self, nil )
		if self.cursor then showCursor( false ) end
	end

	if self.type == "confirm" then
		ibCustomButton( {
			x = 50,
			y = 160,
			sx = 153,
			sy = 41,
			color = tocolor( 180, 70, 70, 255 ),
			texture = ":core/assets/images/gui_dialog/btn_empty.png",
			hover = ":core/assets/images/gui_dialog/btn.png",
			parent = self.elements.bg,
			btn_text = "Продолжить",
			fn = function( _self )
				self.Destroy = function( self )
					_self:Destroy( )
					DestroyTableElements( self.elements )
					setmetatable( self, nil )
					if self.cursor then showCursor( false ) end
				end

				if self.fn then
					self:fn()
				end
			end,
		} )

		ibCustomButton( {
			x = 50 + 170,
			y = 160 ,
			sx = 153,
			sy = 41,
			color = tocolor( 180, 70, 70, 255 ),
			texture = ":core/assets/images/gui_dialog/btn_empty.png",
			hover = ":core/assets/images/gui_dialog/btn.png",
			parent = self.elements.bg,
			btn_text = "Отмена",
			fn = function( _self )
				self.Destroy = function( self )
					_self:Destroy( )
					DestroyTableElements( self.elements )
					setmetatable( self, nil )
					if self.cursor then showCursor( false ) end
				end

				if self.fn_cancel then
					self:fn_cancel( )
				end
				self:Destroy( )
			end,
		} )
		padding_h = padding_h - 25
	elseif self.type == "input" then
		local data = self.edit or { }

		for i, v in pairs( data ) do
			self.elements.edit_bg = ibCreateImage( 0, 55 * ( i - 1 ) + 95, 317, 41, ":core/assets/images/gui_dialog/input.png", self.elements.bg, tocolor(29, 37, 73) ):center_x( )
			self.elements[ "edit_placeholder_"..i ] = ibCreateLabel( v.placeholder_center and 0 or 10, 0, v.placeholder_center and 317 or 0, 41, v.placeholder or "Напиши...", 
				self.elements.edit_bg, v.placeholder_color or COLOR_WHITE, 0.5, 0.5, v.placeholder_center and "center" or _, "center", v.placeholder_font or getFont('montserrat_semibold', 21, 'light') ):ibData( "disabled", true )

			self.elements[ "edit_"..i ] = ibCreateEdit( 0, 0, 305, 41, "", self.elements.edit_bg, COLOR_WHITE, 0, COLOR_WHITE )
			:ibBatchData( {
				align_x = v.placeholder_center and "center" or "left",
				font = v.font or getFont('montserrat_semibold', 22, 'light'),
				scale_x = 0.5,
				scale_y = 0.5,
			} )

			self.elements["edit_"..i]:ibOnFocusChange( function( state ) 
				local text = self.elements[ "edit_placeholder_"..i ]
				local visible = text:ibData( "visible" )
				if state then
					if visible then
						text:ibData( "visible", false )
					end
				else
					if source:ibData( "text" ) == "" then
						text:ibData( "visible", true )
					end
				end
			end)

			if v.onEditChange then
				self.elements[ "edit_"..i ]
				:ibOnDataChange( function( key, value ) 
					if key == ( v.onEditChangeKey or "text" ) then
						local value = source:ibData( "text" )
						v.onEditChange( self.elements[ "edit_"..i ], value )
					end
				end)
			end

			padding_h = padding_h + (#data >= 3 and 30 or 20 )
		end

		ibCustomButton( {
			x = 50,
			y = 170 + padding_h + 10,
			sx = 153,
			sy = 41,
			color = tocolor( 180, 70, 70, 255 ),
			texture = ":core/assets/images/gui_dialog/btn_empty.png",
			hover = ":core/assets/images/gui_dialog/btn.png",
			parent = self.elements.bg,
			btn_text = "Продолжить",
			fn = function( _self )

				self.Destroy = function( self )
					_self:Destroy( )
					DestroyTableElements( self.elements )
					setmetatable( self, nil )
					if self.cursor then showCursor( false ) end
				end

				if self.fn then
					self:fn()
				end
			end,
		} )

		ibCustomButton( {
			x = 50 + 170,
			y = 170 + padding_h + 10,
			sx = 153,
			sy = 41,
			color = tocolor( 180, 70, 70, 255 ),
			texture = ":core/assets/images/gui_dialog/btn_empty.png",
			hover = ":core/assets/images/gui_dialog/btn.png",
			parent = self.elements.bg,
			btn_text = "Отмена",
			fn = function( _self )
				self.Destroy = function( self )
					_self:Destroy( )
					DestroyTableElements( self.elements )
					setmetatable( self, nil )
					if self.cursor then showCursor( false ) end
				end

				if self.fn_cancel then
					self:fn_cancel( )
				end
				self:Destroy( )
			end,
		} )

	end

	for i, v in pairs( { self.elements.bg, self.elements.gradient } ) do
		local sy = v:ibData( "sy" ) + padding_h
		v:ibData( "sy", sy )
		v:center( )
	end

	return self
end