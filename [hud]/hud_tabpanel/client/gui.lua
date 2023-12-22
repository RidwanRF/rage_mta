

openHandler = function()
	showCursor(false)
	updatePlayersList()
end
closeHandler = function()
end

hideBackground = true
clearGuiTextures = false

addEventHandler('onClientResourceStart', resourceRoot, function()



windowModel = {

	main = {
		{'rectangle',
			sx/2 - 872/2, sy/2 - 492/2,
			872, 492,
			color = {24,26,28,255},

			elements = {
				{'rectangle',
					'center', function(s,p) return p[5] + 10 end,
					'100%', 60,
					color = {24,26,28,255},

					list = {
						{ left = 'Возрождение лучшего проекта', right = 'С возвращанием!' },
					},

					onInit = function(element)

						openHandlers.ads = function()
							ads.index = #ads.list > 0 and math.random( #ads.list ) or nil
						end

					end,

					variable = 'ads',

					noDraw = function(element)
						return not element.index
					end,

					onRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						if not element.index then return end
						local ads_item = element.list[ element.index ]

						dxDrawText(ads_item.left,
							x + 30, y,
							x + 30, y+h,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
							'left', 'center', false, false, false, true
						)

						dxDrawText(ads_item.right,
							x + w - 30, y,
							x + w - 30, y+h,
							tocolor(180,70,70,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 25, 'light'),
							'right', 'center'
						)

					end,

				},
			},

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				if localPlayer.dimension ~= 0 then
					return closeWindow()
				end


				dxDrawRectangle(
					x,y,
					w, 119,
					tocolor(18, 18, 18, 255*alpha)
				)

				dxDrawImage(
					x,y,w, 119,
					'assets/images/head_shadow.png',
					0, 0, 0, tocolor(190, 70, 70, 255*alpha)
				)

				dxDrawImage(
					x + w/2 - 125/2,
					y + 10,
					125, 58,
					'assets/images/logo.png', 0, 0, 0, tocolor(255,255,255,255*alpha)
				)

				dxDrawText(Config.serverName,
					0, y + 70,
					sx, y + 70,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, getFont('montserrat', 30, 'bold'),
					'center', 'top'
				)

				local uw,uh = 25, 25
				local ux,uy =
					x + w - 100,
					y + 60

				dxDrawImage(
					ux,uy,uw,uh,
					'assets/images/user.png', 0, 0, 0,
					tocolor(190, 70, 70, 255*alpha)
				)

				dxDrawText('Игроков онлайн',
					ux+uw-5, uy,
					ux+uw-5, uy,
					tocolor(100, 100, 100, 255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 25, 'bold'),
					'right', 'bottom'
				)

				-- dxDrawText(string.format('%s / %s', 232, 500),
				dxDrawText(string.format('%s / %s', #getElementsByType('player'), 500),
					ux-3, uy+1,
					ux-3, uy+uh,
					tocolor(255, 255, 255, 255*alpha),
					0.5, 0.5, getFont('montserrat_semibold', 28, 'bold'),
					'right', 'center'
				)

			end

		},
		{'list',
			sx/2 - 872/2, sy/2 - 492/2 + 160,
			872, 330,

			scrollHeight = 0.8,
			scrollBg = whiteTexture,
			scrollColor = {190,70,70,255},
			scrollBgColor = {10,10,10,255},
			scrollYOffset = -40,
			scrollXOffset = -30,


			scrollWidth = 6,
			listOffset = 0,
			listElements = {},
			font = getFont('montserrat', 26, 'light'),
			scale = 0.5,
			listElementHeight = 42,

			color = {255,255,255,255},

			onInit = function(element)
				playersList = element

				updatePlayersList()
			end,
			needInit = true,

			addEventHandler('onClientPlayerJoin', root, function()
				updatePlayersList()
			end),

			addEventHandler('onClientPlayerQuit', root, function()
				updatePlayersList()
			end),

			onRender = function(element)

				local ex,ey = element:abs()

				local x,y = ex, ey - 5
				local alpha = getElementDrawAlpha(element)

				for _, data in pairs( dataList ) do

					dxDrawText(data.name,
						x + data.offset,y, x + data.offset + data.w, y,
						tocolor(90,90,90, 255*alpha), 0.5, 0.5,
						getFont('montserrat_semibold', 28, 'light'),
						data.align or 'left', 'bottom'
					)

				end

			end,

			additionalElementDrawing = function(lElement, x,y,w,ey, element, index)

				if type(lElement) ~= 'table' and not isElement(lElement) then return end

				local alpha = element.color[4]*windowAlpha/255
				if lElement.type == 'team' then
					drawTeam(lElement.team, x,y,w,ey, element, alpha)
				elseif lElement.type == 'player' then
					drawPlayer(lElement.player, x,y,w,ey, element, alpha)
				else
					drawText(lElement, x,y,w,ey, element, alpha)
				end

			end,

		},
	},
}


---------------------------------------------------------------------

	function drawText(lElement, x,y,w,ey, element, alpha)
		dxDrawText(lElement._text or '',
			x + 40,y, x + 40, y + element.listElementHeight,
			tocolor(90,90,90, 255*alpha), 10/11, 10/11,
			getFont('montserrat_bold', 10*4/3, 'bold'),
			'left', 'center'
		)
		dxDrawText(lElement._text or '',
			x + 40,y, x + 40, y + element.listElementHeight,
			tocolor(90,90,90, 255*alpha), 10/11, 10/11,
			getFont('montserrat_bold', 10*4/3, 'bold'),
			'left', 'center'
		)
	end

	function drawTeam(team, x,y,w,ey, element, alpha)

		local r,g,b
		if isElement(team) then
			r,g,b = getTeamColor(team)
		else
			r,g,b = 255,255,255
		end

		local color = tocolor(r,g,b,150*alpha)
		local color2 = tocolor(190,70,70,255*alpha)

		dxDrawRectangle(
			x,y,w,element.listElementHeight, color
		)

		local nx,ny,nw,nh = 170,y,200,element.listElementHeight

		dxDrawRectangle(
			nx,ny,nw,nh,
			color2
		)

		local font = getFont('montserrat_semibold', 27, 'light')
		local scale = 0.5

		dxDrawText(team.name,
			nx,ny,
			nx+nw,ny+nh,
			tocolor(255,255,255, 255*alpha),
			scale, scale, font,
			'center', 'center'
		)


	end

	function drawPlayer(player, x,y,w,ey, element, alpha)

		if not isElement(player) then return end

		for _, data in pairs( dataList ) do

			local r,g,b = 90,90,90

			if data.colorized then

				local nick_hex = player:getData('character.nickname_color') or '#ffffff'

				if nick_hex ~= '#ffffff' then
					r,g,b = hexToRGB( nick_hex )
				else
					if player == localPlayer then
						r,g,b = 190,70,70
					else
						r,g,b = 255,255,255
					end
				end

				if player.team then
					r,g,b = getTeamColor(player.team)
				end

			end

			local text

			if data.dataName then
				text = player:getData(data.dataName) or ( data.undefine or '' )
			else
				text = data.get(player)
			end

			local _offset = 0
			if data.preIcon then
				local size = 14

				local r,g,b,a = unpack(data.preIconColor or {255,255,255,255})
				if player == localPlayer then
					r,g,b = 190,70,70
				end

				local color = tocolor(r,g,b,a*alpha)

				dxDrawImage(
					x + data.offset + 5,
					y + element.listElementHeight/2 - size/2,
					size, size, data.preIcon, 0, 0, 0, color
				)
				_offset = size + 4
			end

			dxDrawText(text,
				x + data.offset + 5 + _offset,y, x + data.offset + data.w, y + element.listElementHeight,
				tocolor(r,g,b, 255*alpha), 0.5, 0.5,
				getFont('montserrat_semibold', 28, 'bold'),
				data.align or 'left', 'center', false, false, false, true
			)

		end


	end

---------------------------------------------------------------------

	addEventHandler('onClientKey', root, function(button, state)
		if not windowOpened then return end
		if button == 'mouse_wheel_up' then
			scrollList(playersList, 1)
		elseif button == 'mouse_wheel_down' then
			scrollList(playersList, -1)
		end
	end, true, 'low-10')

---------------------------------------------------------------------

	dataList = {
		{
			name = 'ID',
			offset = 20,
			w = 40,
			dataName = 'dynamic.id',
			-- colorized = true,
			align = 'left',
		},
		{
			name = 'Никнейм',
			offset = 170,
			w = 200,
			get = function(player)
				local name = player.name:gsub("#%x%x%x%x%x%x", "")
				if utf8.len(name) > 12 then
					return utf8.sub(name, 0, 12) .. '...'
				else
					return name
				end
			end,
			colorized = true,
			align = 'center',
		},
		{
			name = 'Стаж игры',
			offset = 450,
			w = 200,
			get = function(player)
				return string.format('#ffffff%s #5a5a5aч.', player:getData('level') or 0)
			end,
			align = 'center',
		},
		{
			name = 'Ping',
			offset = 780,
			w = 50,
			get = function(player)
				return player.ping
			end,
			align = 'left',
		},
	}

	function updatePlayersList()
		-- local list = getElementsByType('player')

		-- table.sort(list, function(a,b)
		-- 	return a == localPlayer
		-- end)

		-- table.sort(list, function(a,b)
		-- 	local team_1, team_2 = a.team or {}, b.team or {}
		-- 	return (team_1.name or '') > (team_2.name or '')
		-- end)

		-- local lastTeam 
		-- for index, player in pairs(list) do
		-- 	if player.team and player.team ~= lastTeam then
		-- 		lastTeam = player.team
		-- 		table.insert(list, index, player.team)
		-- 	end
		-- end

		local list = {}
		local teamPlayers = {}

		for _, team in pairs( getElementsByType('team') ) do

			if #team.players > 0 then
				table.insert(list, { type = 'team', team = team })

				for _, player in pairs(team.players) do
					teamPlayers[player] = true
					table.insert(list, { type = 'player', player = player })
				end
			end

		end

		local noTeamCount = 0
		for _, player in pairs( getElementsByType('player') ) do
			if not teamPlayers[player] then
				noTeamCount = noTeamCount + 1
			end
		end

		if noTeamCount > 0 then
			table.insert(list, {type = 'team', team = { name = 'Игроки без клана' }})
		end

		for _, player in pairs( getElementsByType('player') ) do
			if not teamPlayers[player] then
				table.insert(list, { type = 'player', player = player })
			end
		end
		
		playersList.listElements = list

	end

loadGuiModule()

end)
