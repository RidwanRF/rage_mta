--[[local timeout = 5

function CleanupMemory( )

	engineRestreamWorld( )
end

function CheckMemoryUsage()
	local memory = engineStreamingGetUsedMemory( )
	outputConsole(memory)
	--setClipboard(memory)

	local byte = 1024
	local real_memory = math.floor( memory / byte / byte )
	
	if real_memory >= 100 then

	end
end
CheckMemoryUsage()
Timer( CheckMemoryUsage, 1500, 0 )

bindKey( "l", "down", CleanupMemory )]]

loadstring( exports.interfacer:extend( "Interfacer" ) )( )
Extend( "ib" )

ibUseRealFonts( true )

CONST_MEMORY_FIRST_CHECK_DELAY = 60 * 1000
CONST_MEMORY_POLL_RATE = 15 * 1000
CONST_MEMORY_DELAY_AFTER_CLEAN = CONST_MEMORY_POLL_RATE
CONST_MEMORY_CLEANUP_TIME = 10

CONST_MEMORY_LIMIT = 3.35 * 1024 * 1024 * 1024;
CONST_MEMORY_CRITICAL_LIMIT = 3.45 * 1024 * 1024 * 1024;

CONST_MEMORY_COUNT_SCAMP_CLEANUP_TO_FAILED = 3

MEMORY_START_CLEANUP = false
MEMORY_CLEANUP_FAILED = false
MEMORY_COUNT_SCAMP_CLEANUP = 0

STREAM_DISTANCE_STEP = 0.1
STREAM_DISTANCE_MAX = 1
STREAM_DISTANCE_MIN = 0.5
STREAM_DISTANCE = 1

draw = false

UI = nil
UI_TEXT = nil


function CheckMemory( )
	if MEMORY_START_CLEANUP then return end

	if MEMORY_CLEANUP_FAILED then
		MEMORY_START_CLEANUP = true
		return
	end


	local memory = engineStreamingGetUsedMemory( )
	local byte = 1024
	local real_memory = math.floor( memory / byte / byte )

	if exports.acl:isAdmin( localPlayer ) then
		outputChatBox( "Current memory: "..real_memory.." mb / kb: "..math.floor( memory / byte ), 0, 255, 0 )
		--return
	end

	if real_memory and real_memory >= 125 then
		if CONST_MEMORY_LIMIT >= CONST_MEMORY_LIMIT then
			MEMORY_START_CLEANUP = CONST_MEMORY_CLEANUP_TIME

			draw = true
			CreateBoxInfoMemory( )

			setTimer( function( )
				if type( MEMORY_START_CLEANUP ) ~= "number" then return end

				MEMORY_START_CLEANUP = MEMORY_START_CLEANUP - 1

				if MEMORY_START_CLEANUP == 0  then
					if isElement( UI ) then
						UI:ibAlphaTo( 0, 500 )
						setTimer( function( )
							if isElement( UI ) then
								destroyElement( UI )
								draw = false
								localPlayer:setData( "memory_cleanup_ui_active", false, false )
								onClientHideMemoryBox_handler()
							end
							MEMORY_START_CLEANUP = false
						end, 600, 1 )
					end

					MEMORY_START_CLEANUP = nil
					engineRestreamWorld ( )
				else
					if isElement( UI_TEXT ) then
						UI_TEXT:ibData( "text", MEMORY_START_CLEANUP .." секунд..." )
					end
				end
			end, 1000, MEMORY_START_CLEANUP )

			if isTimer( sourceTimer ) then killTimer( sourceTimer ) end
			setTimer( CheckMemory, CONST_MEMORY_DELAY_AFTER_CLEAN, 0 )
		else
			MEMORY_COUNT_SCAMP_CLEANUP = 0
		end
	end
end

function StartMemoryTimer( )
	setTimer( CheckMemory, CONST_MEMORY_POLL_RATE, 0 )
end
setTimer( StartMemoryTimer, CONST_MEMORY_FIRST_CHECK_DELAY, 1 )

bindKey( "l", "up", function( )
	if not exports.acl:isAdmin( localPlayer ) then return end
	CheckMemory ( )
end )

--нароботки
function CreateBoxInfoMemory( )
	if draw == false then return end
	if isElement( UI ) then
		destroyElement( UI )
	end
	if localPlayer:getData( "photo_mode" ) then return end

	local x = guiGetScreenSize( )

	local sx, sy = 500, 61
	local px, py = math.floor( ( x - 500 ) / 2 ), 20
	UI = ibCreateImage( px, 0, sx, sy, "img/warning_bg.png" ):ibData( "alpha", 0 ):ibMoveTo( px, py, 200 ):ibAlphaTo( 255, 200 )
	UI_TEXT = ibCreateLabel( 226, 38, 0, 0, CONST_MEMORY_CLEANUP_TIME .." секунд...", UI, 0xFFFFFFFF, 1, 1, "left", "center" ):ibData( "font", ibFonts.regular_16 )

	localPlayer:setData( "memory_cleanup_ui_active", true, false )
end



function onClientHideMemoryBox_handler()
	if isElement( UI ) then
		destroyElement( UI )
	end
end
addEvent( "onClientHideMemoryBox", true )
addEventHandler( "onClientHideMemoryBox", root, onClientHideMemoryBox_handler )