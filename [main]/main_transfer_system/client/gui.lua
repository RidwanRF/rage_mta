
--------------------------------------------------------------------

	openHandler = function()
		showChat( false )

		if currentWindowSection == 'loading' then
			showCursor( false )
		end

	end

	closeHandler = function()
		showChat( true )
	end

--------------------------------------------------------------------
	
addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	loading = {

		{'image',

			0, 0, sx, real_sy * sx/real_sx,
			'assets/images/bg.png',
			color = {255,255,255,255},

			anim_fix = true,

			variable = 'loading',

			addEvent('transfer_system.transferDisplay', true),
			addEventHandler('transfer_system.transferDisplay', resourceRoot, function()

				openWindow('loading')

				local w,h = 50,50
				local x,y = loading[4] - w - 40, loading[5] - h - 40

				displayLoading( {x,y,w,h}, {180,70,70,255}, 2000, closeWindow )


			end),

			onRender = function(element)

				local alpha = element:alpha()
				local x,y,w,h = element:abs()

				local lw,lh = 675, 337

				dxDrawImage(
					x+w/2-lw/2, y+h/2-lh/2,
					lw,lh,
					'assets/images/logo.png', 0, 0, 0,
					tocolor(255,255,255,255*alpha)
				)

			end,

		},

	},

}

loadGuiModule()

end)

