scx, scy = guiGetScreenSize ( );
ui = { };
width, height = 820, 550;
x, y = ( scx / 2 - width / 2 ), ( scy / 2 - height / 2 );
EVENT_PLAYERS = { };
EVENT_VEHICLES = { };
local input_visible = false;

function Input ( conf )
	if input_visible then return end
	input_visible = true
	local self = conf or { };

	self.edit_text = self.edit_text or 'Введи что то';
	self.w = self.w or 400;
	self.h = self.h or 250;
	self.text = self.text or 'Подтверждение';

	self.px = ( scx / 2 - self.w / 2 );
	self.py = ( scy / 2 - self.h / 2 );
	self.count = self.count or 1

	if self.mp then
		self.count = 2
	end

	self.elements = { };

	self.elements.bg = GuiWindow ( self.px, self.py, self.w, self.h, self.text, false )

	if self.count > 1 then
		for i = 1, self.count do
			self.elements [ 'edit_'..i ] = GuiEdit ( 50, 50 * ( i - 1 ) + 50, 300, 40, '', false, self.elements.bg )
		end
	else
		self.elements [ 'edit_'..1 ] = GuiEdit ( 50, 50, 300, 40, self.edit_text, false, self.elements.bg )
	end

	if self.mp then
		if self.count > 1 then
			for i = 1, self.count do
				self.elements [ 'edit_'..i ].text = i == 1 and 'Введи номер интерьера' or 'Введи измерение'
			end
		end
	end

	self.destroy = function ( self )
		if isElement ( self.elements.bg ) then self.elements.bg:destroy ( ) end
		setmetatable ( self, nil )
		input_visible = false
	end

	self.elements.ok = GuiButton ( 50, self.h - 70, 150, 55, 'Применить', false, self.elements.bg )
	self.elements.net = GuiButton ( 205, self.h - 70, 150, 55, 'Отмена', false, self.elements.bg )

	addEventHandler ( 'onClientGUIClick', root, function ( key, state ) 
		if key == 'left' and state == 'up' then
			if source == self.elements.ok then
				if self.mp then
					local interior = self.elements [ 'edit_'..1 ].text
					local dimension = self.elements [ 'edit_'..2 ].text
					if interior == '' or interior == 'Введи интерьер' then
						outputChatBox ( 'Введи интерьер', 255, 0, 0 )
						return
					end
					if dimension == '' or dimension == 'Введи измерение' then
						outputChatBox ( 'Введи измерение', 255, 0, 0 )
						return
					end
					self.interior = interior;
					self.dimension = dimension;
				else
					local value = self.elements [ 'edit_'..1 ].text
					if value == '' or value == self.edit_text then
						outputChatBox ( self.edit_text, 255, 0, 0 )
						return
					end
					self.value = value;
				end

				if self.fn then self:fn ( ) end
			elseif source == self.elements.net then
				self:destroy ( )
			end
		end
	end)
end


function isMouseInPosition (x, y, w, h)
    if isCursorShowing() then
        local mx, my = getCursorPosition()
        local cursorx, cursory = mx * scx, my * scy
        if cursorx > x and cursorx < x + w and cursory > y and cursory < y + h then
            return true
        end
    end
end

local BUTTON_ALPHA = {}
local BUTTON_COLOR_ACTIVE = tocolor(180,70,70, 255)
local font = DxFont ( 'manrope_semibold.ttf', 12.7 )
function dxCreateButton (x, y, w, h, image_state, image_hover, _alpha, index, text)
    if BUTTON_ALPHA[index] == nil then
        BUTTON_ALPHA[index] = {}
        BUTTON_ALPHA[index] = 0
    end
    
    if isMouseInPosition(x, y, w, h) then
        if BUTTON_ALPHA[index] <= 240 then
            BUTTON_ALPHA[index] = BUTTON_ALPHA[index] + 15
        end
        BUTTON_COLOR_ACTIVE = tocolor(180,70,70, BUTTON_ALPHA[index])
    else
        if BUTTON_ALPHA[index] ~= 0 then
            BUTTON_ALPHA[index] = BUTTON_ALPHA[index] - 15
        end
        BUTTON_COLOR_ACTIVE = tocolor(180,70,70, BUTTON_ALPHA[index])
    end

    dxDrawImage(x, y, w, h, image_state, 0, 0, 0, tocolor(180,70,70,_alpha))
    dxDrawImage(x, y, w, h, image_hover, 0, 0, 0, BUTTON_COLOR_ACTIVE)

    if text then
    	dxDrawText ( text, x, y, x + w, y + h, tocolor ( 255, 255, 255, _alpha ), 1, font, 'center', 'center' )
    end
end