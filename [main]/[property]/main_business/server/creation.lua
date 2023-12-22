
function getFreeID()
	local newID = false
	local result = dbPoll(dbQuery(db, 'SELECT id FROM business ORDER BY id ASC'), -1)
	for i, row in pairs (result) do
		if tonumber(row.id) ~= i then
			newID = i
			break
		end
	end
	return newID or (#result + 1)
end


function addBusiness(x,y,z, payment_sum, cost, donate)

	if client and not exports.acl:isAdmin(client) then return end

	local freeId = getFreeID()
	local name = getBusinessName(payment_sum)
	dbExec(db, string.format('INSERT INTO business(id, owner, name, cost, donate, pos, balance, payment_sum) VALUES (%s, "%s", "%s", %s, %s, \'%s\', %s, %s);',
		freeId, '', name, cost, donate, toJSON({x=x,y=y,z=z}), 0, payment_sum
	))

	local data = {
		id = freeId,
		pos = toJSON({x=x,y=y,z=z}),
		owner = '',
		cost = cost,
		payment_sum = payment_sum,
		donate = donate,
		name = name,
	}

	createBusiness(data)

end
addEvent('business.add', true)
addEventHandler('business.add', resourceRoot, addBusiness)

function deleteBusiness(id)

	if isElement(businessMarkers[id].marker) then
		destroyElement(businessMarkers[id].marker)
	end

	businessMarkers[id] = nil

	dbExec(db, string.format('DELETE FROM business WHERE id=%s;',
		id
	))

	exports.logs:addLog(
		'[BUSINESS][DELETE]',
		{
			data = {
				player = client.account.name,
				id = id,
			},	
		}
	)


end
addEvent('business.delete', true)
addEventHandler('business.delete', resourceRoot, deleteBusiness)
