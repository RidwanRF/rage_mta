
function getFreeHouseID()
	local newID = false
	local result = dbPoll(dbQuery(db, 'SELECT id FROM houses ORDER BY id ASC'), -1)
	for i, row in pairs (result) do
		if tonumber(row.id) ~= i then
			newID = i
			break
		end
	end
	return newID or (#result + 1)
end


function addHouse(x,y,z, lots, cost, donate, interior, _flat_id)

	if client and not exports['acl']:isAdmin(client) then return end

	local freeId = getFreeHouseID()
	dbExec(db, string.format('INSERT INTO houses(id, owner, cost, donate, pos, lots, default_lots, interior, key) VALUES (%s, "%s", %s, %s, \'%s\', %s, %s, %s, "%s");',
		freeId, '', cost, donate, toJSON({x=x,y=y,z=z}), lots, lots, interior,''
		
	))

	local data = {
		id = freeId,
		pos = toJSON({x=x,y=y,z=z}),
		lots = lots,
		default_lots = lots,
		interior = interior,
		owner = '',
		cost = cost,
		key = '',
		donate = donate,
		flat = _flat_id,
	}

	createHouse(data)

end
addEvent('house.add', true)
addEventHandler('house.add', resourceRoot, addHouse)

function deleteHouse(id)

	if exports.acl:isAdmin(client) then

		if isElement(houseMarkers[id].marker) then

			local childMarker = houseMarkers[id].marker:getData('house.childMarker')

			if isElement(childMarker) then
				destroyElement(childMarker)
			end
			destroyElement(houseMarkers[id].marker)

		end

		houseMarkers[id] = nil

		dbExec(db, string.format('DELETE FROM houses WHERE id=%s;',
			id
		))

	end

end
addEvent('house.delete', true)
addEventHandler('house.delete', resourceRoot, deleteHouse)
