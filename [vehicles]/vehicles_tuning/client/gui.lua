
cancelButtons = {
	['f1'] = true,
	['f2'] = true,
	['f3'] = true,
	['f4'] = true,
	['f5'] = true,
	['f7'] = true,
	['f11'] = true,
	['f9'] = true,
	['k'] = true,
	['i'] = true,
	['m'] = true,
	['p'] = true,
	['delete'] = true,
}

function ShowStageStat ( id )
	local conf = exports.vehicle_c_handling:GetStageTable ( )
	if conf and conf [ id ] then
		conf = conf [ id ]
		exports.hud_notify:notify ( 'Информация', 'Стейдж добавит + '..conf.maxVelocity..'\nк скорости' )
	end
end

addEventHandler ( 'onClientElementDataChange', root, function ( key ) 
	if source.type == 'vehicle' and key == 'stages' then
		local cont = getVehicleController ( source )
		if cont == localPlayer then
			if not localPlayer:getData ( 'tuning.interior' ) then return end
			ShowStageStat ( source:getData (  key ) )
		end
	end
end)

openHandler = function()

	showChat(false)

	localPlayer:setData('radar.hidden', true, false)
	localPlayer:setData('speed.hidden', true, false)

	startCamera()

	exports['vehicles_controls']:updateState('head')

	animate('tuning-component', 0)
	animate('tuning-list', 0)

	localPlayer:setData('tuning.interior', true)

	hideComponentsEdit()

	currentVehicle = localPlayer.vehicle

end
closeHandler = function(handleResourceStop)

	showChat(true)

	localPlayer:setData('radar.hidden', false, false)
	localPlayer:setData('speed.hidden', false, false)

	localPlayer:setData('tuning.interior', false)

	loadInitialTuning()
	stopCamera()
	
	if not onChangeSection then
		exitTuning(handleResourceStop)
	end
	onChangeSection = false

	exports['vehicles_controls']:updateState('off')
	currentTuningBasket = {}

	localPlayer:setData('tuning.selpainttype', false, false)
	localPlayer.vehicle:setData('number.curtain.state', false, false)

end


addEventHandler('onClientResourceStart', resourceRoot, function()

local bgSource = 'assets/images/bg.png'
-- local bgSource = createTextureSource('bordered_rectangle', 'assets/images/bg.png', 8, 300, 400)

windowModel = {

	__basic = {

		{'element',
			0, 0, 0, 0,
			color = {255,255,255,255},

			onPreRender = function(element)

				local alpha = element:alpha()

				mta_dxDrawImage(
					0, 0, real_sx, real_sy, 'assets/images/bgg.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
				)

				if localPlayer.vehicle ~= currentVehicle then
					return closeWindow()
				end

			end,

		},

	},

	main = {

		root = {'element',

			0, 80, 0, 0,
			color = {255,255,255,255},

			onInit = function(element)



			end,

			elements = {

				{'button',
					40, sy/2 - 454 - 5 - 88,
					148, 88,

					'',
					bg = 'assets/images/back.png',
					define_from = false,

					color = {255, 255, 255, 255},

					onClick = function(element)
						closeWindow()
					end,
				},

				{'image',
					30, sy/2 - 454 - 5,
					287, 454,
					'assets/images/bg1.png',

					color = {25, 24, 38, 255},

					elements = {

						{'list',

							'center', 22,
							'100%', 454-44,
							scrollBg = scrollTexture,

							scrollColor = {140, 50, 50, 255},
							scrollBgColor = {0, 0, 10, 255},

							scrollWidth = 5,
							listOffset = 0,

							scrollXOffset = -30,
							scrollHeight = 0.8,

							listElements = {},

							font = 'default',
							scale = 1,
							listElementHeight = 50,

							color = {255,255,255,255},

							onInit = function(element)
								tuningSectionsList = element

								closeHandlers.controls = function()

									for _, listElement in pairs( tuningSectionsList.listElements ) do

										if listElement.toggle then
											listElement:toggle( false )
										end
										
									end
								
								end

							end,

							onListElementClick = function(element, lElement)

								if lElement.data then
									for _, prerequisity in pairs( lElement.data.prerequisities or {} ) do
										if ( localPlayer.vehicle:getData(prerequisity) or 0 ) == 0 then

											element.selectedItem = false
											element.lastSelectedItem = false

											return exports['hud_notify']:notify('Недостаточно компонентов', string.format('Установите %s',
												Config.tuningSectionNames[ prerequisity ].name
											))
										end
									end
								end

								hideComponentsEdit()

								animate('tuning-component', lElement.value_type == 'default' and 1 or 0)

								loadSectionComponents( lElement )

								for _, listElement in pairs( element.listElements ) do

									if listElement.toggle then
										listElement:toggle( false )
									end
									
								end

								if lElement.toggle then
									lElement:toggle( true )
								end

							end,

							additionalElementDrawing = function(lElement, x,y,w,ey, element, animData)

								local alpha = element:alpha()
								
								local w,h = element[4], element.listElementHeight - 5
								local x,y = x + element[4]/2 - w/2, y+element.listElementHeight/2 - h/2

								local r,g,b = interpolateBetween(17,17,27, 180, 70, 70, animData, 'InOutQuad')
								local tr,tg,tb = interpolateBetween(255,255,255, 50,20,20, animData, 'InOutQuad')

								dxDrawRectangle(
									x,y,w,h, tocolor(r,g,b,255*alpha)
								)

								dxDrawText(lElement.name,
									x,y,x+w,y+h,
									tocolor(tr,tg,tb,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 27, 'light'),
									'center', 'center'
								)

							end,

						},

					},

				},


				{'image',
					30 + 287 + 10, sy/2 - 454 - 5,
					287, 454,
					'assets/images/bg1.png',

					animationAlpha = 'tuning-list',
					setAnimData('tuning-list', 0.1),

					color = {25, 24, 38, 255},

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local _, target = getAnimData('tuning-component')

						if target == 1 then
							y = y + h - 90
						else
							y = y + h - 40
						end

						if tuningComponentsList.lastSelectedItem then

							local scale, font = 0.5, getFont('montserrat_semibold', 27, 'light')

							dxDrawText('Стоимость',
								x + 25, y,
								x + 25, y,
								tocolor(255,255,255,255*alpha),
								scale, scale, font,
								'left', 'center'
							)

							dxDrawText(splitWithPoints(tuningComponentsList.lastSelectedItem.price, ' '),
								x+w - 25 - 27 - 3, y,
								x+w - 25 - 27 - 3, y,
								tocolor(255,255,255,255*alpha),
								scale, scale, font,
								'right', 'center'
							)

							dxDrawImage(
								x+w - 25 - 25, y - 25/2,
								25, 25,
								'assets/images/money.png',
								0, 0, 0, 
								tocolor(255,255,255,255*alpha)
							)

						end

					end,

					elements = {

						{'button',
							'center', 454-41-20,

							[6]='В корзину',

							animationAlpha = 'tuning-component',
							setAnimData('tuning-component', 1),

							onRender = function(element)

								element[6] = 'В корзину'

								for _, lElement in pairs( basketElement.listElements ) do

									if lElement.component == tuningComponentsList.lastSelectedItem then
										element[6] = 'В корзине'
										break
									end


								end

								if tuningComponentsList.lastSelectedItem and
								tuningComponentsList.lastSelectedItem.index == getInitialTuningValue(tuningComponentsList.lastSelectedItem.section.key) then
									element[6] = 'Установлено'
								end

							end,

							onClick = function(element)

								if tuningComponentsList.lastSelectedItem.index == getInitialTuningValue(
									tuningComponentsList.lastSelectedItem.section.key)
								then
									return
								end

								addComponentToBasket( tuningComponentsList.lastSelectedItem )

							end,
						},

						{'list',

							'center', 22,
							'100%', 454-44-100,
							scrollBg = scrollTexture,

							scrollColor = {140, 50, 50, 255},
							scrollBgColor = {0, 0, 10, 255},

							scrollXOffset = -30,
							scrollHeight = 0.8,

							scrollWidth = 5,
							listOffset = 0,

							listElements = {},

							font = 'default',
							scale = 1,
							listElementHeight = 50,

							animationAlpha = 'tuning-list',

							color = {255,255,255,255},

							onInit = function(element)
								tuningComponentsList = element
								tuningComponentsList.h0 = element[5]
							end,

							onListElementClick = function(element, lElement)

								local valueType = tuningSectionsList.lastSelectedItem.value_type

								hideComponentsEdit()
								animate('tuning-component', 0)

								if valueType == 'default' then
									preloadTuningComponent(lElement)
									animate('tuning-component', 1)
								else
									showComponentEdit(lElement, valueType)
								end

							end,

							additionalElementDrawing = function(lElement, x,y,w,ey, element, animData)

								local alpha = element:alpha()
								
								local w,h = element[4], element.listElementHeight - 5
								local x,y = x + element[4]/2 - w/2, y+element.listElementHeight/2 - h/2

								local r,g,b = interpolateBetween(17,17,27, 180, 70, 70, animData, 'InOutQuad')
								local tr,tg,tb = interpolateBetween(255,255,255, 50,20,20, animData, 'InOutQuad')

								dxDrawRectangle(
									x,y,w,h, tocolor(r,g,b,255*alpha)
								)

								local config = findTuningComponent(lElement.config_link)

								dxDrawText(lElement.name or config.name,
									x,y,x+w,y+h,
									tocolor(tr,tg,tb,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 27, 'light'),
									'center', 'center'
								)

							end,

						},

					},

				},

				{'image',

					30, sy/2 + 5,
					287, 381,
					'assets/images/bg2.png',

					onRender = {

						function(element)

							local alpha = element:alpha()
							local x,y,w,h = element:abs()

							drawImageSection(
								x,y,w,h, element[6],
								{ x = 1, y = 130/h }, tocolor(21,21,33,255*alpha), 1
							)

						end,

						function(element)

							local compatibility = checkTuningCompatibility( localPlayer.vehicle )
							if not compatibility then

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								dxDrawTextShadow('ВНИМАНИЕ! Компоненты',
									x,y+h+5,x+w,y+h+5,
									tocolor(180,70,70,255*alpha),
									0.5, getFont('montserrat_semibold', 25, 'light'),
									'center', 'top', 1, tocolor(0,0,0,100*alpha), false, dxDrawText
								)

								dxDrawTextShadow('несовместимы (колхоз)',
									x,y+h+20,x+w,y+h+20,
									tocolor(180,70,70,255*alpha),
									0.5, getFont('montserrat_semibold', 25, 'light'),
									'center', 'top', 1, tocolor(0,0,0,100*alpha), false, dxDrawText
								)

							end

						end,

						function(element)

							local alpha = element:alpha()
							local x,y,w,h = element:abs()

							dxDrawImage(
								x + 10, y + 10,
								56, 56,
								'assets/images/cart_bg.png', 0, 0, 0, tocolor(180,70,70,255*alpha)
							)
							dxDrawImage(
								x + 10, y + 10,
								56, 56,
								'assets/images/cart_icon.png', 0, 0, 0, tocolor(140,50,50,255*alpha)
							)

							dxDrawImage(
								x + w - 50, y + 10 + 56/2 - 25/2,
								25, 25,
								'assets/images/money.png', 0, 0, 0, tocolor(255,255,255,255*alpha)
							)

							local basketSum = getBasketSum()

							dxDrawText(splitWithPoints(basketSum, ' '),
								x + w - 53 - 3, y + 10 + 56/2,
								x + w - 53 - 3, y + 10 + 56/2,
								tocolor(255,255,255,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
								'right', 'center'
							)

						end,

					},

					color = {25, 24, 38, 255},

					elements = {

						{'button',

							'center', 381-41-20,

							[6]='Перейти к оплате',

							animationAlpha = 'buy-tuning',
							setAnimData('buy-tuning', 0.1, 0.4),

							onClick = function(element)

								if not element:is_active() then return end

								local x,y,w,h = element:abs()

								local basketSum = getBasketSum()

								dialog('Тюнинг', {
									'Вы действительно хотите купить',
									string.format('тюнинг на %s$?', splitWithPoints(basketSum, ' ')),
								}, function(result)

									if result then

										triggerServerEvent('tuning.buy', resourceRoot, basketElement.listElements)
										
									end

								end)

							end,

						},

						{'element',

							'center', 'bottom',
							265, 115,
							color = {255,255,255,255},

							onInit = function(element)

								setAnimData('basket-actions', 0.1, 0.4)
								element.animationAlpha = 'basket-actions'

							end,

							elements = {

								{'button',

									'right', 'top',
									150, 40,

									[6]='Убрать все',

									define_from = 'rect_button',

									onClick = function(element)
										if element:is_active() then
											clearTuningBasket()
										end
									end,
								},

								{'button',
									
									'left', 'top',
									110, 40,

									[6]='Убрать',

									define_from = 'rect_button',

									onClick = function(element)
										if element:is_active() then
											removeComponentFromBasket( basketElement.lastSelectedItem.component )
										end
									end,
								},

							},

						},

						{'list',
							'center', 80,
							'100%', 170,
							scrollBg = scrollTexture,
							scrollColor = {140, 50, 50, 255},
							scrollBgColor = {0, 0, 10, 255},

							scrollXOffset = -25,
							scrollHeight = 0.8,

							scrollWidth = 5,
							listOffset = 0,

							listElements = {},

							font = 'default',
							scale = 1,
							listElementHeight = 50,

							color = {255,255,255,255},

							onInit = function(element)
								basketElement = element
							end,

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								if #element.listElements == 0 then
									dxDrawText('Корзина пуста',
										x, y,
										x + w, y + h,
										tocolor(100, 100, 100, 255*alpha),
										0.5, 0.5, getFont('montserrat', 29, 'light'),
										'center', 'center'
									)
								end

								animate('buy-tuning', #element.listElements == 0 and 0.4 or 1)

							end,

							onListElementClick = function(element, lElement)
								animate('basket-actions', 1)
							end,

							additionalElementDrawing = function(lElement, x,y,w,ey, element, animData)

								local alpha = element:alpha()
								
								local w,h = element[4], element.listElementHeight - 8
								local x,y = x + element[4]/2 - w/2, y+element.listElementHeight/2 - h/2

								local r,g,b = interpolateBetween(17,17,27, 180, 70, 70, animData, 'InOutQuad')
								local tr,tg,tb = interpolateBetween(255,255,255, 50,20,20, animData, 'InOutQuad')

								dxDrawRectangle(
									x,y,w,h, tocolor(r,g,b,255*alpha)
								)

								local config = findTuningComponent(lElement.component.config_link)

								for i = 1,2 do
									dxDrawText(config.name,
										x+25,y,x+w,y+h,
										tocolor(tr,tg,tb,255*alpha),
										0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
										'left', 'center'
									)

									dxDrawText( splitWithPoints(config.price, ' '),
										x+w-25,y,x+w-25,y+h,
										tocolor(tr,tg,tb,255*alpha),
										0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
										'right', 'center'
									)
								end

							end,

						},



					},

				},


			},

		},

	},

	vinils = {

		{'element',

			0, 0, 0, 0, 
			color = {255,255,255,255},

			onPostRender = function(element)
				vinilsDrawElement:updateLayers()
			end,

			variable = 'vinilsRoot',

			onKey = {


				j = function(element)
					camera.rotationHorizontal = camera.rotationHorizontal + 90
				end,

				x = function(element)

					if getKeyState('lshift') then

						for _, layer in pairs( vinilLayers.elements ) do
							element:setCurrentLayer(layer)
							layer.copy:onClick()
							vinilsEdit:mirrorCurrentLayer('x')
						end

					else
						vinilsEdit:mirrorCurrentLayer('x')
					end

				end,

				z = function(element)
					vinilsEdit:mirrorCurrentLayer('y')
				end,

				m = function()

					if vinilsControls:isVisible() then

						if vinilLayers.layer and not vinilLayers.edit_layer then
							vinilLayers:setEditLayer(vinilLayers.layer)
						end

					end

				end,

				delete = function(element)

					if vinilLayers.layer then
						vinilLayers.layer:remove()
					end

				end,

				arrow_d = function(element)

					if getKeyState('lctrl') then

						local id = 0

						if vinilLayers.layer then
							id = vinilLayers.layer.__data.id
						end

						id = cycle( id + 1, 1, #vinilLayers.elements )

						vinilLayers.elements[id]:select()

					end

				end,

				arrow_u = function(element)

					if getKeyState('lctrl') then

						local id = 0

						if vinilLayers.layer then
							id = vinilLayers.layer.__data.id
						end

						id = cycle( id - 1, 1, #vinilLayers.elements )

						vinilLayers.elements[id]:select()

					end

				end,

				p = function(element)

					local anim, target = getAnimData( element.hint_anim )
					animate( element.hint_anim, target == 1 and 0 or 1 )

				end,

			},

			onInit = function(element)

				for i = 1,9 do

					local key = 'num_'..i

					element.onKey[key] = function(element)

						if isMouseInPosition(vinilsShop:abs()) then return end

						local binds = localPlayer:getData('vinils.binds') or {}

						if binds[key] then

							if #vinilLayers.elements >= Config.vinilsLimit then
								return exports.hud_notify:notify('Ошибка', ('Ограничение - %s слоев'):format(Config.vinilsLimit))
							end

							local config = Config.vinilsAssoc[ binds[key] ]
							local data = table.copy( config )

							if vinilLayers.layer then

								data.x = vinilLayers.layer.data.x
								data.y = vinilLayers.layer.data.y
								data.r = vinilLayers.layer.data.r

							end

							if config and config.noSell then
								return
							end

							data.basket = true

							local layer = vinilLayers:addLayer( data )

							vinilLayers:setCurrentLayer( layer, true )
							vinilsEdit:loadLayer( layer.data )

						end

					end

				end

				element.hint_anim = {}
				setAnimData( element.hint_anim, 0.1, 1 )


			end,

			onRender = function(element)

				element:renderHints()

				local element = vinilsEdit
				if not vinilLayers.layer then return end

				if not element.move_keys then

					element.move_keys = {}

					for _, property in pairs( vinilsEdit.edit_properties ) do
						if property.move_toggle_key then
							element.move_keys[ property.move_toggle_key ] = true
						end
					end

				end

				for _, property in pairs( element.edit_properties ) do


					local _empty_access = property.move_toggle_key == 'empty'
					if _empty_access then

						for key in pairs( element.move_keys ) do
							if getKeyState(key) then
								_empty_access = false
								break
							end
						end

					end

					if getKeyState('lctrl') then return end

					local color_element = property.element.edit_element.parent
					if property.move_key and ( _empty_access or (not property.move_toggle_key or getKeyState( property.move_toggle_key )) ) then

						local mul = getKeyState('lshift') and 5 or (getKeyState('lalt') and 0.2 or 1)

						local handle_key = false

						for key, add in pairs( property.move_key ) do

							add = add * (property.step or 1)

							if getKeyState( vinilTransforms:getKeyTransform(key) ) then

								color_element.icolor = {180,70,70}

								local new_value = ( tonumber(property.element.edit_element[6]) or 0 ) + add*mul

								local min,max = unpack(
									type(property.range) == 'function' and
									property.range( vinilLayers.layer.data )
									or (property.range or {})
								)

								if min then
									new_value = math.clamp( new_value, min, max )
								end

								property.element.edit_element:setValue( new_value )
								handle_key = true

							end
						end

						color_element.icolor = handle_key and {180,70,70} or {30,30,40}

					else

						color_element.icolor = {30,30,40}

					end

				end

			end,

			hints = {

				{ buttons = { 'Стрелки' }, text = 'Редактирование' },

				-- { buttons = { 'Q' }, text = 'Режим позиции' },
				{ buttons = { 'W' }, text = 'Режим размера' },
				{ buttons = { 'E' }, text = 'Режим вращения' },
				{ buttons = { 'R' }, text = 'Режим прозрачности' },
				{ buttons = { 'LCTRL' }, text = 'Режим выбора слоя' },

				{ buttons = { 'C' }, text = 'Скопировать слой' },
				{ buttons = { 'X' }, text = 'Отразить по X' },
				{ buttons = { 'Z' }, text = 'Отразить по Y' },

				{ buttons = { 'LSHIFT' }, text = 'Ускорить редактирование' },
				{ buttons = { 'LALT' }, text = 'Замедлить редактирование' },

				{ buttons = { 'ПКМ', 'M' }, text = 'Свободное перемещение слоя' },
				{ buttons = { 'O' }, text = 'Скрыть/показать интерфейс' },
				{ buttons = { 'P' }, text = 'Скрыть/показать подсказки' },
				{ buttons = { 'NUMPAD +' }, text = 'Выбрать новый слой' },
				{ buttons = { 'J' }, text = 'Изменить проекцию камеры' },

			},

			renderHints = function(element)

				local alpha = element:alpha()
				alpha = alpha * getAnimData(element.hint_anim)
				alpha = alpha * (1-getAnimData(vinilsShop.animationAlpha))

				local startY = 150

				local hintH = 40
				local paddingX = 5
				local paddingY = 5

				local scale, font = 0.5, getFont('montserrat_medium', 25, 'light')
				local scale1, font1 = 0.5, getFont('montserrat_semibold', 25, 'light')

				for _, hint in pairs( element.hints ) do

					local startX = sx - 30

					for index, button in pairs( hint.buttons ) do

						if utf8.len(button) then

							local width = math.max(hintH, dxGetTextWidth( button, scale1, font1 ) + 20)

							local r,g,b = 40,40,60

							if getKeyState(button:lower()) then
								r,g,b = 180,70,70
							end

							dxDrawRectangle(
								startX - width, startY,
								width, hintH, tocolor( r,g,b,255*alpha )
							)

							if index ~= #hint.buttons then

								dxDrawRectangle(
									startX - width - paddingX, startY + 3,
									paddingX, hintH - 6, tocolor(18,18,28,255*alpha)
								)

							end

							dxDrawText(button,
								startX - width, startY,
								startX, startY + hintH,
								tocolor(255,255,255,255*alpha),
								scale1, scale1, font1,
								'center', 'center'
							)

							startX = startX - width - paddingX

						end

					end

					startX = startX + paddingX
					local textWidth = math.floor(dxGetTextWidth( hint.text, scale, font ) + 40)

					dxDrawRectangle(
						startX - textWidth, startY + 3,
						textWidth, hintH - 6, tocolor(18,18,28,255*alpha)
					)

					dxDrawTextShadow(hint.text,
						startX - textWidth, startY,
						startX, startY + hintH,
						tocolor(255,255,255,255*alpha),
						scale, font,
						'center', 'center', 1, tocolor(0, 0, 0, 50*alpha), false, dxDrawText
					)

					startY = startY + hintH + paddingY

				end


			end,

		},

		{'element',

			40, 120,
			528, 920,
			color = {255,255,255,255},

			variable = 'vinilsControls',

			onInit = function(element)

				element.animationAlpha = {}
				setAnimData(element.animationAlpha, 0.1, 1)

			end,

			toggle = function(element, flag)

				animate(element.animationAlpha, flag and 1 or 0)

			end,

			isVisible = function(element)

				local _, target = getAnimData(element.animationAlpha)
				return target == 1

			end,

			onKey = {

				o = function(element)

					local _, target = getAnimData(vinilsControls.animationAlpha)
					vinilsControls:toggle( target ~= 1 )
					addVinilButton:toggle( target ~= 1 )
					vinilsShop:toggle( false )

				end,

			},

			noDraw = function(element)

				local anim, target = getAnimData(vinilsControls.animationAlpha)
				if target == 0 then

					local alpha = element:alpha()

					local y = (real_sy - px(40)) * sx/real_sx

					dxDrawText('Нажмите #cd4949O#ffffff, чтобы показать интерфейс',
						40, y,
						40, y,
						tocolor(255,255,255,255*(1-anim)),
						0.5, 0.5, getFont('montserrat_medium', 25, 'light'),
						'left', 'bottom', false, false, false, true
					)

				end


			end,

			elements = {

				{'button',
					20, -88,
					148, 88,

					'',
					bg = 'assets/images/back.png',
					define_from = false,

					color = {255, 255, 255, 255},

					onClick = function(element)
						closeWindow()
					end,
				},

				{'image',

					0, 0,
					528, 497,
					color = {255,255,255,255},

					'assets/images/vinils/draw_bg.png',

					variable = 'vinilsDrawElement',

					addEventHandler('onClientRestore', root, function()

						if not windowOpened then return end
						if currentWindowSection ~= 'vinils' then return end

						setTimer(function()
							vinilsDrawElement:update()
						end, 100, 1)

					end),

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shx,shy,shw,shh = x + w/2 - 556/2, y + h/2 - 525/2 + 5, 556, 525

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/vinils/draw_bg_shadow.png',
							0, 0, 0, tocolor(0, 0, 0, 255*alpha)
						)

					end,

					onRender = function(element)

						local x,y,w,h = element:abs()
						local alpha = element:alpha()

						local gradient = getTextureGradient(getDrawingTexture(element[6]), {
							color = {
								{ 512, 200, 200, 100 },
								{ 0, 0, 0, 0 },
							},
							alpha = alpha,
							angle = -30+180,	
						})

						dxDrawImage(
							x,y,w,h, gradient
						)

					end,

					onPostRender = function(element)

						local x,y,w,h = element:abs()
						local alpha = element:alpha()

						dxDrawText(('%s / %s'):format( #(vinilLayers.elements or {}), Config.vinilsLimit ),
							x+w-30, y+30,
							x+w-30, y+30,
							tocolor(150,150,170,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
							'right', 'top'
						)

					end,

					addMarker = function(element, layer)

						layer.marker = element.render_element:addElement(
							{'element',

								0, 0, 0, 0,
								color = {255,255,255,255},

								layer = layer,

								onRender = function(element)

									local alpha = element.parent:alpha()

									local size = Config.vinilRTSize

									local mul = element.parent[4]/size

									if element.layer == vinilLayers.edit_layer then

										local cx,cy = getCursorPosition()

										if cx and cy then

											cx,cy = cx*sx, cy*real_sy*sx/real_sx

											local prx,pry = element.parent:abs()

											local _abs = { x = prx, y = pry }
											local _side = { x = 'w', y = 'h' }
											local _pos = { x = cx, y = cy }

											for _, dim in pairs( {'x', 'y'} ) do

												local slider = vinilsEdit:getProperty(dim)


												local min,max = unpack(
													type(slider.property.range) == 'function' and
													slider.property.range( element.layer.data )
													or (slider.property.range or {})
												)

												local size = element.layer.data[ _side[dim] ]

												local value = math.floor(( _pos[dim] - _abs[dim] - size*mul/2 )/mul )

												if min then
													value = math.clamp( value, min, max )
												end

												element.layer.data[ dim ] = value

											end


											vinilsEdit:loadLayer( element.layer.data )
											vinilsDrawElement:update()

										end

									end

									element[2] = element.layer.data.x*mul
									element[3] = element.layer.data.y*mul
									element[4] = element.layer.data.w*mul
									element[5] = element.layer.data.h*mul


									local x,y,w,h = element:abs()

									local r,g,b = unpack( element.layer.data.color or {255,255,255} )

									local path = string.format('assets/vinils/%s', element.layer.data.path)

									if element.layer == vinilLayers.layer then

										local r,g,b = 180,70,70

										if element.layer == vinilLayers.edit_layer then
											r,g,b = 20, 140, 255
										end

										dxDrawImage(
											x-30,y-30,w+60,h+60, 'assets/images/vinils/selvinil.png',
											( element.layer.data.r or 0 ), 0, 0,
											tocolor(r,g,b,255*alpha)
										)

									end

									if element.layer.data.mirrorx or element.layer.data.mirrory then

									    vinilsEdit.shaders.mirror = vinilsEdit.shaders.mirror or dxCreateShader('assets/shader/mirror.fx')

									    local shader = vinilsEdit.shaders.mirror

									    local texture = getDrawingTexture(path)

									    dxSetShaderValue(shader, 'mirrorX', element.layer.data.mirrorx and 1 or 0)
									    dxSetShaderValue(shader, 'mirrorY', element.layer.data.mirrory and 1 or 0)

									    local r,g,b = unpack( element.layer.data.color or {255,255,255} )

									    dxSetShaderValue(shader, 'gTexture', texture)
									    dxSetShaderValue(shader, 'r', r/255)
									    dxSetShaderValue(shader, 'g', g/255)
									    dxSetShaderValue(shader, 'b', b/255)
									    dxSetShaderValue(shader, 'alpha', element.layer.data.alpha)

										dxDrawImage(
											x,y,w,h, shader,
											( element.layer.data.r or 0 )
										)

								    else

										dxDrawImage(
											x,y,w,h, path,
											( element.layer.data.r or 0 ), 0, 0,
											tocolor(r,g,b, 255*( element.layer.data.alpha or 1 )*alpha)
										)

								    end



								end,

								onClick = function(element, pos, button)

									if vinilLayers.edit_layer and vinilLayers.edit_layer ~= element.layer then
										handleClick = true
										return
									end

									for index = element.__data.id+1, #element.parent.elements do

										local n_element = element.parent.elements[index]

										if isMouseInPosition( n_element:abs() ) then
											handleClick = true
											return
										end

									end

									if button == 'right' then

										vinilLayers.layer = element.layer

										if not vinilLayers.edit_layer then

											vinilLayers:setEditLayer( element.layer )

										else

											local x,y,w,h,r = unpack(element.layer.prev_pos or {})

											element.layer.prev_pos = nil

											if x and y then
												element.layer.data.x = x
												element.layer.data.y = y
												element.layer.data.w = w
												element.layer.data.h = h
												element.layer.data.r = r
											end

											vinilsEdit:loadLayer(element.layer.data)
											vinilLayers.edit_layer = nil

										end

									elseif button == 'left' then

										vinilLayers.layer = element.layer
										vinilsEdit:loadLayer(element.layer.data)

										if vinilLayers.edit_layer == element.layer then
											vinilLayers.edit_layer = nil
										end

									end

								end,

								onScroll = function(element, side)

									if element.layer == vinilLayers.edit_layer then

										if getKeyState( 'lctrl' ) then

											local delta = side == 'down' and 5 or -5
											element.layer.data.r = (element.layer.data.r or 0) + delta

											vinilsEdit:loadLayer( element.layer.data )
											vinilsDrawElement:update()

										else

											local delta = side == 'down' and -30 or 30
											local sliders = {'w', 'h'}

											for _, slider_name in pairs( sliders ) do

												local slider = vinilsEdit:getProperty(slider_name)

												local min,max = unpack(
													type(slider.property.range) == 'function' and
													slider.property.range( vinilLayers.layer.data )
													or (slider.property.range or {})
												)

												local value = vinilLayers.layer.data[slider_name] + delta

												if min then
													value = math.clamp( value, min, max )
												end

												slider.edit_element:setValue( value )

											end

										end

									elseif vinilLayers.edit_layer then

										vinilLayers.edit_layer.marker:callHandler('onScroll', side)

									end

								end,

								move = function(element, side)

									local id = element.__data.id
									local m_element = element.parent.elements[id + side]

									if not m_element then return end

									local _y = element[3]
									element[3] = m_element[3]
									m_element[3] = _y

									element.__data.id = id + side
									m_element.__data.id = id

									element.parent.elements[id + side] = element
									element.parent.elements[id] = m_element

								end,

							}
						)

					end,

					createRenderTarget = function(element)
						element.renderTarget = isElement(element.renderTarget) and element.renderTarget or
							dxCreateRenderTarget(Config.vinilRTSize, Config.vinilRTSize, true)
					end,

					onInit = function(element)

						openHandlers.vinils_rt = function()

							if currentWindowSection == 'vinils' then
								vinilsDrawElement:createRenderTarget()
							end

						end

						closeHandlers.vinils_rt = function()

							setTimer(createVehicleVinils, 100, 1, localPlayer.vehicle)

						end

						element:createRenderTarget()

						element.render_element = element:addElement(
							{'image',

								'center', 0,
								480,480,
								'assets/images/vinils/scans/default.png',
								color = {100,100,120,150},

								createRenderTarget = function(element)
									element.renderTarget = isElement(element.renderTarget) and element.renderTarget or
										dxCreateRenderTarget(element[4], element[5], true)
								end,

								onRender = {

									function(element)

										element:createRenderTarget()

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										local scanPath = string.format('assets/images/vinils/scans/%s.png', localPlayer.vehicle.model)

										if not fileExists(scanPath) then
											scanPath = 'assets/images/vinils/scans/default.png'
										end

										element[6] = scanPath

									end,

								},

							}
						)

						element:addElement(
							{'element',

								'center', 'center',
								'100%', '100%',
								color = {255,255,255,255},

								variable = 'vinilTransforms',

								getKeyTransform = function(element, key)

									if not key:find('arrow') then return key end

									local side, angle = element:getCurrentTransform()

									local steps = math.floor(angle/90)
									if steps == 0 then return key end

									local arrows = {
										'arrow_d',
										'arrow_l',
										'arrow_u',
										'arrow_r',
									}

									for index, arrow in pairs( arrows ) do

										if arrow == key then

											return arrows[ cycle( index + steps, 1, #arrows ) ]

										end

									end

								end,

								getCurrentTransform = function(element)

									local vx,vy = camera.targetPosition.x, camera.targetPosition.y
									local cx,cy = getCameraMatrix()

									local sideCoords = {}

									for id, side in pairs( element.transform_sides ) do

										local angle = -side.angle+90 + localPlayer.vehicle.rotation.z

										table.insert(sideCoords, {
											side = id,
											angle = angle,
											point = {getPointFromDistanceRotation( vx,vy, camera.distance, angle )},
										})

									end

									table.sort(sideCoords, function(a,b)

										return getDistanceBetweenPoints2D( cx,cy, unpack( a.point ) ) <
											getDistanceBetweenPoints2D( cx,cy, unpack( b.point ) )

									end)

									return sideCoords[1].side, sideCoords[1].angle

								end,

								transform_sides = {

									top = {
										getCoords = function(element) return element[4]/2 - 20/2, 0, 20, 20, 180 end,
										angle = 90,
									},

									bottom = {
										getCoords = function(element) return element[4]/2 - 20/2, element[5]-20, 20, 20, 0 end,
										angle = -90,
									},

									left = {
										getCoords = function(element) return 0, element[5]/2 - 20/2, 20, 20, 90 end,
										angle = 180,
									},

									right = {
										getCoords = function(element) return element[4]-20, element[5]/2 - 20/2, 20, 20, -90 end,
										angle = 0,
									},

								},


								onRender = {

									function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										local current_side = element:getCurrentTransform()

										for id, side in pairs( element.transform_sides ) do

											local rx,ry,rw,rh, rot = side.getCoords(element)

											if not side.anim then
												side.anim = {}
												setAnimData(side.anim, 0.1)
											end

											local anim = getAnimData(side.anim)
											animate( side.anim, current_side == id and 1 or 0 )

											local r,g,b = interpolateBetween( 60,60,80, 180, 70, 70, anim, 'InOutQuad' )

											dxDrawImage(
												x+rx,y+ry,rw,rh, 'assets/images/vinils/tr.png',
												rot, 0, 0,
												tocolor(r,g,b,255*alpha)
											)

											if isMouseInPosition(x+rx,y+ry,rw,rh) and handleClick then
												camera.rotationHorizontal = side.angle+180
												handleClick = false
											end

										end

									end,

								},

							}
						)

					end,

					update = function(element)

						element.need_update = true

					end,

					updateLayers = function(element)

						if element.need_update then

							setPaintJobTexture(localPlayer.vehicle, 'noTexture')

							element:createRenderTarget()

							dxSetBlendMode('modulate_add')

							dxSetRenderTarget(element.renderTarget, true)

								local selected

								for _, layer in pairs( vinilLayers.elements or {} ) do

									if vinilLayers.layer == layer then
										selected = layer
									end

									local selected

									if layer == vinilLayers.layer then

										selected = {}

										local r,g,b = 180,70,70

										if layer == vinilLayers.edit_layer then
											r,g,b = 20, 140, 255
										end

										selected.color = {r,g,b}

									end

									drawVinil(layer.data, true, selected)

								end

							dxSetRenderTarget()

							dxSetBlendMode('blend')

							setPaintJobTexture(localPlayer.vehicle, element.renderTarget)

							element.need_update = false

						end

						local x,y,w,h = element:abs()

						if handleClick and isMouseInPosition(x,y,w,h) then

							vinilLayers.layer = nil
							element:update()
							handleClick = false

						end

					end,

					elements = {


					},

				},

				{'image',
					'left', 497 + 20,
					253, 397,
					color = {22,22,33,255},

					'assets/images/vinils/edit_bg.png',

					variable = 'vinilsEdit',

					shaders = {},

					edit_properties = {

						{ name = 'Позиция X', type = 'number', id = 'x',
							range = function(layer) return { -layer.w/2, Config.vinilRTSize+layer.w/2 } end,
							move_key = { arrow_r = 1, arrow_l = -1 },
							move_toggle_key = 'empty',
						},

						{ name = 'Позиция Y', type = 'number', id = 'y',
							range = function(layer) return { -layer.h/2, Config.vinilRTSize+layer.h/2 } end,
							move_key = { arrow_d = 1, arrow_u = -1 },
							move_toggle_key = 'empty',
						},

						{ name = 'Ширина', type = 'number', id = 'w', range = {30, Config.vinilRTSize},
							move_toggle_key = 'w',
							move_key = { arrow_l = -1, arrow_r = 1 },
						},
						{ name = 'Высота', type = 'number', id = 'h', range = {30, Config.vinilRTSize},
							move_toggle_key = 'w',
							move_key = { arrow_u = 1, arrow_d = -1 },
						},

						{ name = 'Вращение', type = 'number', id = 'r',
							move_toggle_key = 'e',
							move_key = { arrow_l = -1, arrow_r = 1 },
						},

						{ name = 'Непрозр.', type = 'number', id = 'alpha', range = {0,1}, step = 0.01,
							move_toggle_key = 'r',
							move_key = { arrow_l = -1, arrow_r = 1 },
						},

						{ name = 'Отразить X', type = 'checkbox', id = 'mirrorx' },
						{ name = 'Отразить Y', type = 'checkbox', id = 'mirrory' },

					},

					mirrorCurrentLayer = function(element, axis)

						local rotation = element:getProperty('r')
						local value = tonumber(rotation.edit_element[6])
						rotation.edit_element:setValue( -value )

						local position_slider = element:getProperty(axis)
						local position = tonumber(position_slider.edit_element[6])

						local size_slider = element:getProperty(axis == 'x' and 'w' or 'h')
						local size = tonumber(size_slider.edit_element[6])

						position = position + size/2

						local _half = Config.vinilRTSize/2

						position_slider.edit_element:setValue( -( position - _half ) + _half - size/2 )

						local mirror_checkbox = element:getProperty('mirror' .. axis)
						mirror_checkbox.edit_element:setValue( not mirror_checkbox.edit_element.checked )

					end,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shx,shy,shw,shh = x + w/2 - 253/2, y + h/2 - 397/2 + 5, 253, 397

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/vinils/edit_bg_shadow.png',
							0, 0, 0, tocolor(0, 0, 0, 255*alpha)
						)

					end,

					loadLayer = function(element, data)

						for _, c_element in pairs( element.s_element.elements or {} ) do

							if data[ c_element.id ] or c_element.edit_element[1] == 'checkbox' then
								c_element.edit_element:setValue( data[ c_element.id ], true )
							end

						end

					end,

					getProperty = function(element, id)

						for _, c_element in pairs( element.s_element.elements or {} ) do

							if c_element.id == id then
								return c_element
							end

						end

					end,

					onInit = function(element)

						openHandlers.vinils_layers = function()

							if currentWindowSection == 'vinils' then

								setPaintJobTexture(localPlayer.vehicle, 'noTexture')

								local vinils = localPlayer.vehicle:getData('paintjob') or {}

								vinilLayers:clear()

								for _, vinil in pairs( vinils ) do
									vinilLayers:addLayer( vinil )
								end

							end

						end

						local s_element = element:addElement(
							{'element',

								0, 20,
								element[4], element[5]-40,
								color = {255,255,255,255},

								overflow = 'vertical',

								scrollXOffset = -15,

							}
						)

						element.s_element = s_element

						local startY = 0

						local iw,ih = 205,47
						local padding = 5

						element.properties = {}

						for _, property in pairs( element.edit_properties ) do

							local p_element = s_element:addElement(
								{'image',

									'center', startY,
									iw,ih,
									'assets/images/vinils/edit_item_bg.png',
									color = {16,16,26,255},

									property = property,
									id = property.id,

									icolor = {30,30,40},

									onRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										local r,g,b = unpack( element.icolor )

										drawImageSection(
											x,y,w,h, element[6],
											{ y = 1, x = 0.5 }, tocolor(r,g,b,255*alpha), 1
										)

										dxDrawText(element.property.name,
											x,y,x+w/2,y+h,
											tocolor(255,255,255,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 19, 'light'),
											'center', 'center'
										)

									end,

									onPostInit = function(element)

										if element.id == 'h' then

											element:addElement(
												{'image',

													10, -5/2 - 32/2,
													10,32,
													'assets/images/vinils/chain.png',
													color = {255,255,255,255},

													onInit = function(element)
														element.c_anim = {}
														setAnimData(element.c_anim, 0.3)
													end,

													onRender = function(element)

														animate(element.c_anim, element.parent.synchronize and 1 or 0)
														local anim = getAnimData(element.c_anim)

														local r,g,b = interpolateBetween( 255,255,255, 255,110,110, anim, 'InOutQuad' )

														element.color = {r,g,b, element.color[4]}

													end,

													postRenderPriority = true,

													onClick = function(element)
														element.parent.synchronize = not element.parent.synchronize
													end,

												}
											)

										end

									end,

								}
							)

							property.element = p_element

							if property.type == 'checkbox' then

								p_element.edit_element = p_element:addElement(
									{'checkbox',
										function(s,p) return p[4] - p[4]/4 - s[4]/2 end, 'center',
										69, 28,

										color = {18,18,28,255},
										fgColor = {46,43,64,255},
										activeColor = {180,70,70,255},

										bg = 'assets/images/vinils/cb_bg.png',
										fg = 'assets/images/vinils/cb_fg.png',
										size = 45,

										padding = 3,

										onCheck = function(element, checked)

											if not vinilLayers.layer then return end

											vinilLayers.layer.data[element.parent.id] = checked
											vinilsDrawElement:update()

										end,

										setValue = function(element, value)

											element.checked = value
											element:callHandler('onCheck', element.checked)

										end,

									}
								)

							elseif property.type == 'number' then

								p_element.edit_element = p_element:addElement(
									{'input',

										'right', 'center',
										function(s,p) return p[4]/2 end, '100%',
										'',

										alignX = 'center',
										possibleSymbols = '1234567890.',

										color = {255,255,255,255},
										textColor = {255,255,255,255},

										font = getFont('montserrat_semibold', 24, 'light'),
										scale = 0.5,

										property = property,

										onDragDrop = function(element, _, _, x,y)

											if not vinilLayers.layer then return end

											local step = getKeyState('lshift') and 25 or 1
											step = step * (element.parent.property.step or 1)

											if element.prev_x then

												if pressed.mouse1 and math.abs( getTickCount() - pressed.mouse1 ) < 50 then return end

												local delta = x - element.prev_x
												if delta ~= 0 then

													local value = (tonumber(element[6]) or 0) + ( delta > 0 and step or -step )

													local min,max = unpack(
														type(element.parent.property.range) == 'function' and
														element.parent.property.range( vinilLayers.layer.data )
														or (element.parent.property.range or {})
													)

													if min then
														value = math.clamp( value, min, max )
													end

													value = math.round( value, 2 )

													local wSlider = vinilsEdit:getProperty('w')
													local hSlider = vinilsEdit:getProperty('h')
													local p_id = element.parent.id

													if hSlider.synchronize then

														if p_id == 'w' then

															local prev = tonumber(element[6]) or 0

															if prev == vinilLayers.layer.data.h then
																hSlider.edit_element:setValue(value)
															else
																local delta = prev/value
																hSlider.edit_element:setValue( math.round( vinilLayers.layer.data.h/delta ) )
															end

														elseif p_id == 'h' then

															local prev = tonumber(element[6]) or 0

															if prev == vinilLayers.layer.data.w then
																wSlider.edit_element:setValue(value)
															else
																local delta = prev/value
																wSlider.edit_element:setValue( math.round( vinilLayers.layer.data.w/delta ) )
															end

														end

													end

													element:setValue(value)

												end

											end

											element.prev_x = x

										end,

										onInput = function(element)

											if not vinilLayers.layer then return end

											local value = tonumber(element[6]) or 0

											vinilLayers.layer.data[element.parent.id] = value

											vinilsDrawElement:update()

										end,

										setValue = function(element, value, keep_values)

											local prev = tonumber(element[6]) or 0

											if not keep_values then

												if element.parent.id == 'w' then

													local xSlider = vinilsEdit:getProperty('x')
													local x_value = tonumber( xSlider.edit_element[6] ) or 0
													xSlider.edit_element:setValue( x_value - ( value - prev )/2 )

												elseif element.parent.id == 'h' then

													local ySlider = vinilsEdit:getProperty('y')
													local y_value = tonumber( ySlider.edit_element[6] ) or 0
													ySlider.edit_element:setValue( y_value - ( value - prev )/2 )

												end

											end

											
											element[6] = tostring(value)
											element:callHandler('onInput')

										end,


									}
								)

							end

							startY = startY + ih + padding

						end

						s_element:addElement(
							{'image',

								'center', startY,
								201, 235,

								color = {30,30,40,255},
								'assets/images/vinils/vcolorbg.png',
								-- createTextureSource('bordered_rectangle', 'assets/images/vinils/vcolorbg.png', 16, 201, 235),

								variable = 'vinilsPaint',

								id = 'color',

								elements = {

									{'element',
										
										14, 15,
										140, 140,

										color = {255, 255, 255, 255},

										hsv = {0, 0, 1},

										onInit = {

											function(element)
												element.palette_mask = 'assets/images/pmask.png'
												-- element.palette_mask = createTextureSource('bordered_rectangle', 'assets/images/pmask.png', 22, 300, 300)
											end,

											function(element)
												vinilsPaint.palette = element
												vinilsPaint.edit_element = element
											end,

										},

										bg = 'assets/images/palette.png',

										onRender = {

											function(element)
												
												local alpha = element:alpha()
												local x,y,w,h = element:abs()

												dxDrawImage(
													x,y,w,h, cutTextureByMask( getDrawingTexture( element.bg ), {
														alpha = alpha,
														mask = getDrawingTexture( element.palette_mask )
													} )
												)

											end,

											function(element)

												local x,y = unpack(element.hsv)
												y = 1 - y


												local alpha = element:alpha()
												local ex,ey,ew,eh = element:abs()

												dxDrawImage(
													ex + x*ew - 8,
													ey + y*eh - 8,
													16, 16, 'assets/images/palette_target.png',
													0, 0, 0, tocolor(180, 70, 70, 255*alpha)
												)

											end,

										},

										setValue = function(element, color)
											element:setColor( unpack(color) )
											vinilsPaint.input[6] = RGBToHex( unpack(color) ):upper()
										end,

										setColor = function(element, r,g,b)
											local h,s,v = rgbToHsv(r,g,b)
											element.hsv = {h,s,v}
										end,

										getColor = function(element)
											local r,g,b = hsvToRgb(unpack(element.hsv))
											return r,g,b
										end,

										onColorChange = function(element, r,g,b)

											if not vinilLayers.layer then return end

											vinilLayers.layer.data.color = {r,g,b}
											vinilsDrawElement:update()

											vinilsPaint.input[6] = RGBToHex(r,g,b):upper()

										end,

										onDragDrop = function(element, _, _, x,y)

											local ex,ey = element:abs(true)

											x = x*real_sx - px(ex)
											y = y*real_sy - px(ey)
											x = x * sx/real_sx
											y = y * sx/real_sx

											local h,s = 
									            math.clamp(x / element[4],  0, 1),
									            1 - math.clamp(y / element[5],  0, 1)

								            element.hsv = {h,s, element.hsv[3]}

								            element:onColorChange( hsvToRgb( unpack(element.hsv) ) )

										end,

									},

									{'element',
										function(s,p) return p[4] - s[4] - 15 end, 15,
										18, 140,

										bg='assets/images/alpha.png',
										color = {255, 255, 255, 255},

										onRender = {

											function(element)
												
												local alpha = element:alpha()
												local x,y,w,h = element:abs()

												dxDrawImage(
													x,y,w,h, cutTextureByMask( getDrawingTexture( element.bg ), {
														alpha = alpha,
														mask = getDrawingTexture( element.palette_alpha )
													} )
												)

											end,

											function(element)

												local alpha = element:alpha()
												local ex,ey,ew,eh = element:abs()

												local y = 1-vinilsPaint.palette.hsv[3]

												local rw, rh = ew+5, 3
												local rx,ry = ex+ew/2 - rw/2, (ey+8)+(eh-16)*y-rh/2

												mta_dxDrawRectangle(
													px(rx) - 1, px(ry) - 1,
													px(rw)+2, px(rh)+2,
													tocolor(0, 0, 0, 150*alpha)
												)

												dxDrawRectangle(
													rx,ry,
													rw,rh,
													tocolor(180, 70, 70, 255*alpha)
												)

												local r,g,b = hsvToRgb( 
													vinilsPaint.palette.hsv[1],
													vinilsPaint.palette.hsv[2],
													1
												)
												element.color = {r,g,b, element.color[4]}

											end,

										},

										onDragDrop = function(element, _, _, x,y)

											local ex,ey = element:abs(true)

											y = y*real_sy - px(ey)

											local v = 1-math.clamp(y / element[5],  0, 1)
											vinilsPaint.palette.hsv[3] = v

											vinilsPaint.palette:onColorChange( hsvToRgb( unpack(vinilsPaint.palette.hsv) ) )
										end,

										onInit = {

											function(element)
												vinilsPaint.alpha = element
											end,

											function(element)
												element.palette_alpha = 'assets/images/palpha.png'
												-- element.palette_alpha = createTextureSource('bordered_rectangle', 'assets/images/palpha.png', 15, 25, 200)
											end,

										},

									},

									{'input',
										10, function(s,p) return p[5] - s[5] - 40 end,
										function(s,p) return p[4]/2 end, 35,
										-- function(s,p) return p[4] - 30 end, 35,
										'',

										color = {18,18,28,255},
										placeholderColor = {120,120,150,255},

										alignX = 'center',
										possibleSymbols = '#1234567890abcdef',

										scale = 0.5,
										font = getFont('montserrat_bold', 19, 'light'),
										maxSymbols = 7,

										onInit = function(element)
											element.bg = 'assets/images/vinils/colorbg_input2.png'
											-- element.bg = createTextureSource('bordered_rectangle', 'assets/images/vinils/colorbg_input2.png', 16, element[4], element[5])
											vinilsPaint.input = element
										end,

										onInput = function(element)

											element[6] = element[6]:upper()

											if #element[6] == 7 then
												local r,g,b = hexToRGB(element[6] or '')
												if r and g and b then
													vinilsPaint.palette:onColorChange(r,g,b)
													vinilsPaint.palette:setColor(r,g,b)
												end
											elseif element[6]:sub(1,1) ~= '#' then
												element[6] = '#'..element[6]
											end

										end,

									},

									{'button',
										function(s,p) return p[4] - s[4] - 10 end,
										function(s,p) return p[5] - s[5] - 40 end,
										function(s,p) return p[4]/2 - 10 end, 35,
										-- function(s,p) return p[4] - 30 end, 35,
										'В палитру',

										color = {220,90,90,255},

										scale = 0.5,
										font = getFont('montserrat_bold', 19, 'light'),

										define_from = false,

										onInit = function(element)
											element.bg = 'assets/images/vinils/colorbg_input2.png'
											-- element.bg = createTextureSource('bordered_rectangle', 'assets/images/vinils/colorbg_input2.png', 16, element[4], element[5])
										end,

										onClick = function(element)

											if #vinilsPaint.input[6] == 7 then

												local r,g,b = hexToRGB( vinilsPaint.input[6] )

												if r and g and b then
													vinilsPalette:addColor( vinilsPaint.input[6] )
												end

											end


										end,

									},

									{'element',
										'center', function(s,p) return p[5] - s[5] - 10 end,
										function(s,p) return p[4]/2 - 10 end, 25,
										color = {255,255,255,255},

										variable = 'vinilsPalette',

										addColor = function(element, hex)
											table.insert(element.slots, 1, hex)
											element.slots = table.slice( element.slots, 1, element.slotsCount )
										end,

										slots = {},
										slotsCount = 7,

										onInit = function(element)

											local slots = element.slotsCount

											local w,h = 22,22
											local padding = 3

											local bg = 'assets/images/vinils/pcolor.png'
											-- local bg = createTextureSource('bordered_rectangle', 'assets/images/vinils/pcolor.png', 10, w, h)

											local sCount = slots/2

											local startX = element[4]/2 - sCount*w - padding*(sCount-0.5)

											for slot = 1, slots do

												element:addElement(
													{'image',
														startX, 'center',
														w,h,
														bg,
														color = { 18,18,28, 255 },

														slot = slot,

														onPreRender = function(element)

															local alpha = element:alpha()
															local x,y,w,h = element:abs()

															local hex = element.parent.slots[element.slot]

															if hex then

																local r,g,b = hexToRGB( hex )
																element.color = { r,g,b,element.color[4] }

																if hex == vinilsPaint.input[6] then

																	local sin = math.abs( math.sin( getTickCount() * 0.0016 ) )

																	dxDrawImage(
																		x - 1, y - 1,
																		w + 2, h + 2,
																		element[6],
																		0, 0, 0, tocolor( 255,255,255, 255*alpha*sin )
																	)

																end

															else

																element.color = { 18,18,28,element.color[4] }

																element.draw_empty = true

																dxDrawImage(
																	x,y,w,h,
																	'assets/images/vinils/setcolor.png',
																	0, 0, 0, tocolor( 100,100,120, 255*alpha )
																)

															end

														end,

														onRender = function(element)

															local alpha = element:alpha()
															local x,y,w,h = element:abs()

															if element.draw_empty then

																dxDrawImage(
																	x+5,y+5,w-10,h-10,
																	'assets/images/vinils/setcolor.png',
																	0, 0, 0, tocolor( 100,100,120, 255*alpha )
																)

																element.draw_empty = nil
																
															end

														end,

														onClick = function(element)

															if element.parent.slots[element.slot] then 

																local hex = element.parent.slots[element.slot]

																vinilsPaint.input[6] = hex
																vinilsPaint.input:callHandler('onInput')

															end

														end,

													}
												)

												startX = startX + w + padding

											end

										end,

									},


								},


							}
						)



					end,

				},

				{'image',
					'right', 497 + 20,
					253, 397,
					color = {22,22,33,255},

					'assets/images/vinils/edit_bg.png',

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shx,shy,shw,shh = x + w/2 - 253/2, y + h/2 - 397/2 + 5, 253, 397

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/vinils/edit_bg_shadow.png',
							0, 0, 0, tocolor(0, 0, 0, 255*alpha)
						)

					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						drawImageSection(
							x,y,w,h, element[6],
							{ x = 1, y = 100/h }, tocolor(18,18,28,255*alpha), 1
						)

					end,

					elements = {

						{'element',

							0, 20,
							'100%', function(s,p) return p[5] - 20 - 100 end,
							color = {255,255,255,255},

							overflow = 'vertical',
							variable = 'vinilLayers',

							addEvent('vinils.resetBasket', true),
							addEventHandler('vinils.resetBasket', resourceRoot, function()

								for _, layer in pairs( vinilLayers.elements or {} ) do
									layer.data.basket = nil
									layer.data.collection = nil
								end

							end),

							scrollXOffset = -15,

							clear = function(element)

								for _, c_element in pairs( element.elements or {} ) do
									c_element:destroy()
								end

								element.elements = {}

							end,

							onInit = function(element)

								closeHandlers.clear_layers = function()

									vinilLayers:clear()

								end

							end,

							setCurrentLayer = function(element, layer, cancel_edit)

								if element.edit_layer ~= layer and not cancel_edit then
									element:setEditLayer(layer)
								else
									element.edit_layer = nil
								end

								element.layer = layer
							end,

							setEditLayer = function(element, layer)

								element.layer = layer
								element.edit_layer = layer

								layer.prev_pos = { layer.data.x, layer.data.y, layer.data.w, layer.data.h, layer.data.r }

							end,

							addLayer = function(element, data)

								data.category = nil

								local iw,ih = 205, 45
								local padding = 10

								data.layer_name = string.format('Слой %s', #(element.elements or {}) + 1)

								local endY = 0

								if element.elements then

									local lastElement = element.elements[ #element.elements ]
									if lastElement then
										endY = lastElement[3] + lastElement[5]
									end
									
								end

								local s_index

								for index, layer in pairs( element.elements ) do
									if layer == element.layer then
										s_index = index+1
										break
									end
								end

								return element:addElement(
									{'image',

										'center', 0,
										iw,ih,
										color = {18,18,28,255},
										'assets/images/vinils/layer_item_bg.png',

										data = data,

										initializeData = function(element)

											local _data = {

												x = 2048/2-512/2, y = 2048/2-512/2,
												w = 512, h = 512,
												r = 0,
												alpha = 1,
												color = {255,255,255},

											}

											for k,v in pairs( _data ) do
												element.data[k] = element.data[k] or v
											end

										end,

										onInit = function(element)

											element.t_anim = {}
											setAnimData(element.t_anim, 0.5)

											element:initializeData()

											vinilsDrawElement:addMarker(element)
											vinilsDrawElement:update()

										end,

										onPreRender = function(element)

											local id = element.__data.id
											local ih = element[5]
											local startY = 0
											local padding = 10

											for _, c_element in pairs( element.parent.elements or {} ) do

												if c_element == element then
													element[3] = startY
													break
												end

												startY = startY + ih + padding

											end

										end,

										onRender = function(element)

											local x,y,w,h = element:abs()
											local alpha = element:alpha()

											local anim = getAnimData(element.t_anim)
											animate(element.t_anim, element.parent.layer == element and 1 or 0)

											local r,g,b = interpolateBetween(100,100,100,255,255,255, anim, 'InOutQuad')

											dxDrawText(element.data.layer_name,
												x+40, y+15, 
												x+40, y+15,
												tocolor(r,g,b,255*alpha*anim),
												0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
												'left', 'center'
											)

											dxDrawText('Выбрано',
												x+40, y+30, 
												x+40, y+30,
												tocolor(60,60,85,255*alpha*anim),
												0.5, 0.5, getFont('montserrat_semibold', 19, 'light'),
												'left', 'center'
											)

											dxDrawText(element.data.layer_name,
												x+40, y, 
												x+40, y+h,
												tocolor(r,g,b,255*alpha*(1-anim)),
												0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
												'left', 'center'
											)

											if element.data.basket then

												local bw,bh = 18,18
												local bx,by = x+w-87, y+h/2-bh/2

												dxDrawImage(
													bx,by,bw,bh, 'assets/images/vinils/basket.png',
													0, 0, 0, tocolor(100,100,100,255*alpha)
												)

											end


										end,

										onPostRender = function(element)

											local x,y,w,h = element:abs(true)
											if isMouseInPosition(x,y,w,h) and handleClick then

												element:select()

												handleClick = false

											end

										end,

										move = function(element, side)

											local id = element.__data.id
											local m_element = element.parent.elements[id + side]

											if not m_element then return end

											local _y = element[3]
											element[3] = m_element[3]
											m_element[3] = _y

											element.__data.id = id + side
											m_element.__data.id = id

											element.parent.elements[id + side] = element
											element.parent.elements[id] = m_element

											element.marker:move(side)

											vinilsDrawElement:update()

										end,

										onPostDestroy = function(element)

											element.marker:destroy()
											vinilsDrawElement:update()

											local index = 1
											local list = {}

											for _, _element in pairs( element.parent.elements ) do

												list[index] = _element
												_element.__data.id = index
												_element.data.layer_name = string.format('Слой %s', _element.__data.id)

												index = index + 1

											end

											element.parent.elements = list

											setAnimData(vinilLayers.ov_animId, 0.1, 0)

										end,

										select = function(element)

											element.parent.layer = element
											vinilsEdit:loadLayer(element.data)

											vinilsDrawElement:update()

										end,

										remove = function(element)

											if element.parent.layer == vinilLayers.edit_layer then
												vinilLayers.edit_layer = nil
											end

											local id = element.__data.id
											local o_element = element.parent.elements[ id - 1 ] or element.parent.elements[ id + 1 ]

											if o_element then
												o_element:select()
											end

											element:destroy()

										end,

										elements = {

											{'button',

												function(s,p) return p[4] - s[4] - 20 end, 'center',
												15,15,
												'',

												color = {100,100,100,255},
												activeColor = {255,255,255,255},

												define_from = false,
												bg = 'assets/images/vinils/remove.png',

												onClick = function(element)

													dialog('Удаление', {
														'Вы действительно хотите',
														'удалить слой?',
													}, function(result)

														if result then
															element.parent:remove()
														end

													end)

												end,

											},

											{'button',

												function(s,p) return p[4] - s[4] - 45 end, 'center',
												15,15,
												'',

												color = {100,100,100,255},
												activeColor = {255,255,255,255},

												define_from = false,
												bg = 'assets/images/vinils/copy.png',

												onInit = function(element)
													element.parent.copy = element
												end,

												onKey = {
													c = function(element)
														if element.parent.parent.layer == element.parent then
															setTimer(function()
																element:onClick()
															end, 100, 1)
														end
													end,
												},

												onClick = function(element)

													if #vinilLayers.elements >= Config.vinilsLimit then
														return exports.hud_notify:notify('Ошибка', ('Ограничение - %s слоев'):format(Config.vinilsLimit))
													end

													local data = table.copy( element.parent.data )


													local config = Config.vinilsAssoc[ data.path ]
													if config and config.noSell then
														return
													end

													data.basket = true

													vinilLayers:setCurrentLayer( vinilLayers:addLayer( data ), true )


												end,

											},

											{'element',
												15, 'center',
												14, 20,
												color = {255,255,255,255},

												elements = {

													{'button',

														0, 'top',
														14,8,
														'',

														color = {100,100,100,255},
														activeColor = {220,90,90,255},

														define_from = false,
														bg = 'assets/images/vinils/ud_arrow.png',

														onClick = function(element)

															element.parent.parent:move(-1)

														end,

													},

													{'button',

														0, 'bottom',
														14,8,
														'',

														color = {100,100,100,255},
														activeColor = {220,90,90,255},

														define_from = false,
														bg = 'assets/images/vinils/ud_arrow.png',

														rot = 180,

														onClick = function(element)

															element.parent.parent:move(1)

														end,

													},

												},

											},

										},

									}, s_index
								)

							end,

							elements = {},

						},

						{'button',
							'center', function(s,p) return p[5] - s[5] - 20 end,
							157, 36,
							'Применить',

							bg = 'assets/images/vinils/btn_empty.png',
							_activeBg = 'assets/images/vinils/btn.png',
							shadow = 'assets/images/vinils/btn_empty_shadow.png',
							activeShadow = 'assets/images/vinils/btn_shadow.png',
							shadow_size = {174,52},

							font = getFont('montserrat_medium', 22, 'light'),

							onRender = function(element)

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								local sum = 0

								for _, layer in pairs( vinilLayers.elements or {} ) do

									if layer.data.basket then

										local config = Config.vinilsAssoc[layer.data.path]
										sum = sum + config.cost

									end

								end

								dxDrawText(string.format('$ %s', splitWithPoints(sum, '.')),
									x,y-10,x+w,y-10,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
									'center', 'bottom'
								)

							end,

							onInit = function(element)
								element.animationAlpha = {}
								setAnimData(element.animationAlpha, 0.1, 1)
							end,

							onClick = function(element)

								local count = 0
								local sum = 0

								for _, layer in pairs( vinilLayers.elements ) do

									if layer.data.basket then

										count = count + 1

										local config = Config.vinilsAssoc[layer.data.path]
										sum = sum + config.cost

									end

								end

								dialog('Покупка', {
									'Вы действительно хотите оплатить',
									string.format('%s %s на %s$?',
										count, getWordCase(count, 'наклейку', 'наклейки', 'наклеек'), splitWithPoints(sum, ' ')
									),
								}, function(result)

									if result then

										local x,y,w,h = element:abs()

										local list = {}

										for _, element in pairs( vinilLayers.elements ) do
											table.insert(list, { data = element.data })
										end

										triggerServerEvent('vinils.buy', resourceRoot, list)

									end


								end)

							end,

						},

					},


				},

				{'image',

					sx, 50,
					463, 724,
					color = {255,255,255,255},

					'assets/images/vinils/shop_bg.png',

					variable = 'vinilsShop',

					addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

						if dn == 'vinils.binds' and new then

							vinilsShop.bindsAssoc = {}

							for key, path in pairs( new ) do
								vinilsShop.bindsAssoc[path] = key
							end

							vinilsShop:saveBinds()

						end

					end),

					tabs = {
						{ name = 'Магазин', id = 'shop' },
						{ name = 'Коллекция', id = 'collection' },
					},

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shx,shy,shw,shh = x + w/2 - 491/2, y + h/2 - 752/2 + 5, 491, 752

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/vinils/shop_bg_shadow.png',
							0, 0, 0, tocolor(0, 0, 0, 255*alpha)
						)

					end,

					onRender = {

						function(element)

							local alpha = element:alpha()
							local x,y,w,h = element:abs()

							local aw,ah = 489,748
							local ax,ay = x+w/2-aw/2, y+h/2-ah/2

							dxDrawImage(
								ax,ay,aw,ah, 'assets/images/vinils/shop_bg_a.png',
								0, 0, 0, tocolor(180, 70, 70, 255*alpha)
							)

							drawImageSection(
								x,y,w,h, element[6],
								{ x = 1, y = 70/h }, tocolor(200,200,200,255*alpha)
							)

							element[2] = sx - (element[4] + 70) * alpha

						end,

					},

					binds_cache_file = 'vinil_binds.json',

					saveBinds = function(element)

						local binds = localPlayer:getData('vinils.binds') or {}

						if fileExists( element.binds_cache_file ) then
							fileDelete( element.binds_cache_file )
						end

						local file = fileCreate(element.binds_cache_file)
						fileWrite( file, toJSON( binds ) )
						fileClose( file )

					end,

					initBinds = function(element)

						local binds = {}

						if fileExists( element.binds_cache_file ) then

							local file = fileOpen(element.binds_cache_file)
							binds = fromJSON( file:read( file.size ), true )
							fileClose(file)

						end

						localPlayer:setData('vinils.binds', binds, false)

						element.bindsAssoc = {}

						for key, path in pairs( binds or {} ) do
							element.bindsAssoc[path] = key
						end

					end,

					onInit = function(element)

						element:initBinds()

						element.animationAlpha = {}
						setAnimData(element.animationAlpha, 0.1, 0)

						local sCount = #element.tabs/2
						local tw,th = 200, 70

						local padding = 10
						local startX = element[4]/2 - sCount*tw - padding*(sCount-0.5)

						element.tab = element.tabs[1]

						for _, tab in pairs( element.tabs ) do

							element:addElement(
								{'element',

									startX, 0,
									tw,th, 
									color = {255,255,255,255},

									tab = tab,

									onInit = function(element)
										element.t_anim = {}
										setAnimData(element.t_anim, 0.1)
									end,

									onRender = function(element)

										local x,y,w,h = element:abs()
										local alpha = element:alpha()

										local anim = getAnimData(element.t_anim)
										animate(element.t_anim, element.tab == element.parent.tab and 1 or 0)

										local r,g,b = interpolateBetween(200,200,200, 180, 70, 70, anim, 'InOutQuad')

										dxDrawText(element.tab.name,
											x,y,x+w,y+h,
											tocolor(r,g,b,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
											'center', 'center'
										)

									end,

									onClick = function(element)
										element.parent.tab = element.tab
										vinilsList:update()
									end,

								}
							)

							startX = startX + tw

						end

					end,

					toggle = function(element, flag)

						animate(element.animationAlpha, flag and 1 or 0)

					end,

					isVisible = function(element)

						local _, target = getAnimData(element.animationAlpha)
						return target == 1

					end,

					elements = {

						{'element',
							0, 'bottom',
							'100%', 75,
							color = {255,255,255,255},

							variable = 'vinilCategories',

							categories = {
								{ id = 'stickers', },
								{ id = 'figures', },
								{ id = 'drift', },
								-- { id = 'cover', },
							},

							onInit = function(element)

								local sCount = #element.categories/2

								local iw,ih = 40,40
								local padding = (element[4] - iw*#element.categories) / ( #element.categories+1 )

								local startX = element[4]/2 - sCount*iw - padding*(sCount-0.5)

								for _, category in pairs( element.categories ) do

									element:addElement(
										{'image',

											startX, 'center',
											iw,ih,
											color = {200,200,200,255},
											string.format('assets/images/vinils/categories/%s.png', category.id),

											onInit = function(element)	
												element.c_anim = {}
												setAnimData(element.c_anim, 0.2)
												element.y0 = element[3]
											end,

											onRender = function(element)

												local anim = getAnimData(element.c_anim)
												animate(element.c_anim, element.parent.category == element.category and 1 or 0)

												element[3] = element.y0 - 5 * anim

												local x,y,w,h = element:abs()
												local r,g,b = interpolateBetween(200,200,200,255,255,255, anim, 'InOutQuad')

												element.color = {r,g,b, element.color[4]}

												dxDrawImage(
													x+w/2-48/2, y+h-5,
													48,22, 'assets/images/vinils/selcategory.png',
													0, 0, 0, tocolor(180,70,70,255*anim)
												)

											end,

											category = category,

											onClick = function(element)
												element.parent.category = element.category
												vinilsList:update()
											end,

										}
									)

									startX = startX + iw + padding

								end

								vinilCategories.category = element.categories[1]

							end,

							onRender = function(element)

								local ex,ey,ew,eh = element.parent:abs()
								local alpha = element:alpha()

								drawImageSection(
									ex,ey,ew,eh, element.parent[6],
									{ x = 1, y = element[5]/eh }, tocolor(200,200,200,255*alpha), 1
								)

							end,

						},

						{'element',

							0, 80,
							'100%', function(s,p) return p[5] - 160 end,
							color = {255,255,255,255},

							overflow = 'vertical',
							scrollXOffset = -25,

							variable = 'vinilsList',

							update = function(element)


								setAnimData(element.ov_animId, 0.1, 0)

								for _, c_element in pairs( element.elements or {} ) do
									c_element:destroy()
								end

								element.elements = {}

								local list = vinilsShop.tab.id == 'shop' and {} or
									(localPlayer:getData('vinils.collection') or {})

								element.current_list = list

								if vinilsShop.tab.id == 'shop' then

									for _, vinil in pairs( Config.vinils ) do

										if not vinil.noSell and vinilCategories.category.id == vinil.category then
											table.insert(list, vinil)
										end

									end

								end

								local rCount = 3
								local sCount = rCount/2

								local rows = math.ceil( #list/rCount )

								local startY = 0

								local iw,ih = 117,117
								local padding_x = 10
								local padding_y = 10

								local index = 1

								for i = 1, rows do

									local p_element = element:addElement(
										{'element',

											0, startY,
											'100%', ih + padding_y,
											color = {255,255,255,255},

										}
									)

									local startX = element[4]/2 - iw*sCount - padding_x*(sCount-0.5)

									for p_i = 1, rCount do

										if list[index] then


											p_element:addElement(
												{'image',

													startX, 'center',
													iw,ih,
													color = {18,18,28,255},

													'assets/images/vinils/shop_item_bg.png',

													data = list[index],
													index = index,

													bindKey = function(element, key)

														if vinilsShop.tab.id == 'shop' then

															local bound = localPlayer:getData('vinils.binds') or {}
															bound[key] = element.data.path

															localPlayer:setData('vinils.binds', bound, false)

														end

													end,

													onRender = function(element)

														local x,y,w,h = element:abs()
														local alpha = element:alpha()

														local path = string.format('assets/vinils/sml/%s', element.data.path)

														if not fileExists( path ) then
															path = string.format('assets/vinils/%s', element.data.path)
														end

														if fileExists( path ) then

															local iw,ih = 55,55

															dxDrawImage(
																x+w/2-iw/2,y+h/2-ih/2-10,iw,ih,
																path, 0, 0, 0, tocolor(255,255,255,255*alpha)
															)

														end

														local iw,ih = 134,134

														dxDrawImage(
															x+w/2-iw/2,y+h/2-ih/2,iw,ih,
															'assets/images/vinils/shop_item_bg_a.png',
															0, 0, 0, tocolor(180,70,70,255*alpha*element.animData)
														)

														if element.data.cost then
															dxDrawText(string.format('$%s', splitWithPoints( element.data.cost, '.' )),
																x, y + h - 15,
																x + w, y + h - 15,
																tocolor(255,255,255,255*alpha),
																0.5, 0.5, getFont('montserrat_bold', 22, 'light'),
																'center', 'bottom'

															)
														else

															local count = element.data.count

															for _, layer in pairs( vinilLayers.elements or {} ) do

																if layer.data.collection and layer.data.path == element.data.path then
																	count = count - 1
																end

															end

															dxDrawText(string.format('%s шт.', count),
																x + 20, y + h - 10,
																x + 20, y + h - 10,
																count == 0 and tocolor(60,60,85,255*alpha) or tocolor(255,255,255,255*alpha),
																0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
																'left', 'bottom'

															)

														end

														if vinilsShop.tab.id == 'shop' then

															if vinilsShop.bindsAssoc and vinilsShop.bindsAssoc[ element.data.path ] then

																local rw,rh = 29,29
																local rx,ry = x+w-rw/2, y+h-rh/2

																dxDrawImage(
																	rx,ry,rw,rh, 'assets/images/vinils/shop_item_add.png',
																	0, 0, 0, tocolor(180,70,70,255*alpha)
																)

																dxDrawText(vinilsShop.bindsAssoc[ element.data.path ]:gsub('num_', ''),
																	rx, ry, rx + rw, ry + rh,
																	tocolor(255,255,255,255*alpha),
																	0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
																	'center', 'center'

																)

															end

															local anim, target = getAnimData(element)

															if target == 1 then

																for i = 1,9 do

																	local key = 'num_' .. i

																	if getKeyState(key) then
																		element:bindKey(key)
																	end

																end

															end

														end

													end,

													onClick = function(element)

														if #vinilLayers.elements >= Config.vinilsLimit then
															return exports.hud_notify:notify('Ошибка', ('Ограничение - %s слоев'):format(Config.vinilsLimit))
														end

														if element.data.count then

															local count = element.data.count

															for _, layer in pairs( vinilLayers.elements or {} ) do

																if layer.data.collection and layer.data.path == element.data.path then
																	count = count - 1
																end

															end

															if count <= 0 then
																return exports.hud_notify:notify('Ошибка', 'Наклейки закончились')
															end

														end

														element:addToEdit()

													end,

													addToEdit = function(element)

														local data = table.copy(element.data)

														data.basket = vinilsShop.tab.id == 'shop'
														data.collection = vinilsShop.tab.id == 'collection'

														data.count = nil

														vinilLayers:setEditLayer( vinilLayers:addLayer( data ) )

													end,

													-- elements = {

													-- 	{'button',

													-- 		function(s,p) return p[4]-s[4]/2-10 end,
													-- 		function(s,p) return p[5]-s[5]/2-10 end,
													-- 		29,29,
													-- 		'+',

													-- 		bg = 'assets/images/vinils/shop_item_add.png',
													-- 		define_from = false,

													-- 		color = {180,70,70,255},
													-- 		activeColor = {220,90,90,255},

													-- 		scale = 0.5,
													-- 		font = getFont('montserrat_medium', 40, 'light'),

													-- 		onClick = function(element)

													-- 			if element.parent.data.count then

													-- 				local count = element.parent.data.count

													-- 				for _, layer in pairs( vinilLayers.elements or {} ) do

													-- 					if layer.data.collection and layer.data.path == element.parent.data.path then
													-- 						count = count - 1
													-- 					end

													-- 				end

													-- 				if count <= 0 then
													-- 					return exports.hud_notify:notify('Ошибка', 'Наклейки закончились')
													-- 				end

													-- 			end

													-- 			local data = table.copy(element.parent.data)

													-- 			data.basket = vinilsShop.tab.id == 'shop'
													-- 			data.collection = vinilsShop.tab.id == 'collection'

													-- 			data.count = nil

													-- 			vinilLayers:setEditLayer( vinilLayers:addLayer( data ) )

													-- 		end,

													-- 	},

													-- },


												}
											)

											startX = startX + iw + padding_x

										end

										index = index + 1

									end

									startY = startY + ih + padding_y

								end

							end,

							onPostInit = function(element)
								element:update()
							end,

							onRender = function(element)

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								if #(element.elements or {}) == 0 then
									dxDrawText('Список пуст',
										x,y,x+w,y+h,
										tocolor(60,60,85,255*alpha),
										0.5, 0.5, getFont('montserrat_medium', 30, 'light'),
										'center', 'center'
									)
								end

							end,

							addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

								if dn == 'vinils.collection' and vinilsShop.tab.id == 'collection' then
									vinilsList:update()
								end

							end),

						},

					},

				},

			},

		},

		{'element',

			0, 0, 82, 82,

			color = {180,70,70,255},

			variable = 'addVinilButton',

			toggle = function(element, flag)
				animate(element.animationAlpha, flag and 1 or 0)
			end,

			onInit = function(element)

				local ex,ey,ew,eh = element:abs()
				local x,y,w,h = vinilsDrawElement:abs()

				element.x0 = x+w-ew-10
				element.y0 = y+h-eh+40

				element.d_anim = { x = {}, y = {} }

				setAnimData(element.d_anim.x, 0.2, element.x0)
				setAnimData(element.d_anim.y, 0.2, element.y0)

				element.animationAlpha = {}
				setAnimData(element.animationAlpha, 0.1, 1)

				openHandlers.vinils_shop = function()
					vinilsShop:toggle( false )
				end

			end,

			onKey = {

				num_add = function(element)
					element:onClick()
				end,

			},

			onRender = function(element)


				element[2] = getAnimData(element.d_anim.x)
				element[3] = getAnimData(element.d_anim.y)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				local vx,vy,vw,vh = vinilsShop:abs()

				local anim, target = getAnimData(vinilsShop.animationAlpha)

				if target == 1 then

					animate(element.d_anim.x, vx-w+15)
					animate(element.d_anim.y, vy+20)

				else

					animate(element.d_anim.x, element.x0)
					animate(element.d_anim.y, element.y0)

				end

				local r,g,b = interpolateBetween(180,70,70, 220,90,90, element.animData, 'InOutQuad')

				dxDrawImage(
					x,y,w,h, 'assets/images/vinils/add_bg.png',
					0, 0, 0, tocolor(r,g,b, 255*alpha)
				)

				dxDrawText('+',
					x,y,x+w,y+h,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat', 60, 'light'),
					'center', 'center', false, false, false, true, false, 45*anim
				)

			end,

			onClick = function(element)

				local _, target = getAnimData(vinilsControls.animationAlpha)
				if target == 0 then return end

				local _, target = getAnimData(vinilsShop.animationAlpha)
				vinilsShop:toggle( target ~= 1 )

			end,

		},

	},

}

-----------------------------------------------------------------

	hideBackground = true
	blurBackground = false

-----------------------------------------------------------------

	-- createTextureSource('bordered_rectangle', 'assets/images/slider.png', 8, 232, 8)

-----------------------------------------------------------------

	GUIDefine('button', {

		[4]=191, [5]=41,

		bg = 'assets/images/btn_empty.png',
		_activeBg = 'assets/images/btn.png',
		color = {180, 70, 70, 255},
		activeColor = {200, 70, 70, 255},

		onPreRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			if not element:is_active() then
				element.activeBg = nil
				return
			end

			element.activeBg = element._activeBg

			local sw,sh = unpack(element.shadow_size or {209, 59})

			local shx,shy,shw,shh = x + w/2 - sw/2, y + h/2 - sh/2, sw,sh

			dxDrawImage(
				shx,shy,shw,shh, element.shadow or 'assets/images/btn_empty_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
			)
			dxDrawImage(
				shx,shy,shw,shh, element.activeShadow or 'assets/images/btn_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
			)

		end,

		is_active = function(element)
			return element:alpha() >= 0.99
		end,
		
		font = getFont('montserrat_semibold', 23, 'light'),
		scale = 0.5,

	})

	GUIDefine('rect_button', {

		bg = whiteTexture,
		bgActive = false,

		color = {180, 70, 70, 255},
		activeColor = {200, 70, 70, 255},

		is_active = function(element)
			return element:alpha() >= 0.99
		end,

		onPreRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local r,g,b = unpack(element.color)
			local ar,ag,ab = unpack(element.activeColor)

			r,g,b = interpolateBetween( r,g,b, ar,ag,ab, element.animData, 'InOutQuad' )

			local shadowSize = 3 * element.animData

			dxDrawRectangle(
				x - shadowSize, y - shadowSize,
				w + shadowSize*2, h + shadowSize*2,
				tocolor(r,g,b, 50*alpha*element.animData)
			)

		end,

		font = getFont('montserrat_semibold', 23, 'light'),
		scale = 0.5,

	})

-----------------------------------------------------------------


	function loadSectionComponents(section)

		animate('tuning-list', 1)

		local components = {}

		section.sortBy = section.sortBy or 'price'

		for index, component in pairs( section.components ) do

			component.index = index
			component.section = section

			local config_link = table.copy(section.config_link)
			table.insert(config_link, index)

			component.config_link = config_link

			table.insert( components, component )
		end

		table.sort(components, function(a,b)
			if a[section.sortBy] == b[section.sortBy] or section.sortBy == 'index' then
				return a.index < b.index
			else
				return a[section.sortBy] < b[section.sortBy]
			end
		end)

		tuningComponentsList.listElements = components
		tuningComponentsList.listOffset = 0

		tuningComponentsList.selectedItem = false
		tuningComponentsList.lastSelectedItem = false

		local value = getTuningValue(section.key)

		for index, component in pairs( tuningComponentsList.listElements ) do

			if value == component.index or (not value and component.default) then

				tuningComponentsList.selectedItem = index
				tuningComponentsList.lastSelectedItem = component

			end

		end


	end

	function initializeTuningGui()

		if not localPlayer.vehicle then return end

		tuningSectionsList.listElements = getVehicleTuningList( localPlayer.vehicle )

	end

-----------------------------------------------------------------

	currentTuningBasket = {}

	function addComponentToBasket( component, value, _key )

		local section = _key or component.section.key
		local basketComponent = { section = section, component = component, value = value, }
		animate('basket-actions', 0.4)

		for index, element in pairs( basketElement.listElements ) do

			if element.section == section then
				basketElement.listElements[index] = basketComponent
				return
			end
		end

		table.insert( basketElement.listElements, basketComponent)

	end

	function removeComponentFromBasket(component)

		for index, element in pairs( basketElement.listElements ) do
			if element.component == component then
				table.remove( basketElement.listElements, index)
			end
		end

		if component.section.value_type == 'default' then

			for index, component in pairs( tuningComponentsList.listElements ) do

				if getInitialTuningValue(component.section.key) == component.index then
					preloadTuningComponent(component)
				end

			end

		else

			localPlayer.vehicle:setData( component.dataName, getInitialTuningValue(component.dataName) )

		end


		basketElement.lastSelectedItem = false
		basketElement.selectedItem = false

		animate('basket-actions', 0.4)

	end

	function clearTuningBasket()

		for index, element in pairs( basketElement.listElements ) do
			local component = element.component

			if component.section.value_type == 'default' then

				for index, component in pairs( tuningComponentsList.listElements ) do

					if getInitialTuningValue(component.section.key) == component.index then
						preloadTuningComponent(component)
					end

				end

			else

				localPlayer.vehicle:setData( component.dataName, getInitialTuningValue(component.dataName) )

			end


			basketElement.lastSelectedItem = false
			basketElement.selectedItem = false

			animate('basket-actions', 0.4)

		end

		basketElement.listElements = {}

	end

	function getBasketSum()

		local basketSum = 0

		for _, lElement in pairs( basketElement.listElements ) do
			basketSum = basketSum + lElement.component.price
		end

		return basketSum

	end

-----------------------------------------------------------------

	function preloadTuningComponent(component)

		local link = component.config_link

		if link[1] == 'componentsTuning' then

			local tuning = localPlayer.vehicle:getData('tuning') or {}
			tuning[component.section.key] = component.index

			localPlayer.vehicle:setData('tuning', tuning, false)

		else

			localPlayer.vehicle:setData(component.section.key, component.index, false)

		end

	end

-----------------------------------------------------------------

	local componentsEditTypes = {'color', 'float', 'position'}

	componentsEditElements = {}

	for _, type in pairs(componentsEditTypes) do
		setAnimData(type..'-edit', 0.1)
	end

	function hideComponentsEdit()

		for _, type in pairs(componentsEditTypes) do
			animate(type..'-edit', 0)
		end

	end

	function showComponentEdit(component, valueType)

		local config = findTuningComponent( tuningSectionsList.lastSelectedItem.config_link )

		currentComponentEdit = { component = component, valueType = valueType, config = config }

		componentsEditElements[valueType]:initialize(currentComponentEdit)

		animate(valueType..'-edit', 1)

	end

-----------------------------------------------------------------

	table.insert(windowModel.main.root.elements,
		{'image',

			30 + 287 + 10, sy/2 + 5,
			287, 86,
			'assets/images/bg4.png',

			color = {25, 24, 38, 255},

			animationAlpha = 'float-edit',

			elements = {

				{'slider',

					'center',
					50,
					232, 8,

					bg = 'assets/images/slider.png',

					color = {17,17,27,255},
					activeColor = {180, 70, 70,255},

					sliderSize = 14,

					range = {0, 100},
					value = 0,
					divide = 1,

					onInit = function(element)
						componentsEditElements.float = element
					end,

					initialize = function(element, data)

						local sliderConfig = data.component.section.data.slider or {}

						local component_config = findTuningComponent(data.component.config_link)
						if component_config.slider then 
							sliderConfig = component_config.slider
						end

						element.divide = sliderConfig.divide or 100
						element.range = type(sliderConfig.range) == 'function' and sliderConfig:range() or (sliderConfig.range or {0, 100})

						local value = localPlayer.vehicle:getData(data.component.dataName) or element.range[1]
						element.value = value * element.divide

					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawText('Выберите значение',
							x, y - 10,
							x, y - 10,
							tocolor(200,200,200,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 26, 'light'),
							'left', 'bottom'
						)

						local percent = math.floor(
							(element.value - element.range[1])/(element.range[2] - element.range[1])*100
						)
						percent = math.clamp(percent, 0, 100)

						dxDrawText(string.format('%s%%', percent),
							x + w, y - 10,
							x + w, y - 10,
							tocolor(200,200,200,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 26, 'light'),
							'right', 'bottom'
						)


					end,

					onSlide = function(element, value, progress)

						local value = math.floor(value)

						applyFloatValue( currentComponentEdit, value / (element.divide or 1) )

					end,

				},

			},


		}
	)


	function applyFloatValue( data, value )

		addComponentToBasket( data.component, value, data.component.dataName )
		localPlayer.vehicle:setData(data.component.dataName, value, false)

	end

-----------------------------------------------------------------

	table.insert(windowModel.main.root.elements,
		{'image',

			30 + 287 + 10, sy/2 + 5,
			287, 274,
			-- createTextureSource('bordered_rectangle', 'assets/images/bg5.png', 22, 287, 274),
			'assets/images/bg5.png',

			color = {25,24,38,255},

			animationAlpha = 'color-edit',

			elements = {

				{'element',
					
					20, 15,
					200, 200,

					color = {255, 255, 255, 255},

					hsv = {0, 0, 1},

					onInit = {

						function(element)
							element.palette_mask = 'assets/images/pmask.png'
							-- element.palette_mask = createTextureSource('bordered_rectangle', 'assets/images/pmask.png', 22, 300, 300)
						end,

						function(element)

							componentsEditElements.color = element
							paletteElement = element

						end,

					},

					bg = 'assets/images/palette.png',

					onRender = {

						function(element)
							
							local alpha = element:alpha()
							local x,y,w,h = element:abs()

							dxDrawImage(
								x,y,w,h, cutTextureByMask( getDrawingTexture( element.bg ), {
									alpha = alpha,
									mask = getDrawingTexture( element.palette_mask )
								} )
							)

						end,

						function(element)

							local x,y = unpack(element.hsv)
							y = 1 - y


							local alpha = element:alpha()
							local ex,ey,ew,eh = element:abs()

							dxDrawImage(
								ex + x*ew - 8,
								ey + y*eh - 8,
								16, 16, 'assets/images/palette_target.png',
								0, 0, 0, tocolor(180, 70, 70, 255*alpha)
							)

						end,

					},

					setColor = function(element, r,g,b)

						local h,s,v = rgbToHsv(r,g,b)
						element.hsv = {h,s,v}

						paletteElement.input[6] = RGBToHex( r,g,b ):upper()

					end,

					getColor = function(element)
						local r,g,b = hsvToRgb(unpack(element.hsv))
						return r,g,b
					end,

					onColorChange = function(element, r,g,b)
						applyColorValue( currentComponentEdit, RGBToHex(r,g,b) )
						paletteElement.input[6] = RGBToHex(r,g,b):upper()
					end,

					onDragDrop = function(element, _, _, x,y)

						local ex,ey = element:abs()

						x = x*real_sx - px(ex)
						y = y*real_sy - px(ey)
						x = x * sx/real_sx
						y = y * sx/real_sx

						local h,s = 
				            math.clamp(x / element[4],  0, 1),
				            1 - math.clamp(y / element[5],  0, 1)

			            element.hsv = {h,s, element.hsv[3]}

			            element:onColorChange( hsvToRgb( unpack(element.hsv) ) )

					end,

					initialize = function(element, data)

						local value = localPlayer.vehicle:getData(data.component.dataName) or '#ffffff'
						element:setColor( hexToRGB(value) )

					end,

				},

				{'element',
					287-25-20, 15,
					25, 200,

					bg='assets/images/alpha.png',
					color = {255, 255, 255, 255},

					onRender = {

						function(element)
							
							local alpha = element:alpha()
							local x,y,w,h = element:abs()

							dxDrawImage(
								x,y,w,h, cutTextureByMask( getDrawingTexture( element.bg ), {
									alpha = alpha,
									mask = getDrawingTexture( element.palette_alpha )
								} )
							)

						end,

						function(element)

							local alpha = element:alpha()
							local ex,ey,ew,eh = element:abs()

							local y = 1-paletteElement.hsv[3]

							local rw, rh = ew+5, 3
							local rx,ry = ex+ew/2 - rw/2, (ey+8)+(eh-16)*y-rh/2

							mta_dxDrawRectangle(
								px(rx) - 1, px(ry) - 1,
								px(rw)+2, px(rh)+2,
								tocolor(0, 0, 0, 150*alpha)
							)

							dxDrawRectangle(
								rx,ry,
								rw,rh,
								tocolor(180, 70, 70, 255*alpha)
							)

							local r,g,b = hsvToRgb( 
								paletteElement.hsv[1],
								paletteElement.hsv[2],
								1
							)
							element.color = {r,g,b, element.color[4]}

						end,

					},

					onDragDrop = function(element, _, _, x,y)

						local ex,ey = element:abs()

						y = y*real_sy - px(ey)

						local v = 1-math.clamp(y / element[5],  0, 1)
						paletteElement.hsv[3] = v

						paletteElement:onColorChange( hsvToRgb( unpack(paletteElement.hsv) ) )
					end,

					onInit = {

						function(element)
							paletteAlpha = element
						end,

						function(element)
							element.palette_alpha = 'assets/images/palpha.png'
							-- element.palette_alpha = createTextureSource('bordered_rectangle', 'assets/images/palpha.png', 15, 25, 200)
						end,

					},

				},

				{'input',
					'center', function(s,p) return p[5] - s[5] - 15 end,
					function(s,p) return p[4] - 30 end, 35,
					'',

					color = {18,18,28,255},
					placeholderColor = {120,120,150,255},

					alignX = 'center',
					possibleSymbols = '#1234567890abcdef',

					placeholder = 'Цветовой код',

					scale = 0.5,
					font = getFont('montserrat_semibold', 24, 'light'),
					maxSymbols = 7,

					onInit = function(element)
						element.bg = 'assets/images/vinils/colorbg_input.png'
						-- element.bg = createTextureSource('bordered_rectangle', 'assets/images/vinils/colorbg_input.png', 16, element[4], element[5])
						paletteElement.input = element
					end,

					onInput = function(element)

						element[6] = element[6]:upper()

						if #element[6] == 7 then
							local r,g,b = hexToRGB(element[6] or '')
							if r and g and b then
								paletteElement:onColorChange(r,g,b)
								paletteElement:setColor(r,g,b)
							end
						elseif element[6]:sub(1,1) ~= '#' then
							element[6] = '#'..element[6]
						end

					end,

				},

			},


		}
	)

	function applyColorValue( data, value )

		addComponentToBasket( data.component, value, data.component.dataName )
		localPlayer.vehicle:setData(data.component.dataName, value, false)

	end

-----------------------------------------------------------------

	table.insert(windowModel.main.root.elements,
		{'image',

			30 + 287 + 10, sy/2 + 5,
			287, 381,
			'assets/images/bg2.png',

			color = {25,24,38, 255},

			animationAlpha = 'position-edit',

			elements = {

				{'image',
					'center', 20,
					232, 232,
					'assets/images/bg3.png',
					color = {17,17,27, 255},

					pos = {0, 0},

					setPosition = function(element, pos)

						local x,y = unpack(pos)
						x = interpolateNumber( x, -1, 1 )
						y = interpolateNumber( y, 1, -1 )

						element.pos = {x,y}

						positionHeightSlider.value = (pos[3] or 0)*100
						positionRotSlider.value = (pos[4] or 0)*100
					end,

					onRender = function(element)

						local x,y = unpack(element.pos)

						local ex,ey,ew,eh = element:abs()
						local alpha = element:alpha()

						local edit_section = tuningSectionsList.lastSelectedItem

						local car_img = 'assets/images/car.png'

						if edit_section and edit_section.data and edit_section.data.edit_image then
							car_img = edit_section.data.edit_image or car_img
						end

						dxDrawImage(
							ex, ey,
							ew,eh,
							car_img,
							0, 0, 0, tocolor(255, 255, 255, 255*alpha)
						)

						dxDrawImage(
							ex + x*ew - 8,
							ey + y*eh - 8,
							16, 16, 'assets/images/palette_target.png',
							0, 0, 0, tocolor(255, 255, 255, 255*alpha)
						)

						mta_dxDrawRectangle(
							px(ex + ew/2), px(ey),
							1, px(eh),
							tocolor(180, 70, 70, 255*alpha)
						)

						mta_dxDrawRectangle(
							px(ex), px(ey + eh/2),
							px(ew), 1,
							tocolor(180, 70, 70, 200*alpha)
						)

					end,

					applyValue = function(element)

						local x,y = unpack(element.pos)

						x = interpolateBetween(-1, 0, 0, 1, 0, 0, x, 'Linear')
						y = interpolateBetween(1, 0, 0, -1, 0, 0, y, 'Linear')

						applyPositionValue( currentComponentEdit, string.format('%s_%s_%s_%s', x,y,
							positionHeightSlider.value/100,
							positionRotSlider.value/100
						) )

					end,

					onDragDrop = function(element, _, _, x,y)

						local ex,ey = element:abs()

						x = x*real_sx - px(ex)
						y = y*real_sy - px(ey)
						x = x * sx/real_sx
						y = y * sx/real_sx

						element.pos = {
							math.clamp(x / element[4], 0, 1),
							math.clamp(y / element[5], 0, 1),
						}

						element:applyValue()

					end,

					initialize = function(element, data)

						local value = localPlayer.vehicle:getData(data.component.dataName) or '0_0_0'
						local pos = splitString(value, '_')

						for index, coord in pairs(pos) do
							pos[index] = tonumber(coord)
						end

						element:setPosition( pos )

					end,

					onInit = function(element)
						componentsEditElements.position = element
					end,
				},

				{'slider',

					'center', 340 - 35,
					232, 8,

					bg = 'assets/images/slider.png',

					color = {17,17,27,255},
					activeColor = {180, 70, 70,255},

					sliderSize = 14,

					range = {-150, 300},
					value = 0,

					onInit = function(element)
						positionHeightSlider = element
					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local edit_section = tuningSectionsList.lastSelectedItem

						local text = 'Выберите высоту'

						if edit_section and edit_section.data and edit_section.data.edit_text then
							text = edit_section.data.edit_text[1] or text
						end

						dxDrawText(text,
							x, y - 6,
							x, y - 6,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 25, 'light'),
							'left', 'bottom'
						)

						local percent = math.floor(
							(element.value - element.range[1])/(element.range[2] - element.range[1])*100
						)
						percent = math.clamp(percent, 0, 100)

						dxDrawText(string.format('%s%%', percent),
							x + w, y - 6,
							x + w, y - 6,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 28, 'light'),
							'right', 'bottom'
						)


					end,

					onSlide = function(element, value, progress)
						element.value = value
						componentsEditElements.position:applyValue()
					end,

				},

				{'slider',

					'center', 340 - 35 + 10 + 35,
					232, 8,

					bg = 'assets/images/slider.png',

					color = {17,17,27,255},
					activeColor = {180, 70, 70,255},

					sliderSize = 14,

					range = {-100, 100},
					value = 0,

					onInit = function(element)
						positionRotSlider = element
					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local edit_section = tuningSectionsList.lastSelectedItem

						local text = 'Выберите вращение'

						if edit_section and edit_section.data and edit_section.data.edit_text then
							text = edit_section.data.edit_text[2] or text
						end

						dxDrawText(text,
							x, y - 6,
							x, y - 6,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 25, 'light'),
							'left', 'bottom'
						)

						local percent = math.floor(
							(element.value - element.range[1])/(element.range[2] - element.range[1])*100
						)
						percent = math.clamp(percent, 0, 100)

						dxDrawText(string.format('%s%%', percent),
							x + w, y - 6,
							x + w, y - 6,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 28, 'light'),
							'right', 'bottom'
						)


					end,

					onSlide = function(element, value, progress)
						element.value = value
						componentsEditElements.position:applyValue()
					end,

				},

			},


		}
	)

	function applyPositionValue( data, value )

		addComponentToBasket( data.component, value, data.component.dataName )
		localPlayer.vehicle:setData(data.component.dataName, value, false)

	end

-----------------------------------------------------------------

	function reloadGui()

		animate('tuning-component', 0)
		animate('tuning-list', 0)

		hideComponentsEdit()

		clearTuningBasket()

		tuningSectionsList.lastSelectedItem = false
		tuningSectionsList.selectedItem = false

	end

-----------------------------------------------------------------

loadGuiModule()


end)

