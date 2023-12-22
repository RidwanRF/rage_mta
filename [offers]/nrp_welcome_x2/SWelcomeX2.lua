OFFER_DURATION = 48 * 60 * 60

function onPlayerCompleteLogin_handler( player )
    local player = isElement( player ) and player or source
    if not isElement( player ) then return end
    if player.account:getData( "welcome_x2_accept" ) then return end
    local time = tonumber( player.account:getData( "welcome_x2" ) or 0 ) or 0
    if time - getRealTime( ).timestamp > 0 then
    	player:setData( "welcome_x2", time )
    	triggerClientEvent( player, "onStartX2Request", resourceRoot, time - getRealTime( ).timestamp, true )
    end
end
addEventHandler( "onPlayerLogin", root, onPlayerCompleteLogin_handler )

function onResourceStart_handler( )
    for i, v in pairs( getElementsByType( "player" ) ) do
       -- if v:IsInGame( ) then
           	Timer( onPlayerCompleteLogin_handler, 1500, 1, v )
        --end
    end
end
addEventHandler( "onResourceStart", resourceRoot, onResourceStart_handler )


-- Очистка оффера после покупки
function onX2Purchase_handler( cost )
    local player = client or source

    player.account:setData( "welcome_x2", false )
    
    player:SetCommonData( { X2_bought = true } )
    setElementData( player, "X2_ready", false, false )
    triggerEvent( "onX2WelcomeOfferComplete", player )
    triggerClientEvent( player, "onParseX2Purchase", resourceRoot )
end
addEvent( "onX2Purchase", true )
addEventHandler( "onX2Purchase", root, onX2Purchase_handler )

addEvent( "OnPlayerRequestX2", true )
addEventHandler( "OnPlayerRequestX2", root, function( ) 
	local player = isElement( client ) and client.type == "player" and client or source
	if player.account:getData( "welcome_x2_accept" ) then return end

	local current_x2 = player.account:getData( "welcome_x2" ) or 0
	if current_x2 > 0 then
		local time = current_x2 - getRealTime().timestamp
		triggerClientEvent( player, "onStartX2Request", resourceRoot, time, true )
		return
	end

	player.account:setData( "welcome_x2", getRealTime( ).timestamp + OFFER_DURATION )
	player:setData( "welcome_x2", getRealTime( ).timestamp + OFFER_DURATION )
	triggerClientEvent( player, "onStartX2Request", resourceRoot, OFFER_DURATION, true )
end)

addEvent( "OnActivateX2Offer", true )
addEventHandler( "OnActivateX2Offer", resourceRoot, function( sum ) 
	client.account:setData( "x2_offer_sum", true )
	client.account:setData( "welcome_x2", false )
	client:setData( "welcome_x2", false )
	client.account:setData( "welcome_x2_accept", true )
end)