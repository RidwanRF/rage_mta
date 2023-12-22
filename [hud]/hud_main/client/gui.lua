
local sx,sy = guiGetScreenSize()

currentHUDIcons = {}
currentHUDRows = {}

addEventHandler('onClientResourceStart', resourceRoot, function()

	local _data = localPlayer:getData('__restart_cache.hud_main')
	currentHUDIcons, currentHUDRows = unpack(_data or { {}, {} })

end)

addEventHandler('onClientResourceStop', resourceRoot, function()

	localPlayer:setData('__restart_cache.hud_main', {currentHUDIcons, currentHUDRows})

end)

addCommandHandler('hud_clear_rows', function()

	for icon in pairs(currentHUDRows) do
		removePlayerHUDRow(localPlayer, icon)
	end

	for icon in pairs(currentHUDIcons) do
		removePlayerHUDIcon(localPlayer, icon)
	end

end)

addEventHandler('onClientRender', root, function()

	if not localPlayer:getData('unique.login') then return end
	if localPlayer:getData('hud.hidden') then return end

	local w,h = 151, 70
	local x,y = sx - w - 50, 20

	dxDrawImage(
		x,y,w,h, 'assets/images/logo.png',
		0, 0, 0, tocolor(255,255,255,255)
	)

	local ssize = 68

	local nx,ny,nw,nh = x+w-35,y+h/2-ssize/2+1,ssize,ssize

	dxDrawImage(
		nx,ny,nw,nh, 'assets/images/serverid.png',
		0, 0, 0, tocolor(200,70,70,255)
	)

	dxDrawText(root:getData('serverIndex') or 1,
		nx,ny-2,nx+nw,ny+nh,
		tocolor( 25, 22, 36, 255 ),
		0.5, 0.5, getFont('montserrat_black_italic', 30, 'light', true),
		'center', 'center'
	)

	dxDrawImage(
		x + w - 281 + 50, -20, 281, 177, 'assets/images/effects.png',
		0, 0, 0, tocolor(200, 70, 70, 150)
	)

	local ix,iy,iw,ih = x + w - 22 - 5 + 15, y+h-5+3-5, 22, 22

	local hud_rows = {
		{ icon = 'money', data_name = 'money', tick = 0, anim_id = 'money', priority = 100 },
	}

	for icon, data in pairs( currentHUDRows ) do
		table.insert(hud_rows, { icon = icon, tick = data.tick, anim_id = data, data_name = data.data_name, priority = data.priority })
	end

	if #hud_rows > 1 then
		table.sort(hud_rows, function(a,b)

			if a.priority or b.priority then
				return (a.priority or 0) > (b.priority or 0)
			else
				return a.tick < b.tick
			end

		end)
	end

	for _, row in pairs( hud_rows ) do

		local alpha = 1

		if row.anim_id then

			alpha = getAnimData(row.anim_id)

			if not alpha then

				alpha = 0

				setAnimData(row.anim_id, 0.1)
				animate(row.anim_id, 1)

			end

		end

		dxDrawImage(
			ix,iy,iw,ih, string.format('assets/images/icons/%s.png', row.icon), 
			0, 0, 0, tocolor(255,255,255,255*alpha)
		)

		dxDrawTextShadow(splitWithPoints( localPlayer:getData(row.data_name) or 0, '.' ),
			ix - 5,iy,ix-5,iy+ih, tocolor(255,255,255,255*alpha),
			0.5, getFont('montserrat_semibold', 34, 'light', true),
			'right', 'center', 1, tocolor(0, 0, 0, 50*alpha), false, dxDrawText
		)

		iy = iy + ih*alpha + 2

	end

	local stars = localPlayer:getData('police.stars') or 0

	if stars > 0 then

		local size = 54
		local padding = -25

		local t_count = 5

		local startX = sx - 30 - ( size*t_count + padding*(t_count-0.5) ) - 10
		local startY = iy - 10

		for i = 1, t_count do

			dxDrawImage(
				startX, startY,
				size, size, 'assets/images/star.png',
				0, 0, 0, stars >= i and tocolor( 180, 70, 70, 255 ) or tocolor( 0, 0, 0, 170 )
			)

			startX = startX + size + padding

		end


	end


	local icons = {}

	for icon, data in pairs( currentHUDIcons ) do
		table.insert( icons, { icon = icon, anim_id = data, tick = data.tick } )
	end

	if #icons > 1 then
		table.sort(icons, function(a,b)
			return a.tick < b.tick
		end)
	end

	local size = 30
	local startX = x - size + 10
	local padding = 2

	local status = localPlayer:getData('status.current')

	if status then

		local size = 40
		startX = x - size + 15

		local filepath = string.format(':main_freeroam/assets/images/status/%s.png', status)

		if fileExists( filepath ) then
			dxDrawImage(
				startX, y+h/2 - size/2 - 2,
				size, size, filepath,
				0, 0, 0, tocolor(255,255,255,255)	
			)
		end


		size = 30

		startX = startX - size - padding

	end

	whiteTexture = whiteTexture or exports.core:getTexture('white')

	for _, icon in pairs( icons ) do

		local alpha = 1

		if icon.anim_id then
			alpha = getAnimData(icon.anim_id)

			if not alpha then

				alpha = 0

				setAnimData(icon.anim_id, 0.1)
				animate(icon.anim_id, 1)

			end

		end

		dxDrawImage(
			startX, y+h/2 - size/2,
			size, size, string.format('assets/images/icons/%s.png', icon.icon),
			0, 0, 0, tocolor(255,255,255,255*alpha)
		)

		startX = startX - size*(alpha) - padding

	end

	if not exports.main_weapon_zones:isPlayerInZone(localPlayer) and localPlayer.dimension == 0
		and not exports.main_freeroam:hasAchievmentDisplay()
	then

		local w,h = 468,66
		local x,y = sx/2 - w/2, 40

		local aw,ah = 504, 104
		local ax,ay = x+w/2-aw/2, y+h/2-ah/2

		dxDrawImage(
			x,y,w,h, 'assets/images/wz/bg.png',
			0, 0, 0, tocolor(25,24,38,200)
		)

		dxDrawImage(
			ax,ay,aw,ah, 'assets/images/wz/bg_a.png',
			0, 0, 0, tocolor(180,70,70,255)
		)

		dxDrawText('ВЫ НАХОДИТЕСЬ В КРАСНОЙ ЗОНЕ',
			x, y+15, x+w, y+15,
			tocolor(255,255,255,255),
			0.5, 0.5, getFont('montserrat_semibold', 27, 'light', true),
			'center', 'top'
		)
		dxDrawText('Здесь разрешена стрельба',
			x, y+35, x+w, y+35,
			tocolor(100,100,120,255),
			0.5, 0.5, getFont('montserrat_semibold', 23, 'light', true),
			'center', 'top'
		)

	end


end, true, 'low-6')

