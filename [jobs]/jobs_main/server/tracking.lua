
------------------------------------------------

	db = dbConnect('sqlite', ':databases/jobs_tracking.db')

	addEventHandler('onResourceStart', resourceRoot, function()

		dbExec(db, string.format('CREATE TABLE IF NOT EXISTS jobs_tracking(id INTEGER PRIMARY KEY, account TEXT, job TEXT, data TEXT, session INTEGER, timestamp INTEGER);'))

	end)

------------------------------------------------

	function trackPlayerSession(player)

		local session = workSessions[player]
		if session then

			local timestamp = getRealTime().timestamp
			local sessionTime = timestamp - session.start
			
			addPlayerStats(player, 'total_xp', sessionTime, session.work)

			dbExec(db,
			string.format('INSERT INTO jobs_tracking(account, job, data, session, timestamp) VALUES ("%s", "%s", \'%s\', %s, %s)',
				player.account.name, session.work, inspect(session), sessionTime, timestamp
			))


			exports.logs:addLog(
				string.format('[JOB][%s]', utf8.upper(session.work)),
				{
					data = {
						player = player.account.name,
						work = session.work,
						session = session,
						time = sessionTime,
						timestamp = timestamp,
					},	
				}
			)

		end

	end

------------------------------------------------

	function getWorkAverageData(work, time, time_from, time_to)

		local sessions = dbPoll(
			dbQuery(db,
			string.format('SELECT * FROM jobs_tracking WHERE job="%s" AND timestamp > %s AND timestamp < %s;',
				work, time_from or 0, time_to or 9999999999
			)
		), -1)

		local data = {}

		for _, session in pairs( sessions ) do

			local mul = time/session.session
			local sessionData = fromJSON(session.data or '[[]]') or {}

			for key, value in pairs( sessionData ) do
				data[key] = (data[key] or 0) + value*mul
			end

		end

		for key, value in pairs(data) do
			data[key] = value / #sessions
		end

		return data

	end

	addCommandHandler('jobs_average', function(player, _, work, time, time_from, time_to)

		if not exports['shared_utils']:isAdmin(player) then return end

		time_from = time_from and getTimestampFromString(time_from) or false
		time_to = time_to and getTimestampFromString(time_to) or false

		local data = getWorkAverageData( work, time*60, time_from, time_to )

		for key, value in pairs( data ) do
			exports['chat_main']:displayInfo(player, string.format('%s - %s',
				key, value
			), {255,255,255})
		end


	end)