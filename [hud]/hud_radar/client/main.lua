function math.round(number)
    return tonumber(("%.0f"):format(number))
end

local mta_getBlipIcon = getBlipIcon
function getBlipIcon(blip)
	return getElementData(blip, 'icon') or mta_getBlipIcon(blip)
end

local screenW, screenH = guiGetScreenSize()
local defaultScreen = {width = screenW, height = screenH}
-- local defaultScreen = {width = 1920, height = 1080}

-- Настраиваемые параметры
local radar = {
	x	   = math.round( 40												),
	y	   = math.round( screenH-(40+(177*screenH/defaultScreen.height))),
	width  = math.round( 287*screenW/defaultScreen.width				),
	height = math.round( 177*screenH/defaultScreen.height				),
}
local map = {
	left = 1500, right = 1500, top = 1500, bottom = 1500,
	-- left = 2303, right = 1997, top = 1500, bottom = 1500,
	scale = 0.5, -- Количество пикселей в 1 линейном метре карты
}
local blipSize = {
	size = (screenW > 1000) and 32 or 24,
	markerSize = 8,
}
local borderImage = {
	x	   = radar.x - 5,
	y	   = radar.y - 5,
	width  = radar.width + 10,
	height = radar.height + 9,
}
local delayingBlipIcons = {
	target = true,
	gps = true,
	point = true,
	police_spectate = true,
	police_call = true,
	player_house = true,
	player_business = true,
	player_derrick = true,
	prison = true,
	important_point = true,
	auction = true,
	mansion_own = true,
}

local blimingIcons = {
	important_point = true
}

local nativeBlipIcons = {
	lootbox = true,
	oplayer = true,
}


-- Автоматически рассчитываемые параметры
local k = radar.height/radar.width -- Коэффициент наклона прямой, проведенной из центра карты в ее угол
radar.halfWidth, radar.halfHeight = math.round(radar.width/2), math.round(radar.height/2)
radar.border = {
	left = radar.x, right  = radar.x+radar.width,
	top  = radar.y, bottom = radar.y+radar.height,
}
radar.center = {
	x = radar.x+radar.halfWidth,
	y = radar.y+radar.halfHeight,
}

map.width, map.height			   = map.left+map.right, map.top+map.bottom
map.centerShiftX, map.centerShiftY = (map.left - map.right)/2, (map.top - map.bottom)/2

blipSize.halfSize		 = blipSize.size/2
blipSize.halfMarkerSize = blipSize.markerSize/2

local texture = {
	water = dxCreateTexture("assets/images/water.png", "dxt1", true, "clamp"),
	radar = dxCreateTexture("assets/images/radar.dds", "dxt1", true, "clamp"),
	map_mask = dxCreateTexture("assets/images/map_mask.png", "dxt5", true, "clamp"),
}

function getRadarTexture()
	return texture.radar
end

function setRadarTexture(texture)
	texture.radar = texture
end


-- local pixels = dxConvertPixels(dxGetTexturePixels(texture.radar), 'png')
-- local file = fileCreate('radar.png')
-- fileWrite(file, pixels)
-- fileClose(file)

local radarRenderTarget = dxCreateRenderTarget(radar.width, radar.height, false)

-- local north = createBlip(0, 0, 0, 4, 2, 255, 0, 0, 255, 0, 100000)


-- Отрисовка карты
function getCameraParameters()
	local camera = {}
	camera.element = getCamera()
	_, _, camera.rot = getElementRotation(camera.element)
	local radianRotation = math.rad(camera.rot)
	camera.sin = math.sin(radianRotation)
	camera.cos = math.cos(radianRotation)
	return camera
end

function getTargetParameters()
	local target = {}
	target.element = getCameraTarget() or localPlayer
	if (target.element) then
		target.x, target.y, target.z = getElementPosition(target.element)
		_, _, target.rot = getElementRotation(target.element)
		local spX, spY, spZ = getElementVelocity(target.element)
		target.speed = (spX^2 + spY^2 + spZ^2)^(0.5)*180
	else
		target.x, target.y, target.z = getCameraMatrix()
		target.rot = 0
		target.speed = 0
	end
	target.mapX = -target.x*map.scale-map.left
	target.mapY =  target.y*map.scale-map.top
	return target
end

function isRadarVisible()
	if localPlayer:getData('radar.hidden') then return end
	if not localPlayer:getData('unique.login') then return end
	if localPlayer:getData('used.floor') then return end

	return (radarRenderTarget) and (getElementInterior(localPlayer) == 0)
end


local hasRadarSignal = true 

delayedBlips = {}	
nativeBlips = {}	
currentBlips = {}

setTimer(function()
	local target = getTargetParameters()

	currentBlips = {}
	nativeBlips = {}
	delayedBlips = {}

	local localDim = localPlayer.dimension
	for _, blip in pairs(getElementsByType("blip")) do
		if blip.dimension == localDim then

			if (blip:getData('team') and localPlayer.team) or not blip:getData('team') then
				local icon = getBlipIcon(blip)

				if nativeBlipIcons[icon] then

					x, y = getElementPosition(blip)
					maxDistance = blip:getData('max_distance') or 500
					dist = getDistanceBetweenPoints2D(target.x, target.y, x, y)
					attached = getElementAttachedTo(blip)

					atDim = isElement(attached) and getElementDimension(attached) or localDim
					if atDim == localDim and
					dist < maxDistance and (attached ~= localPlayer) then
						table.insert(nativeBlips, blip)
					end

				else

					if not (delayingBlipIcons[ icon ] or blip:getData('delayed')) then
						x, y = getElementPosition(blip)
						maxDistance = blip:getData('max_distance') or 500
						dist = getDistanceBetweenPoints2D(target.x, target.y, x, y)
						attached = getElementAttachedTo(blip)

						atDim = isElement(attached) and getElementDimension(attached) or localDim
						if atDim == localDim and
						dist < maxDistance and (attached ~= localPlayer) then

							-- table.insert(nativeBlips, blip)
							table.insert(getCameraTarget(localPlayer) and nativeBlips or currentBlips, blip)
							-- table.insert(currentBlips, blip)
						end
					else
						table.insert(delayedBlips, blip)
					end

				end
			end

		end
	end
	noSignalDimensions = {
	}
	hasRadarSignal = not noSignalDimensions[localPlayer.dimension]
end, 1000, 0)



---------------------------------------------------------------

	function getLinesData()

		local lines = {}

		table.insert(lines, {
			color = {244,67,54},
			progress = math.clamp(localPlayer.health/100, 0, 1),
		})

		if (localPlayer.armor or 0) > 0 then
			table.insert(lines, {
				color = {200,200,200},
				progress = math.clamp(localPlayer.armor/100, 0, 1),
			})
		end

		if localPlayer.oxygenLevel < 1000 then
			table.insert(lines, {
				color = {11,111,231},
				progress = math.clamp(localPlayer.oxygenLevel/1000, 0, 1),
			})
		end

		return lines

	end


---------------------------------------------------------------

	local strings = {

		months = {
			'Января',
			'Февраля',
			'Марта',
			'Апреля',
			'Мая',
			'Июня',
			'Июля',
			'Августа',
			'Сентября',
			'Октября',
			'Ноября',
			'Декабря',
		},

		weekdays = {
			'Пн',
			'Вт',
			'Ср',
			'Чт',
			'Пт',
			'Сб',
			[0]='Вс',
		},

	}

---------------------------------------------------------------


function convertBlipPosition(x,y,zoom)
	return (x+3000)/6000*map.width*zoom, (-y+3000)/6000*map.height*zoom
end

function renderRadar()
	if not isRadarVisible() then return end

	
	-- Подготовка переменных
	local camera = getCameraParameters()
	local target = getTargetParameters()

	local zoom = 1.0
	if (target.speed < 50) then
		zoom = 1.2
	elseif (target.speed < 160) then
		zoom = 1.2 - (target.speed-50)/183.333
	else
		zoom = 0.6
	end
	
	dxSetBlendMode( 'modulate_add' )
	dxSetRenderTarget(radarRenderTarget)

		dxDrawImage(0, 0, radar.width, radar.height, texture.water)

		local rcx,rcy =
			(target.x*map.scale + map.centerShiftX)*zoom,
			(-target.y*map.scale + map.centerShiftY)*zoom

		local rx,ry =
			target.mapX*zoom + radar.halfWidth,
			target.mapY*zoom + radar.halfHeight

		local rw,rh =
			map.width*zoom,
			map.height*zoom

		dxDrawImage(rx,ry,
			rw,rh,
			texture.radar, camera.rot,
			rcx, rcy
		)

		for _, colshape in pairs( getElementsByType('colshape') ) do

			if colshape:getData('render') and localPlayer.dimension == colshape.dimension then

				local cx,cy = getElementPosition(colshape)
				local sizeX, sizeY = getColShapeSize( colshape )

				local tw,th = dxGetMaterialSize(radarRenderTarget)

				local h_coords = {}
				local px,py = getElementPosition(localPlayer)

				for _, coord in pairs( { { cx,cy }, { cx+sizeX,cy }, { cx+sizeX,cy+sizeY }, { cx, cy+sizeY } } ) do

					local x,y = unpack(coord)

					local r = findRotation(x,y, px,py)
					local dist = getDistanceBetweenPoints2D(px,py, x,y)/ (6000 / map.width) * zoom

					local ctx, cty = tw/2, th/2

					x,y = getPointFromDistanceRotation(ctx, cty, dist, r - camera.rot)

					table.insert( h_coords, {x,y} )

				end

				for index, coord in pairs( h_coords ) do

					local ncoord = h_coords[index+1] or h_coords[1]

					local x1,y1 = unpack(coord)
					local x2,y2 = unpack(ncoord)

					dxDrawLine(
						x1,y1, x2,y2,
						tocolor( 180,70,70,255 ), 2
					)

				end


			end

		end

		for _, blip in pairs(nativeBlips) do

			if isElement(blip) then

				-- if getCameraTarget(localPlayer) then

					local icon = getBlipIcon(blip)
					local draw = true
					local oc

					if icon == 'oplayer' then

						local m_data = localPlayer:getData('team.match.data')

						if m_data then

							local b_player = blip:getData('player')

							local x,y,z = getElementPosition(b_player)
							local px,py,pz = getElementPosition(localPlayer)

							if not m_data.players[m_data.match_team][b_player] and b_player.team then
								oc = {getTeamColor( b_player.team )}
							end
						end

						local s_data = localPlayer:getData('event_shooter.match.data')

						if s_data then

							if s_data.type == 'team' then

								local b_player = blip:getData('player')

								local x,y,z = getElementPosition(b_player)
								local px,py,pz = getElementPosition(localPlayer)

								if not s_data.players[s_data.match_team][b_player] and b_player.team then
									oc = {getTeamColor( b_player.team )}
								end

							elseif s_data.type == 'mincer' then

								
								
							end

							-- if (
							-- 	not m_data.players[m_data.match_team][b_player]
							-- 	and not (dst)
							-- ) then
							-- 	draw = false
							-- end
						end

					end

					if draw then
						local tw,th = dxGetMaterialSize(radarRenderTarget)
						local px,py = getElementPosition(localPlayer)
						local x,y = getElementPosition(blip)

						local r = findRotation(x,y, px,py)
						local dist = getDistanceBetweenPoints2D(px,py, x,y)/ (6000 / map.width) * zoom

						local ctx, cty = tw/2, th/2

						x,y = getPointFromDistanceRotation(ctx, cty, dist, r - camera.rot)

						local size = (blip:getData('size') or 1)*blipSize.size

						local r,g,b = 255,255,255
						if oc then
							r,g,b = unpack(oc)
						elseif blip:getData('color') then
							r,g,b = unpack( blip:getData('color') or {255,255,255} )
						end

						dxDrawImage(
							x - size/2, y - size/2,
							size, size,  "assets/images/blip_icons/"..(icon)..".png",
							0, 0, 0, tocolor(r,g,b, 255)
						)
					end


				-- else
				-- 	drawBlipOnMap(blip, camera, target, zoom)
				-- end


				
			end

		end


	dxSetRenderTarget()
	dxSetBlendMode( 'blend' )

	local texture = cutTextureByMask( radarRenderTarget, {
		mask = texture.map_mask,
	} )

	local tw,th = 178, 28
	local tx,ty = radar.x + 20, radar.y - th + 1

	dxDrawImage(
		tx,ty,tw,th, 'assets/images/time.png',
		0, 0, 0, tocolor( 255,255,255,255 )
	)

	local realTime = getRealTime()

	dxDrawText(string.format('%s, %02d %s, %02d:%02d',
		strings.weekdays[realTime.weekday], realTime.monthday,
		strings.months[realTime.month+1],
		realTime.hour, realTime.minute
	),
		tx,ty,tx+tw,ty+th,
		tocolor(255,255,255,255),
		0.5, 0.5, getFont('montserrat_semibold', 20, 'light', true),
		'center', 'center'
	)

	dxDrawImage(radar.x - 2, radar.y - 2, radar.width + 4, radar.height + 4, 'assets/images/map_mask.png',
		0, 0, 0, tocolor( 21, 21, 33, 255 )
	)

	dxDrawImage(radar.x, radar.y, radar.width, radar.height, texture)

	local w,h = 339, 216
	local x,y = radar.x + radar.width/2 - w/2, radar.y + radar.height/2 - h/2

	-- dxDrawImage(x,y, w,h, 'assets/images/map_shadow.png', 0, 0, 0, tocolor(0, 0, 0, 255))
	dxDrawImage(radar.x, radar.y, radar.width, radar.height, texture)
	dxDrawImage(radar.x, radar.y, radar.width, radar.height, 'assets/images/map_1.png',
		0, 0, 0, tocolor( 0, 0, 0, 255 )
	)


	local animData = getEasingValue(getAnimData('hiteffect'), 'InOutQuad')

	dxDrawImage(radar.x, radar.y, radar.width, radar.height, radarRenderTarget, 0, 0, 0,
		tocolor(255, 0, 0, 100*animData))

	local hw,hh = 273,8
	local hx,hy = radar.x + radar.width/2 - hw/2, radar.y + radar.height + 10

	local hsw, hsh = 281, 17
	local hsx, hsy = hx+hw/2-hsw/2, hy+hh/2 - hsh/2 + 3

	dxDrawImage(
		hsx,hsy,hsw,hsh, 'assets/images/line_shadow.png',
		0, 0, 0, tocolor(0,0,0,150)
	)

	dxDrawImage(
		hx,hy,hw,hh, 'assets/images/line.png',
		0, 0, 0, tocolor(22,25,56,255)
	)

	if localPlayer.oxygenLevel < 1000 then

		drawImageSection(
			hx,hy,hw,hh, 'assets/images/line.png',
			{ x = localPlayer.oxygenLevel/1000, y = 1 }, tocolor(60, 60, 200,255)
		)

	else

		drawImageSection(
			hx,hy,hw,hh, 'assets/images/line.png',
			{ x = localPlayer.health/100, y = 1 }, tocolor(200,70,70,255)
		)

	end

	
	
	-- camera.element = getElementType(camera.element)
	-- target.element = target.element and getElementType(target.element)
	-- local text = "radar "..toJSON(radar).."\n map "..toJSON(map).."\n blipSize "..toJSON(blipSize).."\n camera "..toJSON(camera).."\n target "..toJSON(target)
		-- .."\n zoom "..toJSON(zoom).."\n radarRenderTarget "..tostring(radarRenderTarget).."\n kek "..toJSON({})
	-- dxDrawText(text, 400, 500)
	
	-- Рамка вокруг карты
	-- dxDrawImage(borderImage.x, borderImage.y, borderImage.width, borderImage.height,
	-- 	"assets/images/border.png", 0, 0, 0, getRadarBorderColor())

	
	-- Обновляем блип севера
	-- local northY = 5000
	-- if target.y > 4000 then
	-- 	northY = target.y + 1000
	-- end
	-- setElementPosition(north, target.x, northY, target.z)
	
	-- Рисуем блипы
	for _, blip in pairs( currentBlips ) do
		drawBlipOnMap(blip, camera, target, zoom)
	end

	for _, blip in pairs(delayedBlips) do
		drawBlipOnMap(blip, camera, target, zoom)
	end
	-- Рисуем блип игрока/цели
	if (target.element) then
		dxDrawImage(radar.center.x-blipSize.halfSize, radar.center.y-blipSize.halfSize, blipSize.size, blipSize.size, "assets/images/blip_icons/player.png", camera.rot-target.rot)
	-- else
	-- 	dxDrawImage(radar.center.x-blipSize.halfSize, radar.center.y-blipSize.halfSize, blipSize.size, blipSize.size, "assets/images/blip_icons/64.png", 0)
	end
end
addEventHandler('onClientRender', root, renderRadar)

function drawBlipOnMap(blip, camera, target, zoom)
	if not isElement(blip) then return end
	local icon = getBlipIcon(blip)
	local x, y, z = getElementPosition(blip)

	local size = (blip:getData('size') or 1)*blipSize.size

	local xShift = (x-target.x)*map.scale*zoom
	local yShift = (target.y-y)*map.scale*zoom
	local blipPosX = xShift*camera.cos - yShift*camera.sin
	local blipPosY = xShift*camera.sin + yShift*camera.cos
	if (blipPosX < -radar.halfWidth) or (blipPosX > radar.halfWidth) or (blipPosY < -radar.halfHeight) or (blipPosY > radar.halfHeight) then

		if not (delayingBlipIcons[icon] or blip:getData('delayed')) then
			return
		end

		blipPosX, blipPosY = repairCoordinates(blipPosX, blipPosY, size)
	end

	if blimingIcons[icon] then

		local x,y,w,h = radar.center.x + blipPosX - size/2,
				radar.center.y + blipPosY - size/2,
				size, size

		local tick = getTickCount() * 0.0015
		local blim = math.abs( math.sin( tick ) )
		local r,g,b = interpolateBetween(255,255,255, 20, 130, 240, blim, 'InOutQuad')

		dxDrawImage(x-5,y-5,w+10,h+10, "assets/images/blip_icons/round.png", tick*30, 0, 0, tocolor(r,g,b,255))
		dxDrawImage(x,y,w,h, "assets/images/blip_icons/"..icon..".png", 0, 0, 0, tocolor(r,g,b,255))

	else

		local r,g,b = 255,255,255
		if blip:getData('color') then
			r,g,b = unpack( blip:getData('color') or {255,255,255} )
		end

		dxDrawImage(radar.center.x + blipPosX - size/2,
					radar.center.y + blipPosY - size/2,
					size, size, "assets/images/blip_icons/"..icon..".png",
					0, 0, 0, tocolor(r,g,b,255))
	end

end

function repairCoordinates(blipPosX, blipPosY, size)
	local newX, newY
	if (blipPosX >= 0 and blipPosY < -k*blipPosX) or (blipPosX < 0 and blipPosY < k*blipPosX) then
		-- Верхняя граница
		newY = -radar.halfHeight + size/2
		newX = newY/(blipPosY/blipPosX)
	elseif (blipPosX >= 0 and blipPosY > k*blipPosX) or (blipPosX < 0 and blipPosY > -k*blipPosX) then
		-- Нижняя граница
		newY = radar.halfHeight - size/2
		newX = newY/(blipPosY/blipPosX)
	elseif blipPosX > 0 then
		-- Правая граница
		newX = radar.halfWidth - size/2
		newY = (blipPosY/blipPosX)*newX
	else
		-- Левая граница
		newX = -radar.halfWidth + size/2
		newY = (blipPosY/blipPosX)*newX
	end
	return newX, newY
end

addEventHandler("onClientResourceStop", resourceRoot, function()
	showPlayerHudComponent("radar", true)
end)

addEventHandler("onClientResourceStart", resourceRoot, function()
	showPlayerHudComponent("radar", false)
end)


-- Включение/отключение показа игроков
local playerBlips = {}

addEventHandler("onClientResourceStart", resourceRoot, function()
	refreshPlayerBlips()
end)

function refreshPlayerBlips()

	if not localPlayer:getData('hud_map.display_players') then return end

	for i, blip in pairs(playerBlips) do
		if isElement(blip) then destroyElement(blip) end
		playerBlips[i] = nil
	end

	for _, player in ipairs( getElementsByType("player") ) do
		if player:getData('unique.login') then
			createBlipForPlayer(player)
		end
	end

end

addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

	if dn == 'hud_map.display_players' then

		if new then
			refreshPlayerBlips()
		else
			clearTableElements(playerBlips)
		end

	end

end)


function createBlipForPlayer(player)

	if not localPlayer:getData('hud_map.display_players') then return end

	if isElement(player) then
		local r,g,b = getPlayerNametagColor(player)
		playerBlips[player] = createBlipAttachedTo(player, 0, 2, r, g, b)
		playerBlips[player]:setData('icon', 'oplayer')
		playerBlips[player]:setData('player', player)

		local r,g,b = hexToRGB( player:getData('character.nickname_color') or '#ffffff' )

		if player.team then
			r,g,b = getTeamColor(player.team)
		end

		playerBlips[player]:setData('color', { r,g,b })
	end
	
end

addEventHandler('onClientElementDataChange', root, function( dn, old, new )

	if dn == 'unique.login' and new and not old then
		setTimer(createBlipForPlayer, 1000, 1, source)
	elseif dn == 'character.nickname_color' and isElement(playerBlips[source]) then
		playerBlips[source]:setData('color', hexToRGB(new or '#ffffff'))
	end

end)

addEventHandler("onClientPlayerQuit", root, function()
	if isElement(playerBlips[source]) then destroyElement(playerBlips[source]) end
end)


function playersShowType()
	return showPlayers
end

-- Получение координат радара
function getRadarCoords()
	return radar.x, radar.y, radar.width, radar.height
end


-- ==========     Изменение цвета окантовки вокруг радара     ==========
-- Настройки
local chaseColorDelta = 20
local radiusColorDelta = 5
local restoreDelta = 10
local white = tocolor(255,255,255)

-- Переменные состояния
local customAnimation = false
local hasPolicemenInRadius, hasChase = false, false
local currentColor = {255, 255, 255}
local colorPhase = 1

function getRadarBorderColor()
	if (not customAnimation) then
		return tocolor(35,35,35,255)
	else
		if (hasChase) then
			if (colorPhase == 2) then
				local color = math.min(math.min(currentColor[1], currentColor[2]) + chaseColorDelta, 255)
				currentColor = {color, color, 255}
				if (color == 255) then
					colorPhase = 3
				end
				return tocolor(unpack(currentColor))
			
			elseif (colorPhase == 3) then
				local color = math.max(math.min(currentColor[2], currentColor[3]) - chaseColorDelta, 0)
				currentColor = {255, color, color}
				if (color == 0) then
					colorPhase = 4
				end
				return tocolor(unpack(currentColor))
			
			elseif (colorPhase == 4) then
				local color = math.min(math.min(currentColor[2], currentColor[3]) + chaseColorDelta, 255)
				currentColor = {255, color, color}
				if (color == 255) then
					colorPhase = 1
				end
				return tocolor(unpack(currentColor))
			
			else
				local color = math.max(math.min(currentColor[1], currentColor[2]) - chaseColorDelta, 0)
				currentColor = {color, color, 255}
				if (color == 0) then
					colorPhase = 2
				end
				return tocolor(unpack(currentColor))
			end
			
		elseif (hasPolicemenInRadius) then
			if (colorPhase == 4) then
				local b = math.min(currentColor[3] + radiusColorDelta, 255)
				local g = 255 - (255-b)/2
				currentColor = {255, g, b}
				if (b == 255) then
					colorPhase = 3
				end
				return tocolor(unpack(currentColor))
				
			else
				local b = math.max(currentColor[3] - radiusColorDelta, 0)
				local g = 255 - (255-b)/2
				currentColor = {255, g, b}
				if (b == 0) then
					colorPhase = 4
				end
				return tocolor(unpack(currentColor))
			end
		
		else
			currentColor = {
				math.min(255, currentColor[1]+restoreDelta),
				math.min(255, currentColor[2]+restoreDelta),
				math.min(255, currentColor[3]+restoreDelta),
			}
			if (currentColor[1] == 255) and (currentColor[2] == 255) and (currentColor[3] == 255) then
				customAnimation = false
				return white
			else
				return tocolor(unpack(currentColor))
			end
		end
	end
end

-- Поиск погони за игроком или машиной, в которой он сидит
setTimer(function()
	if (getPlayerWantedLevel() == 0) then
		hasChase = false
		hasPolicemenInRadius = false
		return
	end
	
	local newChaseState = false
	if getElementData(localPlayer, "isChased") then
		newChaseState = true
	else
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if (vehicle) then
			for _, occupant in pairs(getVehicleOccupants(vehicle)) do
				if getElementData(occupant, "isChased") then
					newChaseState = true
					break
				end
			end
		end
	end
	if (newChaseState) then
		hasChase = true
		customAnimation = true
	else
		hasChase = false
	end
end, 1000, 0)
