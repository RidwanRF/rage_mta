
------------------------------------------------------------------------------------

	teams_blips = {}

	function teams_toggleBlips(state)

		for blip in pairs(teams_blips) do
			destroyElement(blip)
		end

		teams_blips = {}

		if state then

			for _, marker in pairs( getElementsByType('marker', resourceRoot) ) do
				local data = marker:getData('business.data') or {}
				if data.clan_area_type then
					local blip = createBlipAttachedTo(marker, 0)
					blip:setData('icon', 'team_area')
					teams_blips[blip] = true
				end
			end

		end

	end

------------------------------------------------------------------------------------

	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

		if dn == 'hud_map.display_areas' then
			teams_toggleBlips(new)
		end

	end)

------------------------------------------------------------------------------------
