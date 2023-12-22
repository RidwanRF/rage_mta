loadstring( exports.interfacer:extend( "Interfacer" ) )( )
Extend( "ShPlayer" )
Extend( "ib" )
Extend( "ShUtils" )

openHandler = function()

	localPlayer:setData( 'hud.hidden', true, false )
	localPlayer:setData( 'speed.hidden', true, false )
	localPlayer:setData( 'radar.hidden', true, false )
	localPlayer:setData( 'drift.hidden', true, false )

	showChat(false)
	showCursor( true )

end

closeHandler = function( )

	localPlayer:setData( 'hud.hidden', false, false )
	localPlayer:setData( 'speed.hidden', false, false )
	localPlayer:setData( 'radar.hidden', false, false )
	localPlayer:setData( 'drift.hidden', false, false )
	
	showChat( true )
	showCursor( false )

end