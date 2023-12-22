ADMIN_EVENTS = { };
PLAYER_EVENTS = { };
EVENTS = { };

function getPlayerWeapons( player )
	local list = { }
	if isElement( player ) then
		for i = 1, 9 do
			local weapon = getPedWeapon( player, i )
            if weapon and weapon ~= 0 then
                local ammo = getPedTotalAmmo( player, i )
				table.insert( list, { weapon, ammo } )
			end
		end
	end
	return list
end

Player.IsAdmin = function ( self )
	return true
end

addEvent ( 'MP::InitUI', true )
addEventHandler ( 'MP::InitUI', resourceRoot, function ( ) 
	if client:IsAdmin ( ) then
		client:triggerEvent ( 'MP::ShowUI', resourceRoot )
	end
end)

function StartAdminEvent ( name, max_players, tp_time, int, dim )

	local event_id = #ADMIN_EVENTS > 0 and #ADMIN_EVENTS + 1 or 1
	
	if ADMIN_EVENTS [ event_id ] then return end
	if client:getData ( 'iEventID' ) then
		client:outputChat ( 'Ты уже проводишь мероприятие', 255, 0, 0 )
		return
	end

	ADMIN_EVENTS [ event_id ] = {
		creator = client;
		max_player_count = tonumber ( max_players );
		interior = int;
		dimension = dim;
		name = name;
		teleport_stop_date = os.time ( ) + tonumber ( tp_time );
		players_list = { };
		players_data = { };
		vehicles = { };
		id = event_id;

		Destroy = function( self )
			
			for player in pairs( self.players_data ) do
				RemovePlayerFromEvent( player )
			end
			for i, v in pairs ( self.vehicles ) do
				if isElement ( v ) then destroyElement ( v ) end
				self.vehicles = { }
			end
			ADMIN_EVENTS[ self.id ] = nil
			EVENTS [ self.creator ] = nil;
		end
	}

	local notify = {
		name = name;
		id = event_id;
		creator = client;
	}

	triggerClientEvent ( 'MP::ShowJoinUIPanel', resourceRoot, notify )

	EVENTS [ client ] = event_id;

	client.interior = int or 0
	client.dimension = dim or 1
	client:setData ( 'iEventID', event_id, false )
	triggerClientEvent ( client, 'MP::OnPlayerStartEvent', resourceRoot )
end
addEvent ( 'MP::StartAdminEvent', true )
addEventHandler ( 'MP::StartAdminEvent', resourceRoot, StartAdminEvent )

function StopAdminEvent ( )
	if not EVENTS [ client ] then
		client:outputChat ( 'Мероприятие не проводиться', 255, 0, 0 )
		return
	end
	local event = ADMIN_EVENTS [ EVENTS [ client ] ];
	if event then
		event:Destroy ( )
	end
	EVENTS [ client ] = nil;
	client:setData ( 'iEventID', false, false )
end
addEvent ( 'MP::StopAdminEvent', true )
addEventHandler ( 'MP::StopAdminEvent', resourceRoot, StopAdminEvent )

function AsyncStopEvent ( player )
	local event_id = player:getData ( 'iEventID' ) or false
	if not event_id then return end
	local event = ADMIN_EVENTS [ event_id ]
	if not event then return end
	event:Destroy ( )
	ADMIN_EVENTS [ event_id ] = nil
	EVENTS [ player ] = nil
	player:setData ( 'iEventID', false, false )
end

function OnPlayerJoinToMP_handler ( id )
	local event = ADMIN_EVENTS [ id ]
	if not event then
		client:outputChat ( 'Мероприятие закончилось', 255, 0, 0 )
		return
	end

	if event.max_player_count <= #event.players_list - 1 then
		client:outputChat( "Необходимое количество игроков уже набрано", 255, 0, 0 )
		return
	end

	if os.time( ) >= event.teleport_stop_date then
		client:outputChat( "Телепорт больше недоступен", 255, 0, 0 )
		return
	end

	--if event.creator == client then return

	if PLAYER_EVENTS [ client ] then return end

	table.insert ( event.players_list, client );

	local current_event = {
		interior = client.interior;
		dimension = client.dimension;
		position = {
			x = client.position.x,
			y = client.position.y,
			z = client.position.z,
		};

		skin = client.model;
		armor = client.armor;
		health = client.health;
		weapons = getPlayerWeapons ( client );
	}

	event.players_data[ client ] = current_event
	PLAYER_EVENTS[ client ] = event
	removePedFromVehicle ( client )
	takeAllWeapons ( client );

	client.interior = event.interior;
	client.dimension = event.dimension;

	if client ~= event.creator then
		local r = math.random( ) * 20
		local a = math.random( ) * math.pi
		client.position = event.creator.position + Vector3( math.cos( a ) * r, math.sin( a ) * r, 0 )
	end
	client:setData ( 'is_on_event', id )
	triggerClientEvent ( event.creator, 'MP::OnPlayerJoinToEvent', client )

	removeEventHandler ( 'onPlayerWasted', client, onPlayerPreWasted_eventHandler )
	removeEventHandler ( 'onPlayerQuit', client, OnPlayerPreQuit_handler )
	addEventHandler ( 'onPlayerWasted', client, onPlayerPreWasted_eventHandler )
	addEventHandler ( 'onPlayerQuit', client, OnPlayerPreQuit_handler )
end
addEvent ( 'MP::OnPlayerJoinToEvent', true )
addEventHandler ( 'MP::OnPlayerJoinToEvent', resourceRoot, OnPlayerJoinToMP_handler )

function RemovePlayerFromEvent ( player, is_dead )
	local current_event = PLAYER_EVENTS[ player ]
	if not current_event then return end

	local player_data = current_event.players_data[ player ]
	if not player_data then return end
	player.health = player_data.health or 100
	player.armor = player_data.armor or 0

	if player == current_event.creator then
		player.dimension = 0
		player.interior = 0
	end

	if is_dead then
		Timer ( function ( player )
			spawnPlayer( player, player_data.position.x, player_data.position.y, player_data.position.z, 0, player_data.skin or player.model, player_data.interior or 0, player_data.dimension or 0 )
			setCameraTarget( player )
			player:setData ( 'is_on_event', false, true )
		end, 500, 1, player)
	else
		setElementPosition ( player, player_data.position.x, player_data.position.y, player_data.position.z )
		player.interior = player == current_event.creator and 0 or player_data.interior or 0
		player.dimension = player == current_event.creator and 0 or player_data.dimension or 0
		player.model = player_data.skin or player.model
	end

	takeAllWeapons ( player )

	for i, v in pairs ( player_data.weapons ) do
		giveWeapon ( player, v [ 1 ], v [ 2 ], true )
	end

	current_event.players_data[ player ] = nil

	for k, v in pairs( current_event.players_list ) do
		if v == player then
			table.remove( current_event.players_list, k )
			break
		end
	end
	

	PLAYER_EVENTS[ player ] = nil
	triggerClientEvent ( current_event.creator, 'MP:onPlayerLeaveEvent', player )
	return true
end

function onPlayerPreWasted_eventHandler( )
	local event = PLAYER_EVENTS[ source ]
	if not event then
		local event_id = source:getData( "is_on_event" )
		if ADMIN_EVENTS[ event_id ] then
			local event = ADMIN_EVENTS[ event_id ]
			for player in pairs( event.players_data ) do
				if player == source then
					RemovePlayerFromEvent( player, true )
					break
				end
			end
		end
		return false
	end
	RemovePlayerFromEvent( source, true )

	--[[if source == event.creator then
		spawnPlayer( source, source.position, 0, source.model, 0, event.dimension )
		setCameraTarget( source )
		cancelEvent( )

		
	elseif RemovePlayerFromEvent( source, true ) then
		--source:ShowInfo( "Вы погибли" )
		cancelEvent( )
	end]]
end

function OnPlayerPreQuit_handler ( )
	local id = source:getData ( 'is_on_event' ) or source:getData ( 'iEventID' ) or false
	if not id then return end
	local event = ADMIN_EVENTS[ id ]

	if event.creator == source then
		event:Destroy( )
	else
		RemovePlayerFromEvent( source )
	end
end

function OnPlayerEventAction_handler ( action, value )
	local event_id = client:getData ( 'iEventID' ) or false
	if not event_id then return end
	local event = ADMIN_EVENTS [ event_id ]
	if not event then return end

	if action == 'health' then
		for i, player in pairs ( event.players_list ) do
			if isElement ( player ) and player ~= client then
				player.health = tonumber ( value ) or 100;
			end
		end
		client:outputChat ( 'Вы выдали всем здоровье: '..tonumber(value), 0, 255, 0 )
	elseif action == 'armor' then
		for i, player in pairs ( event.players_list ) do
			if isElement ( player ) and player ~= client then
				player.armor = tonumber ( value ) or 100;
			end
		end
		client:outputChat ( 'Вы выдали всем броню: '..tonumber(value), 0, 255, 0 )
	elseif action == 'skin' then
		for i, player in pairs ( event.players_list ) do
			if isElement ( player ) and player ~= client then
				setElementModel ( player, tonumber ( value ) )
			end
		end
		client:outputChat ( 'Вы выдали всем скин: '..tonumber(value), 0, 255, 0 )
	elseif action == 'frozen' then
		for i, player in pairs ( event.players_list ) do
			if isElement ( player ) and player ~= client then
				player.frozen = true;
			end
		end
		client:outputChat ( 'Вы заморозили всех', 0, 255, 0 )
	elseif action == 'unfrozen' then
		for i, player in pairs ( event.players_list ) do
			if isElement ( player ) and player ~= client then
				player.frozen = false;
			end
		end
		client:outputChat ( 'Вы разморозили всех', 0, 255, 0 )
	end
end
addEvent ( 'MP::OnPlayerEventAction', true )
addEventHandler ( 'MP::OnPlayerEventAction', resourceRoot, OnPlayerEventAction_handler )

function RemovePlayersFromEvent_handler( players )
	local id = client:getData ( 'iEventID' ) or false
	if not id then return end

	local event = ADMIN_EVENTS[ id ]
	if not event then return end

	if players then
		for i, player in pairs( players ) do
			if event.players_data[ player ] then
				RemovePlayerFromEvent( player )
			end
		end
	else
		for player in pairs( event.players_data ) do
			if player ~= client then
				RemovePlayerFromEvent( player )
			end
		end
	end

	client:outputChat( "Вы успешно убрали игроков из ивента!" )
end
addEvent( "MP::RemovePlayersFromEvent", true )
addEventHandler( "MP::RemovePlayersFromEvent", resourceRoot, RemovePlayersFromEvent_handler )

function GiveItemToPlayers( players, item_type, item_data )
	local id = source:getData ( 'iEventID' ) or false
	if not id then return end

	local event = ADMIN_EVENTS[ id ]
	if not event then
		source:outputChat( "Это можно сделать только после запуска ивента!" )
		return
	end

	for i, player in pairs( players ) do
		local player_data = event.players_data[ player ]
		if isElement( player ) and player_data then
			if item_type == "skin" then
				setElementModel ( player, item_data )
			elseif item_type == "weapon" then
				giveWeapon( player, item_data[ 1 ], item_data[ 2 ] )
			end
		end
	end
	source:outputChat( "Успешно выдано!" )
end
addEvent( "AP:GiveItemToPlayers", true )
addEventHandler( "AP:GiveItemToPlayers", root, GiveItemToPlayers )

function GivePrizeToPlayer ( players, value )
	if value > Config.max_prize then return end
	local id = client:getData ( 'iEventID' ) or false
	if not id then return end

	local event = ADMIN_EVENTS[ id ]
	if not event then
		client:outputChat( "Это можно сделать только после запуска ивента!" )
		return
	end

	for i, player in pairs ( players ) do
		if isElement ( player ) then
			exports['money']:givePlayerMoney ( player, tonumber ( value ) )
			player:outputChat ( ( 'Адмнистратор %s выдал вам приз в размере %s, спасибо за участие!' ):format ( client.name, value ) )
		end
		outputChatBox ( ( 'В мероприятии «%s» победил(и): %s и получили приз: %s' ):format ( event.name, player.name, value..' руб.' ), root, 0, 255, 0 )
	end
	AsyncStopEvent ( client );
end
addEvent ( 'MP::GivePrizeToPlayer', true )
addEventHandler ( 'MP::GivePrizeToPlayer', resourceRoot, GivePrizeToPlayer )

addEventHandler ( 'onResourceStop', resourceRoot, function ( ) 
	for _, player in ipairs ( getElementsByType ( 'player' ) ) do
		local event_id = player:getData ( 'is_on_event' ) or false
		if event_id then
			local event = ADMIN_EVENTS [ event ]
			if event then
				event:Destroy ( )
			end
		end
		if player:getData ( 'iEventID' ) then player:setData ( 'iEventID', false, false ) end
	end
end)

function CreateEventVehicles( vehicle_ids, count, r, g, b )
	local id = source:getData ( 'iEventID' ) or false
	if not id then return end

	local event = ADMIN_EVENTS[ id ]
	if not event then
		source:ShowError( "Это можно сделать только после запуска ивента!" )
		return
	end

	local available_count = Config.max_event_vehicles - table.size( event.vehicles )
	if available_count == 0 then
		source:ShowError( "Вы уже создали макс. кол-во ТС" )
		return
	elseif #vehicle_ids * count > available_count then
		source:ShowError( "Слишком много ТС, вы можете ещё создать " .. available_count .. " шт." )
		return
	end

	local new_vehicles = { }
	local position = source.position
	for i, id in pairs( vehicle_ids ) do
		for i = 1, count do
			local position = position:AddRandomRange( 20 )
			local vehicle = Vehicle ( id, position.x, position.y, position.z )
			vehicle.dimension = event.dimension
			vehicle:setColor( r, g, b )
			table.insert ( event.vehicles, vehicle )
			table.insert( new_vehicles, vehicle )
		end
	end

	source:outputChat( "Транспорт успешно создан!", 0, 255, 0 )
end
addEvent( "MP::CreateEventVehicles", true )
addEventHandler( "MP::CreateEventVehicles", root, CreateEventVehicles )