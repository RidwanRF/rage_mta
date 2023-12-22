

----------------------------------------------------------------

	function putClanMoney( amount )

		if not amount then return end
		if amount <= 0 then return end

		if amount > exports.money:getPlayerMoney(client) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
		end

		if not client.team then return end

		local team_data = client.team:getData('team.data') or {}
		local team = teams[ team_data.id ]

		exports.money:takePlayerMoney( client, amount )
		setTeamData( team.data.id, 'bank', team.data.bank + amount )

		exports.hud_notify:notify(client, 'Успешно', 'Казна пополнена')

		appendTeamHistory( team.data.id, ('#cd4949%s#ffffff пополнил казну на #cd4949$%s'):format(
			formatPlayerName(client), splitWithPoints(amount, '.')
		) )

		exports.logs:addLog(
			'[CLAN][PUT_MONEY]',
			{
				data = {
					player = client.account.name,
					team_name = team.data.name,
					amount = amount,
				},	
			}
		)

	end
	addEvent('clan.putMoney', true)
	addEventHandler('clan.putMoney', resourceRoot, putClanMoney)

----------------------------------------------------------------

	function takeClanMoney( amount )

		if not amount then return end
		if amount <= 0 then return end
		if not client.team then return end

		local team_data = client.team:getData('team.data') or {}
		local team = teams[ team_data.id ]

		if amount > team.data.bank then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег в казне')
		end

		exports.money:givePlayerMoney( client, amount )
		setTeamData( team.data.id, 'bank', team.data.bank - amount )

		exports.hud_notify:notify(client, 'Успешно', 'Вы взяли деньги')

		appendTeamHistory( team.data.id, ('#cd4949%s#ffffff взял из казны #cd4949$%s'):format(
			formatPlayerName(client), splitWithPoints(amount, '.')
		) )

		exports.logs:addLog(
			'[CLAN][TAKE_MONEY]',
			{
				data = {
					player = client.account.name,
					team_name = team.data.name,
					amount = amount,
				},	
			}
		)

	end
	addEvent('clan.takeMoney', true)
	addEventHandler('clan.takeMoney', resourceRoot, takeClanMoney)

----------------------------------------------------------------

	function handlePlayerSalary(player)

		if not player.team then return end
		if exports.afk:isAFK(player) then return end

		local team_data = player.team:getData('team.data') or {}
		local team = teams[ team_data.id ]

		local members = team.data.members
		local member_data = members[ player.account.name ]

		if member_data and hasPlayerRight(player, 'salary') then

			local rank = getPlayerRank( player )

			if rank and rank.salary and team.data.bank >= rank.salary then

				exports.money:givePlayerMoney( player, rank.salary )
				setTeamData( team.data.id, 'bank', team.data.bank - rank.salary )

				exports.hud_notify:notify(player, 'Клановая зарплата', ('Вы получили $%s'):format(
					splitWithPoints( rank.salary, '.' )
				), 6000)

			end

		end

	end

	function handleClanSalary()

		for _, team in pairs( teams ) do

			local salary = calculateClanSalary( team.team )

			if salary <= team.data.bank then

				for _, player in pairs( team.team.players ) do
					handlePlayerSalary(player)
				end

				synchronizeTeam( team.team )

			else

				for _, player in pairs( team.team.players ) do
					exports.hud_notify:notify( player, 'Ошибка клан. зарплаты', 'Недостаточно денег в казне' )
				end

			end

		end

	end

	addEventHandler('onServerHourCycle', root, handleClanSalary)

	addCommandHandler('tm_salary', function(player)

		if exports.acl:isAdmin( player ) then
			handleClanSalary()
		end

	end)

----------------------------------------------------------------