loadstring( exports.interfacer:extend( "Interfacer" ) )( )

Extend( "ShUtils" )
Extend( "ShPlayer" )
Extend( "ib" )

function ShowUI( state )
	if state then
		ShowUI( false )
		showCursor( true )

		local bg = ibCreateImage( 0, 0, 800, 580, nil, nil, tocolor( 0, 0, 0, 200 ) ):center( )
		ui.bg = bg

		ui.players_rt, ui.players_sc = ibCreateScrollpane( 15, 20, 350, 500, bg, { scroll_px = 0 } )
		ui.players_sc:ibSetStyle( "slim_nobg" ):ibBatchData( { absolute = true, sensivity = 70 } )

	else
		DestroyTableElements( ui )
		showCursor( false )
	end
end

if localPlayer:IsAdmin( ) then
	--[[ShowUI( true )

	bindKey( "h", "down", function( )
		ShowUI( not isElement( ui.bg ) )
	end)]]
end