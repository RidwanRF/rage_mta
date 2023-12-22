-- Interfacer.lua. Необходимая часть для работы интерфейсера в других ресурсах.

local getElementData    = getElementData
local getElementsByType = getElementsByType
local getElementByID    = getElementByID
local setElementID      = setElementID
local getElementType    = getElementType
local tonumber          = tonumber
local type              = type
local pairs             = pairs
local string_sub        = string.sub

THIS_RESOURCE_NAME = THIS_RESOURCE_NAME or getResourceName( getThisResource( ) )

addEvent( "onExtensionUpdate", true )
if _G.handle_extension_updates then
	removeEventHandler( "onExtensionUpdate", resourceRoot, _G.handle_extension_updates )
end

function handle_extension_updates( chunk, name, player )
	if client then return end
	if not chunk then
		outputDebugString( "Module load error: " .. inspect( chunk ) .. " // " .. inspect( name ), 2 )
		return 
	end

	local is_returnable = name == "execute" and isElement( player )
	local result, err

	if is_returnable then
		result, err = loadstring( "return " .. chunk )
	end

	if not result or err then
		result, err = loadstring( chunk )
	end

	if not result or err then 
		result = err
	else
		result = { result( ) }
	end 

	if is_returnable then
		triggerEvent( "onExecutionCallback", player, unpack( result ) )
	end
end
addEventHandler( "onExtensionUpdate", resourceRoot, handle_extension_updates )

local LOADED = { }

function Extendexe( name, ... )
	if LOADED[ name ] then return false, "Модуль " .. name .. " уже подключен" end
	if getResourceState( getResourceFromName( "lib" ) ) ~= "running" then return false, "Interfacer не запущен" end

	local str, err = exports.lib:extend( name, THIS_RESOURCE_NAME, ... )

	if str and not err then
		local chunk = type( str ) == "string" and loadstring( str )
		if chunk then
			local result, err = pcall( chunk )
			if not result then
				err = err and err:gsub( "%[string \".*%.%.%.\"%]:(%d+):" , "[" .. name .. ".lua:%1]" ) or "magic error"
				return false, err
			else
				LOADED[ name ] = true
				return true
			end
		end
	else
		return false, err
	end
end

function Import( name, ... )
	Extendexe( name, ... )
end

function Extend( name, ... )
	local result, err = Extendexe( name, ... )
	if not result and err then
		outputDebugString( err, 1 )
	end
end

function enum( name )
	return function( array )
		for i,v in ipairs( array ) do
			_G[v] = i
		end
	end
end

function getRealTimestamp( )
    if localPlayer then
        return localPlayer:getData( "timestamp_real" ) or 0
    end

    return getRealTime( ).timestamp + ( root:getData( "timestamp_fake_diff" ) or 0 )
end

function SET( ... )
	return exports.lib:setConfig( ... )
end

function GET( ... )
	return exports.lib:getConfig( ... )
end

Debug = outputDebugString