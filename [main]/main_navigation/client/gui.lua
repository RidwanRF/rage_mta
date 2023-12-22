


openHandler = function()
	showChat(false)
end
closeHandler = function()
	showChat(true)
end

hideBackground = true

addEventHandler('onClientResourceStart', resourceRoot, function()


windowModel = {
	
	main = {

		{'image',

			'center', 'center',
			669, 501,
			color = {24,30,66,255},
			'assets/images/bg.png',

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 687/2,
					y + h/2 - 519/2 + 5,
					687, 519, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
				)

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				drawImageSection(
					x,y,w,h, element[6],
					{ y = 1, x = 240/w }, tocolor(30,35,70,255*alpha)
				)
				drawImageSection(
					x,y,w,h, element[6],
					{ y = 93/h, x = 1 }, tocolor(35,40,74,255*alpha)
				)

			end,

			openTab = function(element, tab)
				element.tab = tab
			end,

			onKey = {

				tab = function(element)
					element.tab = element.tabs[ cycle( element.tabs[element.tab].index + 1, 1, #element.tabs ) ].tab
				end,

			},

			onInit = {

				function(element)

					element.tabs = {
						{ tab = 'updates', name = 'Обновления' },
						{ tab = 'gps', name = 'GPS Навигатор' },
						{ tab = 'info', name = 'Информация' },
					}

					local scale, font = 0.5, getFont('montserrat_semibold', 26, 'light')

					local startX = 40
					local h = dxGetFontHeight(scale, font)
					local padding = 30

					for index, tab in ipairs( element.tabs ) do

						element.tabs[tab.tab] = tab

						if not element.tab then
							element.tab = tab.tab
						end

						tab.index = index

						local textWidth = dxGetTextWidth( tab.name, scale, font )

						element:addElement(
							{'button',

								startX, 93/2-h/2,
								textWidth, h,
								color = {255,255,255,255},

								tab.name,

								scale = scale,
								font = font,

								tab = tab.tab,
								index = index,

								onInit = function(element)
									element.parent.hl_animId = {}
									setAnimData(element.parent.hl_animId, 0.1)
								end,

								onRender = function(element)

									local alpha = element:alpha()
									local x,y,w,h = element:abs()

									if element.parent.tab == element.tab then

										animate(element.parent.hl_animId, element[2])

									end

									animate(element.parent.tabs[element.tab].anim, element.parent.tab == element.tab and 1 or 0)

									local lx = getAnimData(element.parent.hl_animId)
									lx = lx + element.parent:abs()

									if index == 1 then
										dxDrawImage(
											lx-5, y+h-3,
											39, 17,
											'assets/images/hline.png',
											0, 0, 0, tocolor(180, 70, 70, 255*alpha)
										)
									end


								end,

								onClick = function(element)
									element.parent.tab = element.tab
								end,

							}
						)

						startX = startX + textWidth + padding

					end

				end,

				updates = function(element)

					element.tabs.updates.anim = {}
					setAnimData(element.tabs.updates.anim, 0.1)

					element:addElement(
						{'list',

							0, 93+10,
							240, element[5]-93-20,

							scrollBg = scrollTexture,
							scrollColor = {180, 70, 70,255},
							scrollBgColor = {35, 40, 70,255},
							scrollWidth = 5,

							scrollXOffset = -10,

							listOffset = 0,

							variable = 'updatesVersionsList',

							listElements = table.reverse(Config.versions),

							font = getFont('montserrat_semibold', 26, 'light'),
							scale = 0.5,

							listElementHeight = 45,

							color = {255,255,255,255},

							additionalElementDrawing = function(lElement, x,y,w,ey, element, animData, index, hovered)

								local alpha = element:alpha()
								local ex,ey,ew,eh = element:abs()

								local x,y,w,h = x+element[4]/2-200/2,y+element.listElementHeight/2-32/2, 200, 32

								local r,g,b = interpolateBetween( 35,40,74, 180, 70, 70, animData, 'InOutQuad' )

								dxDrawImage(
									x,y,w,h, 'assets/images/list_button.png',
									0, 0, 0, tocolor(r,g,b,255*alpha)
								)
								dxDrawImage(
									x+w/2-222/2,y+h/2-56/2,222, 56, 'assets/images/list_button_shadow.png',
									0, 0, 0, tocolor(r,g,b,255*alpha*animData)
								)

								dxDrawText(lElement.released,
									x, y,
									x+w, y+h,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
									'center', 'center'
								)

							end,

							onListElementClick = function(element, listElement)

								gui_get('update_info'):loadInfo(listElement)

							end,

							animationAlpha = element.tabs.updates.anim,

						}

					)

					element:addElement(
						{'element',

							240+20, 93+20,
							element[4]-240-40, element[5]-93-40,

							overflow = 'vertical',
							scroll_step = 30,
							id = 'update_info',

							scrollBg = scrollTexture,
							scrollColor = {180, 70, 70,255},
							scrollBgColor = {35, 40, 70,255},
							scrollWidth = 5,

							scrollXOffset = -10,

							font = getFont('montserrat_semibold', 26, 'light'),
							scale = 0.5,

							loadInfo = function(element, info)

								for _, c_element in pairs(element.elements or {}) do
									c_element:destroy()
								end

								setAnimData(element.ov_animId, 0.1, 0)

								local scale, font = 0.5, getFont('montserrat_semibold', 25, 'light')
								local startY = 0

								local padding = 5

								for _, row in pairs( info.rows or {} ) do

									local w,h

									if row.image then

										local texture = getDrawingTexture(row.image)
										w, h = dxGetMaterialSize(texture)
										row.size = {w,h}

									elseif row.text then
										h = dxGetFontHeight(scale, font)
									end

									element:addElement(
										{'element',

											0, startY,
											'100%', h,
											color = {255,255,255,255},

											scale = scale,
											font = font,

											onRender = function(element)

												local alpha = element:alpha()
												local x,y,w,h = element:abs()

												if element.data.text then
													for i = 1,2 do
														drawSmartText(element.data.text,
															x, x, y+h/2, 
															tocolor(255,255,255,255*alpha),
															tocolor(255,255,255,255*alpha),
															element.scale,
															element.font,
															'left', 20, 0
														)

													end
												elseif element.data.image then

													dxDrawImage(
														x,y,
														element.data.size[1], element.data.size[2], 
														element.data.image,
														0, 0, 0, tocolor(255,255,255,255*alpha)
													)

												end

											end,

											data = row,

										}
									)

									startY = startY + h + padding

								end

							end,

							color = {255,255,255,255},
							animationAlpha = element.tabs.updates.anim,
							

						}

					)

				end,

				info = function(element)

					element.tabs.info.anim = {}
					setAnimData(element.tabs.info.anim, 0.1)

					element:addElement(
						{'list',

							0, 93+10,
							240, element[5]-93-20,

							scrollBg = scrollTexture,
							scrollColor = {180, 70, 70,255},
							scrollBgColor = {35, 40, 70,255},
							scrollWidth = 5,

							scrollXOffset = -20,

							listOffset = 0,

							listElements = Config.info,

							font = getFont('montserrat_semibold', 26, 'light'),
							scale = 0.5,

							listElementHeight = 45,

							color = {255,255,255,255},

							additionalElementDrawing = function(lElement, x,y,w,ey, element, animData, index, hovered)

								local alpha = element:alpha()
								local ex,ey,ew,eh = element:abs()

								local x,y,w,h = x+element[4]/2-200/2,y+element.listElementHeight/2-32/2, 200, 32

								local r,g,b = interpolateBetween( 35,40,74, 180, 70, 70, animData, 'InOutQuad' )

								dxDrawImage(
									x,y,w,h, 'assets/images/list_button.png',
									0, 0, 0, tocolor(r,g,b,255*alpha)
								)
								dxDrawImage(
									x+w/2-222/2,y+h/2-56/2,222, 56, 'assets/images/list_button_shadow.png',
									0, 0, 0, tocolor(r,g,b,255*alpha*animData)
								)

								dxDrawText(lElement.section,
									x, y,
									x+w, y+h,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
									'center', 'center'
								)

							end,

							onListElementClick = function(element, listElement)

								gui_get('info_info'):loadInfo(listElement)

							end,

							animationAlpha = element.tabs.info.anim,

						}

					)

					element:addElement(
						{'element',

							240+20, 93+20,
							element[4]-240-40, element[5]-93-40,

							overflow = 'vertical',
							scroll_step = 30,
							id = 'info_info',

							scrollBg = scrollTexture,
							scrollColor = {180, 70, 70,255},
							scrollBgColor = {35, 40, 70,255},
							scrollWidth = 5,

							scrollXOffset = -20,

							font = getFont('montserrat_semibold', 26, 'light'),
							scale = 0.5,

							loadInfo = function(element, info)

								for _, c_element in pairs(element.elements or {}) do
									c_element:destroy()
								end

								setAnimData(element.ov_animId, 0.1, 0)

								local scale, font = 0.5, getFont('montserrat_semibold', 25, 'light')
								local startY = 0

								local padding = 0

								for _, row in pairs( info.rows or {} ) do

									local w,h

									if row.image then

										local texture = getDrawingTexture(row.image)
										w, h = dxGetMaterialSize(texture)
										row.size = {w,h}

									elseif row.text then
										h = dxGetFontHeight(scale, font)
									end

									element:addElement(
										{'element',

											0, startY,
											'100%', h,
											color = {255,255,255,255},

											scale = scale,
											font = font,

											onRender = function(element)

												local alpha = element:alpha()
												local x,y,w,h = element:abs()

												if element.data.text then
													for i = 1,2 do
														drawSmartText(element.data.text,
															x, x, y+h/2, 
															tocolor(255,255,255,255*alpha),
															tocolor(255,255,255,255*alpha),
															element.scale,
															element.font,
															'left', 20, 0
														)

													end
												elseif element.data.image then

													dxDrawImage(
														x,y,
														element.data.size[1], element.data.size[2], 
														element.data.image,
														0, 0, 0, tocolor(255,255,255,255*alpha)
													)

												end

											end,

											data = row,

										}
									)

									startY = startY + h + padding

								end

							end,

							color = {255,255,255,255},
							animationAlpha = element.tabs.info.anim,
							

						}

					)

				end,

				gps = function(element)

					element.tabs.gps.anim = {}
					setAnimData(element.tabs.gps.anim, 0.1)

					element:addElement(
						{'list',

							0, 93+10,
							240, element[5]-93-20,

							scrollBg = scrollTexture,
							scrollColor = {180, 70, 70,255},
							scrollBgColor = {35, 40, 70,255},
							scrollWidth = 5,

							scrollXOffset = -20,

							listOffset = 0,

							listElements = Config.gps,

							font = getFont('montserrat_semibold', 26, 'light'),
							scale = 0.5,

							listElementHeight = 45,

							color = {255,255,255,255},

							additionalElementDrawing = function(lElement, x,y,w,ey, element, animData, index, hovered)

								local alpha = element:alpha()
								local ex,ey,ew,eh = element:abs()

								local x,y,w,h = x+element[4]/2-200/2,y+element.listElementHeight/2-32/2, 200, 32

								local r,g,b = interpolateBetween( 35,40,74, 180, 70, 70, animData, 'InOutQuad' )

								dxDrawImage(
									x,y,w,h, 'assets/images/list_button.png',
									0, 0, 0, tocolor(r,g,b,255*alpha)
								)
								dxDrawImage(
									x+w/2-222/2,y+h/2-56/2,222, 56, 'assets/images/list_button_shadow.png',
									0, 0, 0, tocolor(r,g,b,255*alpha*animData)
								)

								dxDrawText(lElement.name,
									x, y,
									x+w, y+h,
									tocolor(255,255,255,255*alpha),
									0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
									'center', 'center'
								)

							end,

							onListElementClick = function(element, listElement)

								gui_get('gps_list'):loadList(listElement)

							end,

							animationAlpha = element.tabs.gps.anim,

						}

					)

					element:addElement(
						{'element',

							240+20, 93+20,
							element[4]-240-40, element[5]-93-40,

							overflow = 'vertical',
							scroll_step = 50,
							id = 'gps_list',

							scrollBg = scrollTexture,
							scrollColor = {180, 70, 70,255},
							scrollBgColor = {35, 40, 70,255},
							scrollWidth = 5,

							scrollXOffset = -10,

							font = getFont('montserrat_semibold', 26, 'light'),
							scale = 0.5,

							loadList = function(element, list)

								for _, c_element in pairs(element.elements or {}) do
									c_element:destroy()
								end

								setAnimData(element.ov_animId, 0.1, 0)

								local scale, font = 0.5, getFont('montserrat_semibold', 25, 'light')
								local startY = 0

								local padding = 10
								local w,h = 349, 118

								for _, item in pairs( list.items or {} ) do

									element:addElement(
										{'image',

											'center', startY,
											w,h,
											color = {30, 35, 70,255},
											'assets/images/gps_bg.png',

											data = item,

											onRender = function(element)

												local alpha = element:alpha()
												local x,y,w,h = element:abs()

												for i = 1,2 do
													dxDrawText(element.data.name,
														x+20,y+20,
														x+20,y+20,
														tocolor(255,255,255,255*alpha),
														0.5, 0.5, getFont('montserrat_semibold', 27, 'light')
													)
													dxDrawText(element.data.title,
														x+20,y+40,
														x+20,y+40,
														tocolor(255,255,255,255*alpha),
														0.5, 0.5, getFont('montserrat_semibold', 22, 'light')
													)
												end


											end,

											onInit = function(element)

												element:addElement(
													{'button',

														element[4]-160-20, element[5]-27-20,
														160, 27,

														bg = 'assets/images/list_button.png',
														element.data.buttonText,

														scale = 0.5,
														font = getFont('montserrat_semibold', 22, 'light'),

														color = {180, 70, 70, 255},
														activeColor = {200, 70, 70, 255},

														onRender = function(element)

															element[6] = GPSPoints[element.parent.data.id] and 'Убрать метку' or element.parent.data.buttonText

														end,

														onClick = function(element)

															if GPSPoints[element.parent.data.id] then
																removeGPSPoint(element.parent.data.id)
															else
																createGPSPoint(
																	element.parent.data.id,
																	element.parent.data:getBlipCoords(),
																	element.parent.data.name
																)
															end

														end,


													}
												)

											end,

										}
									)

									startY = startY + h + padding

								end

							end,

							color = {255,255,255,255},
							animationAlpha = element.tabs.gps.anim,
							

						}

					)

				end,


			},

			elements = {
			
				{'button',

					0, 0, 35, 35,
					bg = 'assets/images/close.png',
					activeBg = 'assets/images/close_active.png',
					define_from = '',

					'',

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					onInit = function(element)

						element[2] = element.parent[4] - element[4] - 30
						element[3] = 93/2 - element[5]/2

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


			},

		},

	},

	last_update = {

		{'element',
			0, 0, sx, real_sy * sx/real_sx,
			color = {255,255,255,255},

			anim_fix = true,

			variable = 'lastUpdatesElement',

			updateActiveState = function(element)

				if isTimer( element.anim_timer ) then
					killTimer( element.anim_timer )
				end

				animate( element.cursor_anim, 1 )

				element.anim_timer = setTimer(function()

					animate( element.cursor_anim, 0 )

				end, 3000, 1)

			end,

			addEventHandler('onClientCursorMove', root, function()
				lastUpdatesElement:updateActiveState()
			end),

			onKey = {

				mouse_wheel_down = function(element)
					element:scroll(1)
				end,

				mouse_wheel_up = function(element)
					element:scroll(-1)
				end,

			},

			images = {},

			onRender = function(element)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				local animData, target = getAnimData( element.image_anim )

				local startX = x - w*(animData-1)

				for index, image in pairs( element.images or {} ) do

					if isBetween( startX, -w, x+w ) then

						dxDrawImage(
							startX, y,
							w,h, image,
							0, 0, 0, tocolor( 255,255,255,255*alpha )
						)

					end

					startX = startX + w

				end


			end,

			onKey = {

				space = function()
					closeWindow()
				end,

			},

			onInit = function(element)

				openHandlers.images = function()

					if currentWindowSection == 'last_update' then

						lastUpdatesElement.images = {
							'assets/images/lu/banners/1.png',
						}

						windowPriority = 'low-100'

					else

						windowPriority = 'low-2'

					end

				end

				closeHandlers.images = function()

					if currentWindowSection == 'last_update' then
						clearTableElements( lastUpdatesElement.images )
						lastUpdatesElement.images = {}
					end

				end

				element.cursor_anim = {}
				setAnimData( element.cursor_anim, 0.1 )

				element.image_anim = {}
				setAnimData( element.image_anim, 0.06, 1 )

				-- element.lines = element:addElement(
				-- 	{'element',
					
				-- 		'center', function(s,p) return p[5] - s[5] - 70 end,
				-- 		'100%', 10,
				-- 		color = {255,255,255,255},

				-- 		onRender = function(element)

				-- 			local x,y,w,h = element:abs()
				-- 			local alpha = element:alpha()

				-- 			local lw,lh = 96, 10
				-- 			local padding = 5

				-- 			local count = #element.parent.images
				-- 			local _, current = getAnimData( element.parent.image_anim )

				-- 			local sCount = count/2

				-- 			local startX = x + 160

				-- 			for index = 1, count do

				-- 				local r,g,b = 25,24,38

				-- 				if index <= current then
				-- 					r,g,b = 200,80,80
				-- 				end

				-- 				dxDrawImage(
				-- 					startX, y,
				-- 					lw,lh, 'assets/images/lu/line.png',
				-- 					0, 0, 0, tocolor(r,g,b,255*alpha)
				-- 				)

				-- 				startX = startX + lw + padding

				-- 			end

				-- 		end,


				-- 	}
				-- )

			end,

			onPostInit = function(element)

				for _, c_element in pairs( element.elements or {} ) do
					c_element.animationAlpha = element.cursor_anim
				end

			end,

			last_scroll = getTickCount(  ),

			scroll = function( element, side )

				if ( getTickCount() - element.last_scroll ) < 200 then return end
				element.last_scroll = getTickCount(  )

				local _, target = getAnimData( element.image_anim )
				animate( element.image_anim, math.clamp( target + side, 1, #element.images ) )

				lastUpdatesElement:updateActiveState()

			end,

			elements = {

				-- {'next-arrow',
				-- 	40,

				-- 	onClick = function(element)
				-- 		element.parent:scroll(-1)
				-- 	end,

				-- },

				-- {'next-arrow',
				-- 	function(s,p) return p[4] - s[4] - 40 end,

				-- 	onClick = function(element)
				-- 		element.parent:scroll(1)
				-- 	end,

				-- 	rotation = 180,

				-- },

				{'button',
					function(s,p) return p[4] - s[4] - 40 end, 40,
					50, 50, 
					'',
					bg = 'assets/images/lu/close.png',
					color = {180,70,70,255},
					activeColor = {230,90,90,255},

					onClick = function()
						closeWindow()
					end,

				},


			},

		},

	},

}

----------------------------------------------------------------

	GUIDefine('next-arrow', {

		[3]='center',
		[4]=111,[5]=211,
		color = {255,255,255,255},

		onRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			dxDrawImage(
				x,y,w,h, 'assets/images/lu/next.png',
				element.rotation or 0, 0, 0, tocolor(255,255,255,255*alpha*(1-element.animData))
			)

			local aw,ah = 121,221
			local ax,ay = x+w/2-aw/2, y+h/2-ah/2

			dxDrawImage(
				ax,ay,aw,ah, 'assets/images/lu/next_a.png',
				element.rotation or 0, 0, 0, tocolor(255,255,255,255*alpha*(element.animData))
			)

		end,

	})

----------------------------------------------------------------

loadGuiModule()

end)
