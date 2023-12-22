
------------------------------------------------

	function createSliceMarker()

		local slice_markers = workMarker.slice_markers

		local last_marker = slice_markers[ #slice_markers ]
		if not last_marker then return false end

		workMarker.marker = last_marker.marker

		workMarker.marker:setData('controlpoint.3dtext', '[Разрубите дерево]')
		createMarkerHelpHandler( workMarker.marker )

		if #slice_markers == 1 then

			addEventHandler('onClientMarkerHit', workMarker.marker, function( player, mDim )

				if player == localPlayer and mDim and player.interior == source.interior then

					sliceCurrentMarker()

					orderLogLoad( function()

						if not createSliceMarker() then
							completeWorkMarker()
						end

					end )
					
				end

			end)

		end

		return workMarker.marker

	end

------------------------------------------------

	function getCurrentSliceMarker()

		local slice_markers = workMarker.slice_markers

		local last_marker = slice_markers[ #slice_markers ]
		if not last_marker then return end

		return last_marker

	end

------------------------------------------------
	
	function sliceCurrentMarker()

		clearObjectTexture(workMarker.tree, 'bark_' .. (6-#workMarker.slice_markers) )

		local marker = getCurrentSliceMarker()

		clearTableElements( marker )
		table.remove( workMarker.slice_markers )

	end

------------------------------------------------