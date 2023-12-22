exports.save:addParameter( "faction_id", false, true )
exports.save:addParameter( "faction_rank", false, true )
exports.save:addParameter( "faction_exp", false, true )

loadstring( exports.interfacer:extend( "Interfacer" ) )( )
Extend( "ShFactionsConfig" )
Extend( "ShPlayer" )
Extend( "ShUtils" )


FACTIONS_DATA = { }
db = Connection( "sqlite", ":databases/factions.db" )
db:exec( "CREATE TABLE IF NOT EXISTS factions( id, owner )" )

addEvent( "OnPlayerJoinToFaction" )
addEvent( "OnPlayerFactionRankChanged" )
addEvent( "OnPlayerRemoveFaction" )

function LoadFactions( id )
	local result = db:query( "SELECT * FROM factions WHERE id=?", id ):poll( -1 )
	if result and #result > 0 then

		if FACTIONS_DATA[ id ] then
			FACTIONS_DATA[ id ] = nil
		end
		
		FACTIONS_DATA[ id ] = {
			id = id,
			owner = result.owner or "",
			members = GetFactionMembers( id )
		}
	else
		db:exec( "INSERT INTO factions VALUES( ?, ? )", id, "" )
		FACTIONS_DATA[ id ] = {
			owner = "",
			id = id,
			members = GetFactionMembers( id )
		}
	end
end

function GetFactionMembers( faction_id )
	local accounts = getAccounts( )
	local members = { }

	for i, v in pairs( accounts ) do
		local player = getAccountPlayer( v )
		if player then
			if player:GetFaction( ) == faction_id then
				table.insert( members, player.account.name )
			end
		else
			if ( v:getData( "faction_id" ) or 0 ) == faction_id then
				table.insert( members, v.account.name )
			end
		end
	end
	return members
end

function OnResourceStart( )
	for i, v in pairs( FACTIONS_NAMES ) do
		LoadFactions( i )
	end
end
addEventHandler( "onResourceStart", resourceRoot, OnResourceStart )

function GetFactionData( faction_id, key )
	if FACTIONS_DATA[ faction_id ] then
		return FACTIONS_DATA[ faction_id ][ key ]
	end
	return false
end

function SetFactionData( faction_id, key, value )
	if FACTIONS_DATA[ faction_id ] then
		FACTIONS_DATA[ faction_id ][ key ] = value
	end
end

function RemovePlayerOnMembers( self, faction_id )
	local members = GetFactionData( faction_id, "members" ) or { }

	for i, v in pairs( members ) do
		if type( self ) == "string" then
			if v == self then
				table.remove( members, i )
			end
		else
			if v == self.account.name then
				table.remove( members, i )
			end
		end
	end

	SetFactionData( faction_id, "members", members )
end

function SetPlayerFaction( pPlayer, iFactionID, iRankID )

	if iFactionID == false and not iRankID then
		local pPlayer = type( pPlayer ) == "string" and getAccount( pPlayer ) or pPlayer

		exports.logs:addLog(
			'[FACTIONS][SETFACTION]',
			{
				data = {
					player = pPlayer,
					faction = "false",
					rank = "false",
					old_faction = pPlayer:getData( "faction_id" )
				},	
			}
		)

		pPlayer:setData( "faction_id", false )
		pPlayer:setData( "faction_rank", false )
		pPlayer:setData( "faction_exp", false )

		RemovePlayerOnMembers( pPlayer, iFactionID )
		triggerEvent( "OnPlayerRemoveFaction", pPlayer, iFactionID )
		return
	end

	local faction_name = FACTIONS_NAMES[ iFactionID ]
	if not faction_name then return end

	pPlayer:setData( "faction_id", iFactionID )
	pPlayer:setData( "faction_rank", iRankID or 1 )
	pPlayer:setData( "faction_exp", 0 )

	local faction_members = GetFactionData( iFactionID, "members" ) or { }
	table.insert( faction_members, pPlayer.account.name );
	SetFactionData( iFactionID, "members", faction_members )


	triggerEvent( "OnPlayerJoinToFaction", pPlayer )
end

function SetFactionLeader( pPlayer, iFactionID )
	if type( pPlayer ) == "string" then
		local account = getAccount( tostring( pPlayer ) )
		if not account then
			return false;
		end
	else
		SetPlayerFaction( pPlayer, iFactionID, GetFactionMaxLevel( iFactionID ) )
		SetFactionData( iFactionID, "owner", pPlayer.account.name )
		db:exec( "UPDATE factions SET owner=? WHERE id=?", pPlayer.account.name, iFactionID )
	end
end

function OnPlayerInviteToFaction( faction_id )

end


function OnClientShowFactionUI( pPlayer )
	local player = isElement( pPlayer ) and pPlayer or client
	if not isElement( player ) then return end

	local player_faction = player:GetFaction( )
	local faction_data = FACTIONS_DATA[ player_faction ]
	if faction_data then
		local cache_timeout = faction_data.cache_timeout or 0
		if cache_timeout and faction_data.members_cache and cache_timeout > getRealTime( ).timestamp then
			triggerClientEvent( player, "UIControlMenu", resourceRoot, faction_data.members_cache )
		else
			ClientRequestFactiobMemberList_Callback( player, player_faction )
			faction_data.cache_timeout = getRealTime().timestamp + 1.4 * 60
		end
	end
end
addEvent( "OnClientShowFactionUI", true )
addEventHandler( "OnClientShowFactionUI", resourceRoot, OnClientShowFactionUI )

function ClientRequestFactiobMemberList_Callback( player, player_faction )
	local player_faction_members = GetFactionMembers( player_faction ) or { }
	local members = { }

	if #player_faction_members > 0 then
		for i, v in pairs( player_faction_members ) do
			local account = getAccount( v )
			if account then
				local account_player = getAccountPlayer( account )
				local elem = isElement( account_player ) and account_player or account

				table.insert( members, {
					nickname = elem.name,
					lastseen = account:getData( "lastSeen" ) or getRealTime( ).timestamp,
					rank = elem:getData( "faction_rank" ) or 1,
					exp = elem:getData( "faction_exp" ),
					is_leader = ( elem:getData( "faction_rank" ) or 1 ) == GetFactionMaxLevel( player_faction ),

				} )
			end
		end
		FACTIONS_DATA[ player_faction ].members_cache = members
		triggerClientEvent( player, "UIControlMenu", resourceRoot, members )
	end
end

addCommandHandler( "setleader", function( self, cmd, id ) 
	SetFactionLeader( self, id or F_PPS )
end)

addCommandHandler( "removefactions", function() 
	db:exec( "DELETE FROM factions" )
end)