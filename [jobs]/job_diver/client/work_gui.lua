

--------------------------------------------

	function renderDiverHud()

		local w,h = 38, 178
		local x,y = sx - w - 40, 200

		local oxygen, max =
			localPlayer:getData('diver.oxygen') or 0,
			localPlayer:getData('diver.oxygen_max') or 0

		if max > 0 and oxygen > 0 then

			dxDrawImage(
				x,y,w,h, 'assets/images/ox_line.png',
				0, 0, 0, tocolor(21,21,33,255)
			)

			drawImageSection(
				x,y,w,h, 'assets/images/ox_line.png',
				{ x = 1, y = oxygen/max }, tocolor(70,70,80,255), 1
			)

			dxDrawImage(
				x+w/2-31/2,y+h-87,31,57, 'assets/images/bubbles.png',
				0, 0, 0, tocolor(255,255,255,100)
			)

			local iw,ih = 47,47
			local ix,iy = x+w-iw/2+4, y+h-ih-5

			dxDrawImage(
				ix,iy,iw,ih, 'assets/images/bbg.png',
				0, 0, 0, tocolor(18,18,28,255)
			)

			dxDrawImage(
				ix,iy,iw,ih, 'assets/images/bbg_a.png',
				0, 0, 0, tocolor(180,70,70,255)
			)

			dxDrawImage(
				ix+iw/2-35/2,iy+ih/2-35/2,35,35, 'assets/images/ballon.png',
				0, 0, 0, tocolor(255,255,255,255)
			)
		end


		local rw,rh = 50,50
		local padding = 5

		local startY = y+h+20
		local startX = x+w/2-rw/2

		local inventory_size = localPlayer:getData('diver.inventory_size') or Config.defaultInventorySize
		local inventory = localPlayer:getData('diver.inventory') or {}

		for i = 1, inventory_size do

			local slot = inventory[i]

			mta_dxDrawRectangle(
				px(startX) - 1, px(startY) - 1, 
				px(rw)+2,px(rh)+2, tocolor(60,60,85,255)
			)

			dxDrawRectangle(
				startX, startY, 
				rw,rh, tocolor(18,18,28,255)
			)

			if slot then

				local config = Config.loot[slot.id]

				dxDrawImage(
					startX+5,startY+5,rw-10,rh-10, config.icon,
					0, 0, 0, tocolor(255,255,255,255)
				)

			end

			startY = startY + rw + padding

		end


	end

--------------------------------------------

	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

		if dn == 'work.current' then

			if new == Config.resourceName then
				addEventHandler('onClientRender', root, renderDiverHud)
			else
				removeEventHandler('onClientRender', root, renderDiverHud)
			end

		end

	end)

--------------------------------------------