
db = dbConnect('sqlite', ':databases/vehicles.db')


addEventHandler('onResourceStart', resourceRoot, function()

	dbExec(db, string.format('CREATE TABLE IF NOT EXISTS vehicles(id INTEGER PRIMARY KEY, model INTEGER, owner TEXT, position TEXT, health INTEGER, fuel INTEGER, fuel_type TEXT, odometer INTEGER, plate TEXT, appearance_upgrades TEXT, handling TEXT, flag INTEGER, expiry_date INTEGER, unique_mark TEXT);'))

	-- dbExec(db, string.format('ALTER TABLE vehicles ADD COLUMN stages INTEGER;'))
		--dbExec( db, 'ALTER TABLE vehicles ADD COLUMN team_id INTEGER' )


	-- local data = dbPoll( dbQuery(db, string.format('SELECT * FROM vehicles WHERE model=456;')), -1 )

	-- for _, vehicle in pairs( data ) do

	-- 	dbExec(db, string.format('DELETE FROM vehicles WHERE id=%s;', vehicle.id))
	-- 	increaseUserData(vehicle.owner, 'money', 17000000)
	-- 	print(getTickCount(  ), vehicle.owner, 'money', 17000000)

	-- end

	-- dbExec(db, 'UPDATE vehicles SET model=562 WHERE model=561;')
	-- dbExec(db, 'UPDATE vehicles SET model=4545 WHERE model=579;')
	-- dbExec(db, 'UPDATE vehicles SET model=579 WHERE model=477;')
	-- dbExec(db, 'UPDATE vehicles SET model=549 WHERE model=580;')
	-- dbExec(db, 'UPDATE vehicles SET model=580 WHERE model=400;')

end)

cachedVehicles = {}

function setVehicleData(id, key, value, saveOnly)

	local vehicle = getVehicleById(id)

	if isElement(vehicle) and not saveOnly then
		vehicle:setData( key, value, not Config.squeeze[key] )
	end
	dbExec(db, string.format('UPDATE vehicles SET %s=? WHERE id=%s;', key, id), (
		type(value) == 'table' and toJSON(value) or value
	))

	if cachedVehicles[id] then
		cachedVehicles[id][key] = value
	end

end

function getVehicleDBData(id)

	if cachedVehicles[id] then
		return cachedVehicles[id]
	end

	local data = dbPoll(dbQuery(db, string.format('SELECT * FROM vehicles WHERE id=%s;', id)), -1)

	if data and data[1] then
		cachedVehicles[data[1].id] = data[1]
		return cachedVehicles[data[1].id]
	end


end

function destroyVehicle(vehicle)
	squeezed[vehicle] = nil
	destroyElement(vehicle)
end

function returnPlayerVehicles(_player)

	local player = _player or client

	if not player.account then return end

	local login = player.account.name
	local clan = player:getData ( 'team.id' ) or false
	local clan_vehicle = player:getData ( 'clan_vehicle_id' ) or false
	local vehicles = { }
	--iprint(vehicles, clan_vehicle)

	local function LetsGo ( player )
		local data = dbPoll(dbQuery(db, string.format('SELECT * FROM vehicles WHERE owner="%s";', login)), -1)
		for i, v in pairs ( data ) do
			table.insert ( vehicles, v )
		end
		player.account:setData('cars.total', #vehicles)

		triggerClientEvent(player, 'vehicles.getPlayerVehicles', player, vehicles)
		updatePlayerParkingLots(player)
	end

	if clan and clan_vehicle then
		--[[if cachedVehicles [ clan_vehicle ] then
			table.insert ( vehicles, cachedVehicles [ clan_vehicle_id] )
			LetsGo ( player )
			iprint(cachedVehicles[clan_vehicle].model)
			return
		end]]
		db:query ( function ( query, player ) 
			if isElement ( player ) then
				local result = query:poll ( -1 )
				if result and #result > 0 then
					for i, v in pairs ( result ) do
						if tonumber ( v.owner ) == clan then
							table.insert ( vehicles, v )
						end
					end
					LetsGo ( player )
				end
			end
		end, { player }, 'SELECT * FROM vehicles WHERE id = ?', clan_vehicle)
	else
		LetsGo ( player )
	end
end
addEvent('vehicles.sendPlayerVehicles', true)
addEventHandler('vehicles.sendPlayerVehicles', resourceRoot, returnPlayerVehicles)

addEvent ( 'OnPlayerUpdateVehiclesList', true )
addEventHandler ( 'OnPlayerUpdateVehiclesList', root, function ( ) 
	returnPlayerVehicles ( source )
end)

function catchVehicleInfo(vehicle_id)
	triggerClientEvent(client, 'vehicles.catchVehicleInfo', client, getVehicleDBData(vehicle_id))
end
addEvent('vehicles.catchVehicleInfo', true)
addEventHandler('vehicles.catchVehicleInfo', resourceRoot, catchVehicleInfo)
