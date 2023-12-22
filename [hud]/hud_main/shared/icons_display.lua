
---------------------------------

	function addPlayerHUDRow( player, row_icon, row_data, priority )
		return togglePlayerHUDRow( player, row_icon, true, row_data, priority )
	end

	function removePlayerHUDRow( player, row_icon )
		return togglePlayerHUDRow( player, row_icon, false )
	end

	function togglePlayerHUDRow( player, row_icon, flag, row_data, priority )
		
		if localPlayer then

			if flag then

				if not currentHUDRows[row_icon] then
					currentHUDRows[row_icon] = { tick = getTickCount(), data_name = row_data, priority = priority }
				end

			else

				if currentHUDRows[row_icon] then

					animate(currentHUDRows[row_icon], 0, function()
						removeAnimData(currentHUDRows[row_icon])
						currentHUDRows[row_icon] = nil
					end)

				end
				


			end

		else
			triggerClientEvent(player, 'hud_main.toggleHUDRow', resourceRoot, player, row_icon, flag, row_data, priority)
		end

	end
	addEvent('hud_main.toggleHUDRow', true)
	addEventHandler('hud_main.toggleHUDRow', resourceRoot, togglePlayerHUDRow)

---------------------------------

	function addPlayerHUDIcon( player, row_icon )
		return togglePlayerHUDIcon( player, row_icon, true )
	end

	function removePlayerHUDIcon( player, row_icon )
		return togglePlayerHUDIcon( player, row_icon, false )
	end

	function togglePlayerHUDIcon( player, row_icon, flag )
		
		if localPlayer then

			if flag then

				if not currentHUDIcons[row_icon] then
					currentHUDIcons[row_icon] = { tick = getTickCount() }
				end

			else

				if currentHUDIcons[row_icon] then

					animate(currentHUDIcons[row_icon], 0, function()
						removeAnimData(currentHUDIcons[row_icon])
						currentHUDIcons[row_icon] = nil
					end)

				end
				


			end

		else

			triggerClientEvent(player, 'hud_main.toggleHUDIcon', resourceRoot, player, row_icon, flag)

		end

	end
	addEvent('hud_main.toggleHUDIcon', true)
	addEventHandler('hud_main.toggleHUDIcon', resourceRoot, togglePlayerHUDIcon)

---------------------------------
