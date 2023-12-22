
-----------------------------------------------------------------

	function getEmptyInventory()
		return {
			inventory = {},
			weapon = {},
			equipment = {},
		}
	end

-----------------------------------------------------------------

	function getItemConfig(item)
		if not item then return false end
		return Config.items[item.item]
	end

	function getCurrentHandsItem(player)
		local inventory = ( player:getData('inventory') or {} ).weapon or {}
		local slot = player:getData('weapon.slot') or 0

		local item = inventory[slot]
		local config

		if item then
			config = Config.items[item.item]
		end

		return item, config, slot

	end

	function spendWeaponAmmo(player, ammo)
		local slot = player:getData('weapon.slot') or 0
		local weapon = ( player:getData('inventory') or {} ).weapon or {}
		if weapon[slot] and weapon[slot].data then

			weapon[slot].data.ammo = math.max( (weapon[slot].data.ammo or 0)  - ammo, 0)
			weapon[slot].data.inClip = weapon[slot].data.ammo == 0 and 0 or getPedAmmoInClip(player)

			if localPlayer then
				toggleControl('fire', weapon[slot].data.ammo > 0)
			else
				toggleControl(player, 'fire', weapon[slot].data.ammo > 0)
			end

		end



		local inventory = player:getData('inventory') or {}
		inventory.weapon = weapon

		player:setData('inventory', inventory, false)

		if not isElement(localPlayer) then
			triggerClientEvent( player, 'weapon.receiveInventory', resourceRoot, inventory )
		end

	end

-----------------------------------------------------------------

	function hasInventoryItem(args)

		local inventory = args.inventory or ( isElement(args.player) and args.player:getData('inventory') or false )
		if not inventory then return end

		for section_name, section in pairs( inventory ) do

			for index, item in pairs(section) do
				if item.item == args.item then
					return section_name, index
				end
			end

		end

	end

-----------------------------------------------------------------