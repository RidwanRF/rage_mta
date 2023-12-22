
------------------------------------------------

	function startCranMovie()

		triggerClientEvent( root, 'auction.displayCranMovie', resourceRoot )

		setTimer(function()

			for index, auction in pairs( Config.auction ) do
				local x,y,z = unpack(auction)
				createAuction( x,y,z, math.random( #Config.auction_items ), Config.auctionTime, index )
			end

			exports.chat_main:displayInfo( root, string.format('В порту Лос-Сантоса проходит аукцион! Успей принять участие!'), {255, 220, 0} )

		end, Config.cranMovieTime, 1)

	end

	function spawnAuction()

		exports.chat_main:displayInfo( root, string.format('В порту Лос-Сантоса выгружаются контейнеры!'), {200, 255, 150} )

		startCranMovie()

	end

------------------------------------------------
	
	addCommandHandler('create_auction', function(player, _)

		if exports.acl:isAdmin(player) then

			spawnAuction()

		end

	end)

------------------------------------------------
	
	addEventHandler('onServerHourCycle', root, function()

		local h = getTime()

		if Config.spawnHours[h] then

			exports.chat_main:displayInfo( root, string.format('В порту Лос-Сантоса через 5 минут появятся контейнеры!'), {255, 255, 150} )
			setTimer(spawnAuction, 5*60*1000, 1)

		end


	end)

------------------------------------------------

HOUR_OFFSET = 0
function ExecAtTime( time, func, ... )
    local hour, minute = unpack( split( time, ":" ) )

    hour = tonumber( hour )
    minute = tonumber( minute )

    if not hour or not minute then Debug( "Timelib: Неверно задано время выполнения: h " .. tostring( hour ) .. ", m " .. tostring( minute ), 1 ) return end

    local self = { }

    self.hour = hour
    self.minute = minute

    self.func = func
    self.args = { ... }

    self.ParseTime = function( )
    	local timestamp = getRealTime( ).timestamp
        local realtime = getRealTime( timestamp + HOUR_OFFSET * 60 * 60 )
        
        local hour = realtime.hour
        local minute = realtime.minute

        if hour ~= self.hour then return end -- не соответствие часу
        if minute ~= self.minute then return end -- не соответствие минуте

        --iprint( THIS_RESOURCE_NAME, "ExecAtTime: run", getRealTime() )

        self:func( unpack( self.args ) )
        self:destroy()

        return true
    end

    self.timer = Timer( self.ParseTime, 1000*1, 0 )

    self.destroy = function( self )
        if isTimer( self.timer ) then killTimer( self.timer ) end
        setmetatable( self, nil )
        return true
    end

    self.again = function( self, delay )
        if isTimer( self.timer ) then killTimer( self.timer ) end
        self.timer = Timer( 
            function()
                self.timer = Timer( self.ParseTime, 1000*1, 0 )
            end
        , delay, 1 )
    end

    return self
end

for i, v in pairs ( Config.spawnHours ) do
	local hour = tostring ( i )
	ExecAtTime ( hour..':00', function ( ) 
		spawnAuction ( )
	end)
end