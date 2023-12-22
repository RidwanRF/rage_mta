

--------------------------------------------------------------------------------

	function isKillListVibible()
		return not exports.main_weapon_zones:isPlayerInZone( localPlayer )
	end

--------------------------------------------------------------------------------

	killList = {}

	function renderKillList()

		if not localPlayer:getData('settings.kill_list') then return end

		local h = 25

		local sCount = #killList/2

		local startY = (( real_sy ) * sx/real_sx)/2 - h*sCount
		local startX = sx - 20

		local font = getFont('montserrat_semibold', 25, 'light', true)

		for _, row in pairs( killList ) do

			local tw = dxGetTextWidth( row.player, 0.5, font )

			local texture = getDrawingTexture( ('assets/images/weapon/%s.png'):format( row.weapon ) )
			local mw,mh = dxGetMaterialSize( texture )

			local alpha = getAnimData( row.id )

			if alpha then

				dxDrawText(row.player,
					startX - 20*alpha, startY,
					startX - 20*alpha, startY,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, font,
					'right', 'center'
				)

				dxDrawImage(
					startX - 20*alpha - tw - mw - 10, startY - mh/2,
					mw,mh, texture,
					0, 0, 0, tocolor(180,70,70,255*alpha)
				)

				dxDrawText(row.killer,
					startX - 20*alpha - tw - mw - 10 - 10, startY,
					startX - 20*alpha - tw - mw - 10 - 10, startY,
					tocolor(255,255,255,255*alpha),
					0.5, 0.5, font,
					'right', 'center'
				)

			end

			startY = startY + h * ( alpha or 0 )

		end

	end
	addEventHandler('onClientRender', root, renderKillList)

--------------------------------------------------------------------------------

	function removeKillListRow( index )

		table.remove( killList, index )

	end

--------------------------------------------------------------------------------
	
	function appendKillList( player, killer, weapon )

		if not fileExists( ('assets/images/weapon/%s.png'):format( weapon ) ) then
			return
		end

		if #killList >= 10 then
			removeKillListRow( 1 )
		end

		local row = {
			player = player,
			killer = killer,
			weapon = weapon,
			id = {},
		}

		setAnimData( row.id, 0.1 )
		animate( row.id, 1 )

		row.timer = setTimer( function()

			animate( row.id, 0, function()

				for index, _row in pairs( killList ) do
					if _row.id == row.id then
						table.remove( killList, index )
					end
				end

			end )

		end, 12000, 1 )

		table.insert(killList, row)

	end

	addCommandHandler('kl_insert', function(_, player, killer, weapon)
		appendKillList( player, killer, tonumber(weapon) or 0 )
	end)

--------------------------------------------------------------------------------

	addEventHandler('onClientPlayerWasted', root, function( killer, weapon )

		if isElement(killer) and killer.dimension == localPlayer.dimension then
			appendKillList( source.name, killer.name, weapon )
		end

	end)


--------------------------------------------------------------------------------