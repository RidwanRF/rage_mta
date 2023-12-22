

---------------------------------------------------------------------------

	ammoSpend = {}

---------------------------------------------------------------------------

	function updateWeaponControl()

		local item, config, slot = getCurrentHandsItem(localPlayer)
		local controlState = true

		-- if config and config.type ~= 'weapon' then
		-- 	return
		-- end

		if config and config.ammo then
			controlState = (item.data.ammo or 0) > 0
		end

		local isEmpty = localPlayer:getData('weapon.slot') == 0

		if not controlState then
			setControlState('fire', false)
			setControlState('action', false)
		end

		toggleControl('fire', isEmpty or (controlState
			and not exports['main_weapon_zones']:isPlayerInZone(localPlayer))
		)
		toggleControl('action', isEmpty or (controlState
			and not exports['main_weapon_zones']:isPlayerInZone(localPlayer))
		)

	end

	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)
		if (dn == 'inventory' and ( inspect( (old or {}).weapon ) ~= inspect( (new or {}).weapon ) )) or dn == 'weapon.slot' then
			updateWeaponControl()
		end
	end)

	addEventHandler('onClientColShapeHit', root, function()
		updateWeaponControl()
	end)

	addEventHandler('onClientColShapeLeave', root, function()
		updateWeaponControl()
	end)

	setTimer(updateWeaponControl, 10000, 0)

	-- addEventHandler('onClientRender', root, function()
	-- 	local item, config, slot = getCurrentHandsItem(localPlayer)
	-- 	local controlState = true

	-- 	if config and config.ammo then
	-- 		controlState = item.data.ammo > 0
	-- 	end

	-- 	if not controlState then
	-- 		setControlState('fire', false)
	-- 	end

	-- 	toggleControl('fire', controlState)
	-- end)

---------------------------------------------------------------------------


	setTimer(function()

		if getTableLength(ammoSpend) <= 0 then return end

		-- localPlayer:setData('inventory.weapon',
		-- 	localPlayer:getData('inventory.weapon')
		-- )

		triggerServerEvent('weapon.sync_ammo_spend', resourceRoot, ammoSpend)

		ammoSpend = {}

	end, 1000, 0)

	addEvent('weapon.receiveSlot', true)
	addEventHandler('weapon.receiveSlot', resourceRoot, function(slot)
		localPlayer:setData('weapon.slot', slot, false)
	end)

	addEvent('weapon.receiveInventory', true)
	addEventHandler('weapon.receiveInventory', resourceRoot, function(inventory)
		localPlayer:setData('inventory', inventory, false)
	end)


---------------------------------------------------------------------------

	addEventHandler('onClientPlayerWeaponFire', localPlayer, function(weapon, ammo)
		local slot = localPlayer:getData('weapon.slot') or 0
		if not slot or slot == 0 then return end
		ammoSpend[slot] = (ammoSpend[slot] or 0) + 1
		spendWeaponAmmo(localPlayer, 1)
	end)

---------------------------------------------------------------------------

	addEventHandler('onClientResourceStart', resourceRoot, function()
		toggleControl('next_weapon', false)
		toggleControl('previous_weapon', false)
	end)

---------------------------------------------------------------------------


	local lastAction = getTickCount()
	function onWeaponKey(key)

		if isCursorShowing() then return end

		if ( getTickCount() - lastAction ) < 100 then
			return
		end

		lastAction = getTickCount()

		if key == 'r' then
			triggerServerEvent('weapon.reload', resourceRoot, localPlayer)
		else
			triggerServerEvent('weapon.onKey', resourceRoot, localPlayer, key)
		end

	end

	bindKey('mouse_wheel_down', 'both', onWeaponKey)
	bindKey('mouse_wheel_up', 'both', onWeaponKey)
	bindKey('r', 'down', onWeaponKey)

---------------------------------------------------------------------------
	
	addEventHandler('onClientKey', root, function(button)

		if (button:find('mouse_wheel')) and getKeyState('mouse2') then
			cancelEvent()
		end

	end)

---------------------------------------------------------------------------