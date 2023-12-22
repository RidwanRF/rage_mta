
cancelButtons = {
	['f1'] = true,
	['f2'] = true,
	['f3'] = true,
	['f4'] = true,
	['f5'] = true,
	['f6'] = true,
	['f7'] = true,
	['f10'] = true,
	['f11'] = true,
	['f9'] = true,
	['k'] = true,
	['m'] = true,
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

			'center', 'center',
			676, 490,
			color = {25,24,38,255},
			'assets/images/bg.png',


			onPreRender = function(element)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				local shw,shh = 702, 516
				local shx,shy = x+w/2-shw/2, y+h/2-shh/2

				dxDrawImage(
					shx,shy,shw,shh, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor(0, 0, 0, 255*alpha)
				)

			end,

			onRender = function(element)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				local iw,ih = 56,56
				local ix,iy = x + 30, y + 30

				dxDrawImage(
					ix,iy,iw,ih,
					'assets/images/icon_bg.png',
					0, 0, 0, tocolor( 180,70,70,255*alpha )
				)

				dxDrawImage(
					ix,iy,iw,ih,
					'assets/images/icon.png',
					0, 0, 0, tocolor( 0,0,0,150*alpha )
				)

				dxDrawText('Учёт автомобильного долга',
					x, y + 50, x + w, y + 50,
					tocolor( 255,255,255,255*alpha ),
					0.5, 0.5, getFont('montserrat_bold', 27, 'light'),
					'center', 'top'
				)

				dxDrawText('Ваши автомобили с задолженностью',
					x, y + 80, x + w, y + 80,
					tocolor( 255,255,255,255*alpha ),
					0.5, 0.5, getFont('montserrat_medium', 25, 'light'),
					'center', 'top'
				)

				dxDrawText('( Нажмите на автомобиль для выбора )',
					x, y + 99, x + w, y + 99,
					tocolor( 110, 110, 110,255*alpha ),
					0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
					'center', 'top'
				)

				dxDrawText('Автомобиль с задолженностью нельзя передать другому игроку',
					x, y + h - 25, x + w, y + h - 25,
					tocolor( 110, 110, 110,255*alpha ),
					0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
					'center', 'bottom'
				)

			end,

			elements = {

				{'button',

					function(s,p) return p[4] - s[4] - 42 end, 42,
					33, 33,
					bg = 'assets/images/close.png',
					activeBg = 'assets/images/close_active.png',
					define_from = '',

					'',

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

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

				{'image',

					'center', 135,
					571, 299,
					'assets/images/bg1.png',
					color = {21,21,33,255},

					elements = {

						{'element',
							'center', 50,
							'100%', function(s,p) return p[5] - 130 end,
							color = {255,255,255,255},
							overflow = 'vertical',

							variable = 'vehiclesList',

							scrollWidth = 3,
							scrollBgColor = {21,21,33,255},
							scrollXOffset = 10,

							padding = 40,

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local padding = element.padding + 10

								if element.selected then

									local pay = math.floor( (element.selected.row.debt or 0) * (100 - Config.discount)/100 )
									local text = ('К оплате - #cd4949$%s#ffffff'):format( splitWithPoints( pay, '.' ) )

									if Config.discount > 0 then
										text = text .. (' | Скидка %s%%'):format( Config.discount )
									end

									dxDrawText(text,
										x + 40, y + h + 40,
										x + 40, y + h + 40,
										tocolor(255,255,255,255 * alpha),
										0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
										'left', 'center', false, false, false, true
									)

								end

								if #(element.elements or {}) <= 0 then

									dxDrawText('Автомобилей с долгом не найдено',
										x, y,
										x + w, y + h,
										tocolor(100,100,100,255 * alpha),
										0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
										'center', 'center', false, false, false, true
									)

								else

									dxDrawText('Автомобиль',
										x + padding, y - 10,
										x + padding, y - 10,
										tocolor(100,100,100,255 * alpha),
										0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
										'left', 'bottom'
									)

									dxDrawText('Гос. Номер',
										x, y - 10,
										x + w, y - 10,
										tocolor(100,100,100,255 * alpha),
										0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
										'center', 'bottom'
									)

									dxDrawText('Задолженность',
										x + w - padding, y - 10,
										x + w - padding, y - 10,
										tocolor(100,100,100,255 * alpha),
										0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
										'right', 'bottom'
									)

								end


							end,

							clear = function(element)

								for _, c_element in pairs( element.elements or {} ) do
									c_element:destroy()
								end

								element.elements = {}
								element.selected = nil

							end,

							onKey = {

								arrow_u = function(element)

									local index = 0
									for _index, c_element in pairs( element.elements or {} ) do

										if c_element == element.selected then

											index = _index
											break

										end

									end

									element.selected = element.elements[ cycle( index - 1, 1, #element.elements ) ]

								end,

								arrow_d = function(element)

									local index = 0
									for _index, c_element in pairs( element.elements or {} ) do

										if c_element == element.selected then

											index = _index
											break

										end

									end

									element.selected = element.elements[ cycle( index + 1, 1, #element.elements ) ]

								end,

							},

							update = function(element, vehicles)

								element:clear()

								local startY = 0

								local w,h = element[4], 50
								local padding = 10

								for _, row in pairs( vehicles ) do


									if (row.debt or 0) > 0 then

										element:addElement(
											{'rectangle',
												'center', startY,
												w,h,
												color = {25,24,38,255},

												row = row,

												onRender = function(element)

													local anim = getAnimData( element.h_anim )
													local r,g,b = interpolateBetween( 25,24,38, 180, 70, 70, anim, 'InOutQuad' )

													animate( element.h_anim, element.parent.selected == element and 1 or 0 )

													element.color = { r,g,b, element.color[4] }

													local alpha = element:alpha()
													local x,y,w,h = element:abs()

													local padding = vehiclesList.padding

													dxDrawText(element.row.name,
														x + padding, y, 
														x + padding, y + h,
														tocolor( 255,255,255,255*alpha ),
														0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
														'left', 'center'
													)

													dxDrawText(element.row.plate_text,
														x, y, 
														x + w, y + h,
														tocolor( 255,255,255,255*alpha ),
														0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
														'center', 'center'
													)


													dxDrawText(element.row.debt_text,
														x + w - padding, y, 
														x + w - padding, y + h,
														tocolor( 255,255,255,255*alpha ),
														0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
														'right', 'center'
													)

												end,

												onDestroy = function(element)
													removeAnimData(element.h_anim)
												end,

												onInit = function(element)

													element.h_anim = {}
													setAnimData( element.h_anim, 0.1 )

													element.row.name = exports.vehicles_main:getVehicleModName( element.row.model )
													element.row.plate_text = exports.vehicles_manager:convertNumberplateToText( element.row.plate )
													element.row.debt_text = ('$%s'):format( splitWithPoints( element.row.debt or 0, '.' ) )

												end,

												onClick = function(element)
													element.parent.selected = element
												end,

											}
										)

										startY = startY + h + padding

									end


								end

							end,

							onInit = function(element)

								openHandlers.getVehicles = function()

									triggerServerEvent('vehicles.sendPlayerVehicles', root)

								end

							end,

							addEvent('vehicles.getPlayerVehicles', true),
							addEventHandler('vehicles.getPlayerVehicles', root, function(vehicles)

								vehiclesList:update( vehicles )

							end),

							elements = {},

						},

						{'button',

							function(s,p) return p[4] - s[4] - 20 end,
							function(s,p) return p[5] - s[5] - 20 end,
							173, 38,

							bg = 'assets/images/btn_empty.png',
							activeBg = 'assets/images/btn.png',

							color = { 200,80,80,255 },
							'Оплатить',

							font = getFont('montserrat_bold', 19, 'light'),
							scale = 0.5,

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local shadow = {
									['assets/images/btn_empty_shadow.png'] = (1-element.animData),
									['assets/images/btn_shadow.png'] = element.animData,
								}

								for path, anim in pairs( shadow ) do

									local texture = getDrawingTexture( path )

									local mw,mh = dxGetMaterialSize( texture )
									local mx,my = x+w/2-mw/2, y+h/2-mh/2

									dxDrawImage(
										mx,my,mw,mh, texture,
										0, 0, 0, tocolor(200,90,90, 255*alpha*anim)
									)

								end

							end,

							onClick = function(element)

								if vehiclesList.selected then
									triggerServerEvent('vehicles_debt.payDebt', resourceRoot, vehiclesList.selected.row.id)
								else
									exports.hud_notify:notify('Ошибка', 'Автомобиль не выбран')
								end

							end,

						},

					},

				},

			},

		},

	},

}

---------------------------------------------------------------------

loadGuiModule()


end)

