
local peds = {}

function copyPed(player)

	local inventory, weapon, equipment = 
		player:getData('inventory.inventory') or {},
		player:getData('inventory.weapon') or {},
		player:getData('inventory.equipment') or {}

	local slot = player:getData('weapon.slot') or {}

	local x,y,z = getElementPosition(player)
	local rx,ry,rz = getElementRotation(player)

	local ped = createPed(player.model, x,y,z, rz)
	ped:setData('inventory.inventory', inventory)
	ped:setData('inventory.weapon', weapon)
	ped:setData('inventory.equipment', equipment)
	ped:setData('weapon.slot', slot)

	setElementPosition(player, x,y+2,z)

	table.insert(peds, ped)

end

addCommandHandler('copyped', function(player, _)
	if exports.acl:isAdmin(player) then
		copyPed(player)
	end
end)

addCommandHandler('copyped_clear_prev', function(player, _)
	if exports.acl:isAdmin(player) and peds[#peds] then
		destroyElement(peds[#peds])
		peds[#peds] = nil
	end
end)