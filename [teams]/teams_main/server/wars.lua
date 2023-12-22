
---------------------------------------------------------------------
function formatTimestamp( int )
    local int = tonumber(int) or 0 
    return os.date( "%Y-%m-%d %H:%M:%S",  int )
end

	function toggleAreaWar( area_id )

		if not client.team then return end
		local team_data = client.team:getData('team.data') or {}

		local business = exports.main_business:getBusinessFromId( area_id )
		if not business then return end

		if not business.data.clan_war then return end

		if not hasPlayerRight(client, 'area_war') then
			return exports.hud_notify:notify( client, 'Ошибка', 'Недостаточно прав' )
		end

		if warTimers[ area_id ] and isTimer( warTimers[ area_id ].start_war ) then
			return exports.hud_notify:notify( client, 'Ошибка', 'Действие недоступно' )
		end

		local player_team
		if business.data.clan == team_data.id then
			player_team = 'defenders'
		elseif business.data.clan_war.opponent == team_data.id then
			player_team = 'attackers'
		end

		local clan_war = business.data.clan_war
		clan_war[player_team] = clan_war[player_team] or {}

		local m = clan_war[player_team][ client.account.name ]

		if (not m) and getTableLength( clan_war[player_team] ) >= Config.maxWarMembers then
			return exports.hud_notify:notify( client, 'Ошибка', ('Максимум участников - %s'):format( Config.maxWarMembers ) )
		end
		
		clan_war[player_team][ client.account.name ] = (not m) and true or nil

		local joined = 0
		local wars = getTeamWars( client.team )

		for _, war in pairs( wars ) do
			if not m and war.clan_war and war.id ~= business.data.id and
			((war.clan_war.attackers and war.clan_war.attackers[client.account.name]) or
			(war.clan_war.defenders and war.clan_war.defenders[client.account.name])) then

				if business.data.clan_war.timestamp == war.clan_war.timestamp then
					return exports.hud_notify:notify( client, 'Ошибка', 'У вас уже есть бой на это время' )
				end

				joined = joined + 1

			end
		end

		if joined >= 3 then
			return exports.hud_notify:notify( client, 'Ошибка', 'Вы уже участвуете в 3 боях' )
		end

		exports.main_business:setBusinessData( area_id, 'clan_war', clan_war )

		if clan_war[player_team][ client.account.name ] then
			exports.hud_notify:notify( client, 'Успешно', 'Вы присоединились к бою' )
		else
			exports.hud_notify:notify( client, 'Успешно', 'Вы покинули бой' )
		end

		triggerClientEvent(client.team.players, 'teams.gui.forceUpdateWar', resourceRoot, area_id, clan_war)

		exports.logs:addLog(
			'[CLAN][WARJOIN]',
			{
				data = {
					player = client.account.name,
					team = team_data.id,
					team_name = team_data.name,
					area_id = area_id,
				},	
			}
		)

	end
	addEvent('teams.toggleAreaWar', true)
	addEventHandler('teams.toggleAreaWar', resourceRoot, toggleAreaWar)

---------------------------------------------------------------------

	function kickWarMember( area_id, member )

		if not client.team then return end
		local team_data = client.team:getData('team.data') or {}

		local business = exports.main_business:getBusinessFromId( area_id )
		if not business then return end

		if not business.data.clan_war then return end

		if not hasPlayerRight(client, 'area_war_kick') then
			return exports.hud_notify:notify( client, 'Ошибка', 'Недостаточно прав' )
		end

		local clan_war = business.data.clan_war

		if warTimers[ area_id ] and isTimer( warTimers[ area_id ].start_war ) then
			return exports.hud_notify:notify( client, 'Ошибка', 'Действие недоступно' )
		end

		if clan_war.attackers then clan_war.attackers[ member ] = nil end
		if clan_war.defenders then clan_war.defenders[ member ] = nil end

		exports.main_business:setBusinessData( area_id, 'clan_war', clan_war )

		local member_acc = getAccount(member)

		if member_acc and member_acc.player then
			exports.hud_notify:notify( member_acc.player, 'Вы исключены из боя', 'ID Территории: ' .. area_id )
		end

		exports.hud_notify:notify( client, 'Успешно', 'Игрок исключен' )

		triggerClientEvent(client.team.players, 'teams.gui.forceUpdateWar', resourceRoot, area_id, clan_war)

		exports.logs:addLog(
			'[CLAN][WARKICK]',
			{
				data = {

					player = member,
					kicker = client.account.name,

					team = team_data.id,
					team_name = team_data.name,
					area_id = area_id,

				},	
			}
		)

	end

	addEvent('teams.kickWarMember', true)
	addEventHandler('teams.kickWarMember', resourceRoot, kickWarMember)

---------------------------------------------------------------------

	warTimers = {}

---------------------------------------------------------------------
	
	function finishWar( area_id, winner )

		-- local warTimer = warTimers[ area_id ]
		-- if not warTimer then return end

		local area = exports.main_business:getBusinessFromId( area_id )

		local clan_war = area.data.clan_war
		if not clan_war then return end

		exports.main_business:setBusinessData( area_id, 'clan_war', nil )

		if winner == 'attackers' then
			exports.main_business:setBusinessData( area_id, 'clan', clan_war.opponent )
		end

		local c_team = findTeamById( area.data.clan )
		local op_team = findTeamById( clan_war.opponent )

		if winner == 'attackers' then

			exports.hud_notify:notify( op_team.players, 'Победа', 'Клан захватил территорию')
			exports.hud_notify:notify( c_team.players, 'Поражение', 'Клан потерял территорию')

			exports.main_sounds:playSound( op_team.players, 'win' )
			exports.main_sounds:playSound( c_team.players, 'loose' )

			increaseTeamStats( op_team, 'success_wars', 1 )
			increaseTeamStats( c_team, 'fail_wars', 1 )

			appendTeamHistory( clan_war.opponent,
				('Клан захватил новую территорию ( ID: #cd4949%s#ffffff )'):format(
					area_id
				)
			)

			appendTeamHistory( area.data.clan,
				('Клан потерял территорию ( ID: #cd4949%s#ffffff )'):format(
					area_id
				)
			)

		else

			exports.hud_notify:notify( c_team.players, 'Победа', 'Клан удержал территорию')
			exports.hud_notify:notify( op_team.players, 'Поражение', 'Клан не захватил территорию')

			exports.main_sounds:playSound( c_team.players, 'win' )
			exports.main_sounds:playSound( op_team.players, 'loose' )

			increaseTeamStats( c_team, 'success_wars', 1 )
			increaseTeamStats( op_team, 'fail_wars', 1 )

			appendTeamHistory( clan_war.opponent,
				('Клан не смог захватить территорию ( ID: #cd4949%s#ffffff )'):format(
					area_id
				)
			)

			appendTeamHistory( area.data.clan,
				('Клан удержал территорию ( ID: #cd4949%s#ffffff )'):format(
					area_id
				)
			)

		end

		-- removeWarTimer( area_id )

	end

	function startWar( area_id )

		local warTimer = warTimers[ area_id ]
		if not warTimer then return end

		local matchModes = {
			Match, CaptureMatch, VehiclesMatch
		}

		local s_match = matchModes[ warTimer.match_mode ]

		local match = s_match( {

			dimension = 20000 + area_id,
			mode = warTimer.match_mode,
			
			callback = function( match, winner_team )
				finishWar( match.area_id, winner_team )
			end,

		} )
		
		match.area_id = area_id

		for p_type, section in pairs( warTimer.players ) do

			for _, login in pairs( section ) do

				local account = getAccount( login )

				if account and account.player then

					if isElement(account.player) then
						increaseElementData( account.player, 'team.areas.wars', 1 )
						exports.main_freeroam:updatePlayerAchievments( account.player )
						match:addPlayer( account.player, p_type )
					end

				end

			end

		end

		match:start()

		removeWarTimer( area_id )

	end

---------------------------------------------------------------------

	function prepareWar( area_id )

		local warTimer = warTimers[ area_id ]
		if not warTimer then return end

		local area = exports.main_business:getBusinessFromId( area_id )

		local clan_war = area.data.clan_war
		if not clan_war then return end

		local war_members = {}

		if not clan_war.test then

			if getTableLength( clan_war.attackers ) < 3 and getTableLength( clan_war.defenders ) < 3 then

				exports.teams_main:appendTeamHistory( clan_war.opponent,
					('Бой за территорию #cd4949%s#ffffff не состоялся: мало участников'):format(
						area_id
					)
				)

				exports.teams_main:appendTeamHistory( area.data.clan,
					('Бой за территорию #cd4949%s#ffffff не состоялся: мало участников'):format(
						area_id
					)
				)

				exports.main_business:setBusinessData( area_id, 'clan_war', nil )

				return removeWarTimer( area_id )

			elseif getTableLength( clan_war.defenders ) < 3 then

				finishWar( area_id, 'attackers' )
				return removeWarTimer( area_id )


			elseif getTableLength( clan_war.attackers ) < 3 then

				finishWar( area_id, 'defenders' )
				return removeWarTimer( area_id )

			end

		end

		area.data.clan_war.starting = true
		exports.main_business:setBusinessData( area_id, 'clan_war', area.data.clan_war )

		local teams = {
			getTeamFromId( area.data.clan_war.opponent ),
			getTeamFromId( area.data.clan ),
		}

		for _, team in pairs(teams) do
			triggerClientEvent(team.team.players, 'teams.gui.forceUpdateWar', resourceRoot, area_id, area.data.clan_war)
		end

		local war_players = {}

		for index, section in pairs( { attackers = clan_war.attackers, defenders = clan_war.defenders } ) do

			war_players[index] = war_players[index] or {}

			for member in pairs( section ) do
				local account = getAccount( member )
				if account then

					table.insert( war_players[index], account.name )

					if account.player then
						table.insert( war_members, account.player )
					end

				end
			end

		end

		local prepareWarTime = clan_war.test and 1 or Config.prepareWarTime

		warTimer.start_war = setTimer(startWar, prepareWarTime*1000, 1, area_id)
		warTimer.players = war_players

		warTimer.started = getRealTime().timestamp

		area.data.time = prepareWarTime

		triggerClientEvent(war_members, 'teams.displayWarPrepare', resourceRoot, area.data, warTimer.started)

	end

	addEventHandler('onPlayerLogin', root, function()

		if source.team then

			local wars = getTeamWars( source.team )

			for _, war in pairs( wars ) do

				if war.clan_war and war.clan_war.starting and
					(
						( war.clan_war.attackers and war.clan_war.attackers[ source.account.name ] )
						or ( war.clan_war.defenders and war.clan_war.defenders[ source.account.name ] )
					)
				then

					local warTimer = warTimers[ war.id ]
					if not warTimer then return end

					war.time = war.clan_war.test and 1 or Config.prepareWarTime

					return triggerClientEvent(source, 'teams.displayWarPrepare', resourceRoot, war, warTimer.started)

				end

			end

		end

	end, true, 'low-1000')

---------------------------------------------------------------------

	function createWarTimer( area_id )

		if warTimers[ area_id ] then return end
		local area = exports.main_business:getBusinessFromId( area_id )

		local realTime = getRealTime().timestamp
		local time_delta = area.data.clan_war.timestamp - realTime

		local prepareWarTime = area.data.clan_war.test and 1 or Config.prepareWarTime
		local timeout = (time_delta - prepareWarTime)*1000
		iprint(area.data.clan_war.timestamp, formatTimestamp(area.data.clan_war.timestamp))
		if timeout > 1000 then

			warTimers[ area_id ] = {
				timer = setTimer(prepareWar, timeout, 1, area_id),
				match_mode = area.data.clan_war.mode,
			}

			outputDebugString( ('CREATING AREA %s WAR TIMER, %s sec'):format( area_id, timeout/1000 ) )

		else
			exports.main_business:setBusinessData( area_id, 'clan_war', nil )
		end


	end
	function removeWarTimer( area_id )

		local warTimer = warTimers[ area_id ]
		if not warTimer then return end

		clearTableElements( warTimer )
		warTimers[ area_id ] = nil

	end

---------------------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		setTimer(function()

			for _, marker in pairs( getElementsByType('marker', getResourceRoot('main_business')) ) do

				local b_data = marker:getData('business.data') or {}

				if b_data.clan_war then
					b_data.marker = marker
					createWarTimer( b_data.id )
				end

			end
			
		end, 10000, 1)

	end)

---------------------------------------------------------------------

	function wipeClanWars( team_id )

		local team = getTeamFromId( team_id )
		local wars = getTeamWars( team.team )

		for _, war in pairs(wars) do

			if war.clan_war and war.clan_war.opponent == team_id then
				exports.main_business:setBusinessData( war.id, 'clan_war', nil )
			end

		end

	end

---------------------------------------------------------------------