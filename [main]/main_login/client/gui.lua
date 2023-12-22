
cancelButtons = {
	['f1'] = true,
	['f2'] = true,
	['f3'] = true,
	['f4'] = true,
	['f5'] = true,
	['f11'] = true,
	['f9'] = true,
	['k'] = true,
}


openHandler = function( )
	showChat( false)
end
closeHandler = function()
	showChat(true)
end

addEventHandler('onClientResourceStart', resourceRoot, function( )


windowModel = {

	__basic = {

		{'element',

			0, 0, sx, real_sy * sx/real_sx,
			color = {255,255,255,255},

			id = 'loading',

			onInit = function(element)
				setAnimData('login-loading', 0.1, 0)
			end,

			onPreRender = function(element)

				if not isElement(element.renderTarget) then return end

				dxSetRenderTarget(element.renderTarget)
				element.render = true
			end,

			onPostRender = function(element)

				if not isElement(element.renderTarget) then return end
				if not element.render then return end

				local alpha = getElementDrawAlpha(element)

				dxSetRenderTarget()

				local anim = getAnimData('login-loading')

				local blur = getBlurTexture( element.renderTarget, anim*3, alpha )
				local x,y,w,h = element:abs()

				dxDrawImage(
					x,y,w,h, blur
				)

				element.render = false

			end,

			toggle = function(element, state)

				if state then

					if not isElement(element.renderTarget) then
						element.renderTarget = dxCreateRenderTarget(real_sx, real_sy, true)
					end


					animate('login-loading', 1)
					element.onClick = function()end


				else

					animate('login-loading', 0, function()

						if isElement(element.renderTarget) then
							destroyElement(element.renderTarget)
						end

						element.onClick = nil

					end)

				end

			end,

		},

		{'image',
			0, 0, real_sx, real_sy,
			mtaDraw = true,
			color = {255,255,255,255},
			'assets/images/bg.png',
			anim_fix = true,
		},

	},

	login = {

		{'image',

			sx/2 - 561/2, sy/2 - 512/2,
			561, 512,
			color = {32,35,66,255},
			'assets/images/login_bg.png',

			onPreRender = function(element)

				local alpha = getElementDrawAlpha(element)
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 599/2,
					y + h/2 - 550/2 + 5,
					599, 550, 'assets/images/login_bg_shadow.png',
					0, 0, 0, tocolor(32,35,66,255*alpha)
				)

			end,

			onRender = function(element)

				local alpha = getElementDrawAlpha(element)
				local ex,ey,ew,eh = element:abs()

				local text = 'Авторизация'
				local scale, font = 0.5, getFont('montserrat_semibold', 35, 'light')
				local y = ey + 60

				dxDrawText(text,
					ex, y,
					ex + element[4], y,
					tocolor(255,255,255,255*alpha),
					scale, scale, font,
					'center', 'top'
				)

				local fontHeight = dxGetFontHeight( scale, font )
				local textWidth = dxGetTextWidth( text, scale, font )

				dxDrawImage(
					ex + element[4]/2 - textWidth/2,
					y + fontHeight + 3,
					37, 5, 'assets/images/login_line.png',
					0, 0, 0, tocolor(182, 71, 71, 255*alpha)
				)


			end,

			elements = {

				{'input',
					'center', 145,
					362, 59,
					placeholder = 'Введите свой логин',
					id = 'login-login',
				},

				{'input',
					'center', 225,
					362, 59,
					placeholder = 'Введите пароль',
					id = 'login-password',
					mask = '•',
				},

				{'button',
					'center', 330,
					205, 57,
					'Продолжить',
					bg = 'assets/images/login_button_empty.png',
					activeBg = 'assets/images/login_button.png',
					id = 'login-button',

					onPreRender = function(element)

						local alpha = getElementDrawAlpha(element)

						local x,y,w,h = getElementAbsoluteOffset(element)

						local shx,shy,shw,shh = x + w/2 - 237/2, y + h/2 - 91/2, 237, 91

						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/login_button_empty_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
						)
						dxDrawImage(
							shx,shy,shw,shh, 'assets/images/login_button_shadow.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
						)

					end,

					onClick = function(element)

						local x,y,w,h = element:abs()
						local loading = gui_get('loading')

						animate('login-button', 0)
						loading:toggle(true)
						displayLoading( {x+w/2-60/2, y+h/2-60/2, 60, 60}, {180,70,70,255}, 1500, function()

							animate('login-button', 1)
							loading:toggle(false)

							handleAction('login')

						end )

					end,

					setAnimData('login-button', 0.1, 1),
					animationAlpha = 'login-button',

				},

				{'warning', [3] = 415},

				{'button',
					'center', 430,
					205, 30,
					'Регистрация',

					color = {255, 255, 255, 255},

					scale = 0.5,
					font = getFont('montserrat_medium', 25, 'light'),

					onRender = function(element)

						local alpha = getElementDrawAlpha(element)

						local fontHeight = dxGetFontHeight(element.scale, element.font)
						local textWidth = dxGetTextWidth(element[6], element.scale, element.font)

						local x,y,w,h = element:abs()

						dxDrawRectangle(
							x+w/2-textWidth/2, y+h/2+fontHeight/2+1,
							textWidth, 1,
							tocolor(255,255,255,255*alpha)
						)

						dxDrawRectangle(
							x+w/2-textWidth/2, y+h/2+fontHeight/2+1,
							math.ceil(textWidth*(element.animData)), 1,
							tocolor(180,70,70,255*alpha)
						)

						local text = 'Нет аккаунта?'
						local r,g,b = 115,115,130

						local t_textWidth = dxGetTextWidth( text, element.scale, element.font )
						local padding = 10

						local totalWidth = t_textWidth + padding + textWidth

						element[2] = element.parent[4]/2 - totalWidth/2 + t_textWidth + padding
						element[4] = textWidth

						x = element:abs()

						dxDrawText(text,
							x - padding, y+h/2,
							x - padding, y+h/2,
							tocolor(r,g,b,255*alpha),
							element.scale, element.scale, element.font,
							'right', 'center'
						)


					end,

					onClick = function(element)
						currentWindowSection = 'register'
					end,

				},
			
			},

		},


	},

	register = {

		{'image',

			'center', 'center',
			561, 624,
			color = {32,35,66,255},
			'assets/images/register_bg.png',

			onPreRender = function(element)

				local alpha = getElementDrawAlpha(element)
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 599/2,
					y + h/2 - 662/2 + 5,
					599, 662, 'assets/images/register_bg_shadow.png',
					0, 0, 0, tocolor(32,35,66,255*alpha)
				)

			end,

			onRender = function(element)

				local alpha = getElementDrawAlpha(element)
				local ex,ey,ew,eh = element:abs()

				local text = 'Регистрация'
				local scale, font = 0.5, getFont('montserrat_semibold', 35, 'light')
				local y = ey + 60

				dxDrawText(text,
					ex, y,
					ex + element[4], y,
					tocolor(255,255,255,255*alpha),
					scale, scale, font,
					'center', 'top'
				)

				local fontHeight = dxGetFontHeight( scale, font )
				local textWidth = dxGetTextWidth( text, scale, font )

				dxDrawImage(
					ex + element[4]/2 - textWidth/2,
					y + fontHeight + 3,
					37, 5, 'assets/images/login_line.png',
					0, 0, 0, tocolor(182, 71, 71, 255*alpha)
				)





			end,

			elements = {

				{'input',
					'center', 145,
					362, 59,
					placeholder = 'Введите свой логин',
					id = 'register-login',

				},

				{'input',
					'center', 225,
					362, 59,
					'',
					placeholder = 'Введите пароль',
					mask = '•',
					id = 'register-password',

				},

				{'input',
					'center', 305,
					362, 59,
					placeholder = 'Повторите пароль',
					mask = '•',
					id = 'register-password2',

				},

				{'input',
					'center', 385,
					362, 59,
					placeholder = 'Промокод (необязательно)',
					id = 'register-promo',
				},

				{'warning', [3] = 470},

				{'element',

					'center', 500,
					352, 57,
					color = {255,255,255,255},

					setAnimData('register-button', 0.1, 1),
					animationAlpha = 'register-button',

					elements = {

						{'button',
							0, 0,
							171, 57,
							'Назад',
							bg = 'assets/images/reg_button_empty.png',
							activeBg = 'assets/images/reg_button.png',

							onPreRender = function(element)

								local alpha = getElementDrawAlpha(element)

								local x,y,w,h = getElementAbsoluteOffset(element)

								local shx,shy,shw,shh = x + w/2 - 203/2, y + h/2 - 91/2, 203, 91

								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/reg_button_empty_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
								)
								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/reg_button_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
								)

							end,

							onClick = function(element)

								currentWindowSection = 'login'

							end,

						},

						{'button',
							'right', 0,
							171, 57,
							'Далее',
							bg = 'assets/images/reg_button_empty.png',
							activeBg = 'assets/images/reg_button.png',
							id = 'register-button',

							onPreRender = function(element)

								local alpha = getElementDrawAlpha(element)

								local x,y,w,h = getElementAbsoluteOffset(element)

								local shx,shy,shw,shh = x + w/2 - 203/2, y + h/2 - 91/2, 203, 91

								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/reg_button_empty_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
								)
								dxDrawImage(
									shx,shy,shw,shh, 'assets/images/reg_button_shadow.png',
									0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
								)

							end,


							onClick = function(element)

								local x,y,w,h = element.parent:abs()
								local loading = gui_get('loading')

								animate('register-button', 0)
								loading:toggle(true)
								displayLoading( {x+w/2-60/2, y+h/2-60/2, 60, 60}, {180,70,70,255}, 1500, function()

									animate('register-button', 1)
									loading:toggle(false)

									handleAction('register')

								end )

							end,

						},

					},

				},
			
			},

		},


	},

}


-----------------------------------------------

	GUIDefine('input', {
		[6]='',
		bg = 'assets/images/input.png',
		placeholderColor = {75,78,101,255},

		color = {37, 42, 72, 255},
		activeColor = {47, 52, 85, 255},

		scale = 0.5,
		font = getFont('montserrat_semibold', 25, 'light'),

		alignX = 'center',
	})

	GUIDefine('button', {
		color = {180, 70, 70, 255},

		scale = 0.5,
		font = getFont('montserrat_medium', 25, 'light'),
	})

	GUIDefine('warning', {
		[2]='center', 
		[4]=0, [5]=0,
		id = 'warning',

		color = {255,255,255,255},

		onInit = function(element)
			setAnimData(element.animationAlpha, 0.1)
		end,

		onRender = function(element)

			local alpha = getElementDrawAlpha(element)
			local x,y,w,h = element:abs()

			dxDrawText(element.warning_text or '',
				x,y,x+w,y+h,
				tocolor(182,70,70,255*alpha),
				0.5, 0.5, getFont('montserrat_medium', 25, 'light'),
				'center', 'center'
			)

		end,

		display = function(element, text)


			animate(element.animationAlpha, 1, function()

				setTimer(function()
					animate(element.animationAlpha, 0)
				end, 4000, 1)

			end)

			element.warning_text = text

		end,

		animationAlpha = 'warning-anim',
	})

-----------------------------------------------

	addEventHandler('onClientKey', root, function(button, state)

		if windowOpened and state then

			if button == 'tab' then

				local inputs = getGUIElementsByType('input')
				local index = 0

				if selectedInput then

					for _index, input in pairs( inputs ) do

						if input == selectedInput then
							index = _index
							break
						end

					end

				end

				focusInput( inputs[cycle(index + 1, 1, #inputs)] )

			elseif button:find('enter') then

				if currentWindowSection == 'login' then
					gui_get('login-button'):onClick()
				elseif currentWindowSection == 'register' then
					gui_get('register-button'):onClick()
				end

			end


		end

	end)

-----------------------------------------------
	
	actions = {

		login = function()

			local data = {
				login = gui_get('login-login')[6],
				password = gui_get('login-password')[6],
			}

			if #data.login <= 0 or #data.password <= 0 then
				return displayWarning('Заполните все поля')
			end

			if not checkInputSymbols(data.login) or not checkInputSymbols(data.password) then
				return displayWarning('Введены недопустимые символы')
			end

			triggerServerEvent('authpanel.authorize', resourceRoot, data.login, encode(data.password))
			cacheEnterSettings( data.login, data.password )

		end,

		register = function()

			local data = {
				login = gui_get('register-login')[6],
				password = gui_get('register-password')[6],
				password_repeat = gui_get('register-password2')[6],
				promo = gui_get('register-promo')[6],
			}

			if data.password ~= data.password_repeat then
				return displayWarning('Пароли не совпадают')
			end

			if #data.login <= 0 or #data.password <= 0 then
				return displayWarning('Заполните все поля')
			end

			if not checkInputSymbols(data.login) or not checkInputSymbols(data.password) then
				return displayWarning('Введены недопустимые символы')
			end

			triggerServerEvent('authpanel.register', resourceRoot, data.login, encode(data.password), data.promo)
			cacheEnterSettings( data.login, data.password )

		end,

	}

	function handleAction(action)
		local func = actions[action]
		func()
	end

-----------------------------------------------

	function displayWarning(text)
		gui_get('warning'):display(text)
	end

	addEvent('authpanel.displayWarning', true)
	addEventHandler('authpanel.displayWarning', resourceRoot, displayWarning)

-----------------------------------------------


loadGuiModule()

end)
