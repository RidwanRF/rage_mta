


openHandler = function()

	localPlayer:setData('hud.hidden', true)
	localPlayer:setData('radar.hidden', true)
	localPlayer:setData('speed.hidden', true)

	createPreview()

	currentSelectedSkin = 1
	updatePreviewSkin()

	showChat(false)

end
closeHandler = function()

	localPlayer:setData('hud.hidden', false)
	localPlayer:setData('radar.hidden', false)
	localPlayer:setData('speed.hidden', false)

	finishPreview()

	showChat(true)
end


function scrollSkinList(offset)
	if Config.skinsList[currentSelectedSkin + offset] then
		currentSelectedSkin = currentSelectedSkin + offset
	else
		if offset == 1 then
			currentSelectedSkin = 1
		else
			currentSelectedSkin = #Config.skinsList
		end
	end

	updatePreviewSkin()
end

function updatePreviewSkin()
	local skinData = Config.skinsList[currentSelectedSkin]
	if not skinData then return end

	setPreviewModel(skinData.skinId)
end

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'image',

			sx - 429 - 30, sy/2 - 374/2,
			429, 374,

			'assets/images/bg.png',
			color = {32,35,66,255},

			onPreRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawImage(
					x + w/2 - 447/2,
					y + h/2 - 392/2 + 3,
					447, 392, 'assets/images/bg_shadow.png',
					0, 0, 0, tocolor(0,0,0,255*alpha)
				)

			end,

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				dxDrawText('Создание персонажа',
					x,y+45,x+w,y+45,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 32, 'light'),
					'center', 'top'
				)

			end,

			elements = {

				{'input',

					placeholder = 'Введите ник',
					[3] = 100,

					id = 'nickname-input',

					possibleSymbols = 'qwertyuiopasdfghjklzxcvbnm1234567890',

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						local iw,ih = 25,25
						local ix,iy = x + 25, y+h/2-ih/2

						dxDrawImage(
							ix,iy,iw,ih, 'assets/images/user_icon.png',
							0, 0, 0, tocolor(200, 70, 70, 255*alpha)
						)

					end,

				},

				{'input',

					placeholder = '',
					[3] = 180,

					noEdit = true,

					onRender = function(element)

						element[6] = Config.skinsList[currentSelectedSkin].name

					end,

					elements = {

						{'button',

							20, 'center',
							33, 33,
							image_group = 'arrow',

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								dxDrawImage(
									x+w/2-20/2, y+h/2-20/2,
									20, 20, 'assets/images/arrow_icon.png',
									element.r or 0, 0, 0, tocolor(255,255,255,255*alpha)
								)

							end,

							onClick = function()
								scrollSkinList(-1)
							end,

						},

						{'button',

							328-20-33, 'center',
							33, 33,
							image_group = 'arrow',
							r = 180,

							onRender = function(element)

								local alpha = element:alpha()
								local x,y,w,h = element:abs()

								dxDrawImage(
									x+w/2-20/2, y+h/2-20/2,
									20, 20, 'assets/images/arrow_icon.png',
									element.r or 0, 0, 0, tocolor(255,255,255,255*alpha)
								)

							end,

							onClick = function()
								scrollSkinList(1)
							end,

						},

					},

				},

				{'button',
					'center', 270,
					236, 55,

					'Продолжить',
					image_group = 'button',

					onClick = function(element)

						local x,y,w,h = element:abs()

						animate('button', 0)
						displayLoading( {x+w/2-35/2, y+h/2-35/2, 35, 35}, {180,70,70,255}, 1000, function()

							animate('button', 1)

							local skinData = Config.skinsList[currentSelectedSkin]
							if not skinData then return end

							local name = gui_get('nickname-input')[6]

							if utf8.len(name) < 3 then return end

							triggerServerEvent('character.create', resourceRoot, name, skinData.skinId)


						end )

					end,

					addEvent('character.create.closeWindow', true),
					addEventHandler('character.create.closeWindow', root, function()
						closeWindow()
					end),

					setAnimData('button', 0.1, 1),
					animationAlpha = 'button',

				},

			},

		},

	},

}

------------------------------------------------------------------------

	GUIDefine('input', {

		[2] = 'center',
		[4] = 328, [5] = 55,
		[6] = '',

		scale = 0.5,
		font = getFont('montserrat_medium', 26, 'light'),

		bg = 'assets/images/input.png',

		alignX = 'center',

		color = {37,42,74,255},
		activeColor = {47,52,84,255},
		placeholderColor = {75,78,100,255},

	})

	GUIDefine('button', {

		onInit = function(element)

			element.bg = string.format('assets/images/%s_empty.png', element.image_group)
			element.activeBg = string.format('assets/images/%s.png', element.image_group)
			element.shadow = string.format('assets/images/%s_shadow.png', element.image_group)
			element.shadowEmpty = string.format('assets/images/%s_empty_shadow.png', element.image_group)

		end,

		onPreRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			local texture = getDrawingTexture(element.shadowEmpty)
			local mw,mh = dxGetMaterialSize(texture)

			local shx,shy,shw,shh = x + w/2 - mw/2, y + h/2 - mh/2, mw, mh

			dxDrawImage(
				shx,shy,shw,shh, element.shadowEmpty,
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
			)
			dxDrawImage(
				shx,shy,shw,shh, element.shadow,
				0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
			)

		end,

		[6] = '',
		color = {180, 70, 70, 255},

		scale = 0.5,
		font = getFont('montserrat_medium', 25, 'light'),	

	})

------------------------------------------------------------------------

loadGuiModule()

hideBackground = true
blurBackground = false

end)
