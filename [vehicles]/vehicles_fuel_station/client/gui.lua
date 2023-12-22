


openHandler = function()
end

closeHandler = function()
end

addEventHandler('onClientResourceStart', resourceRoot, function()

fuelTypes = exports.vehicles_fuel:getFuelTypesConfig()

windowModel = {

	main = {

		{'image',
			'center', 'center',
			531, 367,
			'assets/images/bg.png',
			color = {24,30,66,255},

			onRender = function(element)

				local alpha = getElementDrawAlpha(element)
				local x,y,w,h = element:abs()

				dxDrawImage(
					x,y,w,h, 'assets/images/fuel_art.png',
					0, 0, 0, tocolor(255,255,255,200*alpha)
				)

				dxDrawText('Заправочная станция',
					x + 70, y + 37,
					x + 70, y + 37,
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

			onPreRender = function(element)

				local alpha = getElementDrawAlpha(element)
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 557/2,
					y + h/2 - 393/2 + 5,
					557, 393, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
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

						element[2] = element.parent[4] - element[4] - 30
						element[3] = 35

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
					'center', 'bottom',
					322, 75,
					color = {255,255,255,255},

					elements = {

						{'button',
							'left', 'top',
							156, 43,
							'Слить топливо',
							bg = 'assets/images/button_empty.png',
							activeBg = 'assets/images/button.png',

							scale = 0.5,
							font = getFont('montserrat_semibold', 22, 'light'),

							color = {180, 70, 70, 255},
							activeColor = {200, 70, 70, 255},

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local shx,shy,shw,shh = x + w/2 - 187/2, y + h/2 - 76/2, 187, 76


								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/button_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
								)

							end,

							onClick = function(element)

								if localPlayer.vehicle:getData('fuel_type') == 'electro' then return end

								if not localPlayer.vehicle then return end
								if localPlayer.vehicle.frozen then return end

								if not localPlayer.vehicle:getData('id') then
									return exports['hud_notify']:notify('Заправка', 'Нельзя слить топливо')
								end

								localPlayer.vehicle:setData('fuel', 0)
								localPlayer.vehicle:setData('fuel_type', false)

								exports['hud_notify']:notify('Заправка', 'Вы слили топливо', 3000)
								fuelSlider:update()

							end,

						},

						{'button',
							'right', 'top',
							156, 43,
							'Заправить',
							bg = 'assets/images/button_empty.png',
							activeBg = 'assets/images/button.png',

							scale = 0.5,
							font = getFont('montserrat_semibold', 22, 'light'),

							color = {180, 70, 70, 255},
							activeColor = {200, 70, 70, 255},

							onPreRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local shx,shy,shw,shh = x + w/2 - 187/2, y + h/2 - 76/2, 187, 76


								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/button_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
								)

							end,

							onClick = function(element)

								local fuel = localPlayer.vehicle:getData('fuel') or 0
								local fuelType = localPlayer.vehicle:getData('fuel_type') or '92'

								local count = gui_get('fuel-slider').fuel_count
								local selected = gui_get('fuel-types').selected_fuel

								local fuelFit = getVehicleFuelFit( localPlayer.vehicle, selected )

								if not fuelFit then
									return exports['hud_notify']:notify('Заправка', 'Это топливо недоступно')
								end

								if fuel > 0 and fuelType ~= selected then
									return exports['hud_notify']:notify('Заправка', 'Сперва слейте топливо')
								end

								if count > 0 then
									triggerServerEvent('fuel.fuelCar', resourceRoot, selected, count)
									closeWindow()
								end

							end,

						},

					},

				},

				{'element',
					'center', 115,
					'100%', 50,
					color = {255,255,255,255},

					id = 'fuel-types',
					possible_fuel = {},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawText('Выберите тип топлива',
							x, y - 15,
							x+w, y - 15,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
							'center', 'bottom'
						)

					end,

					onInit = function(element)

						local w,h = 50,50
						local padding = 12

						local types = {}

						for _, f_type in pairs( {'92', '95', '98', '100', 'diesel', 'electro'} ) do
							local _table = fuelTypes[f_type]
							_table.type = f_type
							table.insert(types, _table)
						end

						local sCount = getTableLength( fuelTypes ) / 2

						local startX = element[4]/2 - w*sCount - padding*(sCount-0.5)
						local startY = 0

						for _, f_type in pairs( types ) do

							element:addElement(
								{'image',

									startX, startY,
									w, h,
									color = {180, 70, 70, 255},
									'assets/images/fuel_type.png',

									fuel = f_type,

									onRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										local tr,tg,tb = 255,255,255

										if not element.parent.possible_fuel[element.fuel.type] then
											element.color = {54,58,78,element.color[4]}
											tr,tg,tb = 54,58,78
										else
											element.color = {180,70,70,element.color[4]}
										end

										if element.parent.selected_fuel == element.fuel.type then
											element[6] = 'assets/images/fuel_type_a.png'

											dxDrawImage(
												x+w/2-74/2, y+h/2-74/2,
												74,74, 'assets/images/fuel_type_shadow.png',
												0, 0, 0, tocolor(180, 70, 70, 255*alpha)
											)

										else
											element[6] = 'assets/images/fuel_type.png'
										end

										if element.fuel.type == 'electro' then

											dxDrawImage(
												x,y,w,h, 'assets/images/electro.png',
												0, 0, 0, tocolor(tr,tg,tb,255*alpha)
											)

										else

											dxDrawText(element.fuel.name,
												x,y,x+w,y+h,
												tocolor(tr,tg,tb,255*alpha),
												0.5, 0.5, getFont('montserrat_semibold', 19, 'light'),
												'center', 'center'
											)

										end


									end,

									onClick = function(element)

										if element.parent.possible_fuel[element.fuel.type] then
											element.parent.selected_fuel = element.fuel.type
 										end

									end,

								}
							)

							startX = startX + w + padding

						end

						openHandlers.get_possible_fuel = function()

							if localPlayer.vehicle then
								gui_get('fuel-types').possible_fuel = exports.vehicles_main:getVehicleSetting(localPlayer.vehicle, 'fuelTypes')
							end

						end

						openHandlers.update_current_fuel = function()

							if localPlayer.vehicle then
								gui_get('fuel-types').selected_fuel = localPlayer.vehicle:getData('fuel_type') or '92'
							end

						end

					end,

				},

				{'slider', 
					'center', 220,
					305, 23,
					bg = 'assets/images/slider.png',

					color = {29,37,73,255},
					activeColor = {180, 70, 70,255},

					index = index,

					id = 'fuel-slider',
					variable = 'fuelSlider',

					range = {10, 100},
					value = 100,

					update = function(element)

						if localPlayer.vehicle then

							local fuel = math.floor( localPlayer.vehicle:getData('fuel') or 0 )

							local slider = gui_get('fuel-slider')

							slider.value = 0

							local maxFuel = exports.vehicles_main:getVehicleProperty(localPlayer.vehicle, 'fuel')

							slider.range = { 0, maxFuel-fuel }

						end

					end,

					onInit = function(element)

						openHandlers.update_slider = function()

							fuelSlider:update()

						end

						element.count_bg = 'assets/images/cbg.png'
						-- element.count_bg = createTextureSource('bordered_rectangle', 'assets/images/cbg.png', 25, 60, 25)

					end,

					onRender = {


						function(element)

							local x,y,w,h = element:abs()
							local alpha = element:alpha()

							element.fuel_count = math.round( element.range[2] - (element.range[2] - element.value) )
							element.cost = element.fuel_count * fuelTypes[ gui_get('fuel-types').selected_fuel ].cost

							drawSmartText(string.format('К оплате - %s <img>assets/images/money.png</img>',
								splitWithPoints( math.floor(
									element.cost
								) , '.')
							),
								x, x+w, y+h+20, 
								tocolor(255,255,255,255*alpha),
								tocolor(255,255,255,255*alpha),
								0.5, getFont('montserrat_semibold', 28, 'light'),
								'center', 25, 0
							)

						end,

						function(element)

							local x,y,w,h = element:abs()
							local alpha = element:alpha()

							local min, max = unpack(element.range or {0,1})
							local percent = math.clamp((element.value-min)/(max-min), 0, 1)

							element.bc_animId = element.bc_animId or {}

							local animData = getAnimData(element.bc_animId)

							if not animData then
								setAnimData(element.bc_animId, 0.1)
								animData = 0
							end

							if element.last_percent ~= percent then

								animate(element.bc_animId, 1)

								if isTimer(element.count_timer) then
									killTimer(element.count_timer)
								end

								element.count_timer = setTimer(function()
									animate(element.bc_animId, 0)
								end, 1000, 1)
							end

							element.last_percent = percent

							dxDrawRectangle(
								x+w*percent-2, y-15,
								2, 10, tocolor(180, 70, 70, 255*alpha*animData)
							)

							local bw,bh = 60, 25

							local bx,by = x+w*percent-2 - bw/2, y-15-bh

							dxDrawImage(
								bx,by,bw,bh, element.count_bg,
								0, 0, 0, tocolor(180, 70, 70, 255*alpha*animData)
							)

							dxDrawText(string.format('+%s L', element.fuel_count),
								bx,by,bx+bw,by+bh,
								tocolor(255,255,255,255*alpha*animData),
								0.5, 0.5, getFont('montserrat_medium', 20, 'light'),
								'center', 'center'
							)

						end,

					},

				},

			},

		},

	},

}

----------------------------------------------------------------------

loadGuiModule()


end)


