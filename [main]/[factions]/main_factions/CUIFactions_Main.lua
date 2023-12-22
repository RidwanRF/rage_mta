local scx, scy = guiGetScreenSize( )
local ui = { }

function ShowFactionUI( state, data )
	if state then
		if isTimer( ui.DestroyTimer ) then return end
		ShowFactionUI( false )
		openHandler( )
		ui.black_bg = ibCreateImage( 0, 0, scx, scy, "img/background.png" ):ibData( "alpha", 0 ):ibAlphaTo( 255, 500 )
		ui.bg = ibCreateArea( 0, -50, scx, scy, ui.black_bg ):ibMoveTo( _, 0, 500 )


		local scale, font = 0.5, getFont('montserrat_semibold', 25, 'light')
		local total_width = 0
		for i, v in pairs( GET_TABS ) do

			local text_width = dxGetTextWidth( v.name, scale, font )
			total_width = total_width + text_width + 40

		end

		ui.positions = { }

		local pX = scx / 2 - total_width / 2
		for i, v in pairs( GET_TABS ) do
			local text_width = dxGetTextWidth( v.name, scale, font ) + 40
			ui[ "tab_area_"..i ] = ibCreateArea( pX, 55, text_width, 30, ui.bg )
			ui[ "tab_lbl_"..i ] = ibCreateLabel( 0, 0, text_width, 30, v.name, ui[ "tab_area_"..i ], CURRENT_TAB == i and COLOR_WHITE or tocolor( 150, 150, 160 ), scale, scale, "center", "center", font )
			:ibData( "disabled", true )

			ui[ "tab_area_"..i ]
			:ibOnClick( function( key, state ) 
				if key == "left" and state == "up" then
					exports.main_sounds:playSound( 'checkbox' )
					SwitchTab( i )
				end
			end)
			:ibOnHover( function( ) 
				if CURRENT_TAB ~= i then
					ui[ "tab_lbl_"..i ]:ibColorTo( 255, 255, 255 )
				end
			end)
			:ibOnLeave( function( ) 
				if CURRENT_TAB ~= i then
					ui[ "tab_lbl_"..i ]:ibColorTo( 150, 150, 160 )
				end
			end)


			pX = pX + text_width + 10
			ui.positions[ i ] = { width = text_width, px = ui[ "tab_area_"..i ]:ibData( "px" ) - 5 }
		end

		ibCreateImage( scx / 2 - total_width / 2 - 8, 95, total_width + ( #GET_TABS * 10 ) + 5, 1, nil, ui.bg, tocolor( 25,24,38 ) )
		ui.tab_line = ibCreateImage( ui.positions[ CURRENT_TAB ].px + 5, 95, ui.positions[ CURRENT_TAB ].width, 1, nil, ui.bg, tocolor(180,70,70) )

		SwitchTab( CURRENT_TAB )
		bindKey( "tab", "down", OnTabSwitch )
	else
		if isElement( ui.black_bg ) then
			ui.black_bg:ibAlphaTo( 0, 500 )
			ui.bg:ibMoveTo( _, -50, 500 )
			ui.DestroyTimer = Timer( DestroyTableElements, 400, 1, ui )
		else
			DestroyTableElements( ui )
		end
		CURRENT_TAB = 1
		showCursor( false )
		closeHandler( )
		unbindKey( "tab", "down", OnTabSwitch )
	end
end

function SwitchTab( tab_id )
	if CURRENT_TAB == tab_id then
		return false
	end

	local old_area = ui[ "tab_area_"..CURRENT_TAB ]
	local old_lbl = ui[ "tab_lbl_"..CURRENT_TAB ]

	local new_area = ui[ "tab_area_"..tab_id ]
	local new_lbl = ui[ "tab_lbl_"..tab_id ]

	old_lbl:ibColorTo( 150, 150, 160, 500 )
	new_lbl:ibColorTo( 255, 255, 255, 500 )

	ui.tab_line:ibMoveTo( ui.positions[ tab_id ].px + 5 )
	ui.tab_line:ibResizeTo( ui.positions[ tab_id ].width )

	CURRENT_TAB = tab_id
end

function GetMembersCache( cache )
	FACTION_CACHE = cache
	ShowFactionUI( true, cache )
end
addEvent( "UIControlMenu", true )
addEventHandler( "UIControlMenu", resourceRoot, GetMembersCache )

function OnTabSwitch()
	if isElement( ui.black_bg ) then
		local tab = CURRENT_TAB
		local max_tab = #GET_TABS
		SwitchTab( tab == max_tab and 1 or tab + 1 )
	end
end

if localPlayer:IsAdmin( ) then
	--ShowFactionUI( true )
	bindKey( "f5", "down", function( ) 

		if isElement( ui.black_bg ) then
			ShowFactionUI( false )
			return
		end

		if isElement( ui.black_bg ) then
			ShowFactionUI( false )
			return
		end
		iprint("press")
		triggerServerEvent( "OnClientShowFactionUI", resourceRoot )

	end)
	localPlayer:setData( "snowballData", {1, 1}, false )

	--[[ibDialog( {
		type = "confirm",
		title = "Редактирование",
		text = "Введи данные",
		edit = {
			{
				placeholder = "Никнейм",
				placeholder_center = true,
			},

			{
				placeholder = "Звание",
				placeholder_center = true,
			},
		},
		fn = function( self )
			local edit_1 = self.elements.edit_1
			local edit_2 = self.elements.edit_2

			local edit_1_text = edit_1:ibData( "text" )
			local edit_2_text = edit_2:ibData( "text" )
			if edit_1_text == "" then
				localPlayer:ShowError( "Введи "..self.edit[1].placeholder )
			end
			self:Destroy()
		end,

	} )]]
end