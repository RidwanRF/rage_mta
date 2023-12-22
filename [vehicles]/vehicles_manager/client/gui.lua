
cancelButtons = {
	['f1'] = true,
	['f2'] = true,
	['f4'] = true,
	['f5'] = true,
	['f6'] = true,
	['f7'] = true,
	['f11'] = true,
	['f9'] = true,
	['k'] = true,
	['m'] = true,
	['i'] = true,
}

function updateVehicles()

	local list = {}

	local vehiclesList = gui_get('vehicles-list')
	if not vehiclesList then return end
	local edit = gui_get( "playersSearch" )
	edit:Clear()

	for index, vehicle in pairs( lastVehiclesList or {} ) do

		local icon

		if vehicle.expiry_date then
			icon = 'assets/images/time.png'
		end

		-- if (vehicle.debt or 0) > 0 then
		-- 	icon = 'assets/images/debt.png'
		-- end

		table.insert(list, {
			name = exports['vehicles_main']:getVehicleModName(vehicle.model),
			model = vehicle.model,
			plate = convertNumberplateToText(vehicle.plate),
			id = vehicle.id,
			flag = vehicle.flag,
			expiry_date = vehicle.expiry_date,

			mark = vehicle.unique_mark and exports.vehicles_main:getVehicleUniqueMark(vehicle.unique_mark) or false,
			unique_mark = vehicle.unique_mark,

			icon = icon,
			-- debt = vehicle.debt or 0,

		})
			
	end

	table.sort(list, function(a1,b1)
		return (a1.icon or 'zzz') < (b1.icon or 'zzz')
	end)

	table.sort(list, function(a1,b1)
		return (a1.unique_mark or 'zzz') < (b1.unique_mark or 'zzz')
	end)

	vehiclesList.listElements = list
	updateLastSelection()

end

openHandler = function()
	updateVehicles()
end

closeHandler = function()

	local vehiclesList = gui_get('vehicles-list')
	if not vehiclesList.lastSelectedItem then return end

	lastSelectedId = vehiclesList.lastSelectedItem.id

end

clearGuiTextures = false
hideBackground = true

addEventHandler('onClientResourceStart', resourceRoot, function()


windowModel = {

	main = {

		{'image',
			'center', 'center',
			693, 460,

			'assets/images/bg.png',
			id = 'window',

			color = {31,36,63,255},

			onPreRender = function(element)

				local alpha = getElementDrawAlpha(element)
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 711/2,
					y + h/2 - 428/2 + 5,
					711, 428, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor(32,35,66,255*alpha)
				)

			end,

			addEvent('vehicles.getPlayerVehicles', true),
			addEventHandler('vehicles.getPlayerVehicles', root, function(vehicles)
				lastVehiclesList = vehicles
				updateVehicles()
			end),

			elements = {

				{'input',
					30, 15,
					321, 40,
					color = {37,42,74,255},
					placeholderColor = {100,100,100,255},
					placeholder = 'Поиск...',
					'',
					bg = ':main_messages/assets/images/search_input.png',

					variable = 'playersSearch',
					id = 'playersSearch',

					possibleSymbols = '1234567890-_=+ёйцукенгшщхъзфывапролджячсмитьбю!№;%:?*()qwertyuiopasdfghjklzxcvbnm,./э ',

					alignX = 'left',

					scale = 0.5,
					font = getFont('montserrat_semibold', 23, 'light'),

					onInput = function(element)
						--if element[6] ~= "" and utf8.len( element[6] ) > 0 then
							gui_get( "vehicles-list" ):applyFilter( element[6] )
						--end
					end,

					Clear = function( element )
						element[6] = ""
					end,

				},

				{'list',

					30, 110,
					336, 300,

					scrollBg = scrollTexture,
					scrollColor = {180, 70, 70,255},
					scrollBgColor = {25, 25, 25,255},
					scrollWidth = 5,

					listOffset = 0,

					listElements = {
						
					},

					font = getFont('montserrat_semibold', 26, 'bold'),
					scale = 0.5,

					listElementHeight = 44,

					color = {255,255,255,255},

					id = 'vehicles-list',

					applyFilter = function( element, filter )
						table.sort( element.listElements, function( a,b )


							local match_a = a and gui_get( "vehicles-list" ):hasFilterMatch( a, filter ) or false
							local match_b = b and gui_get( "vehicles-list" ):hasFilterMatch( b, filter ) or false

							if match_a and match_b then

								--[[local a_last_message = a.messages[#a.messages] or { timestamp = 0 }
								local b_last_message = b.messages[#b.messages] or { timestamp = 0 }

								if a_last_message.timestamp ~= b_last_message.timestamp then
									return a_last_message.timestamp > b_last_message.timestamp
								else
									return a.player.name < b.player.name
								end]]

								return a.name < b.name
								--iprint(match_a, match_b, "gfdg")


							else

								return ( match_a and 1 or 0 ) > ( match_b and 1 or 0 )

							end

						end )

						element:updateElementsOrder()

					end,

					updateElementsOrder = function(element)

						local startY = 0
						local padding = 5

						for _, c_element in pairs( element.elements or {} ) do

							c_element[3] = startY
							startY = startY + c_element[5] + padding

						end

					end,

					hasFilterMatch = function(element, list, filter)

						--if not isElement(element.player) then return false end
						return list.name:lower():find( filter:lower() )

					end,

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x+w/2-336/2, y+h/2-315/2,
							336, 315,
							'assets/images/list_bg.png', 0, 0, 0, 
							tocolor(37,42,74,255*alpha)
						)


					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local padding = 30

						dxDrawText('Транспорт',
							x + padding, y-23,
							x + padding, y-23,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
							'left', 'bottom'
						)

						dxDrawText('Номер',
							x+w - padding, y-23,
							x+w - padding, y-23,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
							'right', 'bottom'
						)

						dxDrawText(string.format('Парковочных ячеек занято #cd4949%s#ffffff из #cd4949%s', getParkingData()),
							x,y+h+15,
							x+w,y+h+15,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
							'center', 'top', false, false, false, true

						)

					end,

					additionalElementDrawing = function(lElement, x,y,w,ey, element, animData, index, hovered)

						local alpha = element:alpha()
						local ex,ey,ew,eh = element:abs()

						local x,y,w,h = x,y+element.listElementHeight/2-39/2, ew, 39

						local tr,tg,tb = unpack( lElement.mark and lElement.mark.color or {255,255,255} )
						local r,g,b = interpolateBetween( 31,36,63, 180, 70, 70, animData, 'InOutQuad' )
						local ir,ig,ib = interpolateBetween( 180, 70, 70, 31,36,63, animData, 'InOutQuad' )

						if lElement.mark then
							r,g,b = interpolateBetween( 31,36,63, tr,tg,tb, animData, 'InOutQuad' )
							tr,tg,tb = interpolateBetween( tr,tg,tb, 31,36,63, animData, 'InOutQuad' )
						end

						dxDrawRectangle(
							x,y,w,h, tocolor(r,g,b,255*alpha)
						)


						local name = lElement.mark and string.format('%s %s', lElement.name, lElement.mark.postfix) or lElement.name

						if lElement.expiry_date then

							dxDrawText(name,
								x + 20, y+3,
								x + 20, y+3,
								tocolor(tr,tg,tb,255*alpha),
								0.5, 0.5, getFont('montserrat_bold', 19, 'light'),
								'left', 'top'
							)

							local timestamp = getServerTimestamp()
							local expiry_date = lElement.expiry_date or 0

							local time = math.max(0, expiry_date - timestamp.timestamp)
							local h = math.floor(time/3600)
							local m = math.floor((time - h*3600)/60)
							local s = time - h*3600 - m*60

							local str = string.format('%02d:%02d:%02d', h,m,s)

							dxDrawText('Осталось '..str,
								x + 20, y+16,
								x + 20, y+16,
								tocolor(tr,tg,tb,255*alpha),
								0.5, 0.5, getFont('montserrat_bold', 19, 'light'),
								'left', 'top'
							)

						else

							dxDrawText(name,
								x + 20, y,
								x + 20, y+h,
								tocolor(tr,tg,tb,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
								'left', 'center'
							)


						end

						if lElement.plate == '' then

							dxDrawText('Отсутствует',
								x + w - 20, y,
								x + w - 20, y+h,
								tocolor(tr,tg,tb,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
								'right', 'center'
							)

						else

							dxDrawText(lElement.plate,
								x + w - 20, y,
								x + w - 20, y+h,
								tocolor(tr,tg,tb,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
								'right', 'center'
							)

						end

					end,

				},

				{'element',

					'right', 'center',
					330, 350,

					color = {255,255,255,255},

					onRender = function(element)

						local x,y,w,h = element:abs()
						local alpha = element:alpha()

						dxDrawText('Управление транспортом',
							x,y+5,x+w,y+5,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
							'center', 'top'
						)

					end,

					elements = {

						{'button',

							[3] = 60, [6]='Респавн',

							onClick = function(element)
								doManagerAction('respawn', false, getPedCameraRotation(localPlayer))
							end,

						},

						{'button',

							[3] = 120, [6]='Убрать',

							onClick = function(element)
								doManagerAction('clear', false)
							end,

						},

						{'button',

							[3] = 255, [6]='Сбросить чип',

							onClick = function(element)

								dialog('Сброс', 'Вы действительно хотите сбросить чип?', function(result)

									if result then
										if gui_get('vehicles-list').lastSelectedItem then
											doManagerAction('reset_handling', false, gui_get('vehicles-list').lastSelectedItem.model)
										end
									end

								end)

							end,

						},

						{'button',

							[3] = 180, [6]='Убрать все',

							onClick = function(element)
								doManagerAction('clearall', true)
							end,

						},


					},

				},

			},

		},


	},

}

----------------------------------------------------------------

	GUIDefine('button', {

		[2]='center', 
		[4]=228, [5]=48,


		color = {180,70,70,255},
		activeColor = {200,70,70,255},

		scale = 0.5,
		font = getFont('montserrat_semibold', 26, 'light'),

		bg = 'assets/images/button_empty.png',
		activeBg = 'assets/images/button.png',

		onPreRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local shx,shy,shw,shh = x + w/2 - 260/2, y + h/2 - 82/2, 260, 82

			dxDrawImage(
				shx,shy,shw,shh, 'assets/images/button_empty_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
			)
			dxDrawImage(
				shx,shy,shw,shh, 'assets/images/button_shadow.png',
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
			)

		end,


	})

----------------------------------------------------------------

	if localPlayer:getData('unique.login') then
		triggerServerEvent('vehicles.sendPlayerVehicles', root)
	end

----------------------------------------------------------------

	addEventHandler('onClientElementDataChange', localPlayer, function(dataName, old, new)
		if dataName == 'unique.login' and new then
			triggerServerEvent('vehicles.sendPlayerVehicles', root)
		end
	end)

----------------------------------------------------------------

	function getParkingData()
		return localPlayer:getData('parks.loaded') or 0, localPlayer:getData('parks.all') or 0
	end

	local lastAction = getTickCount()
	function doManagerAction(action, ignoreSelections, ...)

		if not isPlayerManagerCompatible() and not action:find('clear') then
			return exports.hud_notify:notify('Нельзя использовать F3', 'В данной зоне')
		end

		if (getTickCount() - lastAction) < 300 then return end

		local vehiclesList = gui_get('vehicles-list')
		if not vehiclesList.lastSelectedItem and not ignoreSelections then return end

		if getVehicleType( vehiclesList.lastSelectedItem.model ) == 'Boat' then
			
			if isElementInWater(localPlayer) and localPlayer.position.z < -2 then
				return
			end

		end

		local id = (vehiclesList.lastSelectedItem or {}).id

		lastAction = getTickCount()


		triggerServerEvent('vehicles.manager.action', root,
			action, id, ...)

	end

	function updateLastSelection()
		if not lastSelectedId then return end
		local vehiclesList = gui_get('vehicles-list')

		for _, element in pairs( vehiclesList.listElements ) do
			if element.id == lastSelectedId then
				vehiclesList.lastSelectedItem = element
			end
		end
	end

----------------------------------------------------------------

loadGuiModule()



end)
