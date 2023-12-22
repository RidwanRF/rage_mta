


openHandler = function()
	showCursor(false)
end
closeHandler = function()
end

addEventHandler('onClientResourceStart', resourceRoot, function()

hideBackground = true
blurBackground = false
windowPriority = 'low-5'
clearGuiTextures = false

windowModel = {
	
	main = {

		{'image',
			mtaDraw = true,
			0, 0, real_sx, real_sy,
			color = {0, 0, 0, 255},
			anim_fix = true,
			'assets/images/gradient.png',
		},

		{'element',
			sx, 'center',
			0, 300,
			color = {255,255,255,255},

			controls = {
				{ button = 'F1', control = 'Главное меню' },
				{ button = 'F2', control = 'Помощь и подсказки' },
				{ button = 'F3', control = 'Управление автомобилем' },
				{ button = 'F9', control = 'Личные сообщения' },
				{ button = 'F11', control = 'Игровая карта' },

				{ button = '1', control = 'Починить автомобиль' },
				{ button = '2', control = 'Восстановить автомобиль' },
				{ button = '6', control = 'Вид от первого лица' },
				
				{ button = 'X', control = 'Панель быстрого доступа' },
				{ button = 'M', control = 'Музыкальный плеер' },
				{ button = 'Z', control = 'Закрыть подсказки' },
			},

			onKey = { z = closeWindow, },

			onRender = function(element)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				local itemw, itemh = 294, 58
				local padding = 10

				local sCount = #element.controls/2

				local startY = sy/2 - itemh*sCount - padding*(sCount-0.5)

				x = x - (itemw + 100)*windowAlpha

				for _, control in pairs( element.controls ) do

					dxDrawImage(
						x, startY,
						itemw, itemh,
						'assets/images/bg.png', 0, 0, 0, 
						tocolor(32,35,66,255*alpha)
					)

					local buttons = {}

					if type(control.button) == 'string' then
						buttons = {control.button}
					elseif type(control.button) == 'table' then
						buttons = control.button
					end

					local startX = x - 5
					local bw,bh = 77,77
					local by = startY + itemh/2 - bh/2

					for _, button in pairs( buttons ) do

						dxDrawImage(
							startX,by,bw,bh, 'assets/images/btn.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha)
						)

						dxDrawText(button,
							startX,by,startX+bw,by+bh,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
							'center', 'center'
						)

						startX = startX + 45

					end

					startX = startX + 25

					dxDrawText(control.control,
						startX,by,startX,by+bh,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
						'left', 'center'
					)

					startY = startY + itemh + padding

				end

			end,

		},

	},

}


loadGuiModule()

end)
