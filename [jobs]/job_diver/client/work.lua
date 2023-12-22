

--------------------------------------------------------------------------------

	local current_pick_marker

	function createMarkerBind(marker)

		current_pick_marker = marker

		createBindHandler(marker, 'f', 'Обыскать', function(marker)

			if not isElementInWater( localPlayer ) then return end

			exports.hud_notify:notify('Водолаз', 'Поиск ценностей...')

			setTimer(function()

				triggerServerEvent('diver.lootMarker', resourceRoot, marker)

			end, 2000, 1)
			
			removeBindHandler(marker)

		end)

	end
	addEvent('diver.createLootBind', true)
	addEventHandler('diver.createLootBind', resourceRoot, createMarkerBind)

--------------------------------------------------------------------------------

	addCommandHandler('diver_pick_all', function()

		if exports.acl:isAdmin( localPlayer ) then

			if isElement(current_pick_marker) then
				triggerServerEvent('diver.lootMarker', resourceRoot, current_pick_marker)
			end

		end

	end)

--------------------------------------------------------------------------------

	function savePlayerDrowning()

		local _, _, z = getElementPosition( localPlayer )
		if (localPlayer:getData('diver.oxygen') or 0) > 0 and isElementInWater(localPlayer) and z < 0 then
			setPedOxygenLevel( localPlayer, 1000 )
			setFPSLimit(50)
		else
			setFPSLimit(100)
		end


	end

	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

		if dn == 'work.current' then

			if new == Config.resourceName then
				addEventHandler('onClientRender', root, savePlayerDrowning)
			else
				removeEventHandler('onClientRender', root, savePlayerDrowning)
				setFPSLimit(100)
			end

		end

	end)

--------------------------------------------------------------------------------