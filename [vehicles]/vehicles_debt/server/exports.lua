----------------------------------------------------------------

	function addVehicleDebt(id, amount)
		exports.vehicles_main:setVehicleData( id, 'debt', getVehicleDebt( id ) + amount )
	end

	function addModelDebt(model, amount)

		local vehicles = dbPoll( dbQuery(db, string.format('SELECT id FROM vehicles WHERE model=%s', model)), -1 )

		for _, vehicle in pairs( vehicles ) do
			addVehicleDebt( vehicle.id, amount )
		end

	end

	function getVehicleDebt(id) 

		local data = dbPoll( dbQuery(db, string.format('SELECT debt FROM vehicles WHERE id=%s', id)), -1 )
		if data and data[1] then return (data[1].debt or 0) end

	end

----------------------------------------------------------------

	addCommandHandler('vehicles_add_debt', function(player, _, model, amount)

		if exports.acl:isAdmin(player) then

			if tonumber(model) and tonumber(amount) then

				addModelDebt(model, amount)
				exports.chat_main:displayInfo( player, 'vehicles_add_debt successfully', {255,255,255} )

			end

			
		end

	end)

----------------------------------------------------------------