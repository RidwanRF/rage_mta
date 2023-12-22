-- Плавно переходим на DGS, т.к. это более удобный и оптимальный вариант
-- Нагрузка будет значительно меньше


_SCREEN_X,      _SCREEN_Y      = guiGetScreenSize( )
_SCREEN_X_HALF, _SCREEN_Y_HALF = _SCREEN_X / 2, _SCREEN_Y / 2

local _SCREEN_X,      _SCREEN_Y      = _SCREEN_X,      _SCREEN_Y
local _SCREEN_X_HALF, _SCREEN_Y_HALF = _SCREEN_X_HALF, _SCREEN_Y_HALF

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
                    if _IB_FONTS_ADAPT then font_size = adapt( font_size, true ) end

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


local _DGS_RESOURCE_NAME = "dgs"

local _DGS_RESOURCE = getResourceFromName( _DGS_RESOURCE_NAME )

if _DGS_RESOURCE then
	loadstring( exports.dgs:dgsImportFunction( ) )( )

	function GetY( self )
		local px, py = dgsGetPosition( self )
		return py
	end

	function GetX( self )
		local px, py = dgsGetPosition( self )
		return px
	end

	Element.center = function( self, ox, oy )
		local parent = dgsGetParent( self )
		local px, py = _SCREEN_X, _SCREEN_Y
		local sx, sy = dgsGetSize( self )
		if parent then
			px, py = dgsGetSize( parent )
		end
		dgsSetPosition( self, math_floor( px / 2 - sx / 2 + ( ox or 0 ) ), math_floor( py / 2 - sy / 2 + ( oy or 0 ) ) )
		return self
	end

	Element.center_x = function( self, ox )
		local parent = dgsGetParent( self )
	    local px = _SCREEN_X
	    local sx = dgsGetSize( self )
	    if parent then px = dgsGetSize( parent ) end
	    dgsSetPosition( self, math_floor( px / 2 - sx / 2 + ( ox or 0 ) ) )
	    return self
	end

	Element.center_y = function( self, oy )
		local parent = dgsGetParent( self )
	    local scy = _SCREEN_Y
	    local sx, sy = dgsGetSize( self )
	    if parent then scy = GetY( parent ) end
	    dgsSetPosition( self, GetX( self ), math_floor( scy / 2 - sy / 2 + ( oy or 0 ) ) )
	    return self
	end

	Element.width = function( self )
		local sx, sy = dgsGetSize( self )

		return sx
	end

	Element.height = function( self )
		local sx, sy = dgsGetSize( self )

		return sy
	end

	Element.dgsData = function( self, key, value )
		dgsSetProperty( self, key, value )

		return self
	end

	Element.dgsBatchData = function( self, list )
		dgsSetProperties( self, list )
	end

	local _dgsCreateImage 		= 	dgsCreateImage
	local _dgsCreateLabel 		= 	dgsCreateLabel
	local _dgsCreateButton 		= 	dgsCreateButton
	local _dgsCreateEdit 		= 	dgsCreateEdit
	local _dgsCreateScrollPane 	= 	dgsCreateScrollPane
	local _dgsCreateMemo 		= 	dgsCreateMemo
	local _dgsCreateGridList 	= 	dgsCreateGridList

	function dgsCreateImage( x, y, width, height, texture, parent, color )
		return _dgsCreateImage( x, y, width, height, texture, false, parent, color )
	end

	function dgsCreateLabel( x, y, width, height, text, parent, color, scale_x, scale_y, align_x, align_y, font )
		local label = _dgsCreateLabel( x, y, width, height, text, false, parent, color, scale_x, scale_y, _, _, _, align_x, align_y )

		if font then dgsSetFont( label, font ) end

		return label
	end

	function dgsCreateButton( x, y, width, height, parent, defimg, selimg, cliimg, defcolor, selcolor, clicolor, text, textColor, font )
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

		local btn = _dgsCreateButton( x, y, width, height, text, false, parent, textColor, _, _, defimg, selimg, cliimg, defcolor, selcolor, clicolor )

		if font then dgsSetFont( btn, font ) end

		return btn
	end

	function dgsCreateEdit( x, y, width, height, text, placeholder, parent, image, color )

		local edit = _dgsCreateEdit( x, y, width, height, text, false, parent, _, _, _, image, color )

		if placeholder then edit:dgsData( 'placeHolder', placeholder ) end

		return edit
	end

	function dgsCreateScrollPane( x, y, width, height, parent, conf )
		local conf = conf or { }
		local rt = _dgsCreateScrollPane( x, y, width, height, false, parent )
		local sc = dgsScrollPaneGetScrollBar( rt )
		if sc[ 2 ] and not conf.horizontal then dgsSetVisible( sc[ 2 ], false ) dgsScrollPaneSetScrollBarState( rt, true, false ) end
		if conf.horizontal and sc[ 1 ] then dgsSetVisible( sc[ 1 ], false ) dgsScrollPaneSetScrollBarState( rt, false, true ) end

		if conf and type( conf ) == 'table' then dgsSetProperties( rt, conf ) dgsSetProperties( conf.horizontal and sc[ 2 ] or sc[ 1 ], conf ) end

		dgsSetProperty( rt, 'moveHardness', { conf.sensivity or 0.1, conf.sensivity or 0.1 } )


		local cursorColor = conf.sc_color or tocolor( 180,70,70 )
		local bgColor = conf.bg_color or tocolor( 27,32,54 )

		dgsSetProperties( conf.horizontal and sc[ 2 ] or sc[ 1 ], {
			arrowWidth 		= 	{ 0, false },
			cursorWidth 	= 	{ 5, false },
			troughWidth 	= 	{ conf.sc_width or 5, false },
			troughColor 	= 	{ bgColor, bgColor },
			cursorColor 	= 	{ cursorColor, cursorColor, cursorColor },
		} )

		return rt, conf.horizontal and sc[ 2 ] or sc[ 1 ]
	end


	function dgsCreateArea( x, y, width, height, parent )
		return dgsCreateDetectArea( x, y, width, height, false, parent )
	end

	function dgsCreateMemo( x, y, width, height, parent, textColor, image, color )
		return _dgsCreateMemo( x, y, width, height, false, parent, textColor, _, _, image, color )
	end

	function dgsCreateGridList( x, y, width, height, parent, ... )
		return _dgsCreateGridList( x, y, width, height, false, parent, ... )
	end

	local _EVENTS_LIST = {
	    onDgsMouseClick    		 = 		"dgsOnClick",
	    onDgsMouseHover    		 = 		"dgsOnHover",
	    onDgsMouseLeave    		 = 		"dgsOnLeave",
	    onClientElementDestroy   = 		"dgsOnDestroy",
	}

	for i, v in pairs( _EVENTS_LIST ) do
	    Element[ v ] = function( self, fn, is_propagated )
	        addEventHandler( i, self, fn, is_propagated )
	        return self
	    end
	end


	Element.dgsAlphaTo = function( self, alpha, duration, bType )
		dgsAlphaTo( self, alpha or 1, bType or 'OutQuad', duration or 250 )

		return self
	end

end