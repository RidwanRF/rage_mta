

----------------------------------------------------------------------

	seasons = {}

----------------------------------------------------------------------
	
	seasons.db = dbConnect('sqlite', ':databases/coins_event.db')

----------------------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		-- dbExec(seasons.db, 'DROP TABLE seasons;')
		dbExec(seasons.db, 'CREATE TABLE IF NOT EXISTS seasons(id INTEGER PRIMARY KEY, season_id INTEGER, top TEXT);')

		updateCurrentSeason()

	end)

----------------------------------------------------------------------
	
	function updateCurrentSeason()

		local data = dbPoll( dbQuery(seasons.db, 'SELECT * FROM seasons ORDER BY id DESC LIMIT 1;'), -1 )

		if data and data[1] then
			resourceRoot:setData('current_season', data[1].season_id)
		end

	end

----------------------------------------------------------------------

	function startNewSeason(season_id)

		local top = getPlayersTop().top

		for index, prize in pairs( Config.prizes ) do

			local row = top[index]
			if row and row.account then

				if index <= 10 then
					exports.main_freeroam:giveStatus( row.account, 'firehand' )
				end
				
				prize.give( row.account )
				exports.main_alerts:addAccountAlert( row.account, 'info', 'Награда за RCoin', prize.prize)

				exports.logs:addLog(
					'[COINS][PRIZE]',
					{
						data = {
							player = row.account,
							prize = index,
							name = prize.prize,
						},	
					}
				)

			end

		end

		dbExec(seasons.db, string.format('INSERT INTO seasons(season_id, top) VALUES(%s, \'%s\');', season_id, inspect(top)))

		dbExec(seasons.db, 'DELETE FROM players_data;')

		for _, player in pairs( getElementsByType('player') ) do

			if player.account then

				player:setData('event_coins.account_id', generateAccountId(player))
				player:setData('event_coins.coins', 0)
				player:setData('event_coins.upgrades', false)

				saver:savePlayerData( player, 'event_coins.coins', 0 )


			end

		end

		updateCurrentSeason()

	end

	addCommandHandler('coins_start_season', function(player, _, season_id)

		if exports.acl:isAdmin(player) then

			season_id = tonumber(season_id)
			if not season_id then return end

			startNewSeason(season_id)
			exports.chat_main:displayInfo(player, 'coins_start_season succesfully', {255,255,255})

		end

	end)

----------------------------------------------------------------------

	seasons.update = function(self)

		-- local currentSeason = getCurrentSeason()

		-- local date = getRealTime()
		-- local date_str = string.format('%02d.%02d', date.monthday, date.month + 1)

		-- for season, data in pairs( Config.seasons ) do

		-- 	if season > currentSeason and data.start_at == date_str then



		-- 		startNewSeason(season)
		-- 		break

		-- 	end

		-- end
		startNewSeason(4)

		setTimer(function()
			stopResource( getThisResource() )
		end, 1000, 1)

	end

	addEventHandler('onServerDayCycle', root, seasons.update)

	addCommandHandler('event_coins_update', function(player)

		if exports.acl:isAdmin(player) then
			seasons:update()
		end

	end)

----------------------------------------------------------------------