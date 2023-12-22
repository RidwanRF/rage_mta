------------------------------------------------------------------------

	workSessions = {}

------------------------------------------------------------------------

	addEvent('jobs.onJobStart', true)
	addEvent('jobs.onJobFinish', true)

------------------------------------------------------------------------

	function givePlayerSessionData(player)
		triggerClientEvent(player, 'work.session.receive', resourceRoot, workSessions[player])
	end

------------------------------------------------------------------------

	function createPlayerSession(player, settings)

		if workSessions[player] then return false end

		local level_req = Config.levelRequirement[sourceResource.name] or 0
		if level_req > exports.main_levels:getPlayerLevel(player) then
			exports.hud_notify:notify(player, 'Недостаточно стажа', string.format('Требуется %s %s',
				level_req, getWordCase(level_req, 'час', 'часа', 'часов')
			))
			return false
		end


		workSessions[player] = {
			work = sourceResource.name,
			start = getRealTime().timestamp,
			vip = exports.main_vip:isVip(player),
		}

		player:setData('work.current', sourceResource.name)
		givePlayerSessionData(player)

		increaseElementData(player, 'jobs_main.jobs_started', 1)

		exports.logs:addLog('[JOBS][SESSION][START]', {
			player = player.account.name,
			work = sourceResource.name,
		})

		exports.hud_main:addPlayerHUDIcon( player, 'job' )
		exports.hud_main:addPlayerHUDRow( player, 'session_money', string.format('job.temp_stats.%s.raised_money', sourceResource.name) )

		if doesPedHaveJetPack( player ) then
			removePedJetPack( player )
		end

		triggerEvent('jobs.onJobStart', player, workSessions[player])
		triggerClientEvent(player, 'jobs.onJobStart', root)

		exports['hud_notify']:notify(player, 'Работа', 'Вы начали работу')

		exports.main_sounds:playSound( player, 'work_start' )

		return workSessions[player]

	end

------------------------------------------------------------------------

	function setPlayerSessionData(player, key, value)

		local session = workSessions[player]
		if not session then return end

		session[key] = value

		givePlayerSessionData(player)

		return true

	end

	function getPlayerSessionData(player, key)

		local session = workSessions[player]
		if not session then return end

		return session[key]

	end

	function increasePlayerSessionData(player, key, amount)

		local value = getPlayerSessionData(player, key) or 0
		return setPlayerSessionData(player, key, value + amount)

	end

------------------------------------------------------------------------

	function addPlayerSessionMoney(player, amount, notify)

		if exports.main_vip:isVip(player) then
			amount = math.floor(amount * 1.5)
		end

		if notify ~= false then
			exports['hud_notify']:notify(player, 'Зарплата', string.format('+%s$ за смену',
				splitWithPoints( amount, ' ' )
			))
		end

		addPlayerStats(player, 'raised_money', amount, sourceResource.name)

		return increasePlayerSessionData(player, 'money', amount)
	end

------------------------------------------------------------------------

	function finishPlayerSession(player)

		local session = workSessions[player]
		if not session or session.finished then return end
		session.finished = true

		triggerEvent('jobs.onJobFinish', player, session)

		clearTableElements(session)
		trackPlayerSession(player)

		resetFinishTimer(player)

		local money = math.floor(session.money or 0)

		exports['money']:givePlayerMoney(player, money)
		player:setData('work.current', nil)


		local log = table.copy(session)
		log.player = player.account.name

		workSessions[player] = nil
		givePlayerSessionData(player)

		clearPlayerTempStats(player)
		exports.hud_main:removePlayerHUDIcon( player, 'job' )
		exports.hud_main:removePlayerHUDRow( player, 'session_money' )
		
		exports['hud_notify']:notify(player, 'Работа', 'Вы завершили работу')
		exports['hud_notify']:notify(player, 'Зарплата', string.format('Вы получили %s$',
			splitWithPoints(money, ' ')
		))

		exports.main_sounds:playSound( player, 'work_finish' )

		return money

	end

------------------------------------------------------------------------

