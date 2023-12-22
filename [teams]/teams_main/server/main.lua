

------------------------------------------------------------

	db = dbConnect('sqlite', ':databases/teams.db')

------------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		-- dbExec(db, 'DROP TABLE teams;')
		dbExec(db, 'CREATE TABLE IF NOT EXISTS teams(id INTEGER PRIMARY KEY, name TEXT, members TEXT, ranks TEXT, rules TEXT, inventory TEXT, max_members INTEGER, creator TEXT, icon INTEGER, color TEXT, bank INTEGER, history TEXT, stats TEXT, limits TEXT, rating INTEGER);')
		
		-- dbExec(db, 'ALTER TABLE teams ADD COLUMN rating INTEGER;')
		-- dbExec(db, 'ALTER TABLE teams ADD COLUMN rating INTEGER;')
		-- dbExec(db, 'ALTER TABLE teams ADD COLUMN limits TEXT;')
		-- dbExec(db, 'ALTER TABLE teams ADD COLUMN stats TEXT;')
		-- dbExec(db, 'UPDATE teams SET stats="[[]]";')

		

		dbTables = {
			inventory = true,
			members = true,
			history = true,
			ranks = true,
			rules = true,
			stats = true,
			limits = true,
		}

		setTimer(function()

			local data = dbPoll( dbQuery(db, 'SELECT * FROM teams;'), -1 )

			for _, clan in pairs( data ) do
				initializeClan(clan)
			end

			updateClansTop()
			
		end, 1000, 1)


	end)		

------------------------------------------------------------

	teams = {}

------------------------------------------------------------

	function getTeamFromId(id)
		return teams[id]
	end

------------------------------------------------------------

	function initializeClan( data )

		for key in pairs( dbTables ) do
			data[key] = fromJSON( data[key] or '[[]]', true ) or {}
		end


		local _members = {}
		for member, m_data in pairs( data.members ) do
			_members[tostring(member)] = m_data
		end
		data.members = _members

		local r,g,b = hexToRGB( data.color or '#ffffff' )
		local team = createTeam( data.name, r,g,b )

		team:setData('team.data', data, false)

		team:setData('team.id', data.id)
		team:setData('team.icon', data.icon)

		teams[ data.id ] = {
			team = team,
			data = data,
		}

		updateTeamMembers( data.id )

		return teams[ data.id ]

	end

------------------------------------------------------------

	function setTeamData( id, key, value, sync )

		local team = teams[id]
		if not team then return end

		team.data[key] = value
		team.team:setData('team.data', team.data, false)

		dbExec(db, ('UPDATE teams SET ?=? WHERE id=%s;'):format( id ),
			key,
			type(value) == 'table' and toJSON(value) or value
		)

		if sync ~= false then
			synchronizeTeam( team.team )
		end

	end

	function getTeamData( id, key )

		local team = teams[id]
		if not team then return end

		return team.data[key]

	end

------------------------------------------------------------

	function getFreeClanId()
		local newID = false
		local result = dbPoll(dbQuery(db, 'SELECT id FROM teams ORDER BY id ASC'), -1)
		for i, row in pairs (result) do
			if tonumber(row.id) ~= i then
				newID = i
				break
			end
		end
		return newID or (#result + 1)
	end

------------------------------------------------------------

	function createClan( name, icon, color )

		if getTeamFromName(name) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Данное имя занято')
		end

		local cost = Config.creationCost

		if cost > ( client:getData('bank.donate') or 0 ) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
		end

		if client:getData('team.id') then
			return exports.hud_notify:notify(client, 'Ошибка', 'Вы уже состоите в клане')
		end

		local id = getFreeClanId()
		local emptyTable = toJSON({})

		local data = {

			id = id,

			name = name,
			color = color,
			icon = icon,

			bank = 0,
			rating = 0,
			max_members = 10,
			
			inventory = emptyTable,
			rules = emptyTable,
			ranks = emptyTable,
			members = emptyTable,
			history = emptyTable,
			stats = emptyTable,
			limits = emptyTable,

			creator = client.account.name,

		}

		local keys, values, inserts = {}, {}, {}
		for key, value in pairs( data ) do
			table.insert(keys, key)
			table.insert(values, value)
			table.insert(inserts, '?')
		end

		dbExec(db, ('INSERT INTO teams(%s) VALUES (%s);'):format( table.concat(keys, ', '), table.concat(inserts, ', ') ), unpack( values ))

		initializeClan(data)

		addClanMember( id, client.account.name )

		exports.hud_notify:notify( client, 'Успешно', 'Вы создали клан' )
		exports.hud_notify:notify( client, 'Нажмите F4', 'Для управления кланом', 10000 )

		increaseElementData( client, 'bank.donate', -cost )

		exports.main_freeroam:updatePlayerAchievments( client )

		exports.logs:addLog(
			'[CLAN][CREATE]',
			{
				data = {
					player = client.account.name,
					member = member,
					team = id,
					team_name = name,
					cost = cost,
				},	
			}
		)

	end
	addEvent('clan.create', true)
	addEventHandler('clan.create', resourceRoot, createClan)

------------------------------------------------------------

	function deleteClan( team )

		if not isElement(team) then return end

		local team_data = team:getData('team.data')
		if not team_data then return end

		for member in pairs( team_data.members ) do

			local account = getAccount( member )

			exports.main_alerts:addAccountAlert( member, 'info', 'Ваш клан распущен',
				string.format('Клан %s распущен владельцем\nВы больше не являетесь его участником',
					team_data.name
				)
			)

			account:setData('team.id', nil)

			if account.player then

				exports.hud_notify:notify( account.player, 'Ваш клан распущен', 'Все игроки исключены' )
				account.player:setData('team.id', nil)

				account.player.team = nil

			end

		end

		exports.main_business:wipeClanAreas( team_data.id )
		wipeClanWars( team_data.id )
		wipeMansions( team_data.id )

		destroyElement(team)

		dbExec(db, ('DELETE FROM teams WHERE id=%s;'):format(
			team_data.id
		))

		teams[team_data.id] = nil

		return true

	end
	
	function deletePlayerClan()

		if not client.team then return end

		local team_data = client.team:getData('team.data') or {}
		local team = teams[ team_data.id ]

		if not team then return end

		if deleteClan(team.team) then

			exports.logs:addLog(
				'[CLAN][REMOVE]',
				{
					data = {
						player = client.account.name,
						team = team_data.id,
						team_name = team_data.name,
						serial = client.serial,
					},	
				}
			)

		end

	end
	addEvent('clan.delete', true)
	addEventHandler('clan.delete', resourceRoot, deletePlayerClan)

------------------------------------------------------------
	
	function leaveClan()

		if not client.team then return end

		local team_data = client.team:getData('team.data') or {}
		local team = teams[ team_data.id ]

		if not team then return end

		if removeClanMember( team_data.id, client.account.name ) then

			exports.hud_notify:notify( client, 'Клан', 'Вы покинули клан' )

			exports.logs:addLog(
				'[CLAN][LEAVE]',
				{
					data = {
						player = client.account.name,
						team = team_data.id,
						team_name = team_data.name,
					},	
				}
			)
			
		end


	end
	addEvent('clan.leave', true)
	addEventHandler('clan.leave', resourceRoot, leaveClan)

------------------------------------------------------------

	function changeClanName( name )

		if getTeamFromName(name) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Данное имя занято')
		end

		local cost = Config.changeNameCost

		if cost > ( client:getData('bank.donate') or 0 ) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
		end

		if not client.team then return end

		local team_data = client.team:getData('team.data') or {}
		local team = teams[ team_data.id ]

		if team.data.creator ~= client.account.name then
			return exports.hud_notify:notify(client, 'Ошибка', 'Вы не владелец клана')
		end

		increaseElementData( client, 'bank.donate', -cost )

		setTeamData( team.data.id, 'name', name )
		team.team.name = name

		exports.hud_notify:notify(client, 'Успешно', 'Имя клана изменено')

		appendTeamHistory( team.data.id, ('#cd4949%s#ffffff сменил имя клана на %s'):format( formatPlayerName(client), name ) )

		exports.logs:addLog(
			'[CLAN][CHANGE_NAME]',
			{
				data = {
					player = client.account.name,
					team_name = team_data.name,
					new_name = name,
				},	
			}
		)

	end
	addEvent('clan.changeName', true)
	addEventHandler('clan.changeName', resourceRoot, changeClanName)

------------------------------------------------------------

	function changeClanColor( color )

		local cost = Config.changeColorCost

		if cost > ( client:getData('bank.donate') or 0 ) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
		end

		if not client.team then return end

		local team_data = client.team:getData('team.data') or {}
		local team = teams[ team_data.id ]

		if team.data.creator ~= client.account.name then
			return exports.hud_notify:notify(client, 'Ошибка', 'Вы не владелец клана')
		end

		increaseElementData( client, 'bank.donate', -cost )

		setTeamData( team.data.id, 'color', color )

		local r,g,b = hexToRGB( color )
		setTeamColor(team.team, r,g,b)

		local mansion = getClanMansion( client.team )

		if isElement(mansion) then
			setMarkerColor( mansion, r,g,b, 150 )
		end

		exports.hud_notify:notify(client, 'Успешно', 'Цвет клана изменен')

		appendTeamHistory( team.data.id, ('#cd4949%s#ffffff сменил цвет клана'):format( formatPlayerName(client) ) )

		exports.logs:addLog(
			'[CLAN][CHANGE_COLOR]',
			{
				data = {
					player = client.account.name,
					team_name = team.data.name,
				},	
			}
		)

	end
	addEvent('clan.changeColor', true)
	addEventHandler('clan.changeColor', resourceRoot, changeClanColor)

------------------------------------------------------------

	function changeClanIcon( icon )

		local cost = Config.changeIconCost

		if cost > ( client:getData('bank.donate') or 0 ) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
		end

		if not client.team then return end

		local team_data = client.team:getData('team.data') or {}
		local team = teams[ team_data.id ]

		if team.data.creator ~= client.account.name then
			return exports.hud_notify:notify(client, 'Ошибка', 'Вы не владелец клана')
		end

		if team.data.icon == icon then
			return exports.hud_notify:notify(client, 'Ошибка', 'У вас уже есть этот титул')
		end

		increaseElementData( client, 'bank.donate', -cost )

		setTeamData( team.data.id, 'icon', icon )

		exports.hud_notify:notify(client, 'Успешно', 'Титул клана изменен')

		appendTeamHistory( team.data.id, ('#cd4949%s#ffffff сменил титул клана'):format( formatPlayerName(client) ) )

		exports.logs:addLog(
			'[CLAN][CHANGE_ICON]',
			{
				data = {
					player = client.account.name,
					team_name = team.data.name,
					icon = icon,
				},	
			}
		)

	end
	addEvent('clan.changeIcon', true)
	addEventHandler('clan.changeIcon', resourceRoot, changeClanIcon)

------------------------------------------------------------

	function extendClanSlots()

		local cost = Config.extendSlots.cost

		if cost > ( client:getData('bank.donate') or 0 ) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
		end


		if not client.team then return end

		local team_data = client.team:getData('team.data') or {}
		local team = teams[ team_data.id ]

		if team_data.max_members >= 50 then
			return exports.hud_notify:notify(client, 'Ошибка', 'Лимит - 50')
		end

		if team.data.creator ~= client.account.name then
			return exports.hud_notify:notify(client, 'Ошибка', 'Вы не владелец клана')
		end

		increaseElementData( client, 'bank.donate', -cost )

		setTeamData( team.data.id, 'max_members', team.data.max_members + Config.extendSlots.amount )

		exports.hud_notify:notify(client, 'Успешно', 'Слоты клана расширены')

		exports.logs:addLog(
			'[CLAN][EXTEND_SLOTS]',
			{
				data = {

					player = client.account.name,
					team_name = team.data.name,

					cost = cost,
					amount = Config.extendSlots.amount,

				},	
			}
		)

	end
	addEvent('clan.extendSlots', true)
	addEventHandler('clan.extendSlots', resourceRoot, extendClanSlots)

------------------------------------------------------------