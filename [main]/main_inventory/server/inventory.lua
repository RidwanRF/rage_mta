
--------------------------------------------------------

	function addInventoryItem( args )

		if type(args) ~= 'table' then return false end
		if not args.item then return false end
		if args.count == 0 then return false end

		local inventory, player_inventory

		local config = Config.items[args.item]
		if not config then return end

		if isElement(args.player) then

			player_inventory = args.player:getData('inventory') or getEmptyInventory()

			local section = args.section or 'inventory'

			inventory = player_inventory[ section ] or {}
			player_inventory[ section ] = inventory

		elseif args.account then

			if args.account.player then
				args.player = args.account.player
				return addInventoryItem( args )
			end

			player_inventory = fromJSON( args.account:getData('inventory') or '[[]]' ) or getEmptyInventory()

			local section = args.section or 'inventory'

			inventory = player_inventory[ section ] or {}
			player_inventory[ section ] = inventory


		elseif args.inventory then

			inventory = args.inventory

		else

			return false

		end

		local chance = 0

		if args.slot then

			local slot_data = inventory[args.slot]

			if slot_data then

				if slot_data.item == args.item then

					local count = math.min( args.count, ( config.max_stack - slot_data.count ) )
					chance = args.count - count

					slot_data.count = slot_data.count + count

				end


			else

				local count = math.min( args.count, ( config.max_stack ) )
				chance = args.count - count	

				local data = args.data

				if config.type == 'weapon' then
					data = data or {}
					data.health = config.health
				end

				inventory[args.slot] = {
					item = args.item,
					count = count,
					data = data,
				}

			end

		else

			local slot = getFreeSlot(inventory, args.item)
			args.slot = slot
			return addInventoryItem(args)

		end

		if isElement(args.player) then
			args.player:setData('inventory', player_inventory)
		elseif args.account then
			args.account:setData('inventory', toJSON(player_inventory))
		end

		if chance > 0 then
			args.count = chance
			args.slot = nil
			return addInventoryItem(args)
		end

		return inventory

	end

	function getFreeSlot( inventory, item )

		local config = Config.items[item]

		for index, i_item in pairs( inventory ) do

			if i_item.item == item and (i_item.count or 0) < config.max_stack then
				return index
			end

		end

		local index = 1

		while true do

			if not inventory[index] then
				return index
			end

			index = index + 1

		end

	end

--------------------------------------------------------

	function removeInventoryItem( args )

		if not args then return end

		if not isElement(args.player) then return end
		local inventory = args.player:getData('inventory') or {}

		if args.key then

			for _, inventory_section in pairs( inventory ) do

				for index, item in pairs( inventory_section ) do

					if item.data and ( ( not args.value and item.data[args.key] ) or (item.data[args.key] == args.value and args.value ~= nil) ) then

						inventory_section[ index ] = nil

					end

				end

			end

		elseif args.id and args.section then

			inventory[ args.section ][ args.id ] = nil

		end

		args.player:setData('inventory', inventory)

	end

--------------------------------------------------------

	function moveItem(from, to)

		local source_element = from.source

		local old_inventory = source_element:getData('inventory') or {}
		local new_inventory = source_element:getData('inventory') or {}

		new_inventory[from.section] = new_inventory[from.section] or {}
		new_inventory[to.section] = new_inventory[to.section] or {}

		old_inventory[from.section] = old_inventory[from.section] or {}
		old_inventory[to.section] = old_inventory[to.section] or {}

		local item_ids = {
			(new_inventory[from.section][from.slot] or {}).item or '',
			(new_inventory[to.section][to.slot] or {}).item or '',
		}

		local item_types = {
			(Config.items[ item_ids[1] ] or {}).type or '',
			(Config.items[ item_ids[2] ] or {}).type or '',
		}


		local concat_rule = string.format('%s-%s', unpack(item_types))

		if item_ids[1] == item_ids[2] then
			concat_rule = 'general_equal_types'
		end

		local c_from, c_to = false, false

		if concatRules[concat_rule] then

			c_from, c_to = (concatRules[concat_rule])(
				new_inventory[from.section][from.slot], new_inventory[to.section][to.slot]
			)

		end

		if ( c_from ~= false and c_to ~= false ) then
			new_inventory[from.section][from.slot], new_inventory[to.section][to.slot] = c_from, c_to
		else

			local item_access = {
				(Config.item_access[item_types[1]] or {})[to.section],
				(Config.item_access[item_types[2]] or {})[from.section],
			}

			c_from, c_to = old_inventory[to.section][to.slot], old_inventory[from.section][from.slot]

			if not (item_access[1] and ( not to.item or item_access[2] )) then
				c_from, c_to = c_to, c_from
			end

			new_inventory[to.section][to.slot] = c_to
			new_inventory[from.section][from.slot] = c_from



		end

		source_element:setData('inventory', new_inventory)
		triggerClientEvent(client, 'inventory.sync_callback', resourceRoot)

	end
	addEvent('inventory.moveItem', true)
	addEventHandler('inventory.moveItem', resourceRoot, moveItem)----

--------------------------------------------------------

	function moveElementItem(from, to, exchangeParams)


		local old_inventory = from.source:getData('inventory') or {}
		local new_inventory = to.source:getData('inventory') or {}

		new_inventory[from.section] = new_inventory[from.section] or {}
		new_inventory[to.section] = new_inventory[to.section] or {}

		old_inventory[from.section] = old_inventory[from.section] or {}
		old_inventory[to.section] = old_inventory[to.section] or {}

		local item_ids = {
			(old_inventory[from.section][from.slot] or {}).item or '',
			(new_inventory[to.section][to.slot] or {}).item or '',
		}

		local item_types = {
			(Config.items[ item_ids[1] ] or {}).type or '',
			(Config.items[ item_ids[2] ] or {}).type or '',
		}

		if (
			from.source:getData('mansion.inventory')
			or to.source:getData('mansion.inventory')
		) then

			if not client.team then return end

			local mansion = (
				from.source:getData('mansion.parent_marker')
				or to.source:getData('mansion.parent_marker')
			)
			local mansion_data = mansion:getData('mansion.data') or {}

			local team_data = client.team:getData('team.data') or {}
			if team_data.id ~= mansion_data.owner then
				return exports.hud_notify:notify(client, 'Ошибка', 'Это не ваш общак')
			end

		end
		
		if from.source:getData('mansion.inventory') then

			if from.source ~= client then

				if item_types[1] == 'weapon' and not exports.teams_main:hasPlayerRight(client, 'inventory_weapon') then
					return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно прав')
				end

				if item_types[1] == 'ammo' and not exports.teams_main:hasPlayerRight(client, 'inventory_ammo') then
					return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно прав')
				end

			end

		end


		if exchangeParams and exchangeParams.item_types and not (
			(exchangeParams.item_types[ item_types[1] ] or item_types[1] == '')
			and (exchangeParams.item_types[ item_types[2] ] or item_types[2] == '')
		) then
			return
		end


		local concat_rule = string.format('%s-%s', unpack(item_types))

		if item_ids[1] == item_ids[2] then
			concat_rule = 'general_equal_types'
		end

		local c_from, c_to = false, false

		if concatRules[concat_rule] then

			c_from, c_to = (concatRules[concat_rule])(
				old_inventory[from.section][from.slot], new_inventory[to.section][to.slot]
			)

		end

		if ( c_from ~= false and c_to ~= false ) then
			old_inventory[from.section][from.slot], new_inventory[to.section][to.slot] = c_from, c_to
		else

			local item_access = {
				(Config.item_access[item_types[1]] or {})[to.section],
				(Config.item_access[item_types[2]] or {})[from.section],
			}

			c_from, c_to = new_inventory[to.section][to.slot], old_inventory[from.section][from.slot]

			if not (item_access[1] and ( not to.item or item_access[2] )) then
				c_from, c_to = c_to, c_from
			end

			new_inventory[to.section][to.slot] = c_to
			old_inventory[from.section][from.slot] = c_from


		end

		from.source:setData('inventory', old_inventory)
		to.source:setData('inventory', new_inventory)

		if from.source ~= client and from.source:getData('mansion.inventory') and client.team then

			local team_data = client.team:getData('team.data') or {}

			local item = Config.items[ c_to.item ]

			if item then

				exports.teams_main:appendTeamHistory( team_data.id,
					('#cd4949%s#ffffff взял из общака %s x%s'):format(
						exports.teams_main:formatPlayerName( client ),
						item.name, c_to.count
					)
				)

			end

		end

		triggerClientEvent(client, 'inventory.sync_callback', resourceRoot)

	end
	addEvent('inventory.moveElementItem', true)
	addEventHandler('inventory.moveElementItem', resourceRoot, moveElementItem)

--------------------------------------------------------

	function dropItem(item)

		local new_inventory = client:getData('inventory') or {}

		new_inventory[item.section][item.slot] = nil

		client:setData('inventory', new_inventory)
		triggerClientEvent(client, 'inventory.sync_callback', resourceRoot)

	end
	addEvent('inventory.dropItem', true)
	addEventHandler('inventory.dropItem', resourceRoot, dropItem)

--------------------------------------------------------
	
	function usePlayerItem(player, item)
		return useItem(item, player)
	end

--------------------------------------------------------

	function useItem(item, _player)

		if client and client:getData('binds.disabled') then
			return exports.hud_notify:notify(client, 'Ошибка', 'Действие недоступно')
		end

		local player = isElement(_player) and _player or client


		local new_inventory = player:getData('inventory') or {}
		local inv_item = new_inventory[item.section][item.slot]
		if not inv_item then return end

		local config = getItemConfig(inv_item)

		local count = config:use(player) or 1

		inv_item.count = inv_item.count - count

		if inv_item.count <= 0 then
			new_inventory[item.section][item.slot] = nil
		end

		player:setData('inventory', new_inventory)

	end
	addEvent('inventory.useItem', true)
	addEventHandler('inventory.useItem', resourceRoot, useItem)

--------------------------------------------------------

	addCommandHandler('inventory_give_item', function(player, _, login, item, count, slot)

		if exports.acl:isAdmin(player) then

			local account = getAccount(login)

			if account.player then

				addInventoryItem({

					player = account.player,	
					item = item,
					count = tonumber(count) or 1,
					slot = tonumber(slot),


				})

				exports.chat_main:displayInfo(player, 'inventory_give_item succesfully', {0,255,0})

			end

		end

	end)

	addCommandHandler('clearinventory', function(player, _, login)

		if exports.acl:isAdmin(player) then

			local account = getAccount(login)

			if account.player then

				account.player:setData('inventory', getEmptyInventory())

			end

		end

	end)

--------------------------------------------------------