
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
	blips[marker]:setData('icon', 'player_derrick')
end

function updateBlips()

	local login = localPlayer:getData('unique.login')
	for _, derrick in pairs( getElementsByType('marker', resourceRoot) ) do
		local data = derrick:getData('derrick.data') or {}
		if data.owner == login then
			addBlip(derrick)
		else
			removeBlip(derrick)
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
	if dataName == 'derrick.data' then
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

------------------------------------------------------------------------------------

	freeBlips = {}

	function toggleFreeBlips(state)

		for blip in pairs(freeBlips) do
			destroyElement(blip)
		end

		freeBlips = {}

		if state then

			for _, marker in pairs( getElementsByType('marker', resourceRoot) ) do
				local data = marker:getData('derrick.data') or {}
				if data.owner == '' then
					local blip = createBlipAttachedTo(marker, 0)
					blip:setData('icon', 'free_derrick')
					freeBlips[blip] = true
				end
			end

		end

	end

	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

		if dn == 'hud_map.display_derricks' then
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
				local data = marker:getData('derrick.data') or {}
				if data.owner ~= '' and data.owner ~= localLogin then
					local blip = createBlipAttachedTo(marker, 0)
					blip:setData('icon', 'used_derrick')
					usedBlips[blip] = true
				end
			end

		end

	end

	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

		if dn == 'hud_map.display_used_derricks' then
			toggleUsedBlips(new)
		end

	end)


------------------------------------------------------------------------------------

