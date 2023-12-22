
local iconSize = 25
local padding = 15

local maxIconHeight = 60

addEventHandler('onClientRender', root, function()

	if not localPlayer:getData('unique.login') then return end
	if localPlayer:getData('weapon.hidden') then return end
	if localPlayer.vehicle then return end

	itemsConfig = itemsConfig or exports['main_inventory']:getConfigSetting('items')

	local slot = localPlayer:getData('weapon.slot') or 0
	local inventory = ( localPlayer:getData('inventory') or {} ).weapon or {}

	local weapon = inventory[slot]

	if weapon then

		local config = itemsConfig[weapon.item]

		if config.is_weapon then

			local yDec = 0
			if config.ammo then
				local ammo = weapon.data.ammo or 0
				local clip, total = getPedAmmoInClip(localPlayer), ammo

				clip = math.min(ammo, clip)
				total = total - clip

				mta_dxDrawText(string.format('%s/%s', clip, total),
					real_sx - (iconSize + padding) - 5, real_sy - (iconSize + padding),
					real_sx - (iconSize + padding) - 5, real_sy - padding,
					tocolor(255,255,255,255),
					1,1, getFont('montserrat_medium', 16, 'light', true),
					'right', 'center'
				)

				mta_dxDrawImage(
					real_sx - (iconSize + padding),
					real_sy - (iconSize + padding),
					iconSize,iconSize, 'assets/images/ammo.png',
					0, 0, 0, tocolor(255,255,255,255)
				)
			elseif config.health then 
				local health = weapon.data.health or 0
				local total = config.health

				if config.countAsHealth then
					health = weapon.count
					total = config.maxStack 
				end

				mta_dxDrawText(string.format('%s/%s', health, total),
					real_sx - (iconSize + padding) - 5, real_sy - (iconSize + padding),
					real_sx - (iconSize + padding) - 5, real_sy - padding,
					tocolor(255,255,255,255),
					1,1, getFont('montserrat_medium', 16, 'light', true),
					'right', 'center'
				)

				-- shader = shader or exports['roundshaders']:getShader('mask')
				-- local texture = getDrawingTexture('assets/images/round.png')

				-- local r,g,b = 11,111,231
				-- dxSetShaderValue(shader, 'MaskTexture', texture)
				-- dxSetShaderValue(shader, 'direction', 1)
				-- dxSetShaderValue(shader, 'mulR', r/255)
				-- dxSetShaderValue(shader, 'mulG', g/255)
				-- dxSetShaderValue(shader, 'mulB', b/255)
				-- dxSetShaderValue(shader, 'mulA', 1)

				-- dxSetShaderValue(shader, 'minAngle', 0)
				-- dxSetShaderValue(shader, 'maxAngle', 360*health/total)

				mta_dxDrawImage(
					real_sx - (iconSize + padding) + 5,
					real_sy - (iconSize + padding) + 10,
					iconSize - 20,iconSize - 20, texture,
					0, 0, 0, tocolor(0,0,0,255)
				)
				-- mta_dxDrawImage(
				-- 	real_sx - (iconSize + padding) + 5,
				-- 	real_sy - (iconSize + padding) + 10,
				-- 	iconSize - 20,iconSize - 20, shader,
				-- 	0, 0, 0, tocolor(255,255,255,255)
				-- )

				yDec = -10

			end

			local texture = getDrawingTexture(':main_inventory/'..config.icon)
			-- local mw,mh = dxGetMaterialSize(texture)

			local w,h = 90, 90

			mta_dxDrawImage(
				real_sx - 20 - w,
				real_sy - 15 - h + yDec,
				w,h, texture,
				0, 0, 0, tocolor(255,255,255,255)
			)

		end


	end

------------------------------------------------------------------------------------------

end)
