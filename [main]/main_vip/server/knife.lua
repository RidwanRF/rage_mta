

function toggleKnife(player, flag)

	if flag then

		exports.main_inventory:removeInventoryItem({
			player = player,
			key = 'vip_knife',
		})

		exports.main_inventory:addInventoryItem({

			player = player,
			item = 'weapon_bat',
			data = { vip_knife = true },
			count = 1,

		})

	else

		exports.main_inventory:removeInventoryItem({
			player = player,
			key = 'vip_knife',
		})

	end

end


addEventHandler('onElementDataChange', root, function(dn, old, new)

	if dn == 'vip' and source.type == 'player' then


		toggleKnife(source, new)

	end

end)