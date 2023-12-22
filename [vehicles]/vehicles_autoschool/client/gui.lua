


openHandler = function()
end

closeHandler = function()
end


addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'image',
			'center', 'center',
			686, 482, 
			'assets/images/bg.png',
			color = {25,24,38, 255},

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 704/2,
					y + h/2 - 500/2 + 5,
					704, 500, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
				)

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local texture = getDrawingTexture(element[6])

				local gradient = getTextureGradient(texture, {
					color = {
						{ 0, 0, 0, 0 },
						{ 180, 70, 70, 20 },
					},
					alpha = alpha,
					angle = -30,	
				})

				dxDrawImage(
					x,y,w,h, gradient
				)

				local texture = getDrawingTexture('assets/images/icon_bg.png')
				local gradient = getTextureGradient(texture, {
					texture = texture,
					alpha = alpha,
					angle = -45,
					color = {
						{ 86, 56, 79, 255 },
						{ 180, 70, 70, 255 },
					},
				})

				local isize = 56,56

				dxDrawImage(
					x + 35, y + 25, isize, isize, gradient
				)

				dxDrawImage(
					x + 35, y + 25, isize, isize, 'assets/images/icon.png',
					0, 0, 0, tocolor(40, 40, 40, 255*alpha)
				)

				dxDrawText('Автошкола',
					x + 25 + isize + 15, y + 25,
					x + 25 + isize + 15, y + 25 + isize,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
					'left', 'center'
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

					'center', 100,
					'100%', 320,
					color = {255,255,255,255},

					scrollColor = {180, 70, 70,255},
					scrollBgColor = {15, 15, 27,255},
					scrollWidth = 7,
					scrollXOffset = -25,

					overflow = 'vertical',
					variable = 'licensesList',

					onInit = function(element)

						local categories = {
							{'B', 'C'},
							{'D', 'W'},
						}

						local startY = 0
						local w,h = 287,148

						for _, group in pairs( categories ) do

							local g_element = element:addElement(
								{'element',

									'center', startY,
									w*2+5+10, h+10,
									color = {255,255,255,255},

								}
							)

							for index, category in pairs( group ) do

								g_element:addElement(
									{'image',
										index == 1 and 'left' or 'right',
										5,
										w,h,

										color = {18,18,30,255},
										'assets/images/item_bg.png',

										category = category,
										category_data = Config.categories[category],

										onInit = function(element)

											element.l_anim = {}
											setAnimData(element.l_anim, 0.1)

										end,

										onRender = function(element)

											local alpha = element:alpha()
											local x,y,w,h = element:abs()

											local iw,ih = 91,91
											local ix,iy = x+15, y+15

											local texture = getDrawingTexture('assets/images/item_icon_bg.png')
											local gradient = getTextureGradient(texture, {
												texture = texture,
												alpha = alpha,
												angle = -45,
												color = {
													{ 86, 56, 79, 255 },
													{ 180, 70, 70, 255 },
												},
											})

											dxDrawImage(
												ix,iy,iw,ih, gradient
											)

											dxDrawImage(
												ix,iy,iw,ih, string.format('assets/images/icons/%s.png', element.category),
												0, 0, 0, tocolor(40, 40, 40, 255*alpha)
											)

											if localPlayer:getData('license.'..element.category) then

												local gw,gh = 38, 38
												local gx,gy = x+w-gw-15, y+15

												dxDrawImage(
													gx,gy,gw,gh, 'assets/images/round.png',
													0, 0, 0, tocolor(120, 185, 130, 255*alpha)
												)

												dxDrawImage(
													gx,gy,gw,gh, 'assets/images/got.png',
													0, 0, 0, tocolor(40, 40, 40, 255*alpha)
												)

											end

											dxDrawText(string.format('Стоимость - #cd4949$%s',
												splitWithPoints( element.category_data.cost or 0, '.' )
											),
												x + 30, y+h-20,
												x + 30, y+h-20,
												tocolor(255,255,255,255*alpha),
												0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
												'left', 'bottom', false, false, false, true
											)

											dxDrawText(element.category_data.name,
												ix+iw+5, iy+ih/2,
												ix+iw+5, iy+ih/2,
												tocolor(255,255,255,255*alpha),
												0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
												'left', 'bottom', false, false, false, true
											)

											dxDrawText(string.format('Категория #cd4949%s', element.category),
												ix+iw+5, iy+ih/2,
												ix+iw+5, iy+ih/2,
												tocolor(60,60,80,255*alpha),
												0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
												'left', 'top', false, false, false, true
											)

											local l_anim = getAnimData(element.l_anim)

											dxDrawImage(
												x,y,w,h, element[6],
												0, 0, 0, tocolor(0,0,0,200*alpha*l_anim)
											)

										end,

										onPreRender = function(element)

											local alpha = element:alpha()
											local x,y,w,h = element:abs()

											if not localPlayer:getData('license.'..element.category)then
												local aw,ah = 307,168

												dxDrawImage(
													x+w/2-aw/2,y+h/2-ah/2,aw,ah, 'assets/images/item_bg_active.png',
													0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
												)

											end


										end,

										onClick = function(element)

											local x,y,w,h = element:abs(true)
											licensesList.scroll = false

											if isTimer(licenseDialogTimer) then return end

											licenseDialogTimer = setTimer(function()

												local _, target = getAnimData(element.l_anim)
												if target == 1 then return end

												dialog('Лицензия', {
													string.format('Вы действительно хотите приобрести'),
													string.format('категорию %s за #cd4949$%s#ffffff?',
														element.category, splitWithPoints(element.category_data.cost, '.')
													),	
												}, function(result)

													if result then

														animate(element.l_anim, 1)

														displayLoading( {x+w/2-40/2, y+h/2-40/2, 40, 40}, {180,70,70,255}, 1500, function()

															animate(element.l_anim, 0)
															licensesList.scroll = true
															triggerServerEvent('autoschool.buyCategory', resourceRoot, element.category)

														end )

													end

												end)

											end, 100, 1)

										end,

									}
								)

							end

							startY = startY + h + 10

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

