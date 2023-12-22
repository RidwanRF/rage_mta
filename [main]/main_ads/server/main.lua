
--------------------------------------------------------

	db = dbConnect('sqlite', ':databases/ads.db')

--------------------------------------------------------

	local ad_created = {}

--------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		-- dbExec(db, 'DROP TABLE ads;')
		dbExec(db, 'CREATE TABLE IF NOT EXISTS ads(id INTEGER PRIMARY KEY, ad_text TEXT, player TEXT, finish_time INTEGER, create_time INTEGER, type TEXT);')

		updateAds()

	end)

--------------------------------------------------------

	function createAd(ad_text, time, type)

		local count_data = Config.adsCost[time]

		if count_data.cost > exports.money:getPlayerMoney(client) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
		end

		if ad_created[client.account.name] and ( getRealTime().timestamp - ad_created[client.account.name] ) < 180 then
			return exports.hud_notify:notify(client, 'Ошибка', 'Слишком частые объявления')
		end

		exports.money:takePlayerMoney(client, count_data.cost)

		local real_time = getRealTime().timestamp

		dbExec(db, string.format('INSERT INTO ads(ad_text, player, finish_time, create_time, type) VALUES ("%s", "%s", %s, %s, "%s");',
			ad_text, client.account.name, real_time + count_data.hours*3600, real_time, type
		))

		ad_created[client.account.name] = real_time

		exports.hud_notify:notify(client, 'Успешно', 'Вы подали объявление')

		updateAds()
		returnClientAds()

		exports.logs:addLog(
			'[AD][CREATE]',
			{
				data = {
					player = client.account.name,
					cost = count_data.cost,
					time = count_data.hours,
					type = type,
				},	
			}
		)

	end
	addEvent('ads.createAd', true)
	addEventHandler('ads.createAd', resourceRoot, createAd)

--------------------------------------------------------

	function updateAds()

		dbExec( db, ('DELETE FROM ads WHERE finish_time <= %s;'):format( getRealTime().timestamp ) )
		currentAds = dbPoll( dbQuery( db, 'SELECT * FROM ads ORDER BY create_time DESC;' ), -1 )

	end

	setTimer(updateAds, 5*60*1000, 0)

--------------------------------------------------------
	
	function returnClientAds()
		triggerClientEvent(client, 'ads.receive', resourceRoot, currentAds)
	end
	addEvent('ads.return', true)
	addEventHandler('ads.return', resourceRoot, returnClientAds)

--------------------------------------------------------

	function removeAd(id)

		local data = dbPoll( dbQuery( db, ('SELECT * FROM ads WHERE id=%s;'):format(id) ), -1 )

		if not client.account then return end

		if data and (data[1].player == client.account.name or exports.acl:isAdmin(client)) then

			dbExec(db, ('DELETE FROM ads WHERE id=%s;'):format(id))

			updateAds()
			returnClientAds()

			exports.logs:addLog(
				'[AD][REMOVE]',
				{
					data = {
						player = client.account.name,
						id = id,
					},	
				}
			)

		end

	end
	addEvent('ads.remove', true)
	addEventHandler('ads.remove', resourceRoot, removeAd)

--------------------------------------------------------