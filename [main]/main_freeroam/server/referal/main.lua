
-----------------------------------------------------------------

	db = dbConnect('sqlite', ':databases/referal.db')

	addEventHandler('onResourceStart', resourceRoot, function()


		dbExec(db, string.format('CREATE TABLE IF NOT EXISTS codes(id INTEGER PRIMARY KEY, owner TEXT, code TEXT, uses INTEGER, max_uses INTEGER, users TEXT);'))
		
		-- dbExec(db, string.format('DELETE FROM codes WHERE id=%s;', 35))

		loadUniqueCodes()

		for i, v in pairs( getElementsByType( "player" ) ) do
			udpatePlayerCodeData( v )
		end

	end)

-----------------------------------------------------------------


	function getCodeData(code)
		local data = dbPoll(dbQuery(db, string.format('SELECT * FROM codes WHERE code="%s";',
			code
		)), -1)

		if data and data[1] then
			return data[1]
		end

		return false
	end

	function getAccountCodeData(login)
		local data = dbPoll(dbQuery(db, string.format('SELECT * FROM codes WHERE owner="%s";',
			login
		)), -1)

		if data and data[1] then
			return data[1]
		end

		return false
	end

	function updateOwnerData(code)
		local data = getCodeData(code)

		if data and data.owner then

			local account = getAccount(data.owner)
			if account and account.player then
				account.player:setData('referal.code.data', data)
			end
			
		end

	end

-----------------------------------------------------------------

	function udpatePlayerCodeData(player)
		local level = exports['main_levels']:getPlayerLevel(player)
		local realTime = getRealTime().timestamp
		local code = player:getData('referal.code')

		local data = getAccountCodeData(player.account.name)
		if data then
			code = code or data.code
		end

		-- if level > 2 and not code then

		-- 	local code = createReferalCode(player.account)
		-- 	player:setData('referal.code', code)

		-- elseif level > 2 then
		if code then

			local data = getAccountCodeData(player.account.name)
			if data and data.code ~= code then
				player:setData('referal.code', data.code)
				updateOwnerData(data.code)
			else
				updateOwnerData(code)
			end
			
		end

		-- end
	end

	addEventHandler('onPlayerLogin', root, function()

		udpatePlayerCodeData(source)

	end, true, 'low-2')

	-- addEventHandler('onElementDataChange', root, function(dn, old, new)
	-- 	if dn == 'level' and new and new > 2 then
	-- 		udpatePlayerCodeData(source)
	-- 	end
	-- end)
