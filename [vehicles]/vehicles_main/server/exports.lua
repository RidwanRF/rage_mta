

function vm_getFreeDatabaseId(db, tableName, rowName)

    local newID = false
    local result = dbPoll(dbQuery(db, string.format('SELECT id FROM %s ORDER BY id ASC', tableName)), -1)
    local rowName = rowName or 'id'

    if result and #result > 0 then
    	newID = result[#result].id + 1
    end

    return newID or (#result + 1)

end

------------------------------------------

	OGFDIEnabled = true

	addCommandHandler('vm_toggle_ogfdi', function( player )

		if exports.acl:isAdmin( player ) then
			OGFDIEnabled = not OGFDIEnabled
			exports.chat_main:displayInfo( player, ('OGFDIEnabled: %s'):format( tostring( OGFDIEnabled ) ), {255,255,255} )
		end

	end)

------------------------------------------


function giveAccountVehicle(login, model, _data, time)

	local account = getAccount(login)
	if not account then return end

	local data = _data or {}

	local defaultPosition = {x = 0, y = 0, z = 0, r = 0}
	local emptyTable = {}

	local plate = data.plate or generateVehiclePlate(model)

	local appearance_upgrades = data.appearance_upgrades or table.copy(emptyTable)
	appearance_upgrades.xenon_type = exports.vehicles_main:getVehicleProperty(model, 'default_headlights') or 1
	
	appearance_upgrades.color_1 = appearance_upgrades.color_1 or '#ffffff'
	appearance_upgrades.color_2 = appearance_upgrades.color_2 or '#ffffff'

	local id

	if OGFDIEnabled then
		id = vm_getFreeDatabaseId(db, 'vehicles')
	else
		id = getFreeDatabaseId(db, 'vehicles')
	end

	print(getTickCount(  ), id)

	local config = Config.vehicles[model] or {}

	local flag, expiry_date = 'NULL', 'NULL'
	if time then
		flag = 1
		expiry_date = getRealTime().timestamp + time
	end

	dbExec(db, string.format('INSERT INTO vehicles(id, model, owner, position, health, fuel, fuel_type, odometer, plate, appearance_upgrades, handling, flag, expiry_date, unique_mark) VALUES (%s, %s, "%s", \'%s\', %s, %s, "%s", %s, "%s", \'%s\', \'%s\', %s, %s, "%s")',
		id, model, login,
		toJSON(defaultPosition),
		data.health or 1000,
		data.fuel or 20,
		data.fule_type or (config.defaultFuel or '92'),
		data.odometer or 0,
		plate,	
		toJSON(appearance_upgrades),
		toJSON(data.handling or emptyTable),
		flag, expiry_date, data.unique_mark or 'NULL'
	))

	exports.logs:addLog(
		'[VEHICLES][ADD]',
		{
			data = {
				player = account.name,
				model = model,
				id = id,
				plate = plate,
				expiry_date = expiry_date,
			},	
		}
	)

	if account.player then
		returnPlayerVehicles(account.player)
	end

	return id, plate

end

function getVehiclesOfModel(login, model)
	local data = dbPoll(dbQuery(db, string.format('SELECT * FROM vehicles WHERE owner="%s" AND model=%s;',
		login, model
	)), -1)

	return #(data or {})

end

addCommandHandler('givecar', function(player, cn, login, model, time)
	if exports.acl:isAdmin(player) and tonumber(model) and login then
		giveAccountVehicle(login, tonumber(model), {
			appearance_upgrades = {
				color_1 = RGBToHex(255,255,255),
				color_2 = RGBToHex(255,255,255),
			},
		}, tonumber(time) or nil)
	end
end)

addCommandHandler('giveallcars', function(player, cn, login, time)
	if exports.acl:isAdmin(player) and login then

		for model in pairs(Config.vehicles) do
			giveAccountVehicle(login, tonumber(model), {
				appearance_upgrades = {
					color_1 = RGBToHex(255,255,255),
					color_2 = RGBToHex(255,255,255),
				},
			}, tonumber(time) or nil)
		end

	end
end)

addCommandHandler('clearcars', function(player, cn, login)
	if exports.acl:isAdmin(player) and login then

		wipeAccount(login)

		local account = getAccount(login)
		if account and account.player then
			returnPlayerVehicles(account.player)
		end

	end
end)