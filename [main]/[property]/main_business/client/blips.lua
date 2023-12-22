
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
	blips[marker]:setData('icon', 'player_business')
end

function updateBlips()

	local login = localPlayer:getData('unique.login')
	for _, business in pairs( getElementsByType('marker', resourceRoot) ) do
		local data = business:getData('business.data') or {}
		if data.owner == login then
			addBlip(business)
		else
			removeBlip(business)
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
	if dataName == 'business.data' then
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
				local data = marker:getData('business.data') or {}
				if data.owner == '' then
					local blip = createBlipAttachedTo(marker, 0)
					blip:setData('icon', 'free_business')
					freeBlips[blip] = true
				end
			end

		end

	end

------------------------------------------------------------------------------------

	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

		if dn == 'hud_map.display_business' then
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
				local data = marker:getData('business.data') or {}
				if data.owner ~= '' and data.owner ~= localLogin then
					local blip = createBlipAttachedTo(marker, 0)
					blip:setData('icon', 'used_business')
					usedBlips[blip] = true
				end
			end

		end

	end

	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

		if dn == 'hud_map.display_used_business' then
			toggleUsedBlips(new)
		end

	end)

------------------------------------------------------------------------------------