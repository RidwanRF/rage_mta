ui.bg = GuiWindow ( x, y, width, height, Config.window_text, false );
ui.bg.visible = false;
ui.tabpanel = guiCreateTabPanel ( 0, 20, width, height-70, false, ui.bg )

for i, v in pairs ( Config.tabs ) do
	ui [ 'tab_'..i ] = guiCreateTab ( v.name, ui.tabpanel )
end

ui.tab1 = ui [ 'tab_'..1 ]
ui.tab2 = ui [ 'tab_'..2 ]
ui.tab3 = ui [ 'tab_'..3 ]

ui.close = GuiButton ( width - 160, height - 45, 150, 50, 'Закрыть', false, ui.bg );

ui.edit_mp_name = GuiEdit ( 10, 45, 210, 25, '', false, ui.tab1 )
ui.edit_mp_players = GuiEdit ( 10, 100, 210, 25, '', false, ui.tab1 )
ui.edit_mp_tp_time = GuiEdit ( 10, 155, 210, 25, '', false, ui.tab1 )

ui.edit_mp_name.maxLength = 20
ui.edit_mp_players.maxLength = 3
ui.edit_mp_tp_time.maxLength = 3
ui.edit_mp_players:setProperty( "ValidationString", "^[0-9]*$")
ui.edit_mp_tp_time:setProperty( "ValidationString", "^[0-9]*$")

guiCreateLabel ( 10, 22, 100, 15, 'Название МП', false, ui.tab1 )
guiCreateLabel ( 10, 80, 110, 15, 'Кол-во участников', false, ui.tab1 )
guiCreateLabel ( 10, 135, 205, 15, 'Время работы телепорта в секундах', false, ui.tab1 )

ui.start_mp = GuiButton ( 10, 200, 210, 35, 'Начать МП', false, ui.tab1 )
ui.end_mp = GuiButton ( 10, 240, 210, 35, 'Завершить МП', false, ui.tab1 )
ui.health_btn = GuiButton ( 10, 280, 210, 35, 'Выдать здоровье', false, ui.tab1 )
ui.armor_btn = GuiButton ( 10, 320, 210, 35, 'Выдать броню', false, ui.tab1 )
ui.froze_all = GuiButton ( 10, 360, 210, 35, 'Заморозить всех', false, ui.tab1 )
ui.unfroze_all = GuiButton ( 10, 400, 210, 35, 'Разморозить всех', false, ui.tab1 )

ui.list = guiCreateGridList ( 230, 20, 400, height-130, false, ui.tab1 )
ui.list.sortingEnabled = false
ui.list.selectionMode = 1
ui.list:addColumn( "№", 0.55 ) 
ui.list:addColumn( "Имя", 0.4 )

ui.list1 = guiCreateGridList ( 230, 20, 400, height-130, false, ui.tab2 )
ui.list1.sortingEnabled = false
ui.list1.selectionMode = 1
ui.list1:addColumn( "№", 0.55 ) 
ui.list1:addColumn( "Имя", 0.4 )

ui.del_player = GuiButton ( 230 + 410, 20, 150, 35, 'Убрать из эвента', false, ui.tab1 )
ui.refresh = GuiButton ( 230 + 410, 60, 150, 35, 'Обновить список', false, ui.tab1 )
ui.select_all = GuiButton ( 230 + 410, 100, 150, 35, 'Выделить все', false, ui.tab1 )
ui.select_all_1 = GuiButton ( 230 + 410, 140, 150, 35, 'Выделить половину', false, ui.tab1 )
ui.get_winner = GuiButton ( 230 + 410, 180, 150, 35, 'Объявить победителя и выдать приз', false, ui.tab1 )

ui.refresh1 = GuiButton ( 230 + 410, 20, 150, 35, 'Обновить список', false, ui.tab2 )
ui.select_all1 = GuiButton ( 230 + 410, 60, 150, 35, 'Выделить все', false, ui.tab2 )
ui.select_all_11 = GuiButton ( 230 + 410, 100, 150, 35, 'Выделить половину', false, ui.tab2 )

local skins_panel = guiCreateTabPanel( 5, 20, 220, 160, false, ui.tab2 )
local skins_panel = guiCreateTab( "Скины", skins_panel )
guiCreateLabel( 10, 15, 360, 25, "ID скина:", false, skins_panel )
ui.edit_skin_id = guiCreateEdit( 75, 13, 85, 25, "", false, skins_panel )
ui.edit_skin_id.maxLength = 4
ui.edit_skin_id:setProperty( "ValidationString", "^[0-9]*$")
ui.btn_set_skin = guiCreateButton( 5, 80, 210, 45, "Выдать", false, skins_panel )

local inventory_panel = guiCreateTabPanel( 5, 200, 220, 250, false, ui.tab2 )
local inventory_panel = guiCreateTab( "Оружие", inventory_panel )
guiCreateLabel( 10, 15, 300, 25, "Оружие:", false, inventory_panel )
ui.list_weapons = guiCreateComboBox( 75, 12, 135, 160, "", false, inventory_panel )
for k, v in pairs( Config.accepted_weapons ) do
	ui.list_weapons:addItem( v[ 1 ] ) 
end
ui.list_weapons.selected = 0
guiCreateLabel( 10, 100, 300, 25, "Патроны:", false, inventory_panel )
ui.edit_ammo = guiCreateEdit( 75, 100, 85, 25, "", false, inventory_panel )
ui.edit_ammo.maxLength = 4
ui.edit_ammo:setProperty( "ValidationString", "^[0-9]*$")
ui.btn_give_wepon = guiCreateButton( 5, 175, 210, 45, "Выдать", false, inventory_panel )

local panel = GuiTab( "Список машин для спавна", GuiTabPanel( 19, 15, width / 2-38, height - 120, false, ui.tab3 ) )
ui.veh_list = guiCreateGridList( 1, 1, width / 2 - 40, height - 300, false, panel )
ui.veh_list.selectionMode = 1
ui.veh_list:addColumn( "ID", 0.17 ) 
ui.veh_list:addColumn( "Название", 0.7 )

guiCreateLabel( 20, height - 275, 300, 20, "ID:", false, panel )
ui.edit_veh_ids = guiCreateEdit( 80, height - 275, 250, 20, "", false, panel )
ui.edit_veh_ids:setProperty( "ValidationString", "^[0-9,]*$")


guiCreateLabel( 20, height - 235, 300, 25, "Цвет:", false, panel )
ui.list_colors = guiCreateComboBox( 80, height - 235, 120, 200, "", false, panel )
ui.list_colors:setProperty( "ClippedByParent", "False" )
for i, color in pairs( Config.accepted_colors ) do
	ui.list_colors:addItem( color[ 1 ] )
end

guiCreateLabel( 20, height - 200, 300, 20, "Кол-во:", false, panel )
ui.edit_veh_count = guiCreateEdit( 80, height - 200, 120, 20, "1", false, panel )
ui.edit_veh_count.maxLength = 2
ui.edit_veh_count:setProperty( "ValidationString", "^[0-9]*$")

local vehicle_ids_to_names = { }
for id, data in pairs( VEHICLES_LIST ) do
	vehicle_ids_to_names[ id ] = data.name
end
vehicle_ids_to_names[ 432 ] = "Танк"
vehicle_ids_to_names[ 407 ] = "Пожарная"
vehicle_ids_to_names[ 601 ] = "SWAT"
vehicle_ids_to_names[ 428 ] = "Инкассация"
vehicle_ids_to_names[ 453 ] = "Pershing 50"
vehicle_ids_to_names[ 472 ] = "SpeedBoat Noname"
vehicle_ids_to_names[ 430 ] = "Sports FishingBoat"

for id, name in pairs( vehicle_ids_to_names ) do
	local row = ui.veh_list:addRow( )
	-- self.veh_list:setItemText( row, 1, row, false, false )
	ui.veh_list:setItemText( row, 1, id, false, true )
	ui.veh_list:setItemText( row, 2, name, false, false )
end

ui.btn_spawn_veh = guiCreateButton( width / 2 - 180, height - 200, 120, 30, "Заспавнить", false, panel )

local function GetSelectedPlayers( panel )
	local selected_players = { }
	for i, item in pairs( panel.selectedItems ) do
		if item.column == 0 then
			table.insert( selected_players, EVENT_PLAYERS[ item.row + 1 ] )
		end
	end
	if not next( selected_players ) then
		outputChatBox( "Выберите в списке игроков" )
		return false
	end
	return selected_players
end

addEventHandler ( 'onClientGUIClick', root, function ( key, state ) 
	if key == 'left' and state == 'up' then
		if source == ui.veh_list then
			local ids = { }
			for i, item in pairs( ui.veh_list.selectedItems ) do
				if item.column == 0 then
					table.insert( ids, ui.veh_list:getItemText( item.row, 1 ) )
				end
			end
			ui.edit_veh_ids.text = table.concat( ids, "," )

		elseif source == ui.btn_spawn_veh then
			local selected_ids = fromJSON( "[[" .. ui.edit_veh_ids.text .. "]]" )
			if not selected_ids or #selected_ids == 0 then
				outputChatBox( "Введите ID транспорта или выберите из списка" )
				return
			end
			for i, id in pairs( selected_ids ) do
				if not vehicle_ids_to_names[ id ] or not next( engineGetModelTextureNames( id ) ) then
					outputChatBox( "Введите корректные ID транспорта" )
					return
				end
			end
			if #selected_ids > 10 then
				outputChatBox( "Максимум 10 ID транспорта" )
				return
			end
			local color = Config.accepted_colors[ ui.list_colors.selected + 1 ]
			if not color then
				outputChatBox( "Выберите цвет" )
				return
			end
			local count = tonumber( ui.edit_veh_count.text )
			if not count or count == 0 then
				outputChatBox( "Введите количество" )
				return
			elseif #selected_ids * count > 10 then
				outputChatBox( "Вы не можете создать за раз больше 10 ТС" )
				return
			end
			triggerServerEvent( "MP::CreateEventVehicles", localPlayer, selected_ids, count, unpack( color[ 2 ] ) )
		elseif source == ui.close then
			ShowUI ( false );
		elseif source == ui.start_mp then

			local name = ui.edit_mp_name.text
			if name == "" then
				outputChatBox( "Введите название ивента" )
				return
			end
			local max_player_count = tonumber( ui.edit_mp_players.text )
			if not max_player_count or max_player_count < 1 then
				outputChatBox( "Введите количество игроков" )
				return
			end
			local teleport_enabled_duration = tonumber( ui.edit_mp_tp_time.text )
			if not teleport_enabled_duration then
				outputChatBox( "Введите время работы телепорта" )
				return
			elseif teleport_enabled_duration < 1 or teleport_enabled_duration > 180 then
				outputChatBox( "Введите корректное время работы телепорта (макс. 180 с)" )
				return
			end
			Input ( {
				mp = true;
				fn = function ( self )
					local int, dim = tonumber ( self.interior ), tonumber ( self.dimension )
					triggerServerEvent ( 'MP::StartAdminEvent', resourceRoot, name, max_player_count, teleport_enabled_duration, int, dim )
					self:destroy ( )
					ShowUI ( false )
				end
			} )
		elseif source == ui.end_mp then
			triggerServerEvent ( 'MP::StopAdminEvent', resourceRoot )
		elseif source == ui.health_btn then
			Input ( {
				edit_text = '(1-100)',
				fn = function ( self )
					local value = tonumber ( self.value );
					if value < 1 then value = 0 end
					triggerServerEvent ( 'MP::OnPlayerEventAction', resourceRoot, 'health', value )
					self:destroy ( )
				end
			} )
		elseif source == ui.armor_btn then
			Input ( {
				edit_text = '(0-100)',
				fn = function ( self )
					local value = tonumber ( self.value );
					triggerServerEvent ( 'MP::OnPlayerEventAction', resourceRoot, 'armor', value )
					self:destroy ( )
				end
			} )
		elseif source == ui.froze_all then
			triggerServerEvent ( 'MP::OnPlayerEventAction', resourceRoot, 'frozen' )
		elseif source == ui.unfroze_all then
			triggerServerEvent ( 'MP::OnPlayerEventAction', resourceRoot, 'unfrozen' )
		elseif source == ui.select_all then
			for i = 0, ui.list.rowCount - 1 do
				ui.list:setSelectedItem( i, 1, false )
			end
		elseif source == ui.select_all_1 then
			for i = 0, ( ui.list.rowCount - 1 ) / 2 do
				ui.list:setSelectedItem ( i, 1, false )
			end
		elseif source == ui.refresh then
			UpdatePlayersList ( )
		elseif source == ui.del_player then
			local players_selected = { }
			local selected_players = { }
			for i, item in pairs( ui.list.selectedItems ) do
				if item.column == 0 then
					local player = EVENT_PLAYERS[ item.row + 1 ]
					table.insert( selected_players, player )
					players_selected[ player ] = true
				end
			end
			if not next( selected_players ) then return end
			triggerServerEvent ( 'MP::RemovePlayersFromEvent', resourceRoot, selected_players )
			for i = #EVENT_PLAYERS, 1, -1 do
				local player = EVENT_PLAYERS[ i ]
				if players_selected[ player ] then
					table.remove( EVENT_PLAYERS, i )
					UpdatePlayersList ( )
				end
			end
		elseif source == ui.del_player1 then
			local players_selected = { }
			local selected_players = { }
			for i, item in pairs( ui.list.selectedItems ) do
				if item.column == 0 then
					local player = EVENT_PLAYERS[ item.row + 1 ]
					table.insert( selected_players, player )
					players_selected[ player ] = true
				end
			end
			if not next( selected_players ) then return end
			triggerServerEvent ( 'MP::RemovePlayersFromEvent', resourceRoot, selected_players )
			for i = #EVENT_PLAYERS, 1, -1 do
				local player = EVENT_PLAYERS[ i ]
				if players_selected[ player ] then
					table.remove( EVENT_PLAYERS, i )
					UpdatePlayersList ( )
				end
			end
		elseif source == ui.refresh1 then
			UpdatePlayersList ( )
		elseif source == ui.select_all1 then
			for i = 0, ui.list1.rowCount - 1 do
				ui.list1:setSelectedItem( i, 1, false )
			end
		elseif source == ui.select_all_11 then
			for i = 0, ( ui.list1.rowCount - 1 ) / 2 do
				ui.list1:setSelectedItem ( i, 1, false )
			end
		elseif source == ui.btn_set_skin then
			local skin = ui.edit_skin_id.text
			if not skin or skin == '' then return end
			skin = tonumber ( skin )
			local players = GetSelectedPlayers ( ui.list1 )
			if not players then return end
			triggerServerEvent ( "AP:GiveItemToPlayers", localPlayer, players, "skin", skin )
		elseif source == ui.btn_give_wepon then
			local weapon_id = Config.accepted_weapons[ ui.list_weapons.selected + 1 ][ 2 ]
			if not weapon_id then
				outputChatBox( "Выберите оружие из списка" )
				return
			end
			local ammo = tonumber( ui.edit_ammo.text )
			if not ammo or ammo < 0 then
				outputChatBox( "Введите количество патронов" )
				return
			end
			local selected_players = GetSelectedPlayers( ui.list1 )
			if not selected_players then return end
			triggerServerEvent( "AP:GiveItemToPlayers", localPlayer, selected_players, "weapon", { weapon_id, ammo } )
		elseif source == ui.get_winner then
			if #EVENT_PLAYERS > Config.max_winners then
				outputChatBox ( 'Победителей не должно быть больше '..Config.max_winners..'!', 0, 255, 0 )
				return
			end
			local selected_players = GetSelectedPlayers( ui.list )
			if not selected_players then return end
			Input ( {
				text = 'Объявление победителя';
				edit_text = ( 'Введи кол-во денег ( макс. сумма - %s )' ):format ( Config.max_prize );
				fn = function ( self )
					local value = tonumber ( self.value )
					if value > Config.max_prize then
						outputChatBox ( 'Макс сумма - '..Config.max_prize, 255, 0, 0 )
						return
					end
					triggerServerEvent ( 'MP::GivePrizeToPlayer', resourceRoot, selected_players, value )
					self:destroy ( )
				end
			} )
		end
	end
end)

function ShowUI ( state )
	if state then
		ShowUI ( false );
		showCursor ( true );
		ui.bg.visible = true;
	else
		ui.bg.visible = false;
		showCursor ( false );
	end
end
addEvent ( 'MP::ShowUI', true )
addEventHandler ( 'MP::ShowUI', resourceRoot, function ( ) 
	ShowUI ( not ui.bg.visible )
end)

bindKey ( Config.bind_key, 'down', function ( ) 
	if exports.acl:isModerator(localPlayer) or exports.acl:isAdmin ( localPlayer ) then
		ShowUI ( not ui.bg.visible )
	end
	--triggerServerEvent ( 'MP::InitUI', resourceRoot )
end)

function UpdatePlayersList ( )
	ui.list:clear ( )
	ui.list1:clear ( )

	for i, player in pairs ( EVENT_PLAYERS ) do
		if isElement ( player ) then
			ui.list:addRow( i, player.name )
			ui.list1:addRow( i, player.name )
		end
	end
end

function OnPlayerStartEvent ( )
	EVENT_PLAYERS = { };
	EVENT_VEHICLES = { };
	UpdatePlayersList ( )
end
addEvent ( 'MP::OnPlayerStartEvent', true )
addEventHandler ( 'MP::OnPlayerStartEvent', resourceRoot, OnPlayerStartEvent )

function OnPlayerJoinToEvent ( change )
	table.insert ( EVENT_PLAYERS, source )
	UpdatePlayersList ( )
end
addEvent ( 'MP::OnPlayerJoinToEvent', true )
addEventHandler ( 'MP::OnPlayerJoinToEvent', root, OnPlayerJoinToEvent )

function RemovePlayerFromList( removing_player )
	--local old_event_players = table.copy( EVENT_PLAYERS )
	for i, player in pairs( EVENT_PLAYERS ) do
		if player == removing_player then
			table.remove( EVENT_PLAYERS, i )
			break
		end
	end
	UpdatePlayersList(  )
end

function onPlayerLeaveEvent( )

	RemovePlayerFromList( source )
	removeEventHandler( "onClientPlayerQuit", source, onPlayerLeaveEvent )
end
addEvent( "MP:onPlayerLeaveEvent", true )
addEventHandler( "MP:onPlayerLeaveEvent", root, onPlayerLeaveEvent )

--ShowUI(true)