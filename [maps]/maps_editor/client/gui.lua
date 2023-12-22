
openHandlers = {
	function()
		showChat( false )
		localPlayer:setData('radar.hidden', true)
		localPlayer:setData('hud.hidden', true)
	end,
}

closeHandlers = {
	function()
		showChat( true )
		localPlayer:setData('radar.hidden', false)
		localPlayer:setData('hud.hidden', false)
	end,	
}

disableVerticalAnim = true

addEventHandler('onClientResourceStart', resourceRoot, function()

	
---------------------------------------------------

	GUI = {}

---------------------------------------------------

	function createElementTooltip(element, tooltip)

		element.tooltip = tooltip

		element.onPostRender = function(element)

			if isMouseInPosition( element[2], element[3], element[4], element[5] ) then

				local alpha = getElementDrawAlpha(element)

				local scale, font = 0.5, getFont('proximanova_semibold', 20, 'light')
				local textWidth = dxGetTextWidth(element.tooltip, scale, font) * sx/real_sx

				local x,y = getCursorPosition()

				x,y = x * sx, (y*real_sy) * sx/real_sx
				x,y = x + 10, y + 10

				local w,h = textWidth + 30, 30

				dxDrawRectangle(
					x,y, w,h,
					tocolor(30, 30, 30, 255*alpha)
				)

				dxDrawText(element.tooltip,
					x,y,x+w,y+h,
					tocolor(255,255,255,255*alpha),
					scale, scale, font,
					'center', 'center'
				)

			end

		end

	end

---------------------------------------------------

	GUI.input = {}

	function createInput( id, custom_settings )

		local element = {'input',

			[6] = '',
			bg = whiteTexture,
			color = {0, 0, 0, 255},

			alignX = 'center',
			possibleSymbols = '1234567890.',

			font = getFont('proximanova_semibold', 21, 'light'),
			scale = 0.5,

			onRender = {
				name = function(element)

					local alpha = getElementDrawAlpha(element)

					if element.name then
						dxDrawText(element.name,
							element[2] - 10, element[3],
							element[2] - 10, element[3] + element[5],
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('proximanova_semibold', 24, 'light'),
							'right', 'center'
						)
					end

				end,
			},

			onDragDrop = function(element, _, _, x,y)

				if element.prev_x and element.step then

					if pressed.mouse1 and math.abs( getTickCount() - pressed.mouse1 ) < 50 then return end

					local delta = x - element.prev_x
					if delta ~= 0 then

						local step = element.step * (currentEditStep or 1)

						if element.data and element.data.key == 'step' then
							step = element.step
						end

						local value = (tonumber(element[6]) or 0) + ( delta > 0 and step or -step )
						if element.scalar and value < 0 then value = 0 end

						element[6] = tostring( math.round( value, 2 ) )
						element:onInput()
					end

				end

				element.prev_x = x

			end,

			applyValue = function(element, value)
				element[6] = value
				element:onInput()
			end,

		}

		if custom_settings.tooltip then
			createElementTooltip(element, custom_settings.tooltip)
		end

		for key, value in pairs( custom_settings ) do
			element[key] = value
		end

		GUI.input[id] = element
		return element

	end

---------------------------------------------------

	GUI.checkbox = {}

	function createCheckbox( id, custom_settings )

		local element = {'checkbox',

			bg = whiteTexture,
			fg = whiteTexture,
			color = {0, 0, 0, 255},
			fgColor = {20, 20, 20, 255},
			activeColor = {200, 70, 70, 255},

			onInit = function(element)
				element.size = element[5]-5
			end,

			font = getFont('proximanova_semibold', 21, 'light'),
			scale = 0.5,



			onRender = {
				name = function(element)

					local alpha = getElementDrawAlpha(element)

					if element.name then
						dxDrawText(element.name,
							element[2] - 10, element[3],
							element[2] - 10, element[3] + element[5],
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('proximanova_semibold', 24, 'light'),
							'right', 'center'
						)
					end

				end,
			},

		}

		if custom_settings.tooltip then
			createElementTooltip(element, custom_settings.tooltip)
		end

		for key, value in pairs( custom_settings ) do
			element[key] = value
		end

		GUI.checkbox[id] = element
		return element

	end

---------------------------------------------------
	
	GUI.button = {}

	function createButton( id, custom_settings )

		local element = {'button',

			[6] = 'Button',
			bg = whiteTexture,
			color = {200, 70, 70, 255},

			numbersOnly = true,
			alignX = 'center',

			font = getFont('proximanova_semibold', 24, 'light'),
			scale = 0.5,

		}

		for key, value in pairs( custom_settings ) do
			element[key] = value
		end

		GUI.button[id] = element
		return element

	end	

---------------------------------------------------

	windowModel = {
		main = {
			
			{'image',

				30, 30,
				500, 400,
				createTextureSource('bordered_rectangle', 'assets/images/bg.png', 10, 500, 400),
				color = {20, 20, 20, 255},

				onRender = function(element)

					local alpha = getElementDrawAlpha(element)

				end,

			},
			
			{'image',

				30, 440,
				500, 400,
				createTextureSource('bordered_rectangle', 'assets/images/objects.png', 10, 500, 400),
				color = {20, 20, 20, 255},

				onRender = function(element)

					local alpha = getElementDrawAlpha(element)
					
					local count = 0

					for k,v in pairs(map) do
					  count = count + 1
					end

					dxDrawText(tostring('Менеджер объектов: '..tostring(count)),
						element[2] + 25, element[3] + 25,
						element[2] + 25, element[3] + 25,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('proximanova_semibold', 27, 'light'),
						'left', 'top'
					)

				end,

			},

			{'image',

				30, 850,
				500, 70,
				createTextureSource('bordered_rectangle', 'assets/images/save.png', 10, 500, 70),
				color = {20, 20, 20, 255},

				onRender = function(element)

					local alpha = getElementDrawAlpha(element)

				end,

			},

			{'image',

				30, 930,
				500, 120,
				createTextureSource('bordered_rectangle', 'assets/images/debug.png', 10, 500, 120),
				color = {20, 20, 20, 255},

				onRender = function(element)

					local alpha = getElementDrawAlpha(element)

				end,

			},

			{'list',
				40, 500,
				460, 300,
				scrollBg = scrollTexture,
				scrollColor = {10, 160, 230,255},
				scrollBgColor = {0, 0, 0,255},

				scrollWidth = 5,
				listOffset = 0,
				noSelection = true,

				listElements = {},

				font = 'default',
				scale = 1,
				listElementHeight = 50,

				color = {255,255,255,255},

				onInit = function(element)

					objectsList = element

					local w,h = element[4], element.listElementHeight - 8

					element.source = createTextureSource('bordered_rectangle', 'assets/images/border.png', 10, w, h)
					element.source_active = createTextureSource('bordered_rectangle', 'assets/images/border1.png', 10, w, h)

				end,


				onListElementClick = function(element, lElement)
					lElement:select()
				end,

				additionalElementDrawing = function(lElement, x,y,w,ey, element)

					local alpha = getElementDrawAlpha(element)
					
					local w,h = element[4], element.listElementHeight - 8
					local x,y = x + element[4]/2 - w/2, y+element.listElementHeight/2 - h/2

					local animData = lElement:isSelected() and 1 or 0

					local r,g,b = interpolateBetween(255,255,255, 200, 70, 70, animData, 'InOutQuad')
					local tr,tg,tb = interpolateBetween(255,255,255, 0, 0, 0, animData, 'InOutQuad')

					if lElement:isMeta() then
						r,g,b = interpolateBetween(100,0,0, 200, 70, 70, animData, 'InOutQuad')
					end

					if not isElement(lElement.object) then return end

					dxDrawImage(
						x,y,w,h, element.source,
						0, 0, 0, tocolor(r,g,b,255*alpha)
					)
					dxDrawImage(
						x,y,w,h, element.source_active,
						0, 0, 0, tocolor(r,g,b,255*alpha*animData)
					)

					local name = lElement:getName()

					if utf8.len(name or '') > 15 then
						name = utf8.sub(name or '', 0, 15) .. '...'
					end

					dxDrawText(name,
						x+15,y,x+15,y+h,
						tocolor(0,0,0,255*alpha),
						0.5, 0.5, getFont('proximanova_semibold', 27, 'light'),
						'left', 'center'
					)

					local cx,cy,cw,ch = x+w - 35, y+h/2 - 20/2, 20, 20

					dxDrawImage(
						cx,cy,cw,ch, closeTexture,
						0, 0, 0, tocolor(0,0,0,255*alpha)
					)

					lElement.clickHandlers = lElement.clickHandlers or {}

					lElement.clickHandlers[1] = lElement.clickHandlers[1] or {
						handle = function(lElement)
							lElement:destroy()
						end,
					}

					lElement.clickHandlers[1].coords = {cx,cy,cw,ch}

					local hx,hy,hw,hh = x+w - 65, y+h/2 - 20/2, 20, 20

					dxDrawImage(
						hx,hy,hw,hh, string.format('assets/images/eye%s.png',
							lElement.object.dimension == 1 and '_cross' or ''
						),
						0, 0, 0, tocolor(0,0,0,255*alpha)
					)

					lElement.clickHandlers[2] = lElement.clickHandlers[2] or {
						handle = function(lElement)
							lElement.object.dimension =
								lElement.object.dimension == 1
								and 0 or 1

							lElement:updateLOD()

						end,
					}

					lElement.clickHandlers[2].coords = {hx,hy,hw,hh}

					local cx,cy,cw,ch = x+w - 95, y+h/2 - 20/2, 20, 20

					dxDrawImage(
						cx,cy,cw,ch, 'assets/images/copy.png',
						0, 0, 0, tocolor(0,0,0,255*alpha)
					)

					lElement.clickHandlers[3] = lElement.clickHandlers[3] or {
						handle = function(lElement)

							if lElement:isMeta() then
								return debug:error('Нельзя скопировать мета-отбъект')
							end

							lElement:copy():select()
						end,
					}

					lElement.clickHandlers[3].coords = {cx,cy,cw,ch}

					local fx,fy,fw,fh = x+w - 125, y+h/2 - 20/2, 20, 20

					dxDrawImage(
						fx,fy,fw,fh, 'assets/images/camera.png',
						0, 0, 0, tocolor(0,0,0,255*alpha)
					)

					lElement.clickHandlers[4] = lElement.clickHandlers[4] or {
						handle = function(lElement)
							local x,y,z = getElementPosition( lElement.object )
							setCameraMatrix( x+2,y,z+0.2, x,y,z )
						end,
					}

					lElement.clickHandlers[4].coords = {fx,fy,fw,fh}

				end,

			},

			{'list',
				40, 950,
				460, 80,
				scrollBg = scrollTexture,
				scrollColor = {200,70,70,255},
				scrollBgColor = {0, 0, 0,255},

				listOffset = 0,
				noSelection = true,

				listElements = {},

				font = 'default',
				scale = 1,
				listElementHeight = 20,

				color = {255,255,255,255},

				error = function(element, text)
					table.insert(element.listElements, 1, { message = text, color = {200,30,80}, time = getRealTime(), })
				end,

				info = function(element, text)
					table.insert(element.listElements, 1, { message = text, color = {30,200,80}, time = getRealTime(), })
				end,

				addCommandHandler('me_debug_test', function()
					if windowOpened then
						debug:error('DEBUG TEST')
						debug:info('DEBUG TEST')
					end

				end),

				onInit = function(element)
					debug = element
				end,

				onListElementClick = function(element, lElement)
					lElement:select()
				end,

				additionalElementDrawing = function(lElement, x,y,w,ey, element)

					local alpha = getElementDrawAlpha(element)
					
					local w,h = element[4], element.listElementHeight - 8
					local x,y = x + element[4]/2 - w/2, y+element.listElementHeight/2 - h/2

					local r,g,b = unpack( lElement.color )

					for i = 1,2 do
						dxDrawText(string.format('[%02d:%02d:%02d] %s',
							lElement.time.hour,
							lElement.time.minute,
							lElement.time.second,
							lElement.message
						),
							x+15,y,x+15,y+h,
							tocolor(r,g,b,255*alpha),
							0.5, 0.5, getFont('proximanova_semibold', 27, 'light'),
							'left', 'center'
						)
					end
				end,

			},

			createInput('object_model', {
				[2] = 150, [3] = 60,
				[4] = 100, [5] = 30,
				name = 'Модель',
				step = 1,

				onInput = function(element)

					if tonumber(element[6]) then
						selectedEditObject.object.model = tonumber(element[6])
					end

				end,

			}),

			createInput('object_name', {
				[2] = 360, [3] = 60,
				[4] = 150, [5] = 30,
				name = 'Название',
				step = 1,
				possibleSymbols = false,

				onInput = function(element)
					selectedEditObject:setName(element[6])
				end,

			}),

			createButton('create_object', {

				[2] = 30+500-40-15, [3] = 440 + 15,
				[4] = 40, [5] = 40,
				[6] = '+',

				font = getFont('proximanova_semibold', 40, 'light'),

				onClick = createObjectFromScreen,

			}),

			-- createButton('toggle_remove_world', {

			-- 	[2] = 30+500-40-15-40-10, [3] = 440 + 15,
			-- 	[4] = 40, [5] = 40,
			-- 	[6] = 'x',

			-- 	color = {200, 70, 70, 255},

			-- 	onRender = function(element)

			-- 		local r,g,b = 200, 70, 70

			-- 		if removeWorldMode then
			-- 			r,g,b = 150, 0, 0
			-- 		end

			-- 		element.color = {r,g,b, element.color[4]}

			-- 	end,

			-- 	font = getFont('proximanova_semibold', 40, 'light'),

			-- 	onClick = toggleRemoveWorld,

			-- }),

			createInput('map_file', {

				[2] = 30+15, [3] = 850 + 70/2 - 40/2,
				[4] = 125, [5] = 40,

				placeholder = 'Файл',
				alignX = 'left',
				placeholderColor = {120,120,120,255},
				possibleSymbols = false,

			}),

			createButton('save_map', {

				[2] = 30+500-110-15, [3] = 850 + 70/2 - 40/2,
				[4] = 110, [5] = 40,
				[6] = 'Сохранить',

				onClick = function()
					dialog('Сохранить карту', 'Вы действительно хотите сохранить?', function(result)
						if result then
							gui_saveMap( GUI.input.map_file[6] )
						end
					end)
				end,

			}),

			createButton('load_map', {

				[2] = 30+500-110-15 - 110 - 5, [3] = 850 + 70/2 - 40/2,
				[4] = 110, [5] = 40,
				[6] = 'Загрузить',

				onClick = function()
					dialog('Загрузить карту', 'Вы действительно хотите загрузить?', function(result)
						if result then
							gui_loadMap( GUI.input.map_file[6] )
						end
					end)
				end,

			}),

			createButton('load_map', {

				[2] = 30+500-110-15 - 110 - 5 - 110 - 5, [3] = 850 + 70/2 - 40/2,
				[4] = 110, [5] = 40,
				[6] = 'Коммит',

				tooltip = 'Загрузить карту на сервер, ее будут видеть все',

				onClick = function()
					dialog('Коммит', 'Вы действительно хотите загрузить карту для всех?', function(result)
						if result then
							triggerServerEvent('map.commit_module', root, GUI.input.map_file[6], getMapContent())
						end
					end)
				end,

			}),

			{'image',

				sx - 410, 30,
				400, 700,
				createTextureSource('bordered_rectangle', 'assets/images/modelmanager.png', 10, 400, 700),
				color = {20, 20, 20, 255},

				setAnimData('model-manager', 0.1, 1),

				onInit = function()

					for _, _element in pairs( windowModel.main ) do
						if _element.model_manager and not _element.x0 then
							_element.x0 = _element[2]
						end
					end
				
				end,

				model_manager = true,

				onRender = function(element)

					local alpha = getElementDrawAlpha(element)

					dxDrawText('Менеджер моделей',
						element[2] + 25, element[3] + 25,
						element[2] + 25, element[3] + 25,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('proximanova_semibold', 27, 'light'),
						'left', 'top'
					)

					local animData, target = getAnimData('model-manager')
					animData = getEasingValue(animData, 'InOutQuad')

					for _, _element in pairs( windowModel.main ) do
						if _element.model_manager then
							_element[2] = _element.x0 + (element[4]+20)*(1-animData)
						end
					end

					local w,h = 60, 60
					local x,y = element[2] - w, element[3] + 15

					if handleClick and isMouseInPosition(x,y,w,h) then
						animate('model-manager', 1 - target)
						handleClick = false
					end

					dxDrawImage(
						x,y,w,h,
						'assets/images/arrow.png', 0, 0, 0, tocolor(255,255,255,255*alpha)
					)

				end,

			},

			{'list',
				sx - 410 + 20, 135,
				360, 550,
				scrollBg = scrollTexture,
				scrollColor = {10, 160, 230,255},
				scrollBgColor = {0, 0, 0,255},

				scrollWidth = 5,
				listOffset = 0,
				noSelection = true,
				model_manager = true,

				listElements = {},

				font = 'default',
				scale = 1,
				listElementHeight = 50,

				color = {255,255,255,255},

				initOnce = true,
				onInit = function(element)

					modelsList = element

					local w,h = element[4], element.listElementHeight - 8

					element.source = createTextureSource('bordered_rectangle', 'assets/images/mdborder.png', 10, w, h)
					element.source_active = createTextureSource('bordered_rectangle', 'assets/images/mdborder1.png', 10, w, h)

					if not element._elements then
						element._elements = {}
						for _, data in pairs( table.copy(Config.GTAModels) ) do
							data.name = string.format('%s | %s', data.name, data.model )
							table.insert( element._elements, data )
						end
					end

					element:applyFilter('')

				end,

				onListElementClick = function(element, lElement)
					if selectedEditObject then
						selectedEditObject:setModel( lElement.model )
						animate('replace-model-data', 1)
					end
				end,

				applyFilter = function(element, filter)

					local list = {}

					for _, lElement in pairs(element._elements) do

						local replaced = getReplacedModelData( lElement.model )
						local name = replaced and '!R! '..replaced.name or ((lElement.keywords or '') .. lElement.name)

						if utf8.find(
							utf8.lower(name),
							utf8.lower(filter)
						) then
							table.insert(list, lElement)
						end
					end

					element.listElements = list
					element.listOffset = 0

				end,

				additionalElementDrawing = function(lElement, x,y,w,ey, element)

					local alpha = getElementDrawAlpha(element)
					
					local w,h = element[4], element.listElementHeight - 8
					local x,y = x + element[4]/2 - w/2, y+element.listElementHeight/2 - h/2

					local animData = 0

					if selectedEditObject and isElement(selectedEditObject.object) then
						if selectedEditObject.object.model == lElement.model then
							animData = 1
						end
					end

					local r,g,b = interpolateBetween(255,255,255, 200, 70, 70, animData, 'InOutQuad')

					dxDrawImage(
						x,y,w,h, element.source,
						0, 0, 0, tocolor(r,g,b,255*alpha)
					)
					dxDrawImage(
						x,y,w,h, element.source_active,
						0, 0, 0, tocolor(r,g,b,255*alpha*animData)
					)

					local replaced = getReplacedModelData( lElement.model )
					local name

					if replaced then
						name = '!R! '..replaced.name
					else
						name = lElement.name
					end

					for i = 1,2 do
						dxDrawText(name,
							x+20,y,
							x+20,y+h,
							tocolor(0,0,0, 255*alpha),
							0.5, 0.5, getFont('proximanova_semibold', 30, 'light'),
							'left', 'center'
						)
					end

				end,

			},

			{'input',

				sx - 410 + 20, 90,
				360, 40,
				'',
				bg = whiteTexture,
				color = {0, 0, 0, 255},
				placeholderColor = {100, 100, 100, 255},

				alignX = 'left',
				placeholder = 'Поиск',

				font = getFont('proximanova_semibold', 24, 'light'),
				scale = 0.5,

				onInput = function(element)
					modelsList:applyFilter(element[6])
				end,

				model_manager = true,

			},


			{'image',

				sx - 410, 740,
				400, 200,
				createTextureSource('bordered_rectangle', 'assets/images/replacemodeldata.png', 10, 400, 200),
				color = {20, 20, 20, 255},

				model_manager = true,

				onInit = function(element)
					setAnimData('replace-model-data', 0.1)
					element.animationAlpha = 'replace-model-data'
				end,


				onRender = function(element)

					local alpha = getElementDrawAlpha(element)

					dxDrawText('Замененная модель',
						element[2] + 25, element[3] + 25,
						element[2] + 25, element[3] + 25,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('proximanova_semibold', 27, 'light'),
						'left', 'top'
					)

				end,

			},

			{'input',

				sx - 410 + 20, 740 + 35 + 35,
				360, 40,
				'',
				bg = whiteTexture,
				color = {0, 0, 0, 255},
				placeholderColor = {100, 100, 100, 255},

				alignX = 'left',
				placeholder = 'Введите название',

				onInit = function(element)
					modelReplaceInput = element
				end,

				font = getFont('proximanova_semibold', 24, 'light'),
				scale = 0.5,

				animationAlpha = 'replace-model-data',

				model_manager = true,

			},

			createButton('replace_model', {

				[2] = sx - 410 + 20, [3] = 740 + 35 + 40+10 + 35,
				[4] = 175, [5] = 40,
				[6] = 'Заменить',

				model_manager = true,
				animationAlpha = 'replace-model-data',

				font = getFont('proximanova_semibold', 25, 'light'),

				onClick = function()

					local model
					if selectedEditObject then
						model = selectedEditObject.object.model
					else
						return debug:error('Не выбран объект')
					end

					local modelName = modelReplaceInput[6]

					replaceModel(model, modelName)
				end,

			}),

			createButton('destroy_replace_model', {

				[2] = sx - 410 + 20 + 185, [3] = 740 + 35 + 40+10 + 35,
				[4] = 175, [5] = 40,
				[6] = 'Удалить',

				model_manager = true,
				animationAlpha = 'replace-model-data',

				font = getFont('proximanova_semibold', 25, 'light'),

				onClick = function()
					local model
					if selectedEditObject then
						model = selectedEditObject.object.model
					else
						return debug:error('Не выбран объект')
					end

					destroyReplacedModel(model)
				end,

			}),

		},
	}

---------------------------------------------------

	local stdEdit = {

		{
			{
				id = 'object_x',
				name = 'X',
				data = { key = 'position', axis = 'x' },
				tooltip = 'Позиция объекта по X',
			},
			{
				id = 'object_y',
				name = 'Y',
				data = { key = 'position', axis = 'y' },
				tooltip = 'Позиция объекта по Y',
			},
			{
				id = 'object_z',
				name = 'Z',
				data = { key = 'position', axis = 'z' },
				tooltip = 'Позиция объекта по Z',
			},
		},

		{
			{
				id = 'object_rx',
				name = 'RX',
				data = { key = 'rotation', axis = 'x' },
				tooltip = 'Вращение объекта по X',
			},
			{
				id = 'object_ry',
				name = 'RY',
				data = { key = 'rotation', axis = 'y' },
				tooltip = 'Вращение объекта по Y',
			},
			{
				id = 'object_rz',
				name = 'RZ',
				data = { key = 'rotation', axis = 'z' },
				tooltip = 'Вращение объекта по Z',
			},
		},

		{
			{
				id = 'object_scale',
				name = 'scale',
				data = { key = 'scale' },
				tooltip = 'Масштаб',
				scalar = true,
			},

			{
				id = 'edit_step',
				name = 'step',
				data = { key = 'step' },
				tooltip = 'Скорость редактирования',
				[6] = '1',

				onChange = function(value)
					currentEditStep = value
				end,
			},

			{
				id = 'camspd',
				name = 'cspd',
				data = { key = 'camspd' },
				tooltip = 'Скорость камеры',
				[6] = exports.hud_camhack:getCameraSpeed(),
				scalar = true,

				onChange = function(value)
					executeCommandHandler('setcamhackspeed', value)
				end,

			},

		},

		{
			{
				id = 'frcp',
				name = 'frcp',
				data = { key = 'frcp' },
				scalar = true,
				[6] = tostring(getFarClipDistance()),
				step = 10,
				tooltip = 'Дальность прорисовки',

				onChange = function(value)
					setFarClipDistance( value )
				end,

			},
			{
				id = 'fgds',
				name = 'fgds',
				data = { key = 'fgds' },
				scalar = true,
				[6] = tostring(getFogDistance()),
				step = 10,
				tooltip = 'Дистанция тумана',


				onChange = function(value)
					setFogDistance( value )
				end,
			},
			{
				id = 'dof',
				name = 'dof',
				data = { key = 'dof' },
				scalar = true,
				[6] = tostring(localPlayer:getData('settings.dof_level') or 0),
				tooltip = 'Размытие',

				step = 10,


				onChange = function(value)
					localPlayer:setData('settings.dof_level', value)
				end,
			},

		},

		{

			{
				id = 'mbr',
				name = 'mbr',
				data = { key = 'mbr' },
				type = 'checkbox',
				tooltip = 'Движение по оси объекта',

				onChange = function(value)
					if selectedEditObject then
						selectedEditObject.moveByRotation = value
					end
				end,

			},
			{
				id = 'lod',
				name = 'lod',
				type = 'checkbox',
				tooltip = 'Вкл/Выкл ЛОД',

				onChange = function(value)
					if selectedEditObject then
						return value and selectedEditObject:createLOD() or selectedEditObject:removeLOD()
					end
				end,

			},
			{
				id = 'lmd',
				name = 'lmd',
				data = { key = 'lmd' },
				step = 1,
				tooltip = 'ЛОД Модель',

				onChange = function(value)
					if selectedEditObject then
						selectedEditObject:removeLOD()
						selectedEditObject:createLOD( math.floor(value) )

					end
				end,

			},

		},

		{
			{
				id = 'object_scx',
				name = 'SCX',
				tooltip = 'Масштаб по X',

				step = 0.01,

				onChange = function(value)
					if selectedEditObject then
						local x,y,z = getObjectScale( selectedEditObject.object )
						setObjectScale( selectedEditObject.object, value,y,z )
					end
				end,

			},
			{
				id = 'object_scy',
				name = 'SCY',
				tooltip = 'Масштаб по Y',

				step = 0.01,

				onChange = function(value)
					if selectedEditObject then
						local x,y,z = getObjectScale( selectedEditObject.object )
						setObjectScale( selectedEditObject.object, x,value,z )
					end
				end,

			},
			{
				id = 'object_scz',
				name = 'SCZ',
				tooltip = 'Масштаб по Z',

				step = 0.01,

				onChange = function(value)
					if selectedEditObject then
						local x,y,z = getObjectScale( selectedEditObject.object )
						setObjectScale( selectedEditObject.object, x,y,value )
					end
				end,

			},
		},

		{
			{
				id = 'md_azo',
				name = 'azo',
				data = { key = 'md_azo' },
				tooltip = 'Смещение Z оси модели',

				onChange = function(value)
					if selectedEditObject then
						setModelAxisOffset(selectedEditObject.object, value)
					end
				end,
			},
		},

		{
			{
				id = 'col',
				name = 'col',
				type = 'checkbox',
				tooltip = 'Вкл/Выкл Коллизию',

				onChange = function(value)
					if selectedEditObject then
						return selectedEditObject.object:setCollisionsEnabled(value)
					end
				end,

			},
		},

		{
			{
				id = 'rwm',
				name = 'rwm',
				type = 'checkbox',
				tooltip = 'Вкл/Выкл Удаление World-объектов',

				onChange = function(value)
					if selectedEditObject then
						return selectedEditObject:toggleRemoveWorldMode()
					end
				end,

			},
		},
	}

	local _startX = 100
	local startX = _startX
	local _startY = 110
	local startY = _startY

	local w,h = 90, 30
	local padx, pady = 70, 10

	for index, section in pairs( stdEdit ) do

		for _, element in pairs( section ) do

			local data = element

			data[2] = startX
			data[3] = startY
			data[4] = w
			data[5] = h

			if (element.type or 'input') == 'input' then

				data.step = data.step or 0.01

				data.onInput = function(element)

					local value = math.round( tonumber(element[6]) or 0, 2 )

					if element.scalar then
						value = math.max( value, 0 )
					end

					if element.onChange then
						element.onChange( value )
					else

						if selectedEditObject.moveByRotation and element.data
							and element.data.key == 'position'
						then

							if element.data.axis == 'x' or element.data.axis == 'y' then

								local x,y = tonumber(GUI.input.object_x[6]), tonumber(GUI.input.object_y[6])
								local ox,oy = getElementPosition( selectedEditObject.object )
								local _, _, rz = getElementRotation( selectedEditObject.object )

								local rx,ry
								if element.data.axis == 'x' then
									rx,ry = getPointFromDistanceRotation( ox,oy, x-ox, -(rz + 90) )
								elseif element.data.axis == 'y' then
									rx,ry = getPointFromDistanceRotation( ox,oy, y-oy, -rz )
								end

								rx,ry = math.round( rx, 2 ), math.round( ry, 2 )

								selectedEditObject:setValue( 'position', 'x', rx )
								selectedEditObject:setValue( 'position', 'y', ry )

								GUI.input.object_x[6] = tostring(rx)
								GUI.input.object_y[6] = tostring(ry)

								return


							end

						end

						selectedEditObject:setValue( element.data.key, element.data.axis, value )
					end

				end

				table.insert(windowModel.main, createInput(element.id, data))

			elseif element.type == 'checkbox' then

				data.onCheck = function(element)

					if element.onChange then
						element.onChange(element.checked)
					end

				end

				table.insert(windowModel.main, createCheckbox(element.id, data))

			end

			startY = startY + h + pady

		end

		startY = _startY
		startX = startX + w + padx

		if (index % 3) == 0 then
			startX = _startX
			_startY = startY + (h + pady)*3
			startY = _startY
		end

	end

---------------------------------------------------

	local actions = {
		{

			icon = 'assets/images/icons/newmap.png',
			tooltip = 'Новая карта',
			id = 'newmap',

			action = function(action)
				dialog('Новая карта', 'Несохраненные данные будут утеряны', function(result)
					if result then
						for _, object in pairs( map ) do
							object:destroy()
						end
					end
				end)
			end,

			is_active = function(action)
				return false
			end,

		},
		{

			icon = 'assets/images/icons/chtp.png',
			tooltip = 'Телепорт к камере',
			id = 'chtp',

			action = function(action)
				local x,y,z = getCameraMatrix()
				setElementPosition(localPlayer, x,y,z)
			end,

			is_active = function(action)
				return false
			end,

		},
		{

			icon = 'assets/images/icons/camhack.png',
			tooltip = 'Режим свободной камеры',
			id = 'camhack',

			action = function()
				triggerServerEvent('hud_camhack.toggle', root)
			end,

			is_active = function()
				return localPlayer:getData('isPlayerInCamHackMode')
			end,

		},
		-- {

		-- 	icon = 'assets/images/icons/curve.png',
		-- 	tooltip = 'Режим кривой',
		-- 	id = 'curve',

		-- 	action = function()
		-- 		if selectedEditObject then
		-- 			toggleObjectCurve(selectedEditObject)
		-- 		end
		-- 	end,

		-- 	is_active = function()
		-- 		return selectedCurveObject == selectedEditObject and selectedEditObject
		-- 	end,

		-- },
	}

	local startX = 550
	local startY = 30

	local w,h = 50, 50
	local padding = 10

	local actionBg = createTextureSource('bordered_rectangle', 'assets/images/actionbg.png', 15, w,h)

	for _, action in pairs( actions ) do

		table.insert( windowModel.main,
			{'image',

				startX, startY,
				w,h,
				actionBg,

				color = {20, 20, 20, 255},

				action = action,

				onInit = function(element)
					createElementTooltip(element, element.action.tooltip)
				end,

				onClick = function(element)
					element.action:action()
				end,

				onRender = function(element)

					local alpha = getElementDrawAlpha(element)

					local w,h = 40,40

					local r,g,b = 255,255,255

					if element.action:is_active() then
						r,g,b = 200, 70, 70
					else
						r,g,b = interpolateBetween(r,g,b, 200, 70, 70, element.animData, 'InOutQuad')
					end


					dxDrawImage(
						element[2] + element[4]/2-w/2, element[3] + element[5]/2-h/2,
						w,h, element.action.icon,
						0, 0, 0, tocolor(r,g,b,255*alpha)
					)

				end,

			}
		)

		startX = startX + w + padding

	end


---------------------------------------------------

	local round = createTextureSource('bordered_empty_rectangle', 'assets/images/round.png', 100, 20, 100, 100)

	function createObjectMarker( object )

		table.insert(windowModel.main, 1,
			{'image',
				-100, -100, 100, 100,
				round,
				color = {255,255,255,255},

				marker_object = object,

				onScroll = function(element, side)
					if selectedMoveObject == element.marker_object then

						local delta = side == 'down' and 15 or -15
						local _, _, rz = getElementRotation(element.marker_object.object)

						element.marker_object:setValue('rotation', 'z', (rz + delta) % 360)
						element.marker_object:loadToGUI()

					end
				end,

				onRender = function(element)

					local alpha = getElementDrawAlpha(element)
					local r,g,b = interpolateBetween( 255,255,255, 255,180,0, (element.animData or 0), 'InOutQuad' )

					if element.marker_object:isSelected() then
						r,g,b = 255,180,0
					end

					if element.marker_object:isFreeMoving() then
						r,g,b = 30,160,230
					end

					element.color = {r,g,b, element.color[4]}

					if element.marker_object then

						local x,y,z = getElementPosition(element.marker_object.object)
						local md_azo = getModelAxisOffset(element.marker_object.object)
						z = z + md_azo

						local cx,cy,cz = getCameraMatrix()

						local distance = math.clamp(getDistanceBetweenPoints3D(x,y,z,cx,cy,cz), 0, 10)

						local size = 1/distance * 100
						size = math.max( 20, size )

						local dx,dy = getScreenFromWorldPosition(x,y,z)


						if dx and dy then
							element[2] = (dx - size/2) * sx/real_sx
							element[3] = (dy - size/2) * sx/real_sx
							element[4] = size
							element[5] = size

							return true
						end


					end

					element[2] = sx*2
					element[3] = sy*2

				end,

				noDraw = function(element)
					return element.marker_object.object.dimension ~= 0
				end,

				onClick = function(element, pos, button)

					element.marker_object:select()

					if selectedEditObject ~= element.marker_object then
						objectsList:scrollTo(element.marker_object)
					end

					if button == 'right' then
						if selectedMoveObject == element.marker_object then
							element.marker_object:finishFreeMove(false)
						else
							element.marker_object:toggleFreeMove()
						end
					elseif selectedMoveObject == element.marker_object and button == 'left' then
						element.marker_object:finishFreeMove(true)
					end


				end,


			}
		)

		loadGuiModule()


	end
---------------------------------------------------

	hideBackground = true
	blurBackground = false

---------------------------------------------------

loadGuiModule()


end)