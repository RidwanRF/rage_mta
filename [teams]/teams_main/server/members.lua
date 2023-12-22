

------------------------------------------------------------

	function updateTeamMembers( id )

		local team = teams[id]
		if not team then return end

		for member, data in pairs( team.data.members ) do

			local account = getAccount( member )
			if account then

				data.enter_time = account:getData('lastSeen') or getRealTime().timestamp
				data.nickname = account:getData('character.nickname')
				data.level = account:getData('level') or 0

				if account.player then
					updatePlayerTeam( account.player, team )
				end

			end

		end


		setTeamData( team.data.id, 'members', team.data.members )

	end

------------------------------------------------------------

	function updatePlayerTeam( player, team )

		if not isElement(player) then return end
		if not team then return end

		if not team.data.members[player.account.name] then
			return player:setData('team.id', false)
		end

		player.team = team.team
		player:setData('team.id', team.data.id)
		
		synchronizeTeam( team.team, player )

	end

	addEventHandler('onPlayerLogin', root, function()

		local team_id = source:getData('team.id')

		if team_id then
			updatePlayerTeam( source, getTeamFromId( team_id ) )
		end

	end, true, 'low-100')

------------------------------------------------------------

	function editMemberRank( member, rank )

		local team_id = client:getData('team.id')
		local team = getTeamFromId( team_id )
		if not team then return end

		local members = team.data.members

		if not members[member] then
			return false
		end

		if not hasPlayerRight( client, 'edit_rank' ) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно прав')
		end

		members[member].rank = rank
		setTeamData( team_id, 'members', members )

	end

------------------------------------------------------------

	function kickClanMember( member )

		if member == client.account.name then
			return exports.hud_notify:notify(client, 'Ошибка', 'Нельзя исключить себя')
		end

		local team_id = client:getData('team.id')
		local team = getTeamFromId( team_id )
		if not team then return end

		local members = team.data.members
		local ranks = team.data.ranks

		if not members[member] then
			return false
		end

		if not hasPlayerRight( client, 'kick' ) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно прав')
		end

		if members[member].rank and ranks[ members[member].rank ].rights.no_kick
			and team.data.creator ~= client.account.name
		then
			return exports.hud_notify:notify(client, 'Ошибка', 'Игрока нельзя исключить')
		end

		if removeClanMember( team_id, member ) then

			exports.main_alerts:addAccountAlert( member, 'info', 'Исключение из клана',
				string.format('Вы исключены из клана %s\nигроком %s',
					team.data.name, client.account.name
				)
			)

			appendTeamHistory( team_id,
				('#cd4949%s#ffffff исключил %s'):format(
					formatPlayerName(client), member
				)
			)

			exports.hud_notify:notify(client, 'Успешно', 'Игрок исключен')

			exports.logs:addLog(
				'[CLAN][KICK]',
				{
					data = {
						player = client.account.name,
						member = member,
						team = team_id,
						team_name = team.data.name,
					},	
				}
			)

		end



	end
	addEvent('clan.kickMember', true)
	addEventHandler('clan.kickMember', resourceRoot, kickClanMember)

------------------------------------------------------------
	
	function addClanMember( team_id, member, _rank )

		local team = getTeamFromId( team_id )
		if not team then return end

		local members = team.data.members

		if members[member] then
			return false
		end

		local account = getAccount( member )

		members[member] = {

			rank = _rank,
			invited = getRealTime().timestamp,

			enter_time = account:getData('lastSeen') or getRealTime().timestamp,
			nickname = account:getData('character.nickname'),

		}
		
		setTeamData( team_id, 'members', members )

		if account.player then

			account.player:setData('team.id', team_id)
			updatePlayerTeam( account.player, team )

		else
			account:setData('team.id', team_id)
		end

		return true

	end

	function removeClanMember( team_id, member )

		local team = getTeamFromId( team_id )
		if not team then return end

		local members = team.data.members

		-- if not members[member] then
		-- 	return false
		-- end

		local account = getAccount( member )

		if account.player then
			account.player:setData('team.id', false)
			account.player.team = nil
		else
			account:setData('team.id', nil)
		end

		for _, war in pairs( getTeamWars( team.team ) or {} ) do

			if war.clan_war and
				(war.clan_war.attackers and war.clan_war.attackers[account.name])
				or 
				(war.clan_war.defenders and war.clan_war.defenders[account.name])
			then

				if war.clan_war.attackers then
					war.clan_war.attackers[account.name] = nil
				end

				if war.clan_war.defenders then
					war.clan_war.defenders[account.name] = nil
				end

				exports.main_business:setBusinessData( war.id, 'clan_war', war.clan_war )

			end

		end

		account:setData('team.last_exit', getRealTime().timestamp)

		members[member] = nil
		setTeamData( team_id, 'members', members )

		return true

	end

------------------------------------------------------------

	addCommandHandler('tm_addmember', function( player, _, team_id, login )

		if exports.acl:isAdmin(player) then

			team_id = tonumber(team_id)

			if addClanMember(team_id, login ) then
				exports.chat_main:displayInfo( player, 'tm_addmember successfully', {255,255,255} )
			end

		end

	end)

------------------------------------------------------------