
cancelButtons = {
	['f1'] = true,
	['f2'] = true,
	['f3'] = true,
	['f4'] = true,
	['f5'] = true,
	['f7'] = true,
	['f11'] = true,
	['f10'] = true,
	['k'] = true,
	['m'] = true,
	['t'] = true,
	['i'] = true,
	['y'] = true,
}

openHandler = function()
	showChat( false )
end
closeHandler = function()
	showChat( true )
end

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'image',
			'center', 'center',
			1026, 694,
			color = {25,24,38,255},
			'assets/images/bg.png',

			onPreRender = function(element)

				local x,y,w,h = element:abs()
				local alpha = element:alpha()

				local shw,shh = 1052, 720
				local shx,shy = x+w/2-shw/2, y+h/2-shh/2 + 5

				dxDrawImage(
					shx, shy, shw, shh, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha )
				)

			end,

			variable = 'messagesWindow',
			settings = {},

			onInit = function(element)

				openHandlers.settings = function()

					for setting, element in pairs( messagesWindow.settings ) do

						element.checked = localPlayer:getData( setting )

					end

				end

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + 40, y + 30,
					70, 70, 'assets/images/logo.png',
					0, 0, 0, tocolor(255,255,255,255*alpha)
				)

				dxDrawText('RageMessenger',
					x + 40 + 70, y + 30,
					x + 40 + 70, y + 30 + 70,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
					'left', 'center'
				)

			end,

			elements = {


				{'checkbox',

					45, 110,
					42, 21,

					color = {21,21,33,255},
					fgColor = {46,43,64,255},
					activeColor = {180,70,70,255},

					bg = 'assets/images/cb_bg.png',
					fg = 'assets/images/cb_fg.png',
					size = 38,

					text = 'Выкл. ЛС',
					setting = 'messages.disabled',

					padding = 2,

				},

				{'checkbox',

					180, 110,
					42, 21,

					color = {21,21,33,255},
					fgColor = {46,43,64,255},
					activeColor = {180,70,70,255},

					bg = 'assets/images/cb_bg.png',
					fg = 'assets/images/cb_fg.png',
					size = 38,

					text = 'Выкл. уведомления',
					setting = 'messages.disable_notify',

					padding = 3,

				},


				{'image',
					function(s,p) return p[4] - s[4] - 28 end, 'center', 
					589, 617,
					color = {21,21,33,255},
					'assets/images/bg1.png',

					elements = {

						{'input',
							'center', function(s,p) return p[5] - s[5] - 30 end,
							456, 50,
							color = {25,24,38,255},
							placeholderColor = {100,100,100,255},
							placeholder = 'Ваше сообщение...',
							'',
							bg = 'assets/images/msg_input.png',

							alignX = 'left',
							textPadding = 15,

							maxSymbols = 100,
							textAreaWidth = 300,

							variable = 'messageInput',

							possibleSymbols = '1234567890-_=+ёйцукенгшщхъзфывапролджячсмитьбю!№;%:?*()qwertyuiopasdfghjklzxcvbnm,./э ',

							scale = 0.5,
							font = getFont('montserrat_medium', 25, 'light'),

							elements = {

								{'button',
									function(s,p) return p[4] - s[4] - 15 end, 'center',
									107, 33,
									'Отправить',
									bg = 'assets/images/btn.png',

									color = {180,70,70,255},

									scale = 0.5,
									font = getFont('montserrat_semibold', 20, 'light'),

									onPreRender = function(element)

										local x,y,w,h = element:abs()
										local alpha = element:alpha()

										local shw, shh = 128, 56
										local shx, shy = x+w/2-shw/2, y+h/2-shh/2

										dxDrawImage(
											shx, shy, shw, shh, 'assets/images/btn_shadow.png',
											0, 0, 0, tocolor(180,70,70,( 100 + 155*element.animData ) *alpha )
										)

									end,

									gOnPreRender = function(element)

										local x,y,w,h = element:abs()

										if handleClick and isMouseInPosition(x,y,w,h) then

											element:onClick()
											handleClick = false

										end

									end,

									onClick = function(element)

										if playersList.selected and utf8.len( messageInput[6] ) > 0 then

											triggerServerEvent('messages.send', resourceRoot,
												playersList.selected.player, messageInput[6]
											)

										end
										
										messageInput[6] = ''

									end,

									onKey = {
										enter = function(element) element:onClick() end,
										num_enter = function(element) element:onClick() end,
									},

								},

							},

						},

						{'element',

							'center', 30,
							500, function(s,p) return p[5] - 130 end,
							color = {255,255,255,255},

							overflow = 'vertical',
							scrollXOffset = 10,
							scrollWidth = 3,
							scrollBgColor = {25,24,38,255},

							variable = 'messagesList',
							elements = {},

							load = function( element, player )

								element:clear()

								local p_element = playersList:getPlayerElement( player )

								for _, message in pairs( p_element.messages or {} ) do
									element:appendMessage( message )
								end

								element:update_endY()

							end,

							onPostRender = function(element)

								if element.update_scroll then
									setAnimData( element.ov_animId, 0.1, -(element.ov_endY - element[5]) )
									element.update_scroll = false
								end

							end,

							appendMessage = function(element, message)

								local maxSymbols = 35
								local font = getFont('montserrat_semibold', 24, 'light')

								local message_splitted = splitStringWithCount( message.message, maxSymbols )

								message.message_splitted = table.concat( message_splitted, '-\n' )

								local h = 55

								if #message_splitted > 1 then
									h = h + dxGetFontHeight( 0.5, font ) * ( #message_splitted - 1 )
								end

								local y = 0

								local last_element = element.elements[ #element.elements ]

								if last_element then
									y = last_element[3] + last_element[5]
								end

								local n_element element:addElement(
									{'element',

										'center', y,
										'100%', h,

										color = {255,255,255,255},

										onRender = function(element)

											local alpha = element:alpha()
											local x,y,w,h = element:abs()

											if not isElement(element.message.sender) then
												return
											end

											local sender_text = element.message.sender.name

											if element.message.sender == localPlayer then
												sender_text = '#cd4949' .. sender_text
											end

											if element.message.timestamp then

												local time = getRealTime( element.message.timestamp )
												sender_text = sender_text .. '  #46465a' .. ('%02d:%02d'):format( time.hour, time.minute )

											end

											dxDrawText(sender_text,
												x+25, y+5, x, y+5, 
												tocolor(255,255,255,255*alpha),
												0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
												'left', 'top', false, false, false, true
											)

											dxDrawText(element.message.message_splitted or element.message.message,
												x+25, y + 25,
												x+25, y + 25,
												tocolor(255,255,255,255*alpha),
												0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
												'left', 'top'
											)

										end,

										onPreRender = function(element)

											if element.hovered then

												local alpha = element:alpha()
												local x,y,w,h = element:abs()

												dxDrawRectangle(
													x,y,w,h, tocolor(25,24,38,255*alpha)
												)

											end


										end,

										message = message,

									}
								)

								element.update_scroll = true

								return n_element

							end,

							clear = function(element)

								for _, c_element in pairs( element.elements or {} ) do
									c_element:destroy()
								end

								element.elements = {}

							end,

						},

					},

				},

				{'image',
					30, function(s,p) return p[5] - s[5] - 38 end, 
					365, 513,
					color = {21,21,33,255},
					'assets/images/bg2.png',

					elements = {

						{'input',
							'center', 20,
							321, 40,
							color = {25,24,38,255},
							placeholderColor = {100,100,100,255},
							placeholder = 'Поиск игрока...',
							'',
							bg = 'assets/images/search_input.png',

							variable = 'playersSearch',

							possibleSymbols = '1234567890-_=+ёйцукенгшщхъзфывапролджячсмитьбю!№;%:?*()qwertyuiopasdfghjklzxcvbnm,./э ',

							alignX = 'left',

							scale = 0.5,
							font = getFont('montserrat_semibold', 23, 'light'),

							onInput = function(element)
								playersList:applyFilter( element[6] )
							end,

						},

						{'element',
							'center', 80,
							321, function(s,p) return p[5] - s[3] - 20 end,
							color = {255,255,255,255},

							overflow = 'vertical',
							elements = {},

							variable = 'playersList',

							scrollWidth = 3,
							scrollBgColor = {25,24,38,255},

							scrollXOffset = 10,

							key_players = {},

							clear = function(element)

								for _, c_element in pairs( element.elements or {} ) do
									c_element:destroy()
								end

								element.elements = {}

							end,

							applyFilter = function( element, filter )

								table.sort( element.elements, function( a,b )

									local match_a = a and a:hasFilterMatch( filter ) or false
									local match_b = b and b:hasFilterMatch( filter ) or false

									if match_a and match_b then

										local a_last_message = a.messages[#a.messages] or { timestamp = 0 }
										local b_last_message = b.messages[#b.messages] or { timestamp = 0 }

										if a_last_message.timestamp ~= b_last_message.timestamp then
											return a_last_message.timestamp > b_last_message.timestamp
										else
											return a.player.name < b.player.name
										end


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

							addPlayer = function(element, player)

								if player == localPlayer then return end

								element.key_players[player] = element:addElement(
									{'image',
										'center', 0,
										321, 74,
										color = {25,24,38,255},

										'assets/images/player_bg.png',

										player = player,

										unread = 0,
										messages = {},

										onInit = function(element)
											element.h_anim = {}
											setAnimData( element.h_anim, 0.1, 0 )
										end,

										onDestroy = function(element)

											removeAnimData( element.h_anim )

											if playersList.selected == element then
												playersList.selected = nil
												messagesList:clear()
											end

										end,

										hasFilterMatch = function(element, filter)

											if not isElement(element.player) then return false end
											return element.player.name:lower():find( filter:lower() )

										end,

										onRender = function(element)

											if not isElement(player) then return end

											local x,y,w,h = element:abs()
											local alpha = element:alpha()

											if not element:hasFilterMatch( playersSearch[6] ) then
												alpha = alpha * 0.1
											end

											local r,g,b = interpolateBetween( 25,24,38, 35, 34, 48, element.animData, 'InOutQuad' )
											element.color = {r,g,b, element.color[4]}

											local player_name = element.player.name

											local last_message = element.messages[ #element.messages ]
											local last_message_text = 'Нет сообщений'

											if last_message then

												last_message_text = last_message.message
												local time = getRealTime( last_message.timestamp )

												player_name = player_name .. '  #46465a' .. ('%02d:%02d'):format( time.hour, time.minute )

												if last_message.sender == localPlayer then
													last_message_text = '#cd4949Вы: #646478' .. last_message_text
												end

											end

											dxDrawText(player_name,
												x + 30, y+h/2+2,
												x + 30, y+h/2+2,
												tocolor(200,200,200,255*alpha),
												0.5, 0.5, getFont('montserrat_semibold', 27, 'light'),
												'left', 'bottom', false, false, false, true
											)

											dxDrawText(last_message_text,
												x + 30, y+h/2-1,
												x + 30, y+h/2-1,
												tocolor(100,100,120,255*alpha),
												0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
												'left', 'top', false, false, false, true
											)

											animate( element.h_anim, element == playersList.selected and 1 or 0 )
											local h_animData = getAnimData( element.h_anim )

											if h_animData > 0.01 then

												dxDrawImage(
													x,y,w,h, 'assets/images/player_bg_a.png',
													0, 0, 0, tocolor(180,70,70,255*alpha*h_animData)
												)

											end

											if element.unread > 0 then

												local rw,rh = 47,47
												local rx,ry = x+w - rw - 15, y+h/2 - rh/2

												dxDrawImage(
													rx,ry,rw,rh, 'assets/images/unread.png',
													0, 0, 0, tocolor(180,70,70,255*alpha*(1-element.animData))
												)

												dxDrawText(math.min( element.unread, 9 ),
													rx,ry,rx+rw,ry+rh,
													tocolor(255,255,255,255*alpha*(1-element.animData)),
													0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
													'center', 'center'
												)

											end

										end,

										onClick = function(element)

											playersList.selected = element
											element.unread = 0

											messagesList:load( element.player )

										end,

										elements = {

											{'image',
												function(s,p) return p[4] - s[4] - 10 end, 'center',
												50, 50,
												color = {85,85,100,255},
												'assets/images/bl.png',

												gOnPreRender = function(element)

													local x,y,w,h = element:abs(true)

													if handleClick and isMouseInPosition(x,y,w,h) then

														element:onClick()
														handleClick = false

													end

												end,

												last_click = getTickCount(),

												onClick = function(element)

													if ( getTickCount() - element.last_click ) < 1000 then return end

													element.last_click = getTickCount(  )

													if not isElement(element.parent.player) then return end

													local blacklist = localPlayer:getData('messages.blacklist') or {}
													local flag = true

													if blacklist[ element.parent.player:getData('unique.login') ] then
														flag = false
													end

													if flag then
														dialog('Черный список', {
															'Вы действительно хотите добавить',
															('Игрока %s в черный список?'):format( element.parent.player.name ),
														}, function(result)
															if result then
																triggerServerEvent('messages.setBlackListed', resourceRoot, element.parent.player, flag)
															end
														end)
													else
														triggerServerEvent('messages.setBlackListed', resourceRoot, element.parent.player, flag)
													end


												end,

												onRender = function(element)

													if not isElement(element.parent.player) then return end

													local r,g,b = 85,85,100
													local blacklist = localPlayer:getData('messages.blacklist') or {}

													if blacklist[ element.parent.player:getData('unique.login') ] then
														r,g,b = 180,70,70
													end

													element.color = {r,g,b, element.color[4]}

												end,

												onInit = function(element)
													element.animationAlpha = element.parent
												end,

											},

										},

									}
								)

								element:updateElementsOrder()

							end,


							getPlayerElement = function(element, player)
								return element.key_players[player]
							end,

							removePlayer = function(element, player)

								local p_element = element:getPlayerElement( player )
								if p_element then
									p_element:destroy()
									element:updateElementsOrder()
								end

							end,

							appendPlayerMessage = function(element, player, message)

								local p_element = element:getPlayerElement( player )

								if p_element then

									table.insert( p_element.messages, message )

									if p_element == playersList.selected then
										messagesList:appendMessage( message )
									else
										p_element.unread = p_element.unread + 1
									end

									element:applyFilter( playersSearch[6] )

								end

							end,

							onInit = function(element)

								for _, player in pairs( getElementsByType('player') ) do

									if player:getData('unique.login') and player ~= localPlayer then
										element:addPlayer( player )
									end

								end	

							end,

							addEventHandler('onClientElementDataChange', root, function(dn, old, new)

								if dn == 'unique.login' and source.type == 'player' and not old and new then
									playersList:addPlayer(source)
								end

							end),

							addEventHandler('onClientPlayerQuit', root, function()
								playersList:removePlayer( source )
							end),

							addEvent('messages.receive', true),
							addEventHandler('messages.receive', resourceRoot, function( message )

								if message.chat then
									playersList:appendPlayerMessage( message.chat, message )
								end

							end),


						},

					},

				},

			},

		},

	},

}

-----------------------------------------------------------------

	GUIDefine('checkbox', {

		onInit = function(element)

			element:addHandler('onRender', function(element)

				if element.text then

					local x,y,w,h = element:abs()
					local alpha = element:alpha()

					dxDrawText(element.text,
						x+w+10, y,
						x+w+10, y+h,
						tocolor(255,255,255,255*alpha),
						0.5, 0.5, getFont('montserrat_semibold', 21, 'light'),
						'left', 'center'
					)

				end

			end)

			messagesWindow.settings[element.setting] = element

		end,

		onCheck = function(element)
			if element.setting then
				localPlayer:setData( element.setting, not localPlayer:getData( element.setting ) )
			end
		end,



	})

-----------------------------------------------------------------
	
	function openChat( player )

		local p_element = playersList:getPlayerElement( player )

		if p_element then
			p_element:onClick()
		end

	end

-----------------------------------------------------------------

loadGuiModule()


end)

