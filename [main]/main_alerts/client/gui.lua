
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
			398, 481,

			'assets/images/bg.png',
			color = {25,24,38, 255},

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 416/2,
					y + h/2 - 499/2 + 5,
					416, 499, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
				)

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				drawImageSection(
					x,y,w,h, element[6],
					{ x = 1, y = 92/h }, tocolor(18,18,28,255*alpha)
				)

				local aw,ah = 38,38
				local ax,ay = x + 30, y+92/2-ah/2

				local texture = getDrawingTexture( 'assets/images/notify_icon_bg.png' )

				local gradient = getTextureGradient(texture, {

					alpha = alpha,
					color = {
						{ 180, 70, 70, 255 },
						{ 86, 56, 79, 255 },
					},
					angle = 45,

				})

				dxDrawImage(
					ax,ay,aw,ah, gradient
				)

				dxDrawImage(
					ax,ay,aw,ah, 'assets/images/notify_icon.png',
					0, 0, 0, tocolor(0,0,0,100*alpha)
				)

				local alerts = localPlayer:getData('alerts') or {}
				local count = getTableLength(alerts)

				if count > 0 then

					local cw,ch = 32,32
					local cx,cy = ax+aw-cw/2-5, ay+ah-ch/2-5

					dxDrawImage(
						cx,cy,cw,ch, 'assets/images/count.png',
						0, 0, 0, tocolor(180,70,70,255*alpha)
					)

					dxDrawText(count,
						cx,cy,cx+cw,cy+ch,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_medium', 24, 'light'),
						'center', 'center'
					)

				end

				dxDrawText('Уведомления',
					ax + aw + 15, ay,
					ax + aw + 15, ay+ah,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
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

						element[2] = element.parent[4] - element[4] - 30
						element[3] = 92/2-element[5]/2

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

				{'button',

					'center', function( s,p ) return p[5] - s[5] - 35 end,
					215, 46,

					bg = 'assets/images/button_empty.png',
					activeBg = 'assets/images/button.png',

					'Очистить все',

					scale = 0.5,
					font = getFont('montserrat_medium', 23, 'light'),

					color = {180, 70, 70, 255},
					activeColor = {200, 70, 70, 255},

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local shx,shy,shw,shh = x + w/2 - 233/2, y + h/2 - 64/2, 233, 64
						
						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/button_empty_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
						)

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/button_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
						)

					end,

					onClick = function(element)

						triggerServerEvent('alert.removeAll', resourceRoot)

					end,

					noDraw = function(element)

						return getTableLength( localPlayer:getData('alerts') or {} ) <= 0

					end,


				},

				{'element',

					0, 100,
					'100%', 280,
					color = {255,255,255,255},

					variable = 'alertsList',
					overflow = 'vertical',

					scrollXOffset = 10,

					update = function(element)


						for _, c_element in pairs( element.elements or {} ) do
							c_element:destroy()
						end

						element.elements = {}

						local alerts = localPlayer:getData('alerts') or {}

						local startY = 0

						local aw,ah = element[4], 80
						local padding = 5

						for id, alert in pairs( alerts ) do

							element:addElement(
								{'rectangle',
									0, startY,
									aw,ah,
									color = {18,18,20,255},

									alert = alert,
									id = id,

									onRender = function(element)

										local x,y,w,h = element:abs()
										local alpha = element:alpha()

										local iconPath = string.format('assets/images/icons/%s.png', element.alert.type)
										iconPath = fileExists(iconPath) and iconPath or 'assets/images/icons/info.png'

										local iw,ih = 45,45

										dxDrawImage(
											x + 20, y+h/2-ih/2,
											iw,ih, iconPath,
											0, 0, 0, tocolor(255,255,255,255*alpha)
										)

										local title_scale, title_font = 0.5, getFont('montserrat_semibold', 24, 'light')
										local text_scale, text_font = 0.5, getFont('montserrat_semibold', 22, 'light')

										local totalHeight = dxGetFontHeight( title_scale, title_font ) +
											dxGetFontHeight( text_scale, text_font ) * #splitString(element.alert.text, '\n')

										dxDrawText(element.alert.title,
											x + 20 + iw + 10, y + h/2 - totalHeight/2,
											x + 20 + iw + 10, y + h/2 - totalHeight/2,
											tocolor(255,255,255,255*alpha),
											title_scale, title_scale, title_font,
											'left', 'top', false, false, false, true
										)

										dxDrawText(element.alert.text,
											x + 20 + iw + 10, y + h/2 + totalHeight/2,
											x + 20 + iw + 10, y + h/2 + totalHeight/2,
											tocolor(60,60,85,255*alpha),
											text_scale, text_scale, text_font,
											'left', 'bottom', false, false, false, true
										)

									end,

									elements = {

										{'button',

											function( s,p ) return p[4] - s[4] - 8 end,
											8,
											15, 15,
											bg = 'assets/images/close.png',
											define_from = '',

											'',

											color = {100, 100, 100, 255},
											activeColor = {255, 255, 255, 255},

											onRender = function(element)

												local alpha = element:alpha()
												local x,y,w,h = element:abs()

												dxDrawImage(
													x,y,w,h, 'assets/images/close_icon.png',
													0, 0, 0, tocolor(255,255,255,255*alpha)
												)

											end,

											onClick = function(element)
												triggerServerEvent('alert.remove', resourceRoot, element.parent.id)
											end,

										},

									},



								}
							)

							startY = startY + ah + padding

						end

					end,

					onInit = function(element)
						alertsList:update()
					end,

					addEventHandler('onClientElementDataChange', localPlayer, function(dn)

						if dn == 'alerts' then
							alertsList:update()
						end

					end),

				},

			},

		},

	},

}

loadGuiModule()


end)

