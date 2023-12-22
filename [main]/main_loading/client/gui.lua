windowPriority = 'low-20'

openHandler = function()
	showChat(false)
end
closeHandler = function()
	showChat(true)
end

addEventHandler('onClientResourceStart', resourceRoot, function()


windowModel = {

	main = {
		{'image',
			mtaDraw = true,
			0, 0, real_sx, real_sy,
			color = {255,255,255,255},
			'assets/images/bg.png',

			onRender = function(element)
				local alpha = getElementDrawAlpha(element)

				dxDrawImage(
					sx/2 - 675/2, sy/2 - 337/2,
					675, 337,
					'assets/images/logo.png', 0, 0, 0,
					tocolor(255,255,255,255*alpha)
				)

				local y = (real_sy - px(100)) * sx/real_sx

				dxDrawImage(
					200, y,
					50, 50, 'assets/images/info.png',
					0, 0, 0, tocolor(190, 70, 70, 255*alpha)
				)

				dxDrawText('Обработка файлов кэша...',
					200 + 65, y,
					200 + 65, y + 50,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('proximanova_semibold', 40, 'light'),
					'left', 'center'

				)

				local x,y,w,h = sx/2 + 300, y + 50/2 - 8/2, 300, 8

				local percent = getLoadingState()


				dxDrawRectangle(
					x,y,w,h, tocolor(20, 20, 20, 255*alpha)
				)
				dxDrawRectangle(
					x,y,w*percent,h, tocolor(190, 70, 70, 255*alpha)
				)

			end,
		},

	},

}

loadGuiModule()

end)
