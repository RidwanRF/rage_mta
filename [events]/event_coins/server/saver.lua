
---------------------------------------------------------------------------

	saver = {}
	saver.params = {}

---------------------------------------------------------------------------

	saver.db = dbConnect('sqlite', ':databases/coins_event.db')

---------------------------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		dbExec(saver.db, 'CREATE TABLE IF NOT EXISTS players_data(id INTEGER PRIMARY KEY, account TEXT, key TEXT, value TEXT);')
		-- dbExec(saver.db, 'UPDATE players_data SET value=909090 WHERE account="broker";')

		-- for _, player in pairs( getElementsByType('player') ) do
		-- 	player:setData('event_coins.coins', 0)
		-- end

	end)

---------------------------------------------------------------------------

	saver.dumpValue = function(self, key, value)

		if value == 'false' then return false end

		if not value then return value end

		local param = self.params[key]
		if not param then return value end

		local data_type = param.data_type or 'string'

		if data_type == 'string' then
			return value
		elseif data_type == 'number' then
			return tostring(value)
		elseif data_type == 'table' then
			return toJSON(value, true)
		end

	end

	saver.loadValue = function(self, key, value)

		if not value then return value end
		
		local param = self.params[key]
		if not param then return value end

		local data_type = param.data_type or 'string'

		if data_type == 'string' then
			return value
		elseif data_type == 'number' then
			return tonumber(value) or 0
		elseif data_type == 'table' then
			return fromJSON(value, true)
		end

	end

---------------------------------------------------------------------------

	saver.loadPlayerData = function(self, player)

		if not player.account then return end

		local data = dbPoll( dbQuery(self.db, string.format('SELECT * FROM players_data WHERE account="%s";',
			player.account.name
		)), -1 )

		if data then

			for _, row in pairs(data) do
				player:setData( row.key, self:loadValue(row.key, row.value) )
			end

		end

	end

	addEventHandler('onPlayerLogin', root, function()

		saver:loadPlayerData(source)

	end, true, 'high+100')

	addCommandHandler('coins_load_data', function(player)

		if exports.acl:isAdmin(player) then
			saver:loadPlayerData(player)
		end

	end)

	-- addEventHandler('onResourceStart', resourceRoot, function()

	-- 	for _, player in pairs( getElementsByType('player') ) do
	-- 		saver:loadPlayerData(player)
	-- 	end

	-- end)

---------------------------------------------------------------------------

	saver.savePlayerData = function(self, player, key, value)

		if not player.account then return end

		if key then

			value = value or false

			local data = dbPoll( dbQuery(self.db, string.format('SELECT * FROM players_data WHERE key="%s" AND account="%s";',
				key, player.account.name
			)), -1 )

			if data and data[1] then

				dbExec(self.db, string.format('UPDATE players_data SET value=\'%s\' WHERE account="%s" AND key="%s";',
					self:dumpValue(key, value) or 'false', player.account.name, key
				))

			else

				dbExec(self.db, string.format('INSERT INTO players_data(account, key, value) VALUES ("%s", "%s", \'%s\');',
					player.account.name, key, self:dumpValue(key, value) or 'false'
				))

			end

		else

			for key, value in pairs( self.params or {} ) do
				self:savePlayerData( player, key, player:getData(key) )
			end

		end

	end

	addEventHandler('onPlayerQuit', root, function()

		saver:savePlayerData(source)

	end)

---------------------------------------------------------------------------
	
	saver.addSaveKey = function(self, key, data_type, dynamic)
		self.params[key] = { dynamic = dynamic, data_type = data_type or 'string' }
	end

---------------------------------------------------------------------------

	addEventHandler('onElementDataChange', root, function(dn, old, new)

		if saver.params[dn] and source.account then

			if client then
				return source:setData(dn, old)
			end

			if saver.params[dn].dynamic then
				saver:savePlayerData(source, dn, new)
			end

		end

	end)

---------------------------------------------------------------------------