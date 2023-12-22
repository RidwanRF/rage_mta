
-------------------------------------------------------------------------------------

	function updatePlayerWeapon(player, _resetWeapon)

		local resetWeapon = (_resetWeapon == nil or _resetWeapon) and true or false

		local data = ( player:getData('inventory') or {} ).weapon or {}
		local wSlot = player:getData('weapon.slot') or 0
		local weapon = data[wSlot]


		if resetWeapon then
			takeAllWeapons(player)
		end

		if weapon then

			local config = Config.items[weapon.item]

			if config.type == 'weapon' then

				removePlayerCustomObject(player)

				if resetWeapon then
					giveWeapon(player, config.model, 99999999)
					weapon.data = weapon.dataName or {}
					setWeaponAmmo(player, config.model, 99999999, (weapon.data.inClip or config.ammo) or 1)
					setPedWeaponSlot(player, Config.weaponSlots[config.model])
				end

				-- if config.ammo then
				-- 	setTimer(toggleControl, 50, 1, player, 'fire', weapon.data.ammo > 0)
				-- end

			else

				if resetWeapon then
					setPlayerCustomObject(player, config)
				end

			end

		else

			removePlayerCustomObject(player)

		end
	end

-------------------------------------------------------------------------------------

	addEventHandler('onElementDataChange', root, function(dataName, old, new)
		if dataName == 'inventory' and new then

			local oldSlots = {}
			local newSlots = {}

			for _, slot in pairs( (old or {}).weapon or {} ) do
				table.insert(oldSlots, slot.item)
			end

			for _, slot in pairs( (new or {}).weapon or {} ) do
				table.insert(newSlots, slot.item)
			end

			updatePlayerWeapon(source,
				table.concat(oldSlots) ~= table.concat(newSlots)
			)

		elseif dataName == 'weapon.slot' then

			updatePlayerWeapon(source)
		end
	end)

	addEventHandler('onResourceStart', resourceRoot, function()
		for _, player in pairs( getElementsByType('player') ) do
			if player.account then
				updatePlayerWeapon(player,
					( player:getData('inventory') or {} ).weapon or {}
				)
			end
		end
	end)

	addEventHandler('onPlayerSpawn', root, function()
		if source.account then
			updatePlayerWeapon(source,
				( source:getData('inventory') or {} ).weapon or {}
			)
		end
	end)

-------------------------------------------------------------------------------------

	local lastWeaponScrolls = {}

	function onWeaponKey(player, key)

		if lastWeaponScrolls[player] and (
			getTickCount() - lastWeaponScrolls[player]
		) < 100 then return end

		if player:getData('server.item_using') then return end
		if player:getData('inventory.hands_disabled') then return end

		if player:getData('prison.time') then return end

		
		if player.vehicle then
			return
		end

		lastWeaponScrolls[player] = getTickCount()

		local wSlot = player:getData('weapon.slot') or 0
		wSlot = wSlot + (key == 'mouse_wheel_down' and 1 or -1)

		if wSlot > 2 then wSlot = 0 end
		if wSlot < 0 then wSlot = 2 end

		player:setData('weapon.slot', wSlot, false)
		triggerClientEvent(player, 'weapon.receiveSlot', resourceRoot, wSlot)

	end
	addEvent('weapon.onKey', true)
	addEventHandler('weapon.onKey', resourceRoot, onWeaponKey)

	function reloadWeapon(player)
		local slot = player:getData('weapon.slot') or 0
		local inventory = ( player:getData('inventory') or {} ).weapon or {}

		local weapon = inventory[slot]
		if weapon then
			local config = Config.items[weapon.item]
			if config and config.type == 'weapon' and getPedAmmoInClip(player) < (config.ammo or 0) then
				reloadPedWeapon(player)
				setTimer(spendWeaponAmmo, config.reloadTime or 1500, 1, player, 0)
			end
		end
	end
	addEvent('weapon.reload', true)
	addEventHandler('weapon.reload', resourceRoot, reloadWeapon)

	addEventHandler('onVehicleStartEnter', root, function(player)
		player:setData('weapon.slot', 0)
	end)

	function setInventoryHandSlotsEnabled(player, state)
		player:setData('inventory.hands_disabled', not state, false)
	end

-------------------------------------------------------------------------------------

	function receivePlayerWeapon(ammoSpend)

		local inventory = client:getData('inventory') or {}
		local reload = false

		for slot, amount in pairs( ammoSpend ) do

			if inventory.weapon[slot] and inventory.weapon[slot].data then

				inventory.weapon[slot].data.ammo = math.max( (inventory.weapon[slot].data.ammo or 0) - amount, 0)
				inventory.weapon[slot].data.inClip = getPedAmmoInClip(client)

				if inventory.weapon[slot].data.inClip <= 0 then
					reload = true
				end

			end

		end

		client:setData('inventory', inventory, false)

		if reload then
			setTimer(spendWeaponAmmo, 2000, 1, client, 0)
		end

		-- triggerClientEvent(client, 'weapon.receiveInventory', resourceRoot, inventory)

	end
	addEvent('weapon.sync_ammo_spend', true)
	addEventHandler('weapon.sync_ammo_spend', root, receivePlayerWeapon)
	

-------------------------------------------------------------------------------------

	function spendWeaponHealth( slot, amount )

		local inventory = client:getData('inventory') or {}

		if not inventory.weapon[slot] then return false end

		local config = Config.items[ inventory.weapon[slot].item ]
		if not config then return end

		if config.health then

			local data = inventory.weapon[slot].data

			data.health = (
				data.health or configHealth
			) - amount

			if data.health <= 0 then

				exports.hud_notify:notify(client, 'Оружие износилось', 'Вы сломали оружие')

				if data.ammo > 0 then
					addInventoryItem({
						player = client,
						item = config.ammo_access,
						count = data.ammo,	
					})
				end

				return removeInventoryItem( {
					player = client,
					section = 'weapon',	
					id = slot,
				} )

			end

		end

		client:setData('inventory', inventory, false)

	end

	addEventHandler('weapon.sync_ammo_spend', root, function( ammoSpend )

		-- for slot, amount in pairs( ammoSpend ) do
		-- 	spendWeaponHealth( slot, amount )
		-- end

		local inventory = client:getData('inventory') or {}
		triggerClientEvent(client, 'weapon.receiveInventory', resourceRoot, inventory)

	end)


-------------------------------------------------------------------------------------