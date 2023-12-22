
cancelButtons = {
	['f2'] = true,
	['f3'] = true,
	['f4'] = true,
	['f5'] = true,
	['f7'] = true,
	['f11'] = true,
	['f10'] = true,
	['f9'] = true,
	['k'] = true,
	['t'] = true,
	['y'] = true,
	['i'] = true,
}

windowPriority = 'low-100'

hideBackground = true
clearGuiTextures = false

openHandler = function()



end

closeHandler = function()
end


addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'image',
			'center', 'center',
			796, 507,
			color = {25,24,38,255},
			'assets/images/bg.png',

			variable = 'radioWindow',

			onPreRender = function(element)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				local shw,shh = 820, 533
				local shx,shy = x+w/2-shw/2, y+h/2-shh/2 + 5

				dxDrawImage(
					shx, shy, shw, shh, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha )
				)

			end,

			elements = {

				{'element',
					0, 0, '50%', '100%',
					color = { 255,255,255,255 },

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element.parent:abs()

						drawImageSection(
							x,y,w,h, element.parent[6],
							{ x = 0.5, y = 1 }, tocolor(21,21,33,255*alpha)
						)

					end,

					variable = 'musicWindow',

					tabs = {
						{ name = 'Поиск музыки', id = 'search', },
						{ name = 'Сохраненная музыка', id = 'saved', },
						{ name = 'Радиостанции', id = 'radio', },
					},

					onInit = function(element)

						local startY = 60
						local padding = 12

						local w,h = 271, 48

						for _, tab in pairs( element.tabs ) do

							local tab_element = element:addElement(
								{'element',
									'center',startY,
									w,h,
									color = {255,255,255,255},

									onInit = function(element)
										element.t_anim = {}
										setAnimData( element.t_anim, 0.1, 0 )
									end,

									tab = tab,

									onRender = function(element)

										local alpha = element:alpha()
										local x,y,w,h = element:abs()

										local shw,shh = 295,73
										local shx,shy = x+w/2-shw/2, y+h/2-shh/2

										animate( element.t_anim, element.parent.tab == element and 1 or 0 )

										local t_animData = getAnimData( element.t_anim )

										dxDrawImage(
											x,y,w,h, 'assets/images/tbtn_empty.png',
											0, 0, 0, tocolor(180,70,70,255*alpha*(1-t_animData))
										)

										dxDrawImage(
											shx,shy,shw,shh, 'assets/images/tbtn_shadow.png',
											0, 0, 0, tocolor(180,70,70,255*alpha*t_animData)
										)

										dxDrawImage(
											x,y,w,h, 'assets/images/tbtn.png',
											0, 0, 0, tocolor(180,70,70,255*alpha*t_animData)
										)

										dxDrawText(element.tab.name,
											x + 30, y,
											x + 30, y+h,
											tocolor(255,255,255,255*alpha),
											0.5, 0.5, getFont('montserrat_medium', 21, 'light'),
											'left', 'center'
										)

										local iw,ih = 40,40
										local ix,iy = x+w-iw-15, y+h/2-ih/2

										dxDrawImage(
											ix,iy,iw,ih, ('assets/images/tab_%s.png'):format( element.tab.id ),
											0, 0, 0, tocolor(255,255,255,255*alpha)
										)

									end,

									onClick = function(element)
										element.parent.tab = element
										musicList:update()
									end,


								}
							)

							if not element.tab then
								element.tab = tab_element
							end

							startY = startY + h + padding

						end

					end,

					elements = {

						{'input',

							'center', 260,
							271, 48,
							color = {25,24,38,255},
							bg = 'assets/images/search_input.png',
							'',

							placeholderColor = { 100,100,120,255 },
							placeholder = 'Поиск музыки...',

							variable = 'searchInput',

							onInput = function(element)
								if musicWindow.tab.tab.id == 'saved' then
									musicList:update( element[6] )
								end
							end,


							alignX = 'left',
							textPadding = 15,
							scale = 0.5,
							font = getFont('montserrat_medium', 24, 'light'),

							elements = {

								{'image',

									function(s,p) return p[4] - s[4] - 10 end, 'center',
									37,37,
									color = {100,100,120,255},
									'assets/images/search.png',

									onRender = function(element)

										local r,g,b = interpolateBetween( 100,100,120, 180,70,70, element.animData, 'InOutQuad' )
										element.color = { r,g,b, element.color[4] }

									end,

									gOnPreRender = function(element)

										local x,y,w,h = element:abs()

										if handleClick and isMouseInPosition(x,y,w,h) then
											element:onClick()
											handleClick = false
										end

									end,

									last_click = getTickCount(  ),

									onClick = function(element)

										if ( getTickCount() - element.last_click ) < 1000 then return end

										element.last_click = getTickCount(  )

										triggerServerEvent('radio.doSearch', resourceRoot, searchInput[6])

									end,

									onKey = {
										enter = function(element) element:onClick() end,
										num_enter = function(element) element:onClick() end,
									},

								},

							},

						},

						{'image',
							'center', 400,
							240, 5,
							'assets/images/time.png',
							color = {14,14,24,255},

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								local sElement = getLocalSoundElement()
								local soundData = elementSounds[sElement] or {}

								local data = getLocalElementSoundData('data') or {}

								local artist = cutString(data.artist or 'None', 15, '...')
								local name = cutString(data.name or 'None', 15, '...')

								dxDrawText(artist,
									x+2, y - 25+2,
									x+2, y - 25+2,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
									'left', 'bottom'
								)

								dxDrawText(name,
									x+2, y - 25-2,
									x+2, y - 25-2,
									tocolor(180,70,70,255*alpha),
									0.5, 0.5, getFont('montserrat_medium', 22, 'light'),
									'left', 'top'
								)

								if isElement(soundData.sound) then

									local position = getSoundPosition( soundData.sound )
									local length = getSoundLength( soundData.sound )

									if (length or 0) ~= 0 then
										drawImageSection(
											x,y,w,h, element[6],
											{ y = 1, x = position/length }, tocolor(180, 70, 70, 255*alpha)
										)
									end

									if not data.stream then
										local m = math.floor( position/60 )
										local s = math.floor( position - m*60 )
										local posStr = string.format('%s:%02d', m,s)

										local m = math.floor( length/60 )
										local s = math.floor( length - m*60 )
										local lengthStr = string.format('%s:%02d', m,s)

										dxDrawText(string.format('#cd4949%s#a7a7a8 / %s', posStr, lengthStr),
											x+w, y-10,
											x+w, y-10,
											tocolor(167,167,168,255*alpha),
											0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
											'right', 'bottom', false, false, false, true
										)
									end


								end

							end,

							onInit = function(element)

								local playerActions = {
									['repeat'] = function()
										musicList.repeatCurrent = not musicList.repeatCurrent
									end,
									['next'] = playNextSound,
									['prev'] = playPreviousSound,
									['pause'] = function()
										local data = getLocalElementSoundData('data')
										if not data then return end
										return toggleTrack(data)
									end,
								}

								local playerButtons = {
									{ id = 'repeat', active = function() return musicList.repeatCurrent end },
									{ id = 'prev', active = true },
									{ id = 'pause',  icon = function()
										local data = getLocalElementSoundData('data')
										if not data then return 'play' end
										return isCurrentTrack(data, true) and 'pause' or 'play'
									end, active = true },
									{ id = 'next', active = true },
								}

								local size, padding = 25, 15

								local startX = 5
								local startY = element[5] + 20

								for _, button in pairs( playerButtons ) do

									element:addElement(
										{'button',
											startX, startY,
											size, size,
											'',
											bg = string.format('assets/images/%s.png', button.id),
											button = button,

											player = true,

											color = {100,20,20,255},
											activeColor = {255,70,70,255},

											scale = 1,
											font = 'default',

											onRender = function(element)

												element.color = {120,50,50,element.color[4]}
												if element.button.active and ( type( element.button.active ) ~= 'function' or element.button.active() ) then
													element.color = {190,70,70,element.color[4]}
												end

												if element.button.icon then
													element.bg = string.format('assets/images/%s.png',
														element.button.icon()
													)
												end

											end,

											onClick = playerActions[button.id],

										}
									)

									startX = startX + size + padding

								end

								element:addElement(
									{'slider',
										startX, startY + size/2 - 5/2,
										58,5,

										player = true,

										bg = 'assets/images/volume_slider.png',

										slider = 'assets/images/volume_round.png',
										sliderSize = 12,

										data = element,
										section = name,

										onSlide = function(element, value)
											setLocalSoundData('volume', value, false)
										end,

										onInit = function(element)
											soundSlider = element
										end,

										range = {0, 100},
										value = 50,

										onRender = function(element)

											local alpha = element:alpha()
											local x,y,w,h = element:abs()
											
											--[[dxDrawImage(
												x + w + 4, y + h/2 - 20/2,
												20, 20,
												'assets/images/volume.png', 0, 0, 0, 
												tocolor(190, 70, 70, 255*alpha)
											)]]

										end,

										padding = 2,
										color = {37,42,74,255},
										activeColor = {190,70,70,255},
										sliderColor = {190,70,70,255},

									}
								)


							end,

						},

					},


				},

				{'element',
					function(s,p) return p[4]/2 end, 'center',
					'50%', function(s,p) return p[5] - 50 end,
					color = {255,255,255,255},

					overflow = 'vertical',
					variable = 'musicList',

					scrollWidth = 3,
					scrollBgColor = {14,14,24,255},
					scrollXOffset = -15,

					elements = {},

					clear = function(element)

						for _, c_element in pairs( element.elements or {} ) do
							c_element:destroy()
						end

						element.elements = {}

					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						if #element.elements == 0 then
							dxDrawText('В плейлисте пока нет музыки...',
								x,y,x+w,y+h,
								tocolor(100,100,120,255*alpha),
								0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
								'center', 'center'
							)
						end

					end,

					update = function(element, filter)

						filter = filter or ''

						local prevCount = #element.elements

						local lists = {
							search = currentMusicSearchResult,
							saved = localPlayer:getData('radio.saved') or {},
							radio = Config.radio,
						}

						element:clear()

						local tbl = table.copy( lists[musicWindow.tab.tab.id] or {} )

						local startY = 0
						local h = 65
						local padding = 5

						for _, m_element in pairs( tbl ) do

							if utf8.find(m_element.artist or '', filter) or utf8.find(m_element.name or '', filter) then

								m_element.section = musicWindow.tab.tab.id

								element:addElement(
									{'rectangle',
										'center', startY,
										'100%', h,
										color = {18,18,28,255},

										data = m_element,

										onRender = function(element)

											local x,y,w,h = element:abs()
											local alpha = element:alpha()

											local r,g,b = interpolateBetween( 18,18,28, 21,21,33, element.animData, 'InOutQuad' )
											element.color = {r,g,b, element.color[4]}

											dxDrawText(cutString(element.data.name or '', 15, '...'),
												x + 20, y+h/2+1,
												x + 20, y+h/2+1,
												tocolor(255,255,255,255*alpha),
												0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
												'left', 'bottom'
											)

											dxDrawText(cutString(element.data.artist or '', 15, '...'),
												x + 20, y+h/2-1,
												x + 20, y+h/2-1,
												tocolor(180,70,70,255*alpha),
												0.5, 0.5, getFont('montserrat_medium', 25, 'light'),
												'left', 'top'
											)

										end,

										elements = {

											{'element',
												function(s,p) return p[4] - s[4] - 30 end, 'center',
												30, 30,
												color = {255,255,255,255},

												onRender = function(element)

													local alpha = element:alpha()
													local x,y,w,h = element:abs()

													local saved = localPlayer:getData('radio.saved') or {}

													dxDrawImage(
														x,y,w,h, ('assets/images/%s.png'):format(
															saved[ element.parent.data.path ] and 'remove' or 'add'
														),
														0, 0, 0, saved[ element.parent.data.path ]
															and tocolor(230,90,90,255*alpha) or tocolor(90,230,90,255*alpha)
													)

												end,

												onClick = function(element)

													local saved = localPlayer:getData('radio.saved') or {}

													if saved[ element.parent.data.path ] then
														triggerServerEvent('radio.removeItem', resourceRoot, element.parent.data.path)
													else
														triggerServerEvent('radio.saveItem', resourceRoot, element.parent.data)
													end

												end,

												noDraw = function(element)
													return element.parent.data.stream
												end,

											},

											{'element',
												function(s,p) return p[4] - s[4] - 65 end, 'center',
												17, 17,
												color = {255,255,255,255},

												onRender = function(element)

													local alpha = element:alpha()
													local x,y,w,h = element:abs()

													local saved = localPlayer:getData('radio.saved') or {}

													dxDrawImage(
														x,y,w,h, ('assets/images/%s.png'):format(
															isCurrentTrack(element.parent.data, true) and 'pause' or 'play'
														),
														0, 0, 0, tocolor(180,70,70,255*alpha)
													)

													element[2] = element.parent.data.stream and (
														element.parent[4] - element[4] - 30
													) or (
														element.parent[4] - element[4] - 65
													)

												end,

												onClick = function(element)
													toggleTrack(element.parent.data)
												end,

											},

										},

									}
								)

								startY = startY + h + padding

							end


						end

						setAnimData(element.ov_animId, 0.1, 0)


					end,

					addEvent('radio.doSearch_callback', true),
					addEventHandler('radio.doSearch_callback', root, function(result)

						currentMusicSearchResult = result
						setClipboard( inspect(currentMusicSearchResult) )
						musicList:update()

					end),

					addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)
						if dn == 'radio.saved' and musicWindow.tab.tab.id == 'saved' then
							musicList:update()
						end
					end),

				},

			},

		},



	},

}


loadGuiModule()


end)

