
cancelButtons = {
	['f1'] = true,
	['f2'] = true,
	['f3'] = true,
	['f4'] = true,
	['f5'] = true,
	['f11'] = true,
	['f7'] = true,
	['f9'] = true,
	['k'] = true,
	['m'] = true,
	['t'] = true,
	['y'] = true,
}

addEventHandler('onClientKey', root, function(button)
	if windowOpened and button ~= 'F10' then
		cancelEvent()
	end
end)

openHandler = function()

	showChat(false)

	adminSearchList:clear()
	adminDataList:clear()
	adminPropertyList:clear()

	adminSearchList:search()

end
closeHandler = function()
	showChat(true)
end

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'rectangle',

			'center', 'center',
			1157, 641,
			color = {25,24,38,255},

			variable = 'adminWindow',

			elements = {

				{'element',
					'center', 'center',
					1050, '100%',
					color = {255,255,255,255},

					elements = {

						{'element',

							'left', 'center',
							335, 544,
							color = {255,255,255,255},

							elements = {

								{'input',
									0, 25, 277, 58,
									placeholder = 'Поиск игрока',
									variable = 'adminSearchInput',
									maxSymbols = 40,

									tabs = {
										{ id = 'login', checked = true },
										{ id = 'nick', checked = true },
										{ id = 'serial' },
										{ id = 'online', checked = true },
										{ id = 'offline', checked = true },
									},

									getSettings = function(element)

										local settings = {}

										for _, tab in pairs(element.tabs) do
											settings[tab.id] = tab.checked
										end

										return settings

									end,

									onInit = function(element)

										local startX = 0
										local scale, font = 0.5, getFont('montserrat_medium', 20, 'light')

										local padding = 5
										local h = 20

										element:addElement(
											{'rectangle',
												0, -h-5,
												element.parent[4], h,
												color = {22,20,34,100},
											}
										)

										for _, tab in pairs(element.tabs) do

											local textWidth = dxGetTextWidth(tab.id, scale, font) + 20

											element:addElement(
												{'rectangle',
													startX, -h-5,
													textWidth, h,
													color = {32,30,44,255},

													onInit = function(element)
														element.c_anim = {}
														setAnimData(element.c_anim, 0.1)
													end,

													tab = tab,

													scale = scale,
													font = font,

													onRender = function(element)

														local x,y,w,h = element:abs()
														local alpha = element:alpha()

														local anim = getAnimData(element.c_anim)
														animate(element.c_anim, element.tab.checked and 1 or 0)

														local r,g,b = interpolateBetween(22,20,34, 180,70,70, anim, 'InOutQuad')
														element.color = {r,g,b, element.color[4]}

														dxDrawText(element.tab.id,
															x,y,x+w,y+h,
															tocolor(255,255,255,255*alpha),
															element.scale, element.scale, element.font, 
															'center', 'center'
														)

													end,

													onClick = function(element)
														element.tab.checked = not element.tab.checked
													end,

												}
											)

											startX = startX + textWidth + padding

										end

									end,

								},

								{'button',

									'right', 25, 58, 58,
									'',

									icon = 'assets/images/search.png',
									icon_size = {30,30},

									onClick = function(element)
										if adminSearchList:isActive() then
											adminSearchList:search()
										end
									end,

								},

								{'rectangle',

									0, 'bottom',
									'100%', 441,
									color = {22,20,34,255},

									elements = {

										{'element',
											0, 0, '100%', '100%',
											color = {255,255,255,255},

											overflow = 'vertical',
											variable = 'adminSearchList',

											scrollXOffset = -15,

											isActive = function(element)
												local _, target = getAnimData(element.animationAlpha)
												return target == 1 
											end,


											onRender = function(element)

												local x,y,w,h = element:abs()
												local alpha = element:alpha()

												if #(element.elements or {}) == 0 then
													dxDrawText('Список игроков пуст',
														x,y,x+w,y+h,
														tocolor(60,60,85,255*alpha),
														0.5, 0.5, getFont('montserrat_medium', 26, 'light'),
														'center', 'center'
													)
												else

													local count = #(element.elements or {})

													dxDrawText(string.format('%s %s',
														count, getWordCase(count, 'игрок', 'игрока', 'игроков')
													),
														x+10,y+h+10,x + 10,y+h+10,
														tocolor(60,60,85,255*alpha),
														0.5, 0.5, getFont('montserrat_medium', 26, 'light'),
														'left', 'top'
													)

												end

											end,

											search = function(element, _filter, _settings)

												local x,y,w,h = element:abs()

												local filter = _filter or adminSearchInput[6]
												local settings = _settings or adminSearchInput:getSettings()

												if utf8.len(filter) > 0 and settings.offline then

													animate(element.animationAlpha, 0)
													displayLoading({x+w/2-70/2, y+h/2-70/2, 70, 70}, {180,70,70,255}, Config.searchTime+100,
													function()end)

												end

												admin:call('returnSearch', filter, settings)

											end,

											onInit = function(element)

												element.animationAlpha = {}
												setAnimData(element.animationAlpha, 0.1, 1)

												element.contextMenu = adminWindow:addElement(
													{'element',

														-300-15, 0,
														300, 200,
														color = {255,255,255,255},

														gOnPreRender = function(element)

															local x,y,w,h = element:abs()

															if element:isActive() and handleClick and not isMouseInPosition(x,y,w,h) then
																element:hide()
																handleClick = false
															end

														end,

														overflow = 'vertical',
														scrollXOffset = -5,
														scroll_step = 30,

														onPreRender = function(element)

															local x,y,w,h = element:abs()
															local alpha = element:alpha()

															-- local totalH = 0

															-- local padding = 5
															-- for _, c_element in pairs( element.elements or {} ) do
															-- 	totalH = totalH + c_element[5] + padding
															-- end

															-- element[5] = totalH

															dxDrawRectangle(
																x - 10, y - 10,
																w + 20, element[5] + 20,
																tocolor(17,15,26,255*alpha)
															)

														end,

														isActive = function(element)
															local _, target = getAnimData(element.animationAlpha)
															return target == 1 
														end,

														addButton = function(element, button)

															local startY = 0
															local w,h = 280, 45
															local padding = 5

															for _, c_element in pairs( element.elements or {} ) do
																startY = startY + c_element[5] + padding
															end

															element:addElement(
																{'button',
																	'center', startY,
																	w,h,

																	[6] = button.name,
																	action = button.action,

																	onClick = function(element)
																		element.parent:hide()
																		element:action()
																	end,

																}
															)

														end,

														show = function(element)
															animate(element.animationAlpha, 1)
														end,

														hide = function(element)
															animate(element.animationAlpha, 0)
														end,

														clear = function(element)

															for _, c_element in pairs( element.elements or {} ) do
																c_element:destroy()
															end

															element.elements = {}

															element.ov_animY = 0

														end,

														onInit = function(element)

															element.animationAlpha = {}
															setAnimData(element.animationAlpha, 0.1, 0)

														end,

													}
												)

											end,

											clear = function(element)

												for _, c_element in pairs( element.elements or {}) do
													c_element:destroy()
												end

												element.elements = {}

												element.ov_animY = 0

											end,

											update = function(element, list)

												animate(element.animationAlpha, 1)

												element:clear()
												adminDataList:clear()
												adminPropertyList:clear()
												adminLogList:clear()

												local startY = 0

												local w,h = 335, 58
												local padding = 5

												for _, row in pairs(list) do

													element:addElement(
														{'rectangle',

															'center', startY,
															w,h,
															color = {23,22,36,255},

															row = row,

															onInit = function(element)
																element.s_anim = {}
																setAnimData(element.s_anim, 0.1)
															end,

															onRender = function(element)

																local x,y,w,h = element:abs()
																local alpha = element:alpha()

																local anim = getAnimData(element.s_anim)
																animate(element.s_anim, element.parent.selected == element and 1 or 0)

																local r,g,b = interpolateBetween(23,22,36, 40,40,55, anim, 'InOutQuad')
																element.color = {r,g,b, element.color[4]}

																dxDrawText(element.row.data['character.nickname'] or '---',
																	x+20,y+10,x+20,y+10,
																	tocolor(255,255,255,255*alpha),
																	0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
																	'left', 'top'
																)

																dxDrawText(element.row.data.account_name,
																	x+20,y+27,x+20,y+27,
																	tocolor(200,200,200,255*alpha),
																	0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
																	'left', 'top'
																)

																local rw,rh = 10,10
																local rr,rg,rb = 100,100,100

																local _player = getPlayerFromLogin(element.row.data.account_name)
																if _player then

																	rr,rg,rb = 100,255,120

																	if exports.afk:isAFK(_player) then
																		rr,rg,rb = 255,160,20
																	end

																end

																local rx,ry = x+w-rw-30, y+h/2-rh/2

																dxDrawImage(
																	rx,ry,rw,rh, roundTexture,
																	0, 0, 0, tocolor(rr,rg,rb,255*alpha)
																)

															end,

															onClick = function(element, _, button)

																if element.parent.contextMenu:isActive() then
																	handleClick = true
																	return
																end

																if button == 'left' then
																	element.parent:select(element)
																elseif button == 'right' then
																	element.parent:select(element)
																	element.parent:createContextMenu(element)
																end

															end,


														}
													)

													startY = startY + h + padding

												end

											end,

											select = function(element, c_element)

												element.selected = c_element
												adminDataList:update(c_element.row.data)
												adminPropertyList:update(c_element.row.property)

											end,

											createContextMenu = function(element, c_element)

												local contextMenu = element.contextMenu
												contextMenu:clear()

												setAnimData(contextMenu.ov_animId, 0.1, 0)

												local buttons = {}

												local rowData = adminSearchList.selected.row.data

												for action_id, action in pairs( Config.accountActions ) do

													if not action.right or hasPlayerRight(localPlayer, action.right)
														and (action.is_offline or rowData.player)
													then
														table.insert(buttons, {
															name = action.name,
															action = function()

																local login = rowData.account_name

																if action.args then

																	local args = type(action.args) == 'function' and action.args() or action.args

																	if args == false then
																		return
																	end

																	dialog_input(action.name, 'Заполните данные', args, function(data)
																		if data then
																			admin:call('accountAction', login, action_id, unpack(data))
																		end
																	end)

																elseif action.confirm then

																	dialog('Подтвердите действие', 'Вы выбрали действие '..action.name,
																		function(result)

																			if result then
																				admin:call('accountAction', login, action_id)
																			end

																		end
																	)

																else
																	admin:call('accountAction', login, action_id)
																end

															end,
														})
													end

												end

												if #buttons > 0 then

													local cx,cy = getCursorPosition()
													cx,cy = (cx*sx - adminWindow[2]), (cy*real_sy * sx/real_sx - adminWindow[3])

													contextMenu[2] = cx + 5
													contextMenu[3] = cy + 5

													contextMenu:show()

													for _, button in pairs( buttons ) do
														contextMenu:addButton(button)
													end

												end


											end,

											admin:addCallback('receiveSearch', function(list)
												adminSearchList:update(list)
											end),

											admin:addCallback('receiveAccount', function(login, data)

												for _, c_element in pairs( adminSearchList.elements or {} ) do

													if c_element.row.data.account_name == login then

														c_element.row = data

														if c_element == adminSearchList.selected then
															adminSearchList:select(c_element)
														end

													end

												end

											end),


										},

									},
								},

							},

						},

						{'element',

							'center', 'center',
							335, 544,
							color = {255,255,255,255},

							elements = {

								{'rectangle',

									0, 'top',
									'100%', 191,
									color = {22,20,34,255},

									overflow = 'vertical',
									variable = 'adminDataList',

									scrollXOffset = -15,

									clear = function(element)

										for _, c_element in pairs( element.elements or {}) do
											c_element:destroy()
										end

										element.elements = {}

										element.ov_animY = 0

									end,

									update = function(element, list)

										element:clear()

										element.elements = {}

										local startY = 0

										local w,h = element[4], 50
										local padding = 5

										local rows = {}

										for _, data_row in pairs( Config.accountData ) do

											local value = adminSearchList.selected.row.data[data_row.key]
											local _value = value
											if type(data_row.value) == 'function' then
												_value = data_row.value(_value or '')
											end

											local row = {
												edit = data_row.edit ~= false,
												copy = data_row.copy,
												name = data_row.name,
												key = data_row.key,

												value = _value,
												default_value = value,

												type = data_row.type or 'text',
											}

											table.insert(rows, row)

										end

										for _, row in pairs( rows ) do

											element:addElement(
												{'rectangle',

													'center', startY,
													w,h,
													color = {23,22,36,255},

													row = row,

													onRender = function(element)

														local x,y,w,h = element:abs()
														local alpha = element:alpha()

														local anim = getAnimData(element.s_anim)
														animate(element.s_anim, element.parent.row == element and 1 or 0)

														local value = element.row.value

														if element.row.type == 'number' then
															value = splitWithPoints(value, '.')
														end

														dxDrawText(string.format('%s - %s',
															element.row.name, value
														),
															x+25,y,x+25,y+h,
															tocolor(255,255,255,255*alpha),
															0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
															'left', 'center'
														)

													end,

													onInit = function(element)

														local w,h = 20,20
														local startX = element[4] - w - 30
														local padding = 10

														if element.row.edit then

															element:addElement(
																{'button',

																	startX, 'center',
																	w,h,
																	bg = false,

																	icon_size = {20,20},
																	icon = 'assets/images/edit.png',

																	onClick = function(element)

																		if adminSearchList.contextMenu:isActive() then
																			handleClick = true
																			return
																		end

																		local row = element.parent.row
																		local login = adminSearchList.selected.row.data.account_name

																		if row.edit then

																			setTimer(function()

																				dialog_input('Редактирование',
																					string.format('Игрок %s, поле %s',
																						login,
																						row.name
																					), {
																						{ type = row.type, name = row.name },
																					},
																					function(data)

																						if data then
																							admin:call('editAccountData', login, row.key, data[1])
																						end

																					end
																				)

																			end, 50, 1)


																		end

																	end,

																}
															)

															startX = startX - 20 - padding

														end

														if element.row.copy then

															element:addElement(
																{'button',

																	startX, 'center',
																	w,h,
																	bg = false,

																	icon_size = {20,20},
																	icon = 'assets/images/copy.png',

																	onClick = function(element)

																		if adminSearchList.contextMenu:isActive() then
																			handleClick = true
																			return
																		end

																		local row = element.parent.row

																		if row.copy then
																			setClipboard(inspect(row.default_value))
																			exports.hud_notify:notify('Успешно', 'Данные скопированы')
																		end

																	end,

																}
															)

															startX = startX - 20 - padding

														end

													end,

												}
											)

											startY = startY + h + padding

										end

									end,

									onRender = function(element)

										local x,y,w,h = element:abs()
										local alpha = element:alpha()

										if #(element.elements or {}) == 0 then
											dxDrawText('Список данных пуст',
												x,y,x+w,y+h,
												tocolor(60,60,85,255*alpha),
												0.5, 0.5, getFont('montserrat_medium', 26, 'light'),
												'center', 'center'
											)
										end

									end,

								},

								{'rectangle',

									0, 'bottom',
									'100%', 329,
									color = {22,20,34,255},

									overflow = 'vertical',
									variable = 'adminPropertyList',

									clear = function(element)

										for _, c_element in pairs( element.elements or {}) do
											c_element:destroy()
										end

										element.elements = {}

										element.ov_animY = 0

									end,

									update = function(element, list)

										element:clear()

										element.elements = {}

										local startY = 0

										local w = element[4]
										local padding = 5

										local scale, font = 0.5, getFont('montserrat_semibold', 23, 'light')
										local fontHeight = dxGetFontHeight(scale, font)

										for _, row in pairs( list ) do

											local h = 40 + fontHeight*( 1 + #Config.propertyDisplay[row.row_type] )

											row.edit = Config.propertyDisplay[row.row_type].edit ~= false

											element:addElement(
												{'rectangle',

													'center', startY,
													w,h,
													color = {23,22,36,255},

													row = row,

													scrollXOffset = -15,

													scale = scale,
													font = font,
													fontHeight = fontHeight,

													onRender = function(element)

														local x,y,w,h = element:abs()
														local alpha = element:alpha()

														local startY = y+20

														local display = Config.propertyDisplay[element.row.row_type]
														local rows = {}

														table.insert(rows, { text = string.format('%s (id %s)',
															element.row.row_name, element.row.id
														) })

														for _, display_key in pairs( display or {} ) do

															local value = element.row[display_key.key] or '---'

															if display_key.type == 'number' then
																value = splitWithPoints(value, '.')
															end

															table.insert(rows, { text = string.format('%s - %s',
																display_key.name, value
															) })

														end

														for _, row in pairs( rows ) do

															dxDrawText(row.text,
																x + 20, startY,
																x + 20, startY,
																tocolor(255,255,255,255*alpha),
																element.scale, element.scale, element.font,
																'left', 'top'
															)

															startY = startY + element.fontHeight
																
														end


													end,

													onInit = function(element)

														local w,h = 20,20
														local startX = element[4] - w - 40
														local startY = element[5] - h - 20
														local padding = 10

														element:addElement(
															{'button',

																startX, startY,
																w,h,
																bg = false,

																icon_size = {20,20},
																icon = 'assets/images/edit.png',

																onClick = function(element)

																	if adminSearchList.contextMenu:isActive() then
																		handleClick = true
																		return
																	end

																	local row = element.parent.row
																	local login = adminSearchList.selected.row.data.account_name

																	if row.edit then

																		setTimer(function()

																			local inputs = {}

																			local params = {
																				onRender = function(element)
																					if element.focused then
																						element.textColor = {255,255,255,element.color[4]}
																					else
																						element.textColor = {255,255,255,0}
																						element.placeholderColor = {255,255,255,0}

																						local x,y,w,h = element:abs()
																						local alpha = element:alpha()

																						dxDrawText(string.format('%s: %s',
																							element.placeholder, element[6]
																						),
																							x,y,x+w,y+h,
																							tocolor(255,255,255,255*alpha),
																							element.scale, element.scale, element.font,
																							'center', 'center'
																						)
																					end
																				end,
																			}

																			for _, field in pairs( Config.propertyDisplay[row.row_type] ) do
																				table.insert(inputs,
																					{
																						type = field.type or 'text', 
																						name = field.name,
																						params = {
																							[6] = row[field.key] or '',
																							onRender = params.onRender
																						}
																					}
																				)
																			end

																			dialog_input('Редактирование',
																				string.format('%s (id %s)',
																					row.row_name,
																					row.id
																				), inputs,
																				function(data)

																					if data then

																						local rows = {}

																						for index, row in pairs( Config.propertyDisplay[row.row_type] ) do
																							rows[row.key] = data[index] or ''
																						end

																						admin:call('editAccountProperty', login,
																							{ id = row.id, type = row.row_type }, rows)

																					end

																				end
																			)

																		end, 50, 1)


																	end

																end,

															}
														)

														startY = startY - h - padding

														element:addElement(
															{'button',

																startX, startY,
																w,h,
																bg = false,

																icon_size = {20,20},
																icon = 'assets/images/copy.png',

																onClick = function(element)

																	if adminSearchList.contextMenu:isActive() then
																		handleClick = true
																		return
																	end

																	local row = element.parent.row

																	setClipboard(inspect(row))
																	exports.hud_notify:notify('Успешно', 'Данные скопированы')

																end,

															}
														)

														startY = startY - h - padding

													end,
												}
											)

											startY = startY + h + padding

										end

									end,

									onRender = function(element)

										local x,y,w,h = element:abs()
										local alpha = element:alpha()

										if #(element.elements or {}) == 0 then
											dxDrawText('Список имущества пуст',
												x,y,x+w,y+h,
												tocolor(60,60,85,255*alpha),
												0.5, 0.5, getFont('montserrat_medium', 26, 'light'),
												'center', 'center'
											)
										end

									end,

								},

							},

						},

						{'element',

							'right', 'center',
							335, 544,
							color = {255,255,255,255},

							elements = {

								{'input',
									0, 0, 277, 58,
									placeholder = 'Поиск логов',
									variable = 'adminLogSearch',

								},

								{'button',

									'right', 0, 58, 58,
									'',

									icon = 'assets/images/search.png',
									icon_size = {30,30},

									onClick = function(element)
										if adminLogList:isActive() then
											adminLogList:search()
										end
									end,

								},

								{'rectangle',
									0, 'center',
									'100%', function(s,p) return p[5] - 58*2 - 30 end,
									color = {22,20,34,255},

									elements = {

										{'element',

											0, 0, '100%', '100%',
											color = {255,255,255,255},

											overflow = 'vertical',
											scrollXOffset = -15,

											variable = 'adminLogList',

											onInit = function(element)

												element.animationAlpha = {}
												setAnimData(element.animationAlpha, 0.1, 1)

											end,

											isActive = function(element)
												local _, target = getAnimData(element.animationAlpha)
												return target == 1 
											end,

											search = function(element)

												if adminSearchList.selected then

													local x,y,w,h = element:abs()

													animate(element.animationAlpha, 0)
													displayLoading({x+w/2-70/2, y+h/2-70/2, 70, 70}, {180,70,70,255}, Config.searchTime+100,
													function()
														animate(element.animationAlpha, 1)
													end)

													setTimer(function()

														admin:call('returnAccountLogs',
															adminSearchList.selected.row.data.account_name,
															adminLogSearch[6]
														)

													end, 1000, 1)

												end

											end,

											clear = function(element)

												for _, c_element in pairs( element.elements or {} ) do
													c_element:destroy()
												end

												element.elements = {}

												element.ov_animY = 0

											end,

											onRender = function(element)

												local x,y,w,h = element:abs()
												local alpha = element:alpha()

												if #(element.elements or {}) == 0 then
													dxDrawText('Список логов пуст',
														x,y,x+w,y+h,
														tocolor(60,60,85,255*alpha),
														0.5, 0.5, getFont('montserrat_medium', 26, 'light'),
														'center', 'center'
													)
												end

											end,

											update = function(element, list)

												element:clear()

												local startY = 0

												local scale, font = 0.5, getFont('montserrat_medium', 22, 'light')
												local w,h = element[4], 60
												local padding = 5

												for _, row in pairs( list ) do

													row.data = loadstring( string.format('return %s', row.data or '{}') )()

													element:addElement(
														{'rectangle',

															0, startY,
															w,h,

															color = {23,22,36,255},

															row = row,

															onRender = function(element)

																local x,y,w,h = element:abs()
																local alpha = element:alpha()

																dxDrawText(element.row.tag,
																	x + 20, y + 10,
																	x + 20, y + 10,
																	tocolor(255,255,255,255*alpha),
																	0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
																	'left', 'top'
																)

																dxDrawText(element.row.date,
																	x + 20, y + 30,
																	x + 20, y + 30,
																	tocolor(60,60,85,255*alpha),
																	0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
																	'left', 'top'
																)

															end,

															onInit = function(element)

																local w,h = 20,20

																element:addElement(
																	{'button',

																		element[4] - w - 40,
																		element[5] - h - 20,
																		w,h,
																		bg = false,

																		icon_size = {20,20},
																		icon = 'assets/images/copy.png',

																		onClick = function(element)

																			if adminSearchList.contextMenu:isActive() then
																				handleClick = true
																				return
																			end

																			local row = element.parent.row

																			setClipboard(inspect(row))
																			exports.hud_notify:notify('Успешно', 'Данные скопированы')

																		end,

																	}
																)

															end,

														}
													)

													startY = startY + h + padding

												end

											end,

											admin:addCallback('receiveLogs', function(list)
												adminLogList:update(list)
											end),

										},

									},

								},

								{'element',

									0, 'bottom',
									'100%', 58,
									color = {255,255,255,255},

									elements = {

										{'button',

											'left', 'center',
											160, '100%',
											color = {22,20,34,255},
											'Банлист',

											onClick = function(element)

												if exports.acl:isAdmin(localPlayer) then
													currentWindowSection = 'bans'
													adminBanList:search()
												else
													exports.hud_notify:notify('Ошибка', 'Нет доступа')
												end

											end,

										},

										{'button',

											'right', 'center',
											160, '100%',
											color = {22,20,34,255},
											'Никлогин',

											onClick = function(element)

												if exports.acl:isAdmin(localPlayer) then
													currentWindowSection = 'nicklogin'
												else
													exports.hud_notify:notify('Ошибка', 'Нет доступа')
												end

											end,

										},

									},

								},


							},

						},
					
					},

				},


			},

		},
	
	},

	bans = {

		{'rectangle',

			'center', 'center',
			1257, 641,
			color = {25,24,38,255},

			onRender = function(element)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				dxDrawText('Банлист',
					x + 60, y + 30,
					x + 60, y + 30,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 50, 'light'),
					'left', 'top'
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

					onClick = function()
						currentWindowSection = 'main'
					end,

				},

				{'input',
					230, 32, 255, 45,
					placeholder = 'Поиск',
					variable = 'adminBanSearchInput',
					alignX = 'center',

					onInput = function(element)
						adminBanList.currentFilter = element[6]
						adminBanList:update()
					end,

				},

				{'element',

					'center', 150,
					'90%', function(s,p) return p[5] - 20 - s[3] end,
					color = {255,255,255,255},

					overflow = 'vertical',
					variable = 'adminBanList',

					columns = {

						{ name = 'Баннер', width = 180, get = function(row)
							return string.format('%s', row.banner)
						end, },

						{ name = 'Имя (Логин)', width = 180, get = function(row)
							return string.format('%s (%s)', row.name, row.login)
						end, },

						{ name = 'Serial', width = 160, get = function(row)

							if not row.serial then return '---' end
							local serial = row.serial:sub(0, 5) .. '...' .. row.serial:sub(-5)
							return serial

						end, },

						{ name = 'Дата', width = 160, get = function(row)

							local timestamp = getRealTime(row.timestamp)
							local str = string.format('%02d.%02d.%s %02d:%02d',
								timestamp.monthday, timestamp.month+1, timestamp.year + 1900,
								timestamp.hour, timestamp.minute
							)

							return str

						end, },

						{ name = 'Причина', width = 180, get = function(row)

							local reason

							if utf8.len(row.reason or '') > 20 then
								reason = utf8.sub(row.reason or '', 0, 20) .. '...'
							else
								reason = row.reason or ''
							end

							return reason

						end, },

						{ name = 'Срок', width = 100, get = function(row)
							local delta = row.unbanTime - row.time
							return math.floor( delta/60 ) .. ' мин.'
						end, },
					},

					onRender = function(element)

						local x,y,w,h = element:abs()
						local alpha = element:alpha()

						local startX = x

						local ch = 40
						local cy = y - ch - 5

						dxDrawRectangle(
							x, cy, w, ch, tocolor(18,18,28,255*alpha)
						)

						for _, column in pairs( element.columns ) do

							dxDrawText(column.name,
								startX, cy,
								startX + column.width, cy+ch,
								tocolor(100,100,120,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
								'center', 'center'
							)

							startX = startX + column.width

						end


					end,

					currentFilter = '',

					update = function(element, list)

						for _, c_element in pairs(element.elements or {}) do
							c_element:destroy()
						end

						element._list = list and table.copy(list) or element._list

						element.elements = {}

						local startY = 0

						local w,h = element[4], 50
						local padding = 5

						for _, row in pairs(element._list) do

							if utf8.find(
								utf8.lower( (row.serial or '---') .. row.name .. row.login ),
								utf8.lower(element.currentFilter)
							) then

								element:addElement(
									{'rectangle',

										0, startY,
										w,h,
										color = {18,18,28,255},

										row = row,

										onRender = function(element)


											local x,y,w,h = element:abs()
											local alpha = element:alpha()

											local startX = x

											for _, column in pairs( element.parent.columns ) do

												dxDrawText(column.get(element.row),
													startX, y,
													startX + column.width, y+h,
													tocolor(170,170,200,255*alpha),
													0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
													'center', 'center'
												)

												startX = startX + column.width

											end

										end,

										onInit = function(element)

											element:addElement(
												{'button',

													function(s,p) return p[4] - s[4] - 10 end, 'center',
													100, 40,
													'Разбан',

													onClick = function(element)

														dialog('Разбан', {
															'Вы действительно хотите',
															'сделать разбан?',
														}, function(result)

															if result then
																admin:call('unban', element.parent.row)
															end

														end)


													end,

												}
											)

										end,

									}
								)

								startY = startY + h + padding

							
							end


						end

					end,

					search = function(element)

						admin:call('returnBans')

					end,

					admin:addCallback('receiveBans', function(list)
						adminBanList:update(list)
					end),

				},

			},

		},

	},

	nicklogin = {

		{'rectangle',

			'center', 'center',
			1257, 641,
			color = {25,24,38,255},

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

					onClick = function()
						currentWindowSection = 'main'
					end,

				},

				{'element',

					0, 0, function(s,p) return p[4]-240 end, '100%',
					color = {255,255,255,255},

					elements = {

						{'element',
							50, 32, 300, 45,
							color = {255,255,255,255},

							elements = {

								{'input',
									0, 0, 255, 45,
									placeholder = 'Поиск',
									variable = 'adminNickloginSearchInput',
									maxSymbols = 40,
								},

								{'button',

									'right', 0, 45, 45,
									'',

									icon = 'assets/images/search.png',
									icon_size = {30,30},

									onClick = function(element)
										adminNickloginList:search()
									end,

								},

							},

						},

						{'element',

							'center', 150,
							'90%', function(s,p) return p[5] - 20 - s[3] end,
							color = {255,255,255,255},

							overflow = 'vertical',
							variable = 'adminNickloginList',

							scrollXOffset = 10,

							columns = {

								{ name = 'Ник', width = 180, get = function(row)
									return row.nick
								end, },

								{ name = 'Логин', width = 180, get = function(row)
									return row.login
								end, },

								{ name = 'Серийник', width = 160, get = function(row)

									if not row.serial then return '---' end
									local serial = row.serial:sub(0, 5) .. '...' .. row.serial:sub(-5)
									return serial

								end, },

								{ name = 'IP', width = 100, get = function(row)

									return row.ip

								end, },

								{ name = 'Дата', width = 160, get = function(row)

									local timestamp = getRealTime(row.timestamp)
									local str = string.format('%02d.%02d.%s %02d:%02d',
										timestamp.monthday, timestamp.month+1, timestamp.year + 1900,
										timestamp.hour, timestamp.minute
									)

									return str

								end, },

								{ name = 'Действие', width = 100, get = function(row)
									return row.action
								end, },
							},

							onRender = function(element)

								local x,y,w,h = element:abs()
								local alpha = element:alpha()

								local startX = x

								local ch = 40
								local cy = y - ch - 5

								dxDrawRectangle(
									x, cy, w, ch, tocolor(18,18,28,255*alpha)
								)

								for _, column in pairs( element.columns ) do

									dxDrawText(column.name,
										startX, cy,
										startX + column.width, cy+ch,
										tocolor(100,100,120,255*alpha),
										0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
										'center', 'center'
									)

									startX = startX + column.width

								end


							end,

							update = function(element, list)

								for _, c_element in pairs(element.elements or {}) do
									c_element:destroy()
								end

								element.elements = {}

								local startY = 0

								local w,h = element[4], 40
								local padding = 5

								for _, row in pairs(list) do

									element:addElement(
										{'rectangle',

											0, startY,
											w,h,
											color = {18,18,28,255},

											row = row,

											onInit = function(element)
												element.h_animId = {}
												setAnimData(element.h_animId, 0.1)
											end,

											onRender = function(element)


												local x,y,w,h = element:abs()
												local alpha = element:alpha()

												local startX = x

												for _, column in pairs( element.parent.columns ) do

													dxDrawText(column.get(element.row),
														startX, y,
														startX + column.width, y+h,
														tocolor(255,255,255,255*alpha),
														0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
														'center', 'center'
													)

													startX = startX + column.width

												end

												animate(element.h_animId, element.row == element.parent.row and 1 or 0)

												local anim = getAnimData(element.h_animId)

												local r,g,b = interpolateBetween(18,18,28, 180,70,70, anim, 'InOutQuad')

												element.color = {r,g,b, element.color[4]}

											end,

											onClick = function(element)
												element.parent.row = element.row
											end,

										}
									)

									startY = startY + h + padding

								end

							end,

							search = function(element)

								admin:call('nickLoginSearch', adminNickloginSearchInput[6], nickloginTabs.tab.tab)

							end,

							admin:addCallback('receiveNicklogin', function(list)
								adminNickloginList:update(list)
							end),

						},

					},

				},

				{'rectangle',

					'right', 0, 260, '100%',
					color = {18,18,28,255},

					variable = 'nickloginTabs',

					tabs = {
						{ name = 'Ник', tab = 'nick' },
						{ name = 'Логин', tab = 'login' },
						{ name = 'Серийник', tab = 'serial' },
						{ name = 'IP', tab = 'ip' },
					},

					actions = {

						{
							name = 'Перейти',
							action = function(row)

								currentWindowSection = 'main'
								adminSearchList:search( row.serial, { serial = true, offline = true, online = true } )

							end,
						},

						{
							name = 'Скопировать',
							action = function(row)

								setClipboard( inspect(row) )
								exports.hud_notify:notify('Успешно', 'Данные скопированы')

							end,
						},

					},

					onInit = function(element)

						local w,h = 220, 45
						local padding = 10

						local startY = 20

						for _, tab in pairs( element.tabs ) do

							element:addElement(
								{'button',

									'center', startY,
									w,h,
									tab.name,

									tab = tab,

									onRender = function(element)

										local r,g,b

										if element.tab == element.parent.tab then
											r,g,b = 180,70,70
										else
											r,g,b = 22,20,34
										end

										element.color = {r,g,b, element.color[4]}

									end,

									onClick = function(element)
										element.parent.tab = element.tab
									end,

								}
							)

							startY = startY + h + padding

						end

						element.tab = element.tabs[1]

						startY = startY + h + padding

						for _, action in pairs( element.actions ) do

							element:addElement(
								{'button',

									'center', startY,
									w,h,
									action.name,

									action = action,

									onClick = function(element)

										if adminNickloginList.row then
											element.action.action( adminNickloginList.row )
										end

									end,

								}
							)

							startY = startY + h + padding

						end


					end,

					elements = {

						{'button',

							'center', function(s,p) return p[5] - s[5] - 20 end,
							220, 45,
							'Закрыть',

							onClick = function(element)
								currentWindowSection = 'main'
							end,

						},

					},

				},


			},

		},

	},


}


------------------------------------------------------------------------------------------------------------

	GUIDefine('input', {

		scale = 0.5,
		font = getFont('montserrat_semibold', 25, 'light'),

		bg = whiteTexture,

		placeholderColor = {100,100,100,255},
		textColor = {255,255,255,255},
		color = {22,20,34,255},
		[6] = '',

	})

	GUIDefine('button', {

		scale = 0.5,
		font = getFont('montserrat_semibold', 25, 'light'),
		[6] = '',

		bg = whiteTexture,

		textColor = {255,255,255,255},

		color = {22,20,34,255},
		activeColor = {180,70,70,255},

		onRender = function(element)

			local x,y,w,h = element:abs()
			local alpha = element:alpha()

			if element.icon then

				local iw,ih = unpack(element.icon_size or {w,h})
				local ix,iy = x+w/2-iw/2, y+h/2-ih/2

				local r,g,b = interpolateBetween(100,100,100, 255,255,255, element.animData, 'InOutQuad')

				dxDrawImage(
					ix,iy,iw,ih, element.icon,
					0, 0, 0, tocolor(r,g,b,255*alpha)
				)

			end

		end,

	})

------------------------------------------------------------------------------------------------------------

loadGuiModule()

end)
