-- client_notify - Уведомления

local font = DxFont ( 'assets/fonts/hb.ttf', 12 )

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
    if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
        local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
        if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
            for i, v in ipairs( aAttachedFunctions ) do
                if v == func then
                    return true
                end
            end
        end
    end
    return false
end

local max_messages = 7
local messages = { }
local timeout = 4 -- 4 seconds

local _SCREEN_X, _SCREEN_Y = guiGetScreenSize ( )

function updatePositionsOfMessages( )
	for index, message in pairs( messages ) do
		--if message.disabled then removeMessage ( i ) end
		local newY = index * 120
		message.pos_y = newY - 130
	end
end

function removeMessage( index )
	if not index then index = #messages end -- if not index, then remove last message

	table.remove( messages, index )

	--if #messages ~= 0 then
		updatePositionsOfMessages( )
	--end
end

function addMessage ( text, img )
	local img = img or false

	if #messages >= max_messages then removeMessage( ) end

	table.insert ( messages, {
		text = text,
		tick = getTickCount ( ),
		color = color or tocolor ( 255, 255, 255 ),
		img = img,
	} )
	updatePositionsOfMessages ( )
	if not isEventHandlerAdded ( 'onClientRender', root, drawMessage ) then
		addEventHandler ( 'onClientRender', root, drawMessage )
	end
end


function drawMessage ( )
	local tick = getTickCount ( )

	for i, v in pairs ( messages ) do
		if not v.disabled then
			local width = dxGetTextWidth ( v.text, 2, 'default-bold' )
			if width >= 100 then
				width = 200
			else
				width = width + 50
			end

			local alpha = interpolateBetween ( 0, 0, 0, 255, 0, 0, ( getTickCount ( ) - v.tick ) / 1000, 'OutQuad' )
			local y 	= interpolateBetween ( -100, 0, 0, v.pos_y, 0, 0, ( getTickCount ( ) - v.tick ) / 700, 'OutQuad' )
			local x 	= _SCREEN_X / 2 - 150 / 2

			dxDrawImage ( _SCREEN_X / 2 - width / 2, y, 150, 150, v.img or 'assets/images/bon.png', 0, 0, 0, tocolor ( 255, 255, 255, alpha ) )
			dxDrawText ( 'Нажми '..utf8.upper ( KEY_TAKE )..', что бы забрать '..v.text, x, y + 130, x + 100, y + 150, tocolor ( 255, 255, 255, alpha ) , 1, font, 'center' )


			local n_tick = v.tick + timeout * 1000

			if tick >= n_tick then
				v.pos_y = interpolateBetween ( v.pos_y, 0, 0, -200, 0, 0, ( tick - n_tick ) / 5000, 'OutQuad' )
				Timer ( function ( ) 
					v.disabled = true
				end, 200, 1)
			end
		end
	end

	if #messages <= 0 then
		removeEventHandler ( 'onClientRender', root, drawMessage )
	end
end

Player.ShowInfo = function ( self, text, img, color )
	addMessage ( text, img, color )
end

addEvent ( 'addMessage', true )
addEventHandler ( 'addMessage', resourceRoot, addMessage )

Timer ( function ( ) 
	if #messages > 0 then
		for i, v in pairs ( messages ) do
			if v.disabled then
				removeMessage ( i )
			end
		end
	end
end, 100, 0)