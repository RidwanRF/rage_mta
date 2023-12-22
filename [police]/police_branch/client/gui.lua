

openHandler = function()
end
closeHandler = function()
end
addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'image',
			'center', 'center',
			629, 456,

			color = {24,30,66, 255},
			'assets/images/bg.png',


			onPreRender = function(element)

				local alpha = getElementDrawAlpha(element)
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 474/2,
					y + h/2 - 474/2 + 5,
					647, 474, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
				)


			end,

			onRender = function(element)

				local alpha = getElementDrawAlpha(element)
				local x,y,w,h = element:abs()

				dxDrawImage(
					x,y,w,h, 'assets/images/police_icon.png',
					0, 0, 0, tocolor(255,255,255,255*alpha)
				)

				dxDrawText('Полицейский участок',
					x + 70, y + 40,
					x + 70, y + 40,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 28, 'light'),
					'left', 'top'
				)

				dxDrawImage(
					x + 60, y + 60,
					58, 22,
					'assets/images/hline.png',
					0, 0, 0, tocolor(180, 70, 70, 255*alpha)
				)


			end,

			elements = {

				{'button',

					0, 0, 26, 26,
					bg = 'assets/images/close.png',
					activeBg = 'assets/images/close_active.png',
					define_from = '',

					'',

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					onInit = function(element)

						element[2] = element.parent[4] - element[4] - 20
						element[3] = 25

					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x,y,w,h, 'assets/images/close_icon.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

					end,

					onClick = closeWindow,

				},

				{'element',
					80, 100,
					200, 0,
					color = {255,255,255,255},

					elements = {

						{'input',
							'center', 50,
							200, 41,
							'',
							bg = 'assets/images/input.png',

							color = {29, 37, 73, 255},
							placeholderColor = {85, 89, 111, 255},

							placeholder = 'Сумма',
							alignX = 'center',
							scale = 0.5,
							font = getFont('montserrat_semibold', 25, 'light'),

							type = 'number',

							id = 'sum-input',

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								dxDrawText('Сумма штрафов',
									x, y - 35 + 2,
									x+w, y - 35 + 2,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
									'center', 'bottom'
								)
								dxDrawText(string.format('%s #b64747$',
									splitWithPoints( localPlayer:getData('police.withdraws') or 0 , '.')
								),
									x, y - 35 - 2 + 2,
									x+w, y - 35 - 2 + 2,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
									'center', 'top', false, false, false, true
								)

							end,

						},

						{'element',

							'center', 110,
							'100%', 90,

							color = {255,255,255,255},

							elements = {

								{'button',
									'center', 'top',
									200, 41,
									'Оплатить',
									bg = 'assets/images/btn_empty.png',
									activeBg = 'assets/images/btn.png',

									scale = 0.5,
									font = getFont('montserrat_semibold', 23, 'light'),

									color = {180, 70, 70, 255},
									activeColor = {200, 70, 70, 255},

									onPreRender = function(element)

										local alpha = getElementDrawAlpha(element)

										local x,y,w,h = getElementAbsoluteOffset(element)

										local shx,shy,shw,shh = x + w/2 - 237/2, y + h/2 - 91/2, 237, 91

										dxDrawImage(
											shx,shy,shw,shh, 'assets/images/btn_empty_shadow.png',
											0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
										)
										dxDrawImage(
											shx,shy,shw,shh, 'assets/images/btn_shadow.png',
											0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
										)

									end,

									onClick = function(element)

										local x,y,w,h = element.parent:abs()

										animate('withdraws-button', 0)
										local size = 40

										displayLoading( {x+w/2-size/2, y+h/2-size/2, size, size}, {180,70,70,255}, 1500, function()

											animate('withdraws-button', 1)

											local sum = tonumber( gui_get('sum-input')[6] )
											if not sum then return end

											triggerServerEvent('police.payWithdraws', resourceRoot, sum)

										end )

									end,

									setAnimData('withdraws-button', 0.1, 1),

									animationAlpha = 'withdraws-button',

								},

								{'button',
									'center', 'bottom',
									200, 41,
									'Оплатить все',
									bg = 'assets/images/btn_empty.png',
									activeBg = 'assets/images/btn.png',

									scale = 0.5,
									font = getFont('montserrat_semibold', 23, 'light'),

									color = {180, 70, 70, 255},
									activeColor = {200, 70, 70, 255},

									onPreRender = function(element)

										local alpha = getElementDrawAlpha(element)

										local x,y,w,h = getElementAbsoluteOffset(element)

										local shx,shy,shw,shh = x + w/2 - 237/2, y + h/2 - 91/2, 237, 91

										dxDrawImage(
											shx,shy,shw,shh, 'assets/images/btn_empty_shadow.png',
											0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
										)
										dxDrawImage(
											shx,shy,shw,shh, 'assets/images/btn_shadow.png',
											0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
										)

									end,

									onClick = function(element)

										local x,y,w,h = element.parent:abs()

										animate('withdraws-button', 0)
										local size = 40

										displayLoading( {x+w/2-size/2, y+h/2-size/2, size, size}, {180,70,70,255}, 1500, function()

											animate('withdraws-button', 1)

											local sum = localPlayer:getData('police.withdraws') or 0
											if not sum then return end

											triggerServerEvent('police.payWithdraws', resourceRoot, sum)

										end )

									end,

									animationAlpha = 'withdraws-button',

								},


							},

						},

						{'button',
							'center', 280,
							200, 41,
							'Снять звезды',
							bg = 'assets/images/btn_empty.png',
							activeBg = 'assets/images/btn.png',

							scale = 0.5,
							font = getFont('montserrat_semibold', 23, 'light'),

							color = {180, 70, 70, 255},
							activeColor = {200, 70, 70, 255},

							onPreRender = function(element)

								local alpha = element:alpha()

								local x,y,w,h = element:abs()

								local shx,shy,shw,shh = x + w/2 - 237/2, y + h/2 - 91/2, 237, 91

								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/btn_empty_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
								)
								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/btn_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
								)

							end,

							onClick = function(element)

								local x,y,w,h = element:abs()

								animate('stars-button', 0)
								local size = 40
								displayLoading( {x+w/2-size/2, y+h/2-size/2, size, size}, {180,70,70,255}, 1500, function()

									triggerServerEvent('police.clearStars', resourceRoot)
									animate('stars-button', 1)

								end )

							end,

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()
								local animData = getAnimData('stars-button')
								alpha = alpha*animData

								local stsize = 25
								local padding = 0
								local sCount = 2.5

								local startX = x+w/2 - stsize*sCount - padding*(sCount-0.5)
								local startY = y - 60

								local stars = localPlayer:getData('police.stars') or 0

								for i = 1,5 do

									dxDrawImage(
										startX, startY,
										stsize, stsize, 'assets/images/star.png',
										0, 0, 0, i <= stars and tocolor(255, 220, 100, 255*alpha) or tocolor(10, 15, 30, 255*alpha)
									)

									startX = startX + stsize + padding

								end

								dxDrawText(string.format('Снять звезды - #ffdc64%s $',
									splitWithPoints(Config.starCost * stars, '.')
								),
									x, y - 10,
									x+w, y - 10,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
									'center', 'bottom', false, false, false, true

								)

							end,

							setAnimData('stars-button', 0.1, 1),

							animationAlpha = 'stars-button',

						},

					},

				},

			},

		},

	},

}


----------------------------------------------------------------------

loadGuiModule()


end)

