

-------------------------------------------------------

	addEventHandler('onResourceStart', resourceRoot, function()

		-- dbExec(db, 'DROP TABLE mansions;')
		dbExec(db, 'CREATE TABLE IF NOT EXISTS mansions(id INTEGER PRIMARY KEY, owner INTEGER, pos TEXT, cost INTEGER);')
		
		setTimer(function()

			local data = dbPoll( dbQuery(db, 'SELECT * FROM mansions;'), -1 )

			for _, mansion in pairs( data ) do
				createMansionMarker(mansion)
			end
			
		end, 1000, 1)


	end)		

-------------------------------------------------------

	mansions = {}

-------------------------------------------------------

	function setMansionData( id, key, value )

		local mansion = mansions[id]
		if not mansion then return end

		if value == 'false' then value = false end
		if value == 'nil' then value = nil end

		mansion.data[key] = value
		mansion.marker:setData('mansion.data', mansion.data)

		dbExec(db, ('UPDATE mansions SET %s=? WHERE id=%s;'):format( key, id ),
			type(value) == 'table' and toJSON(value) or value
		)

	end

	addCommandHandler('tm_setmansiondata', function(player, _, id, key, value)

		if exports.acl:isAdmin( player ) then

			id = tonumber(id)
			value = tonumber(value) or value

			if not id or not key or not value then
				return exports.chat_main:displayInfo(player, 'ERROR: NOT ENOUGH ARGS', {255, 0, 0})
			end

			setMansionData( id, key, value )

		end

	end)

-------------------------------------------------------

	addEventHandler('onElementDataChange', resourceRoot, function(dn, old, new)

		if dn == 'mansion.data' and new then

			local team_name = 'отсутствует'

			local team = getTeamFromId( new.owner )
			if team then team_name = team.team.name end

			source:setData('3dtext', string.format([=[
[ID - %s]
[Особняк клана]
[Клан - %s]
			]=],
				new.id, team_name)
			)

			if team and team.team and new.owner then
				local r,g,b = getTeamColor( team.team )
				setMarkerColor( source, r,g,b, 150 )
			else
				setMarkerColor( source, 200, 0, 0, 150 )
			end

		end

	end)

-------------------------------------------------------

	function createMansionMarker( data )

		data.pos = fromJSON( data.pos or '[[]]', true ) or {}

		local x,y,z = unpack( data.pos )
		local ex,ey,ez = unpack( Config.mansionInterior.enter )
		local ix,iy,iz = unpack( Config.mansionInterior.inventory )

		local marker = createMarker( x,y,z, 'cylinder', 2, 200, 0, 0, 150 )

		local exit_marker = createMarker( ex,ey,ez, 'cylinder', 1.2, 0, 0, 200, 150 )
		exit_marker:setData('3dtext', '[Выход]')

		local inventory_marker = createMarker( ix,iy,iz, 'cylinder', 1.2, 0, 200, 0, 150 )
		inventory_marker:setData('3dtext', '[Инвентарь]')

		marker:setData('mansion.data', data)

		for key, _marker in pairs( {
			inventory = inventory_marker,
			exit = exit_marker,
		} ) do

			_marker:setData('mansion.parent_marker', marker, false)
			_marker:setData('mansion.' .. key, true)

			_marker.interior = Config.mansionInterior.interior
			_marker.dimension = data.id
			iprint(_marker.interior)

		end

		if data.owner then

			local team = getTeamFromId( data.owner )

			if team then
				local r,g,b = hexToRGB( team.data.color or '#ffffff' )
				setMarkerColor( marker, r,g,b, 150 )
			end

		end

		mansions[data.id] = {
			data = data,
			marker = marker,
			exit_marker = exit_marker,
			inventory_marker = inventory_marker,
		}


	end

-------------------------------------------------------

	function buyMansion( id )

		if not client.team then return end

		local team_data = client.team:getData('team.data') or {}

		if team_data.creator ~= client.account.name then
			return exports.hud_notify:notify(client, 'Ошибка', 'Вы не владелец клана')
		end

		if getClanMansion( client.team ) then
			return exports.hud_notify:notify(client, 'Ошибка', 'У вас уже есть особняк')
		end

		local mansion = mansions[id]
		if not mansion then return end

		if ( exports.money:getPlayerMoney(client) < mansion.data.cost ) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
		end

		exports.money:takePlayerMoney(client, mansion.data.cost)
		setMansionData(id, 'owner', team_data.id)

		exports.hud_notify:notify(client, 'Успешно', 'Особняк приобретен')

		appendTeamHistory( team_data.id, ('#cd4949%s#ffffff приобрел особняк для клана'):format( formatPlayerName(client), name ) )

		exports.logs:addLog(
			'[CLAN][MANSION_BUY]',
			{
				data = {
					player = client.account.name,
					team_name = team_data.name,
					id = id,
					cost = mansion.data.cost,
				},	
			}
		)

	end
	addEvent('teams.buyMansion', true)
	addEventHandler('teams.buyMansion', resourceRoot, buyMansion)

-------------------------------------------------------

	function sellMansion( id )

		if not client.team then return end

		local team_data = client.team:getData('team.data') or {}

		if team_data.creator ~= client.account.name then
			return exports.hud_notify:notify(client, 'Ошибка', 'Вы не владелец клана')
		end

		local mansion = mansions[id]
		if not mansion then return end

		local cost = mansion.data.cost * Config.mansionSell

		exports.money:givePlayerMoney(client, cost)
		setMansionData(id, 'owner', nil)

		exports.main_business:wipeClanAreas( team_data.id )

		exports.hud_notify:notify(client, 'Успешно', 'Особняк продан')

		appendTeamHistory( team_data.id, ('#cd4949%s#ffffff продал особняк клана'):format( formatPlayerName(client), name ) )

		exports.logs:addLog(
			'[CLAN][MANSION_SELL]',
			{
				data = {
					player = client.account.name,
					team_name = team_data.name,
					id = id,
					cost = cost,
				},	
			}
		)

	end
	addEvent('teams.sellMansion', true)
	addEventHandler('teams.sellMansion', resourceRoot, sellMansion)

-------------------------------------------------------

	function sellMansionInvite( id, player, cost )

		if not client.team then return end

		local team_data = client.team:getData('team.data') or {}

		if team_data.creator ~= client.account.name then
			return exports.hud_notify:notify(client, 'Ошибка', 'Вы не владелец клана')
		end

		local mansion = mansions[id]
		if not mansion then return end

		triggerClientEvent(player, 'mansion.sellOffer', resourceRoot, mansion.data, client, cost)

		exports.logs:addLog(
			'[CLAN][MANSION][OFFER]',
			{
				data = {
					player = client.account.name,
					team_name = team_data.name,
					id = id,
					cost = cost,
				},	
			}
		)

	end
	addEvent('teams.sellMansionInvite', true)
	addEventHandler('teams.sellMansionInvite', resourceRoot, sellMansionInvite)

-------------------------------------------------------

	function sellMansionResponse( id, seller, cost, result )

		if not client.team then return end

		local team_data = client.team:getData('team.data') or {}

		if team_data.creator ~= client.account.name then
			return exports.hud_notify:notify(client, 'Ошибка', 'Вы не владелец клана')
		end

		local mansion = mansions[id]
		if not mansion then return end

		if not isElement(seller) then
			return exports.hud_notify:notify(client, 'Ошибка', 'Продавец вышел с сервера')
		end

		if not seller.team then
			return exports.hud_notify:notify(client, 'Ошибка', 'У продавца нет клана')
		end

		if getClanMansion( client.team ) then
			return exports.hud_notify:notify(client, 'Ошибка', 'У вас есть особняк')
		end

		if exports.money:getPlayerMoney(client) < cost then
			return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
		end

		if result then

			setMansionData( mansion.data.id, 'owner', client:getData('team.id') )
			exports.main_business:wipeClanAreas( seller:getData('team.id') )

			exports.money:takePlayerMoney( client, cost, false )
			exports.money:givePlayerMoney( seller, cost )

			exports['hud_notify']:notify(seller, 'Особняк', 'Игрок приобрел особняк', 3000)
			exports['hud_notify']:notify(client, 'Особняк', 'Вы приобрели особняк', 3000)

			exports.logs:addLog(
				'[CLAN][SELL_MANSION][ACCEPT]',
				{
					data = {
						player = client.account.name,
						team_name = team_data.name,
						id = id,
						cost = cost,
					},	
				}
			)

		else

			exports['hud_notify']:notify(seller, 'Особняк', 'Игрок отказался от покупки', 3000)

			exports.logs:addLog(
				'[CLAN][SELL_MANSION][DENY]',
				{
					data = {
						player = client.account.name,
						team_name = team_data.name,
						id = id,
						cost = cost,
					},	
				}
			)

		end

	end
	addEvent('teams.sellMansionResponse', true)
	addEventHandler('teams.sellMansionResponse', resourceRoot, sellMansionResponse)

-------------------------------------------------------

	function createNewMansion( player, _, cost )

		if exports.acl:isAdmin(player) then

			cost = tonumber(cost)

			if not cost then
				return exports.chat_main:displayInfo(player, 'ERROR: COST NOT FOUND', {255, 0, 0})
			end

			local new_id = getFreeDatabaseId( db, 'mansions' )
			local pos = toJSON( { getElementPosition(player) }, true )

			local data = {
				id = new_id,
				pos = pos,
				owner = nil,
				cost = cost,
			}

			dbExec( db, ('INSERT INTO mansions(id, owner, pos, cost) VALUES (%s, NULL, \'%s\', %s);'):format(
				new_id, data.pos, data.cost
			) )

			createMansionMarker( data )

		end

	end

	function deleteMansion( player, _, id )

		if exports.acl:isAdmin(player) then

			id = tonumber(id)
			local mansion = mansions[id]

			if not mansion then
				return exports.chat_main:displayInfo(player, 'ERROR: MANSION NOT FOUND', {255, 0, 0})
			end

			clearTableElements(mansion)
			dbExec( db, ('DELETE FROM mansions WHERE id=%s;'):format(id) )

			mansions[id] = nil

		end

	end

	addCommandHandler('tm_create_mansion', createNewMansion)
	addCommandHandler('tm_delete_mansion', deleteMansion)

-------------------------------------------------------

	function wipeMansions( team_id )

		for id, mansion in pairs( mansions ) do
			if mansion.data.owner == team_id then

				setMansionData(id, 'owner', nil)

			end
		end

	end

-------------------------------------------------------


	function enterMansion( player, marker )

		local m_data = marker:getData('mansion.data')
		if not m_data then return end

		setElementPosition( player, unpack( Config.mansionInterior.enter ) )
		player.interior = Config.mansionInterior.interior
		player.dimension = m_data.id

	end

	function exitMansion( player )

		local mansion = getClanMansion( player.team )
		if not isElement( mansion ) then return end

		local x,y,z = getElementPosition( mansion )
		setElementPosition( player, x,y,z )

		player.interior = 0
		player.dimension = 0

	end

-------------------------------------------------------

	function handleEnterMansion( id )

		local mansion = mansions[id]
		if not mansion then return end

		local m_data = mansion.marker:getData('mansion.data')

		if not m_data then

			local p_marker = mansion.marker:getData('mansion.parent_marker')

			if isElement(p_marker) then
				m_data = p_marker:getData('mansion.data')
			end

		end

		if not m_data then return end

		local t_id = client:getData('team.id')
		if not t_id then return end

		if mansion.marker:getData('mansion.data') and t_id == m_data.owner then

			enterMansion( client, mansion.marker )

		end

	end
	addEvent('mansion.enter', true)
	addEventHandler('mansion.enter', resourceRoot, handleEnterMansion)

-------------------------------------------------------

	addEventHandler('onMarkerHit', resourceRoot, function( player, mDim )

		if not isElement( source ) then return end

		local m_data = source:getData('mansion.data')

		if not m_data then

			local p_marker = source:getData('mansion.parent_marker')

			if isElement(p_marker) then
				m_data = p_marker:getData('mansion.data')
			end

		end

		if not m_data then return end

		local t_id = player:getData('team.id')
		if not t_id then return end

		if source:getData('mansion.exit') and t_id == m_data.owner then
			exitMansion( player )
		end

	end)

-------------------------------------------------------

	addEventHandler('onPlayerQuit', root, function()

		if source.interior == Config.mansionInterior.interior then
			exitMansion( source )
		end

	end)

-------------------------------------------------------