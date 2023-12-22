
------------------------------------------------------------

	function decreaseVehicleHealth( vehicle, amount )

		local hp = vehicle:getData('hp') or 0
		local max_hp = vehicle:getData('max_hp') or 0

		hp = math.clamp(hp - amount, 0, max_hp)

		if hp <= 0 then

			local player = getVehicleOccupant(vehicle)
			local match = getPlayerMatch(player)

			if match then
				match:removePlayer(player)
			end

		end


	end

------------------------------------------------------------

	function handleVehicleDamage( shell )

		local damage = 100

		local x,y,z = getElementPosition(shell)
		triggerClientEvent(root, 'event_br.createExplosion', root, { x,y,z, 2, true, 0.5, false })

		decreaseVehicleHealth( client.vehicle, damage )

		fixVehicle(source)
		destroyElement(shell)

	end
	addEvent('event_br.handleVehicleDamage', true)
	addEventHandler('event_br.handleVehicleDamage', resourceRoot, handleVehicleDamage)

------------------------------------------------------------

	addEventHandler('onVehicleDamage', resourceRoot, function(loss)
		fixVehicle(source)
		decreaseVehicleHealth(source, loss)
	end)

------------------------------------------------------------