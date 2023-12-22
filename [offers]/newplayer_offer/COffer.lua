loadstring( exports.interfacer:extend( "Interfacer" ) )( )
Extend( "ib" )
Extend( "ShUtils" )

local scx, scy = guiGetScreenSize( )
local ui = { }

function ShowUI( state )
	if state then
		ShowUI( false )
		showCursor( true )

		ui.black_bg = ibCreateBackground( tocolor( 0, 0, 0, 200 ) ):ibData( "alpha", 0 ):ibAlphaTo( 255, 750 )

		local pY = ( scy - 700 ) / 2
		local bg = ibCreateImage( 0, 0, 900, 700, "img/t_bg.png", ui.black_bg, tocolor( 31, 32, 47 ) ):center_x( ):ibMoveTo( _, pY, 500 )

		ibCreateLabel( 40, 25, 0, 0, "Уникальное предложение", bg, COLOR_WHITE, 1, 1, _, _, ibFonts.bold_15 )

		local btn = ibCreateButtonAlpha( {
			px = 860,
			py = 25,
			realsize = true,
			texture = "img/close_icon.png",
			hover = "img/close.png",
			parent = bg,
			color1 = tocolor( 180, 70, 70 ),
			fn = function( )
				ShowUI( false )
			end
		} )

		ui.rt, ui.sc = ibCreateScrollpane( 0, 100, 900, 600, bg, { scroll_px = -25 } )
		ui.sc:ibSetStyle( "rage" )
		

		for i = 1, 16 do
			local px = 205 * ( ( i - 1 ) % 4 ) + 40
			local py = 195 * math.floor( ( i - 1 ) / 4 )

			local item = ibCreateImage( px, py, 195, 180, "img/item.png", ui.rt, tocolor(20,20,30) )
		end

		ui.rt:AdaptHeightToContents( ui.sc )
	else
		if isElement( ui.black_bg ) then
			ui.black_bg:ibAlphaTo( 0, 500 )
			ui.TimerDelete = Timer( function( ) 
				DestroyTableElements( ui )
			end, 500, 1)
		else
			DestroyTableElements( ui )
		end
		showCursor( false )
	end
end

bindKey( "h", "down", function( ) 
	ShowUI( not isElement( ui.black_bg ) )
end)

ShowUI( true )