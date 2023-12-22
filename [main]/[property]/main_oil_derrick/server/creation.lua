
function getFreeID()
	local newID = false
	local result = dbPoll(dbQuery(db, 'SELECT id FROM derricks ORDER BY id ASC'), -1)
	for i, row in pairs (result) do
		if tonumber(row.id) ~= i then
			newID = i
			break
		end
	end
	return newID or (#result + 1)
end


function addBusiness(x,y,z,cost,override_income)

	if client and not exports.acl:isAdmin(client) then return end

	local freeId = getFreeID()
	local health = Config.derrick.levels[1].health

	dbExec(db, string.format('INSERT INTO derricks(id, owner, pos, balance, upgrades_level, health, fix_amount,cost,override_income) VALUES (%s, "%s", \'%s\', %s, %s, %s, %s,%s,%s);',
		freeId, '', toJSON({x=x,y=y,z=z}), 0, 1, health, 0, cost, override_income or 'NULL'
	))

	local data = {

		id = freeId,
		pos = toJSON({x=x,y=y,z=z}),
		owner = '',

		balance = 0,
		health = health,
		upgrades_level = 1,
		fix_amount = 0,
		cost = cost,
		override_income = override_income,

	}

	createBusiness(data)

end
addEvent('derrick.add', true)
addEventHandler('derrick.add', resourceRoot, addBusiness)

function deleteBusiness(id)

	if isElement(businessMarkers[id].marker) then
		destroyElement(businessMarkers[id].marker)
	end

	businessMarkers[id] = nil

	dbExec(db, string.format('DELETE FROM derricks WHERE id=%s;',
		id
	))

	outputDebugString(string.format('[BUSINESS] %s deleted derrick %s',
		client.account.name, id
	))
end
addEvent('derrick.delete', true)
addEventHandler('derrick.delete', resourceRoot, deleteBusiness)
