


------------------------------------------------------------------------

	function addClanRule( index, text )

		if not client.team then return end

		local team_data = client.team:getData('team.data') or {}
		local team = teams[ team_data.id ]

		if team.data.creator ~= client.account.name then
			return exports.hud_notify:notify(client, 'Ошибка', 'Вы не владелец клана')
		end

		local rules = team.data.rules

		if text then

			if rules[index] then
				rules[index] = text
			elseif #rules < 10 then
				table.insert( rules, text )
			end

		else

			table.remove( rules, index )

		end


		setTeamData( team.data.id, 'rules', rules )

		exports.hud_notify:notify(client, 'Успешно', 'Правила изменены')

	end
	addEvent('clan.addRule', true)
	addEventHandler('clan.addRule', resourceRoot, addClanRule)

------------------------------------------------------------------------