
----------------------------------------------------------------------------

	blips = {}

	function removeBlip(marker)

		if isElement(blips[marker]) then
			destroyElement(blips[marker])
		end

		blips[marker] = nil

	end

	function addBlip(marker)
		if isElement(blips[marker]) then return end
		blips[marker] = createBlipAttachedTo(marker, 0)
		blips[marker]:setData('icon', 'player_house')
	end

	function updateBlips()

		local login = localPlayer:getData('unique.login')
		for _, house in pairs( getElementsByType('marker', resourceRoot) ) do
			local data = house:getData('house.data') or {}
			if data.owner == login then
				addBlip(house)
			else
				removeBlip(house)
			end
		end

	end

	addEventHandler('onClientElementDataChange', localPlayer, function(dataName, old, new)
		if dataName == 'unique.login' then
			updateBlips()
		end
	end)

	addEventHandler('onClientResourceStart', resourceRoot, updateBlips)

	addEventHandler('onClientElementDataChange', resourceRoot, function(dataName, old, new)
		if dataName == 'house.data' then
			if new.owner == localPlayer:getData('unique.login') then
				addBlip(source)
			else
				removeBlip(source)
			end
		end
	end)

	addEventHandler('onClientElementDestroy', resourceRoot, function()
		removeBlip(source)
	end)


----------------------------------------------------------------------------

	freeBlips = {}

	function toggleFreeBlips(state)

		for blip in pairs(freeBlips) do
			destroyElement(blip)
		end

		freeBlips = {}

		if state then

			for _, marker in pairs( getElementsByType('marker', resourceRoot) ) do
				if marker.dimension == 0 and marker.interior == 0 then

					local data = marker:getData('house.data') or {}
					if data.owner == '' then
						local blip = createBlipAttachedTo(marker, 0)
						blip:setData('icon', 'free_house')
						freeBlips[blip] = true
					end

				end


			end

		end

	end


	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

		if dn == 'hud_map.display_houses' then
			toggleFreeBlips(new)
		end

	end)

------------------------------------------------------------------------------------

	usedBlips = {}

	function toggleUsedBlips(state)

		for blip in pairs(usedBlips) do
			destroyElement(blip)
		end

		local localLogin = localPlayer:getData('unique.login')

		usedBlips = {}

		if state then

			for _, marker in pairs( getElementsByType('marker', resourceRoot) ) do
				if not marker:getData('house.exit') and marker.dimension == 0 and marker.interior == 0 then

					local data = marker:getData('house.data') or {}
					if data.owner ~= '' and data.owner ~= localLogin then
						local blip = createBlipAttachedTo(marker, 0)
						blip:setData('icon', 'used_house')
						usedBlips[blip] = true
					end
					
				end
			end

		end

	end

	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

		if dn == 'hud_map.display_used_houses' then
			toggleUsedBlips(new)
		end

	end)

------------------------------------------------------------------------------------