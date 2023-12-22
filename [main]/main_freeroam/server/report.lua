
---------------------------------------------------------------

	exports.save:addParameter('report.stats.reports_completed')
	exports.save:addParameter('report.stats.reports_good')
	exports.save:addParameter('report.stats.reports_bad')

---------------------------------------------------------------

	local report_db = dbConnect('sqlite', ':databases/report.db')

---------------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		-- dbExec(report_db, 'DROP TABLE reports;')
		dbExec(report_db, 'CREATE TABLE IF NOT EXISTS reports(id INTEGER PRIMARY KEY, player TEXT, moderator TEXT, messages TEXT, mark INTEGER, state TEXT, type TEXT, delayed INTEGER);')

	end)

---------------------------------------------------------------

	function hasPlayerRole(player, role)

		if exports.acl:isAdmin(player) then return true end

		if role == 'moderator' then
			return exports.acl:isModerator(player)
		elseif role == 'player' then
			return not exports.acl:isModerator(player)
		end

	end

---------------------------------------------------------------

	function getReportDataById(id)

		if not id then return end
		local data = dbPoll( dbQuery(report_db, string.format('SELECT * FROM reports WHERE id=%s;', id)), -1 )

		if data and data[1] then

			return data[1]

		end

	end

--------------------------------------------------------------

	function updateReport(player)

		local data = {}

		if exports.acl:isModerator( player ) then

			data = dbPoll( dbQuery( report_db, string.format('SELECT * from reports WHERE state!="closed";') ), -1 )

		else

			data = dbPoll( dbQuery( report_db, string.format('SELECT * from reports WHERE player="%s";', player.account.name) ), -1 )

		end

		for _, row in pairs( data ) do

			row.messages = fromJSON(row.messages or '[[]]') or {}

			for index, message in pairs( row.messages or {} ) do
				if message.base then
					message.message = base64Decode(message.message)
				end
			end

		end

		triggerClientEvent(player, 'freeroam.receiveReport', resourceRoot, data)

	end
	addEvent('freeroam.updateReport', true)
	addEventHandler('freeroam.updateReport', resourceRoot, updateReport)

---------------------------------------------------------------

	function receiveReport(id)

		local data = getReportDataById(id)
		if not data then return end

		local account = getAccount( data.player )

		if account and account.player then
			updateReport(account.player)
		end

		updateModeratorReport()

	end

---------------------------------------------------------------

	function updateModeratorReport()

		for _, player in pairs( getElementsByType('player') ) do

			if hasPlayerRole(player, 'moderator') then
				updateReport(player)
			end

		end

	end

---------------------------------------------------------------

	function createReport( type, text )

		if not hasPlayerRole(client, 'player') then return end

		local messages = {}

		table.insert( messages, {

			sender = client.account.name,
			message = base64Encode( text ),
			timestamp = getRealTime().timestamp,
			base = true,

		} )

		dbExec(report_db, string.format('INSERT INTO reports(player, messages, mark, state, type) VALUES ("%s", \'%s\', 0, "%s", "%s");',
			client.account.name, toJSON(messages), 'unread', type
		))

		exports.hud_notify:notify(client, 'Репорт', 'Ожидайте ответа модератора')

		updateReport(client)
		updateModeratorReport()

		for _, player in pairs( getElementsByType('player') ) do

			if hasPlayerRole(player, 'moderator') then
				exports.hud_notify:notify(player, 'Репорт', 'Новое сообщение')
			end

		end

	end
	addEvent('freeroam.createReport', true)
	addEventHandler('freeroam.createReport', resourceRoot, createReport)

---------------------------------------------------------------

	function sendReportMessage( id, message )

		local data = getReportDataById(id)
		if not data then return end
		if data.state == 'closed' then return end

		data.messages = fromJSON( data.messages or '[[]]' ) or {}

		table.insert( data.messages, {

			sender = client.account.name,
			moderator = true,
			message = base64Encode( message ),
			base = true,
			timestamp = getRealTime().timestamp,

		} )

		dbExec(report_db, string.format('UPDATE reports SET messages=\'%s\', moderator="%s" WHERE id=%s;',
			toJSON(data.messages), client.account.name, id
		))

		local account = getAccount(data.player)
		if account and account.player then
			exports.hud_notify:notify(account.player, 'Репорт', 'Новое сообщение')
		end

		closeReport(id)

	end
	addEvent('freeroam.sendReportMessage', true)
	addEventHandler('freeroam.sendReportMessage', resourceRoot, sendReportMessage)

---------------------------------------------------------------

	function closeReport(id)

		local data = getReportDataById(id)
		if not data then return end

		if exports.acl:isModerator(client) and not ( data.state == 'closed' and exports.acl:isAdmin(client) ) then
			dbExec(report_db, string.format('UPDATE reports SET state="closed" WHERE id=%s;',
				id
			))
		else
			dbExec(report_db, string.format('DELETE FROM reports WHERE id=%s;',
				id
			))
		end

		exports.hud_notify:notify(client, 'Репорт', 'Заявка закрыта')

		if exports.acl:isModerator(client) and not ( data.state == 'closed' and exports.acl:isAdmin(client) ) then
			increaseUserData(client.account.name, 'report.stats.reports_completed', 1)
		end

		updateReport(client)
		updateModeratorReport()

	end
	addEvent('freeroam.closeReport', true)
	addEventHandler('freeroam.closeReport', resourceRoot, closeReport)

---------------------------------------------------------------

	function markReport(id, mark)

		local data = getReportDataById(id)
		if not data then return end

		if data.state ~= 'closed' then return end
		if data.mark ~= 0 then return end

		dbExec(report_db, string.format('UPDATE reports SET mark=%s WHERE id=%s;',
			mark, id
		))

		increaseUserData(data.moderator, 'report.stats.reports_'..( mark == 1 and 'good' or 'bad' ), 1)

		receiveReport(id)

	end
	addEvent('freeroam.markReport', true)
	addEventHandler('freeroam.markReport', resourceRoot, markReport)

---------------------------------------------------------------

	function delayReport(id)

		local data = getReportDataById(id)
		if not data then return end

		if data.state == 'closed' then return end

		dbExec(report_db, string.format('UPDATE reports SET delayed=1 WHERE id=%s;',
			id
		))

		exports.hud_notify:notify(client, 'Репорт', 'Вы отложили заявку')

		receiveReport(id)

	end
	addEvent('freeroam.delayReport', true)
	addEventHandler('freeroam.delayReport', resourceRoot, delayReport)

---------------------------------------------------------------