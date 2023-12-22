


cancelButtons = {
	['f1'] = true,
	['f2'] = true,
	['f3'] = true,
	['f4'] = true,
	['f5'] = true,
	['f7'] = true,
	['f9'] = true,
	['k'] = true,
	['i'] = true,
	['m'] = true,
}

windowPriority = 'low-10'


openHandler = function()

	showChat(false)
	moveMap = false
	altPressed = false

	updateCurrentBlips()
	setTimer(updateAntiStick, 1000, 1)

end
closeHandler = function()
	showChat(true)
end

local mta_getBlipIcon = getBlipIcon
function getBlipIcon(blip)
	return getElementData(blip, 'm_icon') or (getElementData(blip, 'icon') or mta_getBlipIcon(blip))
end

---------------------------------------------

	function destroyPoint()

		for _, element in pairs( currentPoint ) do
			if isElement(element) then
				destroyElement(element)
			end
		end

		currentPoint = nil

	end


	function createPoint()

		if isTimer(pointTimer) then return end

		local posX, posY = getCursorPosition()

		posX = posX * real_sx - mapElement[2]
		posY = posY * real_sy - mapElement[3]

		local x,y = convertScreenPosition( posX, posY )

		if currentPoint then
			destroyPoint()
		else

			currentPoint = {}

			currentPoint.blip = createBlip(x,y, 0, 0)
			currentPoint.blip:setData('icon', 'point')

			local farClip = getFarClipDistance()
			setFarClipDistance(10000)

			pointTimer = setTimer(function()

				local z = getGroundPosition(x,y, 100)
				currentPoint.marker = createMarker(x,y,z+0.5, 'corona', 4, 0, 0, 0, 0)
				currentPoint.marker:setData('controlpoint.3dtext', '[Метка]')

				setFarClipDistance(farClip)

			end, 100, 1)

			exports.hud_notify:notify('Метка', 'Метка установлена')

		end

	end

	addEventHandler('onClientMarkerHit', resourceRoot, function(player, mDim)
		if currentPoint and currentPoint.marker == source and player == localPlayer and mDim and player.interior == source.interior then
			exports.hud_notify:notify('Метка', 'Метка удалена')
			destroyPoint()
		end
	end)

---------------------------------------------

mapSize = real_sy*0.9
defaultblipSize = 15
blipSize = defaultblipSize

function convertBlipPosition(x,y, _mapSize)
	local mapSize = _mapSize or mapSize*mapZoom
	return (x+3000)/6000*mapSize, (-y+3000)/6000*mapSize
end

function convertScreenPosition(x,y, _mapSize)

	local mapSize = _mapSize or mapSize*mapZoom
	return (x/(mapSize) * 6000) - 3000, - ( (y/(mapSize) * 6000) - 3000 )
end

function drawBlip(blip, alpha, r, _icon)


	local icon = _icon or getBlipIcon(blip)
	local path = string.format(':hud_radar/assets/images/blip_icons/%s.png', icon)
	if not fileExists(path) then return end

	if not localPlayer:getData('hud_map.display_players')
		and icon == 'oplayer'
	then
		return
	end

	bx,by = getElementPosition(blip)
	box, boy = unpack( getElementData(blip, 'offset') or {0,0} )

	bx,by = bx + box,by + boy

	bx,by = convertBlipPosition( bx,by )
	local bs = blipSize
	local size = blip:getData('size') or 1

	size = size * mapZoom^0.5

	if icon == currentTipBlip then

		if not noScale[icon] then
			bs = bs * 2
		end
		alpha = alpha * math.abs(math.sin( getTickCount()*0.002 ))

	end

	bs = bs * size

	local br,bg,bb = 255,255,255
	if blip:getData('color') then
		br,bg,bb = unpack( blip:getData('color') or {} )
	end

	local x,y = mapElement:abs()

	mta_dxDrawImage(
		x + bx - bs/2, y + by - bs/2,
		bs, bs, path,
		r or 0, 0, 0, tocolor(br,bg,bb,255*alpha)
	)

end

noScale = {
	free_business = true,
	free_house = true,
}

blipTips = {

	{'autoschool', 'Автошкола'},
	{'carshop', 'Автосалон'},

	{'fuel_station', 'Заправка'},
	-- {'bank', 'Банкомат'},
	{'police', 'Полицеский участок'},
	-- {'weapon_shop', 'Магазин оружия'},
	{'clothes_shop', 'Магазин одежды'},
	{'weapon_shop', 'Магазин оружия'},

	{'casino', 'Казино'},
	{'transfer', 'Переправа'},

	{'exchange', 'ЕКХ'},
	
	{'tuning', 'Тюнинг'},
	{'by', 'Б.У Рынок'},
	{'police', 'Оплата штрафов'},

	-- {'free_business', 'Свободный бизнес'},
	-- {'free_house', 'Свободный дом'},
	-- {'free_derrick', 'Свободная нефтевышка'},

	{'player_business', 'Мой бизнес'},
	{'player_house', 'Мой дом'},
	{'player_derrick', 'Моя нефтевышка'},
	{'flat', 'Квартира'},

	{'camera', 'Камера'},

	{'job_post', 'Почтальон'},
	{'job_miner', 'Шахтер'},
	{'job_taxi', 'Таксист'},
	{'job_bus', 'Водитель автобуса'},
	{'job_logist', 'Работа логиста'},
	{'job_lumberjack', 'Лесоруб'},
	{'job_green', 'Газонокосильщик'},
	{'job_cargo', 'Грузчик'},
	{'job_rubbisher', 'Уборщик отходов'},
	{'incassator', 'Инкассатор'},
	
	-- {'toll', 'КПП'},

}

blipPriorities = {
	target = 100,
	shop = 100,
}

hideBackground = true

currentBlips = {}
function updateCurrentBlips()

	currentBlips = getElementsByType('blip')
	table.sort(currentBlips, function(a,b)
		local priority1 = blipPriorities[getBlipIcon(a)] or 0
		local priority2 = blipPriorities[getBlipIcon(b)] or 0
		return priority1 < priority2
	end)

end

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'rectangle',
			mtaDraw = true,
			0, 0, real_sx, real_sy,
			color = {0,0,0,220},
			anim_fix = true,
		},

		{'image',
			mtaDraw = true,
			real_sx/2 - mapSize/2, real_sy/2 - mapSize/2,
			mapSize, mapSize,
			'',
			color = {255,255,255,255},

			x0 = real_sx/2 - mapSize/2,
			y0 = real_sy/2 - mapSize/2,

			onInit = function(element)

				mapElement = element

			end,

			-- initGhetto = function(element)

			-- 	local ghetto = exports.main_weapon_zones:getGhettoZone()

			-- 	local tbl = splitTableWithCount( ghetto, 2 )

			-- 	local texture = exports.hud_radar:getRadarTexture()

			-- 	local rt = dxCreateRenderTarget( 6000, 6000, true )

			-- 	dxSetBlendMode( 'modulate_add' )

			-- 	dxSetRenderTarget( rt )

			-- 		dxDrawImage(
			-- 			0, 0, 6000, 6000, texture
			-- 		)

			-- 		for index, coord in pairs( tbl ) do

			-- 			local nextcoord = tbl[ index + 1 ] or tbl[1]

			-- 			local x1,y1 = convertBlipPosition( coord[1], coord[2], 6000 )
			-- 			local x2,y2 = convertBlipPosition( nextcoord[1], nextcoord[2], 6000 )

			-- 			dxDrawImage(
			-- 				x1-5, y1-5,
			-- 				10, 10, roundTexture,
			-- 				0, 0, 0, tocolor(180,70,70,255) 
			-- 			)

			-- 			dxDrawLine(
			-- 				x1, y1,
			-- 				x2, y2,
			-- 				tocolor(180,70,70,255), 10
			-- 			)

			-- 		end

			-- 	dxSetRenderTarget(  )

			-- 	dxSetBlendMode( 'blend' )

			-- 	local rt_pixels = dxGetTexturePixels( rt )
			-- 	local ghetto_tex = dxCreateTexture( rt_pixels )

			-- 	local file = fileCreate('map.png')
			-- 	local npixels = dxConvertPixels( rt_pixels, 'png' )
			-- 	fileWrite(file, npixels)
			-- 	fileClose(file)

			-- 	element.ghetto_tex = ghetto_tex

			-- 	destroyElement( rt )

			-- end,

			onRender = function(element)

				local alpha = element:alpha()

				local x,y,w,h = element:abs()
				local bx,by

				if localPlayer:getData('hud_map.display_blips') then
					for _, blip in pairs( currentBlips ) do
						if isElement(blip) then
							if getElementAttachedTo(blip) ~= localPlayer then
								drawBlip(blip, alpha)
							else
								drawBlip(blip, alpha, -localPlayer.rotation.z, 'player')
							end
						end
					end
				end

				element[6] = isElement(element[6]) and element[6] or exports.hud_radar:getRadarTexture()

				if altPressed or getKeyState('l') then
					element.onClick = element._onClick
				else
					element.onClick = nil
				end

				-- if isElement( element.ghetto_tex ) then

				-- 	dxDrawImage(
				-- 		x,y,w,h, element.ghetto_tex,
				-- 		0, 0, 0, tocolor( 180, 70, 70, 255*alpha )
				-- 	)

				-- end

				-- if element.initGhetto then
				-- 	element:initGhetto()
				-- 	element.initGhetto = nil
				-- end

			end,

			_onClick = function(element, pos)

				if (
					exports.acl:isPlayerInGroup(localPlayer, 'youtube')
					or
					exports.acl:isPlayerInGroup(localPlayer, 'admin')
					or
					exports.acl:isPlayerInGroup(localPlayer, 'teleport')
					or root:getData('isTest')
					-- or true
				) and altPressed then

					local x,y = convertScreenPosition(unpack(pos))
					setElementPosition(localPlayer.vehicle or localPlayer, x,y, 100)

					setTimer(function()
						local px,py,pz = getElementPosition(localPlayer.vehicle or localPlayer)
						local z = getGroundPosition(px,py,pz)
						setElementPosition(localPlayer.vehicle or localPlayer, px,py, z + 1)

					end, 1000, 1)

					closeWindow()

				elseif getKeyState('l') then

					if exports.acl:isAdmin( localPlayer ) then

						local x,y = convertScreenPosition( unpack(pos) )

						local group = {}

						for _, blip in pairs( getElementsByType('blip') ) do

							local bx,by = getElementPosition( blip )
							if getDistanceBetweenPoints2D( x,y, bx,by ) < (defaultblipSize*4) then
								table.insert( group, blip )
							end

						end

						blipGroups = blipGroups or {}
						table.insert( blipGroups, {x,y} )

						setClipboard( inspect(blipGroups) )

						processBlipGroup( group )

					end

				end

			end,
		},

		{'image',

			30, ( real_sy - px(30) - px(152) ) * sx/real_sx,
			581, 152,

			'assets/images/hints.png',
			color = {32,35,66,255},

			onPreRender = function(element)

				local alpha = getElementDrawAlpha(element)
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 599/2,
					y + h/2 - 170/2 + 5,
					599, 170, 'assets/images/hints_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
				)

			end,

			onRender = function(element)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				local hints = {
					{ id = 'tab', textpadding = 15, text = isElement(currentPoint) and 'Удалить метку на карте' or 'Поставить метку на карте', },
					{ id = 'move', textpadding = 10, text = 'Перемещать карту', },
					{ id = 'shift', textpadding = 15, text = 'Скрыть подсказки', },
					{ id = 'scroll', textpadding = 10, text = 'Приблизить / отдалить', },
				}

				local itemw, itemh = 270, 45
				local sCount = 1

				local startX = x+w/2 - sCount*itemw
				local _startX = startX
				local startY = y+h/2 - sCount*itemh

				local index = 1

				for i_1 = 1,2 do
					for i_2 = 1,2 do

						local hint = hints[index]
						local texture = getDrawingTexture( string.format('assets/images/hint_%s.png', hint.id) )
						local mw,mh = dxGetMaterialSize(texture)

						dxDrawImage(
							startX + 10, startY + itemh/2 - mh/2,
							mw,mh, texture, 0, 0, 0,
							tocolor(255,255,255,255*alpha)
						)

						dxDrawText(hint.text,
							startX + (hint.textpadding or 10) + mw, startY,
							startX + (hint.textpadding or 10) + mw, startY+itemh,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 21, 'light'),
							'left', 'center'
						)

						index = index + 1

						startX = startX + itemw

						if index == 3 then
							startY = startY + itemh
							startX = _startX
						end

					end
				end

			end,

			setAnimData('tips', 0.1, 1),
			animationAlpha = 'tips',
		},

		{'list',
			sx - 313 - 30, 30 + 30, 313, 387 - 60,
			scrollBg = scrollTexture,

			scrollColor = {200, 70, 70, 255},
			scrollBgColor = {25, 25, 25,255},

			scrollWidth = 5,
			scrollXOffset = -30,
			scrollHeight = 0.8,
			listOffset = 0,
			listElements = {},

			listElementHeight = 40,

			onInit = function(element)
				blipTipsList = element

				blipTipsList.listElements = table.copy(blipTips)
			end,

			noSelection = true,

			color = {255,255,255,255},

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()
				y = y - 30
				h = h + 60

				dxDrawImage(
					x,y,w,h, 'assets/images/blips.png',
					0, 0, 0, tocolor(32,35,66,255*alpha)
				)

				dxDrawImage(
					x + w/2 - 331/2,
					y + h/2 - 405/2 + 5,
					331, 405, 'assets/images/blips_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
				)

				if element.prevTip and not currentTipBlip then
					-- element.onTooltipHover()
					lastBlipHovered = nil
				end

				element.prevTip = currentTipBlip
				currentTipBlip = false

			end,

			onRender = function(element)
				element.hovered = isMouseInPosition(
					element[2], element[3],
					element[4], element[5]
				)

				if currentTipBlip ~= element.prevTip then
					updateCurrentBlips()
				end

			end,

			-- onTooltipHover = function(blipTip)

			-- 	exports.main_house:toggleFreeBlips(blipTip == 'free_house')
			-- 	exports.main_business:toggleFreeBlips(blipTip == 'free_business')
			-- 	exports.main_oil_derrick:toggleFreeBlips(blipTip == 'free_derrick')

			-- end,

			additionalElementDrawing = function(lElement, x,y,w,ey, element, animData, index, hover)

				local alpha = getElementDrawAlpha(element)

				local x,y,w,h = x + 20, y + element.listElementHeight/2 - 35/2, 35, 35

				dxDrawImage(
					x,y,w,h,
					string.format(':hud_radar/assets/images/blip_icons/%s.png', lElement[1]),
					0, 0, 0,
					tocolor(255,255,255,255*alpha)
				)

				local r,g,b = 255,255,255
				if hover then

					r,g,b = 200,70,70
					currentTipBlip = lElement[1]

					if lastBlipHovered ~= currentTipBlip then
						lastBlipHovered = currentTipBlip
						-- element.onTooltipHover(currentTipBlip)
					end

				end

				for i = 1,2 do
					dxDrawText(lElement[2],
						x + w + 5, y,
						x + w + 5, y+h,
						tocolor(r,g,b, 255*alpha),
						0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
						'left', 'center'
					)
				end


			end,

		},

		{'image',

			sx - 313 - 30, 30 + 10 + 387,
			313, 260,

			-- createTextureSource('bordered_rectangle', 'assets/images/settings.png', 22, 313, 260),
			'assets/images/settings.png',
			color = {32,35,66,255},

			-- onPreRender = function(element)

			-- 	local alpha = getElementDrawAlpha(element)
			-- 	local x,y,w,h = element:abs()

			-- 	dxDrawImage(
			-- 		x + w/2 - 331/2,
			-- 		y + h/2 - 378/2 + 5,
			-- 		331, 378, 'assets/images/settings_shadow.png',
			-- 		0, 0, 0, tocolor(0,0,0,255*alpha)
			-- 	)

			-- end,

			overflow = 'vertical',

			scrollColor = {200, 70, 70, 255},
			scrollBgColor = {25, 25, 25,255},

			variable = 'settingsList',

			elements = {

				{'element',

					0, 0, '100%', 30,

					onRender = function(element)

						local x,y,w,h = element:abs()
						local alpha = element:alpha()

						dxDrawText('Настройки',
							x,y+h,
							x+w,y+h,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
							'center', 'center'
						)

					end,

				},

				{'checkbox',

					40, 60,
					47, 23,

					text = 'Отображение игроков',
					setting = 'hud_map.display_players',
					default = true,

				},

				{'checkbox',

					40, 90,
					47, 23,

					text = 'Отображение блипов',
					setting = 'hud_map.display_blips',
					default = true,

				},


				{'checkbox',

					40, 150,
					47, 23,

					text = 'Свободные дома',
					setting = 'hud_map.display_houses',
					default = false,

				},


				{'checkbox',

					40, 180,
					47, 23,

					text = 'Свободные бизнесы',
					setting = 'hud_map.display_business',
					default = false,

				},


				{'checkbox',

					40, 210,
					47, 23,

					text = 'Свободные вышки',
					setting = 'hud_map.display_derricks',
					default = false,

				},


				{'checkbox',

					40, 270,
					47, 23,

					text = 'Занятые дома',
					setting = 'hud_map.display_used_houses',
					default = false,

				},


				{'checkbox',

					40, 300,
					47, 23,

					text = 'Занятые бизнесы',
					setting = 'hud_map.display_used_business',
					default = false,

				},

				{'checkbox',

					40, 330,
					47, 23,

					text = 'Занятые вышки',
					setting = 'hud_map.display_used_derricks',
					default = false,

				},

				{'checkbox',

					40, 390,
					47, 23,

					text = 'Клановые территории',
					setting = 'hud_map.display_areas',
					default = false,

				},

				{'element',
					0, 410, '100%', 20, color = {255,255,255,255},
				},

			},

		},

	},

}

----------------------------------------------------------------------

	GUIDefine('checkbox', {

		color = {37,42,74,255},
		fgColor = {54,59,88,255},
		activeColor = {200,70,70,255},

		onRender = function(element)

			local x,y,w,h = element:abs()
			local alpha = element:alpha()

			dxDrawText(element.text or '',
				x + w + 10, y,
				x + w + 10, y+h,
				tocolor(255,255,255,255*alpha),
				0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
				'left', 'center'
			)


		end,

		onCheck = function(element)
			localPlayer:setData(element.setting, not localPlayer:getData(element.setting), false)
		end,

		onInit = function(element)

			if element.default ~= nil then
				element.checked = element.default
				localPlayer:setData(element.setting, element.default, false)
			end

		end,

	})

----------------------------------------------------------------------

	local excludeIcons = {
	}

	addEventHandler('onClientElementDataChange', root, function(dn, old, new)
		if dn == 'icon' and source.type == 'blip' and not excludeIcons[new] then
			updateCurrentBlips()
		end
	end)

----------------------------------------------------------------------

	mapZoom = 1

	function increaseMapZoom(amount)
		mapZoom = math.clamp(mapZoom + amount, 1, 10)

		local _mapSize = mapSize*mapZoom

		mapElement[2] = real_sx/2 - _mapSize/2 + (xOffset or 0)
		mapElement[3] = real_sy/2 - _mapSize/2 + (yOffset or 0)
		mapElement[4] = _mapSize
		mapElement[5] = _mapSize
		blipSize = defaultblipSize * math.clamp(mapZoom, 1, 3)
	end

	addEventHandler('onClientKey', root, function(button, state)
		if not windowOpened then return end

		if button == 'mouse_wheel_down' then

			if not blipTipsList.hovered and not settingsList.hovered then
				increaseMapZoom(-0.1)
			end

		elseif button == 'mouse_wheel_up' then

			if not blipTipsList.hovered and not settingsList.hovered then
				increaseMapZoom(0.1)
			end

		elseif button == 'lshift' and state then

			tipsHidden = not tipsHidden
			animate('tips', tipsHidden and 0 or 1)

		elseif button == 'ralt' or button == 'end' then
			altPressed = state
		elseif button == 'tab' and state then
			createPoint()
			cancelEvent()
		end

	end)

	xOffset, yOffset = 0,0
	function udpateMapPosition(x,y)

		local xAdd, yAdd = x*1000, y*1000

		-- mapElement[2] = math.clamp(mapElement[2] + xAdd, -mapSize + 50, real_sx - 50)
		-- mapElement[3] = math.clamp(mapElement[3] + yAdd, -mapSize + 50, real_sy - 50)
		
		mapElement[2] = math.clamp(mapElement[2] + xAdd, 0 -(mapSize*mapZoom - mapSize),
			real_sx - mapSize*mapZoom + (mapSize*mapZoom - mapSize))
		mapElement[3] = math.clamp(mapElement[3] + yAdd, 0 -(mapSize*mapZoom - mapSize),
			real_sy - mapSize*mapZoom + (mapSize*mapZoom - mapSize))

		xOffset, yOffset = xOffset + xAdd, yOffset + yAdd
		-- xOffset, yOffset = mapElement[2] - mapElement.x0, mapElement[3] - mapElement.y0

	end

	addEventHandler('onClientClick', root, function(button, state)
		if not windowOpened then return end

		if button == 'left' then
			moveMap = state == 'down'
		end
	end)

	addEventHandler('onClientCursorMove', root, function(x,y)
		if not windowOpened then return end

		if moveMap and lastMovePosition then
			local deltaX, deltaY = lastMovePosition[1] - x, lastMovePosition[2] - y
			udpateMapPosition(-deltaX, -deltaY)
		end

		lastMovePosition = {x,y}
	end)

----------------------------------------------------------------------

loadGuiModule()


end)

