

cancelButtons = {
	['f1'] = true,
	['f2'] = true,
	['f3'] = true,
	['f4'] = true,
	['f5'] = true,
	['f11'] = true,
	['f10'] = true,
	['f4'] = true,
	['f9'] = true,
	['k'] = true,
	['m'] = true,
	['i'] = true,
}



openHandler = function()
end

closeHandler = function()
end

hideBackground = true

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'image',
			0, 0, real_sx, real_sy,
			mtaDraw = true,
			'assets/images/imgbg.png',
			color = {255,255,255,255},
			anim_fix = true,
		},

		{'image',

			'center', 'center',
			387, 312,
			'assets/images/bg.png',
			color = {32,35,66,255},

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 405/2,
					y + h/2 - 330/2 + 5,
					405, 330, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
				)

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawText('Выберите место спавна',
					x, y+30, x+w, y+30,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 28, 'light'),
					'center', 'top'
				)

			end,

			elements = {
				{'element',
					'center', 60,
					'100%', 235,
					color = {255,255,255,255},
					id = 'gui-manager',

					addEvent('play.spawn_select.displayError', true),
					addEventHandler('play.spawn_select.displayError', resourceRoot, function(text)
						gui_get('gui-manager'):displayError(text)
					end),

					displayError = function(element, text)

						clearTableElements(element.error or {})

						animate(element.err_anim, 1)

						element.error = {
							timer = setTimer(function()
								animate(element.err_anim, 0)
							end, 3500, 1),
							text = text,
						}

					end,

					onRender = function(element)

						local x,y,w,h = element:abs()

						local animData = getAnimData(element.err_anim)

						if element.error then

							local x,y,w,h = element.parent:abs()
							local alpha = element:alpha()

							dxDrawText(element.error.text,
								x, y+h+10,
								x+w, y+h+10,
								tocolor(180, 70, 70, 255*alpha*animData),
								0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
								'center', 'top'
							)

						end

					end,

					clear = function(element)

						for _, c_element in pairs( element.elements or {} ) do
							c_element:destroy()
						end

						element.elements = {}

					end,

					update = function(element)

						element:clear()

						local buttons = {

							{ name = 'Место выхода', action = 'last_exit', icon = 'assets/images/select_last_exit.png' },
							{ name = 'Мой дом', action = 'home', icon = 'assets/images/select_home.png' },
							{ name = 'Спавн', action = 'spawn', icon = 'assets/images/select_spawn.png' },

						}

						local bw,bh = 304, 51
						local padding = 14
						local startY = 20
						element.parent[5] = 312

						if localPlayer.team and exports.teams_main:getClanMansion( localPlayer.team ) then
							table.insert( buttons, { name = 'Особняк клана', action = 'mansion', icon = 'assets/images/select_mansion.png' } )
							startY = 10
							padding = 10
							element.parent[5] = 340
						end

						for index, button in pairs( buttons ) do

							element:addElement(
								{'button',
									'center', startY,
									bw,bh,
									button.name,

									bg = 'assets/images/btn_empty.png',
									activeBg = 'assets/images/btn.png',

									onPreRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										local shx,shy,shw,shh = x + w/2 - 322/2, y + h/2 - 68/2, 322, 68

										dxDrawImage(
											shx,shy,shw,shh, 'assets/images/btn_empty_shadow.png',
											0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
										)
										dxDrawImage(
											shx,shy,shw,shh, 'assets/images/btn_shadow.png',
											0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
										)

									end,

									onInit = function(element)
										element.h_anim = {}
										setAnimData(element.h_anim, 0.05)
									end,

									onHover = function(element)
										setAnimData(element.h_anim, 0.05)
										animate(element.h_anim, 1)
									end,

									onRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										dxDrawImage(
											x+w-45,y+h/2-30/2,
											30, 30, element.icon,
											0, 0, 0, tocolor(255,255,255,255*alpha)
										)

										local animData = getAnimData(element.h_anim)

										drawImageSection(
											x,y,w,h, element.activeBg,
											{ x = animData, y = 1 }, tocolor( 200, 90, 90, 255*alpha*(1-animData) )
										)

									end,

									onClick = function(element)

										local x,y,w,h = element.parent:abs()

										animate(element.animationAlpha, 0)
										displayLoading( {x+w/2-60/2, y+h/2-60/2, 60, 60}, {180,70,70,255}, 1000, function()

											animate(element.animationAlpha, 1)

											triggerServerEvent('play.spawn_select.selectSpawn', resourceRoot, element.action)

										end )

									end,

									icon = button.icon,
									action = button.action,

									color = {180, 70, 70, 255},

									scale = 0.5,
									font = getFont('montserrat_bold', 24, 'light'),

									animationAlpha = element.c_anim,

								}
							)

							startY = startY + bh + padding

						end

						element:addElement(
							{'element', 0, startY, '100%', 2, color = {255,255,255,255}}
						)

					end,

					onInit = function(element)

						local x,y,w,h = element:abs()

						element.y0 = element[3]
						element.err_anim = {}
						setAnimData(element.err_anim, 0.1, 0)

						element.c_anim = {}
						setAnimData(element.c_anim, 0.1, 1)

						element:update()

						openHandlers.buttons = function()
							gui_get('gui-manager'):update()
						end

					end,

					elements = {},

				},
			},


		},

	},

}

loadGuiModule()

end)
