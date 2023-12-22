

------------------------------------------------------

	function addClanRank( index, rank )

		if not client.team then return end

		local team_data = client.team:getData('team.data') or {}
		local team = teams[ team_data.id ]

		if team.data.creator ~= client.account.name then
			return exports.hud_notify:notify(client, 'Ошибка', 'Вы не владелец клана')
		end

		local ranks = team.data.ranks

		if rank then
			ranks[index] = rank
		else

			ranks[index] = nil

			local members = team.data.members

			for member, data in pairs( members ) do
				if data.rank == index then
					data.rank = nil
				end
			end

			setTeamData( team.data.id, 'members', members )
			

		end


		setTeamData( team.data.id, 'ranks', ranks )

		exports.hud_notify:notify(client, 'Успешно', 'Ранги изменены')

	end
	addEvent('clan.addRank', true)
	addEventHandler('clan.addRank', resourceRoot, addClanRank)	

------------------------------------------------------

	function editPlayerRank( member, rank )

		if not client.team then return end

		local team_data = client.team:getData('team.data') or {}
		local team = teams[ team_data.id ]

		if not hasPlayerRight(client, 'edit_rank') then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно прав')
		end

		local members = team.data.members
		if not members[member] then return end

		members[member].rank = rank
		exports.hud_notify:notify(client, 'Успешно', 'Ранг изменен')

		setTeamData( team.data.id, 'members', members )

		exports.logs:addLog(
			'[CLAN][EDIT_RANK]',
			{
				data = {
					player = client.account.name,
					member = member,
					new_rank = rank,
					team_name = team.data.name,
				},	
			}
		)

	end
	addEvent('clan.editPlayerRank', true)
	addEventHandler('clan.editPlayerRank', resourceRoot, editPlayerRank)	

------------------------------------------------------