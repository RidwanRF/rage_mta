-- TimeLib.lua

HOUR_OFFSET = 0 --3

getRealTimestamp = function ( )
    return getRealTime ( ).timestamp
end

-- Конвертирует timestamp в читабельную дату
formatTimestamp = function ( int )
    local int = tonumber ( int ) or 0 
    return os.date ( "%Y-%m-%d %H:%M:%S",  int )
end

function ExecAtTime( time, func, ... )
    local hour, minute = unpack( split( time, ":" ) )

    hour = tonumber( hour )
    minute = tonumber( minute )

    if not hour or not minute then iprint( "Timelib: Неверно задано время выполнения: h " .. tostring( hour ) .. ", m " .. tostring( minute ) ) return end

    local self = { }

    self.hour = hour
    self.minute = minute

    self.func = func
    self.args = { ... }

    self.ParseTime = function( )
        local realtime = getRealTime( getRealTimestamp( ) + HOUR_OFFSET * 60 * 60 )
        
        local hour = realtime.hour
        local minute = realtime.minute

        if hour ~= self.hour then return end -- не соответствие часу
        if minute ~= self.minute then return end -- не соответствие минуте


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