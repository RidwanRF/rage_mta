

------------------------------------------------------------

	invites = {}

------------------------------------------------------------

	function sendPlayerInvite( player )

		if not isElement(player) then
			return exports.hud_notify:notify( client, 'Ошибка', 'Игрок не найден' )
		end

		local time_delta = getRealTime().timestamp - (player.account:getData('team.last_exit') or 0)
		local hours_reload = 10

		local l = math.ceil( ( 3600*hours_reload - time_delta*hours_reload )/3600 )
		
		if l > 0 then
			
			return exports.hud_notify:notify( client, 'Игрок недавно покинул клан', ('Можно пригласить через %sч.'):format(
				l
			) )

		end

		if player.team then
			return exports.hud_notify:notify( client, 'Ошибка', 'Игрок уже в клане' )
		end

		if getDistanceBetween( client, player ) > 20 then
			return exports.hud_notify:notify( client, 'Ошибка', 'Игрок слишком далеко' )
		end

		local invite = invites[player]
		if invite then
			return exports.hud_notify:notify( client, 'Ошибка', 'Игрок уже приглашен' )
		end

		local team_data = client.team:getData('team.data') or {}

		local members = getTableLength( team_data.members )
		local invited = 0

		for player, invite in pairs( invites ) do
			if invite.team == client.team then
				invited = invited + 1
			end
		end

		if ( members + invited ) >= team_data.max_members then

			if invited > 0 then
				return exports.hud_notify:notify( client, 'Ошибка', 'Превышен лимит приглашений' )
			else
				return exports.hud_notify:notify( client, 'Ошибка', 'В клане недостаточно места' )
			end

		end

		invites[player] = {

			team = client.team,
			inviter = client,

			inviter_name = client.name,
			team_name = client.team.name,

		}

		triggerClientEvent( player, 'teams.displayInvite', resourceRoot, invites[player])
		exports.hud_notify:notify( player, 'Приглашение в клан', 'Откройте F4' )
		exports.hud_notify:notify( client, 'Успешно', 'Приглашение отправлено' )

	end
	addEvent('teams.sendPlayerInvite', true)
	addEventHandler('teams.sendPlayerInvite', resourceRoot, sendPlayerInvite)

------------------------------------------------------------

	function inviteResult( result )

		local invite = invites[client]
		if not invite then return end

		if not isElement(invite.team) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Клан уже распущен')
		end

		invites[client] = nil

		local team_data = invite.team:getData('team.data') or {}

		if getTableLength( team_data.members ) >= team_data.max_members then
			return exports.hud_notify:notify(client, 'Ошибка', 'В клане недостаточно мест')
		end

		if result then

			addClanMember( team_data.id, client.account.name )

			exports.hud_notify:notify(client, 'Успешно', 'Вы вступили в клан')

			if isElement(invite.inviter) then
				exports.hud_notify:notify(invite.inviter, 'Приглашение', client.name ..' вступил в клан')
			end

			appendTeamHistory( team_data.id,
				('#cd4949%s#ffffff вступил в клан'):format(
					client.name
				)
			)

			exports.logs:addLog(
				'[CLAN][JOIN]',
				{
					data = {
						player = client.account.name,
						team_id = team_data.id,
						team_name = team_data.name,
					},	
				}
			)

		else

			if isElement(invite.inviter) then
				exports.hud_notify:notify(invite.inviter, 'Приглашение', client.name ..' отклонил приглашение')
			end

		end

		invites[client] = nil

	end
	addEvent('teams.inviteResult', true)
	addEventHandler('teams.inviteResult', resourceRoot, inviteResult)

------------------------------------------------------------

	addEventHandler('onPlayerQuit', root, function()

		if invites[source] then

			if isElement(invites[source].inviter) then
				exports.hud_notify:notify(invites[source].inviter, 'Приглашение', source.name ..' вышел с сервера')
			end

			invites[source] = nil

		end

	end)

------------------------------------------------------------