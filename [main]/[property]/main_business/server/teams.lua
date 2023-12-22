

------------------------------------------------------------------------------------------------

	function captureArea( id )

		if not client.team then return end

		local data = businessMarkers[id].data
		if not data then return end

		if data.clan then return end

		if not exports.teams_main:hasPlayerRight(client, 'area_capture') then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно прав')
		end

		if not exports.teams_main:getClanMansion(client.team) then
			return exports.hud_notify:notify(client, 'Ошибка', 'У клана нет особняка')
		end

		local team_data = client.team:getData('team.data')
		if not team_data then return end


		local max_areas = 30
		-- local max_areas = math.floor( getTableLength( team_data.members or {} )/2 )

		if ( #exports.teams_main:getClanAreas( client.team ) + #exports.teams_main:getTeamWars( client.team, 'attack' ) ) >= max_areas then
			return exports.hud_notify:notify(client, 'Ошибка', 'Превышен лимит территорий')
		end

		if exports.teams_main:getTeamLimit(client.team, 'areas') >= 5 then
			return exports.hud_notify:notify(client, 'Ошибка', 'Не более 5 территорий в день')
		end

		setBusinessData( id, 'clan', team_data.id )
		exports.hud_notify:notify(client, 'Успешно', 'Территория захвачена')

		exports.teams_main:increaseTeamLimit(client.team, 'areas')

		exports.teams_main:appendTeamHistory( team_data.id,
			('#cd4949%s#ffffff захватил новую территорию'):format(
				exports.teams_main:formatPlayerName(client)
			)
		)

		exports.logs:addLog(
			'[CLAN][AREA][CAPTURE]',
			{
				data = {
					player = client.account.name,
					id = id,
					team_name = team_data.name,
				},	
			}
		)

	end
	addEvent('team_area.capture', true)
	addEventHandler('team_area.capture', resourceRoot, captureArea)

------------------------------------------------------------------------------------------------

	function leaveArea( id )

		if not client.team then return end

		local data = businessMarkers[id].data
		if not data then return end

		if not data.clan then return end

		if not exports.teams_main:hasPlayerRight(client, 'area_capture') then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно прав')
		end

		if not exports.teams_main:getClanMansion(client.team) then
			return exports.hud_notify:notify(client, 'Ошибка', 'У клана нет особняка')
		end

		if data.clan_war then
			return exports.hud_notify:notify(client, 'Нельзя покинуть территорию', 'Если за нее назначен бой')
		end

		local team_data = client.team:getData('team.data')
		if not team_data then return end

		setBusinessData( id, 'clan', nil )

		exports.hud_notify:notify(client, 'Успешно', 'Клан покинул территорию')

		exports.teams_main:appendTeamHistory( team_data.id,
			('#cd4949%s#ffffff покинул территорию ( ID #cd4949%s#ffff )'):format(
				exports.teams_main:formatPlayerName(client), id
			)
		)

		exports.logs:addLog(
			'[CLAN][AREA][LEAVE]',
			{
				data = {
					player = client.account.name,
					id = id,
					team_name = team_data.name,
				},	
			}
		)

	end
	addEvent('team_area.leave', true)
	addEventHandler('team_area.leave', resourceRoot, leaveArea)

------------------------------------------------------------------------------------------------

	function createAreaWar( id, mode, time )

		if not client.team then return end

		local test_mode = root:getData('isTest')

		local data = businessMarkers[id].data
		if not data then return end

		if not data.clan then
			return exports.hud_notify:notify(client, 'Ошибка', 'Территория свободна')
		end

		if not exports.teams_main:hasPlayerRight(client, 'area_create_war') then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно прав')
		end

		if not exports.teams_main:getClanMansion(client.team) then
			return exports.hud_notify:notify(client, 'Ошибка', 'У клана нет особняка')
		end

		if data.clan_war then
			return exports.hud_notify:notify(client, 'Ошибка', 'За территорию уже назначен бой')
		end

		local realTime = getRealTime()

		if isBetween( realTime.weekday, 1, 2 ) and not test_mode then
			return exports.hud_notify:notify(client, 'Бой недоступен', 'Завтра выходной день')
		end

		local timestamp = (
			realTime.timestamp - realTime.hour*3600 - realTime.minute*60 -
			realTime.second + time[1]*3600 + time[2]*60
		) + 86400

		local d_time = getRealTime( timestamp )

		if #exports.teams_main:getTeamWars( client.team, 'attack' ) >= 2 and not test_mode then
			return exports.hud_notify:notify(client, 'У вас превышен лимит', 'Максимум две атаки')
		end

		if #exports.teams_main:getTeamWars( exports.teams_main:findTeamById(data.clan), 'defend' ) >= 2 and not test_mode then
			return exports.hud_notify:notify(client, 'У противников превышен лимит', 'Максимум две защиты')
		end

		for _, war in pairs( exports.teams_main:getTeamWars( exports.teams_main:findTeamById(data.clan) ) ) do
			if war.clan_war.timestamp == timestamp then
				return exports.hud_notify:notify(client, 'У соперников уже есть бой', 'На назначенное время')
			end
		end

		for _, war in pairs( exports.teams_main:getTeamWars( client.team ) ) do
			if war.clan_war.timestamp == timestamp then
				return exports.hud_notify:notify(client, 'У вашего клана уже есть бой', 'На назначенное время')
			end
		end

		local team_data = client.team:getData('team.data')
		if not team_data then return end

		local max_areas = 30
		-- local max_areas = math.floor( getTableLength( team_data.members or {} )/2 )

		if ( #exports.teams_main:getClanAreas( client.team ) + #exports.teams_main:getTeamWars( client.team, 'attack' ) ) >= max_areas and not test_mode then
			return exports.hud_notify:notify(client, 'Ошибка', 'Превышен лимит территорий')
		end

		--[[if exports.teams_main:getTeamLimit(client.team, 'wars') >= 5 and not test_mode then
			return exports.hud_notify:notify(client, 'Ошибка', 'Не более 5 боев в день')
		end]]

		exports.teams_main:increaseTeamLimit(client.team, 'wars')

		local b_team = exports.teams_main:findTeamById( data.clan )
		local b_team_data = b_team:getData('team.data') or {}

		local war_data = {

			-- timestamp = realTime.timestamp + 20,
			timestamp = timestamp,

			time_str = ('%02d.%02d %02d:%02d МСК'):format(
				d_time.monthday, d_time.month+1, d_time.hour, d_time.minute
			),

			opponent = team_data.id,
			cancel_timestamp = realTime.timestamp + 1800,

			mode = mode,
			
		}

		if test_mode then
			war_data.timestamp = realTime.timestamp + 20
			war_data.test = true
		end

		setBusinessData( id, 'clan_war', war_data )
		exports.teams_main:createWarTimer( id )

		exports.hud_notify:notify(client, 'Успешно', 'Бой за территорию назначен')
		exports.hud_notify:notify(client.team.players, 'Назначен новый бой', 'Подробнее F4 > График битв', 20000)
		exports.hud_notify:notify(exports.teams_main:findTeamById(b_team_data.id).players, 'Назначен новый бой', 'Подробнее F4 > График битв', 20000)

		exports.teams_main:appendTeamHistory( team_data.id,
			('#cd4949%s#ffffff назначил бой за территорию'):format(
				exports.teams_main:formatPlayerName(client)
			)
		)

		exports.teams_main:appendTeamHistory( b_team_data.id,
			('Клан #cd4949%s#ffffff назначил вам бой за территорию'):format(
				client.team.name
			)
		)

		exports.logs:addLog(
			'[CLAN][AREA][CREATEWAR]',
			{
				data = {
					player = client.account.name,
					id = id,
					team_name = team_data.name,
				},	
			}
		)

	end
	addEvent('team_area.createWar', true)
	addEventHandler('team_area.createWar', resourceRoot, createAreaWar)

------------------------------------------------------------------------------------------------

	function leaveAreaWar( id )

		if not client.team then return end

		local data = businessMarkers[id].data
		if not data then return end

		if not data.clan then
			return exports.hud_notify:notify(client, 'Ошибка', 'Территория свободна')
		end

		if not exports.teams_main:hasPlayerRight(client, 'area_create_war') then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно прав')
		end

		if not exports.teams_main:getClanMansion(client.team) then
			return exports.hud_notify:notify(client, 'Ошибка', 'У клана нет особняка')
		end

		if not data.clan_war then
			return exports.hud_notify:notify(client, 'Ошибка', 'Бой не назначен')
		end

		if data.clan_war.starting then
			return exports.hud_notify:notify(client, 'Ошибка', 'Бой уже идет')
		end

		if ( data.clan_war.cancel_timestamp < getRealTime().timestamp ) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Поздно отменить бой')
		end

		local team_data = client.team:getData('team.data')
		if not team_data then return end

		local b_team = exports.teams_main:findTeamById( data.clan )
		local b_team_data = b_team:getData('team.data') or {}

		setBusinessData( id, 'clan_war', nil )
		exports.teams_main:removeWarTimer( id )

		exports.hud_notify:notify(client, 'Успешно', 'Бой за территорию отменен')

		exports.teams_main:appendTeamHistory( team_data.id,
			('#cd4949%s#ffffff отменил бой за территорию'):format(
				exports.teams_main:formatPlayerName(client)
			)
		)

		exports.teams_main:appendTeamHistory( b_team_data.id,
			('Клан #cd4949%s#ffffff отменил бой за территорию'):format(
				client.team.name
			)
		)

		exports.logs:addLog(
			'[CLAN][AREA][CANCELWAR]',
			{
				data = {
					player = client.account.name,
					id = id,
					team_name = team_data.name,
				},	
			}
		)

	end
	addEvent('team_area.leaveWar', true)
	addEventHandler('team_area.leaveWar', resourceRoot, leaveAreaWar)

------------------------------------------------------------------------------------------------

	function takeAreaMoney( id )

		if not client.team then return end

		local data = businessMarkers[id].data
		if not data then return end

		if not exports.teams_main:hasPlayerRight(client, 'area_capture') then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно прав')
		end

		local team_data = client.team:getData('team.data')
		if not team_data then return end

		data.clan_bank = data.clan_bank or 0

		if data.clan ~= team_data.id then return end
		if data.clan_bank == 0 then return end

		exports.teams_main:setTeamData( team_data.id, 'bank', team_data.bank + data.clan_bank )

		exports.teams_main:appendTeamHistory( team_data.id,
			('#cd4949%s#ffffff снял с территории #cd4949$%s#ffffff в общак'):format(
				exports.teams_main:formatPlayerName(client), splitWithPoints( data.clan_bank, '.' )
			)
		)

		setBusinessData( id, 'clan_bank', 0 )
		exports.hud_notify:notify(client, 'Успешно', 'Деньги выведены в общак')

		exports.logs:addLog(
			'[CLAN][AREA][TAKE_MONEY]',
			{
				data = {
					player = client.account.name,
					id = id,
					amount = data.clan_bank,
					team_name = team_data.name,
				},	
			}
		)

	end
	addEvent('team_area.takeMoney', true)
	addEventHandler('team_area.takeMoney', resourceRoot, takeAreaMoney)

------------------------------------------------------------------------------------------------

	function wipeClanAreas( team_id )

		for id, business in pairs( businessMarkers ) do
			if business.data.clan == team_id then
				setBusinessData( id, 'clan', nil )
				setBusinessData( id, 'clan_bank', 0 )
				setBusinessData( id, 'clan_war', nil )
			end
		end

	end

------------------------------------------------------------------------------------------------

	function handleAreasIncome()

		local data = exports.teams_main:getConfigSetting('areasData')

		for id, business in pairs( businessMarkers ) do

			if business.data.clan and business.data.clan_area_type then

				local c_data = data[ business.data.clan_area_type or 1 ]

				setBusinessData( id, 'clan_bank', (business.data.clan_bank or 0) + c_data.income )

				exports.teams_main:increaseTeamStats( exports.teams_main:findTeamById( business.data.clan ), 'areas_rating', c_data.rating )

			end

		end

	end

	addCommandHandler('areas_day_cycle', function( player, _, c1, c2, c3 )

		if exports.acl:isAdmin( player ) then

			handleAreasIncome()
			exports.chat_main:displayInfo( player, 'areas_day_cycle successfully', {255,255,255} )

		end

	end)

------------------------------------------------------------------------------------------------

	function recalculateTeamAreas( data )

		local total_need = data[1] + data[2] + data[3]
		local random_ids = {}

		for id, business in pairs( businessMarkers ) do

			setBusinessData( id, 'clan', nil )
			setBusinessData( id, 'clan_area_type', nil )
			setBusinessData( id, 'clan_war', nil )

			table.insert(random_ids, id)
		end

		random_ids = randomSort( random_ids )
		random_ids = table.slice( random_ids, 0, total_need )

		local index = 0

		for type, amount in pairs( data ) do

			for index = index+1, index+amount do
				local id = random_ids[index]
				setBusinessData( id, 'clan_area_type', type )
			end

			index = index + amount

		end


	end

	addCommandHandler('recalc_team_areas', function( player, _, c1, c2, c3 )

		if exports.acl:isAdmin( player ) then

			local c1, c2, c3 = tonumber(c1), tonumber(c2), tonumber(c3)
			if c1 and c2 and c3 then

				recalculateTeamAreas( { c1,c2,c3 } )

				exports.chat_main:displayInfo( player, 'recalc_team_areas successfully', {255,255,255} )

			end

		end

	end)

------------------------------------------------------------------------------------------------