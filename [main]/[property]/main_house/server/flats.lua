

------------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		dbExec(db, string.format('CREATE TABLE IF NOT EXISTS flats(id INTEGER PRIMARY KEY, pos TEXT);'))
		-- dbExec(db, string.format('ALTER TABLE houses ADD COLUMN flat INTEGER;'))

		local flats = dbPoll( dbQuery( db, 'SELECT * FROM flats;' ), -1 )

		for _, flat in pairs(flats) do
			createFlat(flat)
		end

	end)

------------------------------------------------------------

	function getFreeFlatID()
		local newID = false
		local result = dbPoll(dbQuery(db, 'SELECT id FROM flats ORDER BY id ASC'), -1)
		for i, row in pairs (result) do
			if tonumber(row.id) ~= i then
				newID = i
				break
			end
		end
		return newID or (#result + 1)
	end

------------------------------------------------------------

	function addFlat( x,y,z, lots, cost, count )

		if client and not exports['acl']:isAdmin(client) then return end

		local freeId = getFreeFlatID()
		dbExec(db, string.format('INSERT INTO flats(id, pos) VALUES (%s, \'%s\');',
			freeId, toJSON({x=x,y=y,z=z})
		))

		local data = {
			id = freeId,
			pos = toJSON({x=x,y=y,z=z}),
		}

		createFlat(data)

		local _p = 3000
		for i = 1, count do
			addHouse(_p,_p,_p, lots, cost, 0, 1, freeId)
		end

	end
	addEvent('flat.add', true)
	addEventHandler('flat.add', resourceRoot, addFlat)


------------------------------------------------------------

	flatMarkers = {}
	
	function createFlat( data )

		data.pos = fromJSON(data.pos or '[[]]') or {}

		local marker = createMarker(data.pos.x, data.pos.y, data.pos.z, 'corona', 1, 200, 150, 200, 50)
		marker:setData('flat.marker', true)
		marker:setData('flat.data', data)

		local blip = createBlipAttachedTo(marker)
		blip:setData('icon', 'flat')

		local colshape = createColSphere(data.pos.x, data.pos.y, data.pos.z, 20)
		colshape:setData('flat.colshape', true)

		local houses = dbPoll( dbQuery(db, ('SELECT * FROM houses WHERE flat=%s;'):format(data.id)), -1 )
		data.houses_count = #houses

		marker:setData('flat.3dtext', string.format([=[
[Многоэтажный дом]
[Квартиры - %s]
[ID - %s]
		]=],
			data.id,
			data.houses_count
		))

		flatMarkers[data.id] = {
			marker = marker,
			blip = blip,
			data = data,
			colshape = colshape,
		}

	end

------------------------------------------------------------

	function getFlatHouses(f_id)

		local list = {}

		for id, house in pairs( houseMarkers ) do

			if house.data.flat == f_id then
				table.insert(list, { id = id, house = house })
			end

		end

		return list

	end

------------------------------------------------------------

	function deleteFlat(id)

		if exports.acl:isAdmin(client) then

			local houses = getFlatHouses( id )

			for _, data in pairs( houses ) do
				deleteHouse(data.id)
			end

			clearTableElements(flatMarkers[id])

			flatMarkers[id] = nil

			dbExec(db, string.format('DELETE FROM flats WHERE id=%s;',
				id
			))

		end

	end
	addEvent('flat.delete', true)
	addEventHandler('flat.delete', resourceRoot, deleteFlat)

------------------------------------------------------------

	function getFlatById( id )
		if flatMarkers[ id ] then
			return flatMarkers[ id ].marker
		end
	end

------------------------------------------------------------