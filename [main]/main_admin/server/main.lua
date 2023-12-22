
------------------------------------------------------------------------------

	functions = {}

------------------------------------------------------------------------------

	function clientEvent(player, eventName, ...)
		return triggerClientEvent(player, eventName, resourceRoot, ...)
	end

------------------------------------------------------------------------------

	------------------------------------------------------------------------------

		local property_db = {
			business = dbConnect('sqlite', ':databases/business.db'),
			house = dbConnect('sqlite', ':databases/house.db'),
			vehicles = dbConnect('sqlite', ':databases/vehicles.db'),
			numbers = dbConnect('sqlite', ':databases/numbers.db'),
		}

		local accountProperty = {

			derrick = { name = 'Нефтевышка', get = function( login )
				
				local data = dbPoll( dbQuery(property_db.business, string.format('SELECT * FROM derricks WHERE owner="%s";', login)), -1 )
				return data

			end },

			business = { name = 'Бизнес', get = function( login )

				local data = dbPoll( dbQuery(property_db.business, string.format('SELECT * FROM business WHERE owner="%s";', login)), -1 )
				return data				

			end },

			house = { name = 'Дом', get = function( login )
				
				local data = dbPoll( dbQuery(property_db.house, string.format('SELECT * FROM houses WHERE owner="%s";', login)), -1 )
				return data	


			end },

			vehicle = { name = function( row )

				local t = ''
				if row.expiry_date then
					t = row.expiry_date and ' |T|' or ''
				end
				return (exports.vehicles_main:getVehicleModName(row.model) or '') .. t
			end, get = function( login )

				local data = dbPoll( dbQuery(property_db.vehicles, string.format('SELECT * FROM vehicles WHERE owner="%s";', login)), -1 )
				return data	

			end },

			number = { name = 'Номер', get = function( login )

				local data = dbPoll( dbQuery(property_db.numbers, string.format('SELECT * FROM numbers WHERE owner="%s";', login)), -1 )
				return data	

			end },

		}

	------------------------------------------------------------------------------

	excludeSerials = {
		-- ['85A6B0360E64EFDF82D5C6C4BC3A6FB2'] = true,
	}

	------------------------------------------------------------------------------

	function getAccountProperty(login)

		local account = getAccount(login)
		if not account then return nil end

		local result = {

			data = {

				account_name = login,
				serial = account.serial,
				registered_serial = account:getData('unique.serial'),

				player = account.player,

				ip = account.ip,

			},

			property = {},

		}

		for _, row in pairs( Config.accountData ) do
			result.data[ row.key ] = account:getData(row.key) or 0
		end

		for key, row in pairs( accountProperty ) do

			local property = row.get(login)

			for _, property_row in pairs(property) do

				if type(row.name) == 'function' then
					property_row.row_name = row.name(property_row)
				else
					property_row.row_name = row.name
				end

				property_row.row_type = key
				table.insert( result.property, property_row )

			end

		end

		return result

	end

	local searchQueue = {}

	function hasAccountSearchFilter(account, filter, search_settings)

		local nickname = account.player and account.player.name or account:getData('character.nickname')

		return (
			( search_settings.login and utf8.find( account.name:lower(), filter:lower() ) ) or
			( search_settings.serial and account.serial and not excludeSerials[account.serial] and utf8.find( account.serial:lower(), filter:lower() ) ) or
			( search_settings.nick and nickname and utf8.find( nickname:lower(), filter:lower() ) )
		)

	end

	functions.returnSearch = function(filter, search_settings)

		local queue = searchQueue[client]
		if queue then
			return false
		else
			queue = { index = 1, data = {}, iteration = 0 }
			searchQueue[client] = queue
		end

		for _, player in pairs( getElementsByType('player') ) do

			if player.account and hasAccountSearchFilter(player.account, filter, search_settings) and search_settings.online then
				table.insert( queue.data, getAccountProperty(player.account.name) )
			end

		end

		if utf8.len(filter) > 0 and search_settings.offline then

			local accounts = getAccounts()
			
			local iterations = (Config.searchTime/50)
			local partSize = math.floor(#accounts / iterations)
			local final = #accounts - partSize*iterations

			setTimer(function(player, filter, search_settings)

				local queue = searchQueue[player]

				if queue and isElement(player) then

					queue.iteration = queue.iteration + 1

					for i = queue.index, queue.index + (partSize-1) + (queue.iteration == iterations and final or 0) do

						local acc = accounts[i]

						if acc and not (acc.player)
						and hasAccountSearchFilter(acc, filter, search_settings) then

							table.insert( queue.data, getAccountProperty(acc.name) )

						end

					end

					queue.index = queue.index + partSize

					if queue.iteration == iterations then
						searchQueue[player] = nil
						clientEvent(player, 'admin.receiveSearch', queue.data)
					end

				end

			end, 50, iterations, client, filter, search_settings)

		else

			searchQueue[client] = nil
			clientEvent(client, 'admin.receiveSearch', queue.data)

		end


	end

	function returnAccountData(player, login)
		clientEvent( player, 'admin.receiveAccount', login, getAccountProperty(login) )
	end

------------------------------------------------------------------------------

	functions.editAccountData = function(login, key, value)

		if not hasPlayerRight(client, 'admin') then
			return exports.hud_notify:notify(client, 'Ошибка', 'Нет доступа')
		end

		setUserData(login, key, value)
		returnAccountData(client, login)

		logAdminAction( client, string.format('EDIT %s FOR %s', key, login), { value = value } )



		exports.hud_notify:notify(client, 'Успешно', 'Значение изменено')

		exports.logs:addLog(
			'[ADMIN][GIVEDATA]',
			{
				data = {
					player = login,
					key = key,
					value = value,
					admin = client.account.name,
				},	
			}
		)

	end

------------------------------------------------------------------------------

	local propertyEditFunctions = {

		business = function(id, key, value)
			exports.main_business:setBusinessData(id, key, value)
		end,

		derrick = function(id, key, value)
			exports.main_oil_derrick:setBusinessData(id, key, value)
		end,

		house = function(id, key, value)
			exports.main_house:setHouseData(id, key, value)
		end,

		vehicle = function(id, key, value)
			exports.vehicles_main:setVehicleData(id, key, value)
		end,

		number = function(id, key, value)
			exports.vehicles_numbers:setPlateData(id, key, value)
		end,

	}

	functions.editAccountProperty = function(login, property, rows)

		if not hasPlayerRight(client, 'admin') then
			return exports.hud_notify:notify(client, 'Ошибка', 'Нет доступа')
		end

		local func = propertyEditFunctions[property.type]

		if func then

			for key,value in pairs( rows ) do
				func( property.id, key, value )
			end

			logAdminAction( client, string.format('EDIT %s %s', property.type, property.id), rows )

			returnAccountData(client, login)

				exports.logs:addLog(
					'[ADMIN][GIVEPROPERTY]',
					{
						data = {
							player = login,
							admin = client.account.name,
							rows = inspect( rows ),
						},	
					}
				)

		end

	end

------------------------------------------------------------------------------

	local logs_db = dbConnect('sqlite', ':databases/logs.db')

	functions.returnAccountLogs = function(login, filter)

		if not hasPlayerRight(client, 'admin') then
			return exports.hud_notify:notify(client, 'Ошибка', 'Нет доступа')
		end

		local data = dbPoll( dbQuery(logs_db,
			string.format('SELECT * FROM logs WHERE data LIKE "%%%s%%" and tag LIKE "%%%s%%" ORDER BY id DESC LIMIT 50;',
				login, filter or ''
			)
		), -1 )

		clientEvent(client, 'admin.receiveLogs', data)

	end

------------------------------------------------------------------------------

	functions.accountAction = function(login, action, ...)

		local account = getAccount(login)
		if not account then return end

		local action_data = Config.accountActions[action]
		if not hasPlayerRight(client, action_data.right) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Нет доступа')
		end

		if not action_data.is_offline and not account.player then
			return exports.hud_notify:notify(client, 'Ошибка', 'Игрок не в сети')
		end

		if action_data.right == 'admin' then
			logAdminAction( client, string.format('ACTION %s FOR %s', action, login), {...} )
		end

		action_data.action( login, client, ... )
		exports.hud_notify:notify(client, 'Успешно', 'Действие выполнено')

	end

------------------------------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		for name, func in pairs( functions ) do

			local eventName = 'admin.'..name

			addEvent(eventName, true)
			addEventHandler(eventName, resourceRoot, func)

		end
		
	end)


------------------------------------------------------------------------------