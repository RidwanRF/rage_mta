
--------------------------------------------------------

	local serial_db = dbConnect('sqlite', ':databases/serial_check.db')

--------------------------------------------------------

	addEventHandler('onUnban', root, function()
		for _, player in pairs( getElementsByType('player') ) do
			if hasPlayerRight(player, 'admin') then
				setTimer(functions.returnBans, 1000, 1, player)
			end
		end
	end)

--------------------------------------------------------

	functions.ban = function(data, reason, time, _rPlayer)
		local rPlayer = _rPlayer or client
		addBan(data.ip, nil, data.serial, rPlayer, reason, time*60)

		functions.returnBans(rPlayer)

		exports.logs:addLog(
			'[ADMIN][BAN]',
			{
				data = {
					player = rPlayer.account.name,
					reason = reason,
					time = time,
					ban_data = data,
				},	
			}
		)

	end

	functions.unban = function(data)
	
		for _, ban in pairs( getBans() ) do
			if getBanSerial(ban) == data.serial then
				removeBan(ban, client)
			end
		end

		functions.returnBans(client)

		exports.logs:addLog(
			'[ADMIN][UNBAN]',
			{
				data = {
					player = client.account.name,
					ban_data = data,
				},	
			}
		)
	end

--------------------------------------------------------

	functions.returnBans = function(_player)

		local player = _player or client

		local bans = {}

		for _, ban in pairs( getBans() ) do

			local serial = getBanSerial(ban)

			local row = serial and dbPoll( dbQuery( serial_db,
				string.format('SELECT * FROM serial_check WHERE serial="%s";', serial) ), -1) or false

			local account = (row and row[1]) and getAccount(row[1].login) or false

			table.insert(bans, {
				name = account and account:getData('character.nickname') or '---',
				login = account and account.name or '---',
				serial = serial,
				time = getBanTime(ban),
				unbanTime = getUnbanTime(ban),
				reason = getBanReason(ban),
				banner = getBanAdmin(ban),
			})
		end

		clientEvent(player, 'admin.receiveBans', bans)

	end

--------------------------------------------------------