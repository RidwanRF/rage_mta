
addEventHandler('onClientResourceStart', resourceRoot, function()

	for id, position in pairs( Config.positions ) do

		local marker

		for _, side in pairs({'from', 'to'}) do

			local x,y,z = unpack( position[side] )
			marker = createMarker(
				x,y,z,
				'cylinder',
				1,
				34, 29, 144, 150
			)

			marker:setData('transfer.side', side)
			marker:setData('transfer.pos_id', id)
			marker:setData('transfer.type', position.type)
			marker:setData('transfer.marker', true)

			if position.blip then
				local blip = createBlipAttachedTo(marker, 0)
				blip:setData('icon', 'transfer')
			end

			local names = {
				water = 'Водная переправа',
				vehicle = 'Автостанция',
				air = 'Аэропорт',
			}

			marker:setData('3dtext', string.format('[%s]',
				names[position.type]
			))

			addEventHandler('onClientMarkerHit', marker, function(player, mDim)

				if player == localPlayer and mDim and player.interior == source.interior and not windowOpened and not player.vehicle then

					local pos_id, side = 
						source:getData('transfer.pos_id'),
						source:getData('transfer.side')

					local other_side = side == 'from' and 'to' or 'from'

					local config = Config.positions[pos_id]

					local action_names = {
						water = 'Переплыть',
						vehicle = 'Переехать',
						air = 'Перелететь',
					}

					local cost = config.cost

					if exports.main_levels:getPlayerLevel( localPlayer ) <= Config.freeLevel then
						cost = 0
					end

					dialog('Транспорт', {
						string.format('%s из %s в %s',
							action_names[config.type], config[other_side].name, config[side].name
						),
						string.format('обойдётся вам в #cd4949$#ffffff%s',
							splitWithPoints(cost, '.')
						),
						'Продолжить?',
					}, function(result)

						if result then

							triggerServerEvent('transfer_system.transfer', resourceRoot,
								pos_id, other_side
							)

						end

					end)

				end

			end)

		end


	end

end)