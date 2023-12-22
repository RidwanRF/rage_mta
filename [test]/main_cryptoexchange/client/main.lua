local realTime = getRealTime ( )
day, month = realTime.monthday, strings.months[realTime.month+1]
ui = { }
scx, scy = guiGetScreenSize ( )

loadstring ( exports.lib:extend ( 'Interfacer' ) ) ( )
Extend ( 'ib' )
Extend ( 'ShUtils' )

local key_timer = nil

sssx,sssy = 1920, 1080
real_sx,real_sy = scx, scy
function px(value)
	return math.floor(value*(real_sx/sssx)*1)
end

function px_noround(value)
	return value*(real_sx/sssx)*1
end

function ShowCryptUI ( )
	if isTimer ( key_timer ) then
		ShowUI ( not isElement ( ui.bg ) )
	else
		key_timer = Timer ( function ( ) 
			if isTimer ( key_timer ) then killTimer ( key_timer ) end
		end, 15000, 1)
		triggerServerEvent ( 'UpdateServerData', resourceRoot )
	end
end
addEvent ( 'ShowCryptUI', true )
addEventHandler ( 'ShowCryptUI', root, ShowCryptUI )

bindKey('f5', 'down', ShowCryptUI )

local _FONTS = { }
_dxCreateFont = dxCreateFont
function dxCreateFont ( ... )
	return _dxCreateFont ( ... )
end

function Font ( font, size )
	if _FONTS [ font ] and _FONTS [ font ].size == size then
		return _FONTS [ font ].real_font;
	end
	local font = font or 'Semibold'
	local size = size or 15

	_FONTS [ font ] = {
		font = font;
		size = size;
		real_font = dxCreateFont ( 'fonts/ProximaNova-'..font..'.ttf', px_noround ( size ), false, "antialiased" )
	}

	return _FONTS [ font ].real_font;
end

DATA = { }
CACHE = { }

addEvent ( 'UpdateData', true )
addEventHandler ( 'UpdateData', resourceRoot, function ( data, showing ) 
	DATA = data;
	if showing then
		ShowUI ( not isElement ( ui.bg ) )
	end
end)

function ExplodeValue ( id, value )
	local value = value or localPlayer:GetCryptValue ( id ) or 0
	if value == -0 or value == '-0' then value = 0 end
	local course = DATA [ id ].course
	if not course then return false end
	return value * course == -0 and 0 or value * course
end


addEventHandler ( 'onClientClick', root, function ( key, state ) 
	if ibGetHoveredElement ( ) and key == 'left' and state == 'down' then
		local res = getResourceFromName ( 'main_sounds' )
		if res and res.state == 'running' then
			exports.main_sounds:playSound( 'checkbox' )
		end
	end
end)