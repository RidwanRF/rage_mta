

function renderPrisonInterface()

	local prisonTime = localPlayer:getData('prison.time')
	if not prisonTime then return end

	local w,h = 408, 56
	local x,y = sx/2 - w/2, 100

	local sw,sh = 426, 74
	dxDrawImage(
		x+w/2-sw/2,y+h/2-sh/2+5,
		sw,sh, 'assets/images/time_bg_shadow.png',
		0, 0, 0, tocolor(0, 0, 0, 255)
	)

	dxDrawImage(
		x,y,w,h, 'assets/images/time_bg.png',
		0, 0, 0, tocolor(32,35,66,255)
	)

	local time = {}
	time.h = math.floor( prisonTime / 3600 )
	time.m = math.floor( (prisonTime - time.h*3600) / 60 )
	time.s = math.floor( prisonTime - time.h*3600 - time.m*60 )

	dxDrawText(string.format('Время до освобождения #cd4949 | #ffffff %02d#8c8d91ч#ffffff %02d#8c8d91м#ffffff %02d#8c8d91с#ffffff ',
		time.h, time.m, time.s
	),
		x,y,x+w,y+h,
		tocolor(255,255,255,255),
		0.5, 0.5, getFont('montserrat_medium', 26, 'light', true),
		'center', 'center', false, false, false, true
	)

	local tw,th = 145, 56
	local tx,ty = sx/2 - 145/2 - 100, (real_sy - px(56) - 100) * sx/real_sx

	local tsw, tsh = 162, 74

	dxDrawImage(
		tx+tw/2-tsw/2, ty+th/2-tsh/2, tsw,tsh,
		'assets/images/ticket_bg_shadow.png', 0, 0, 0, tocolor(0, 0, 0, 255)
	)

	dxDrawImage(
		tx,ty,tw,th, 'assets/images/ticket_bg.png',
		0, 0, 0, tocolor(32,35,66,255)
	)

	local iw,ih = 60, 60
	local ix,iy = tx + 10, ty+th/2-ih/2+3

	dxDrawImage(
		ix,iy,iw,ih, 'assets/images/ticket.png',
		0, 0, 0, tocolor(255,255,255,255)
	)

	dxDrawText(string.format('%s шт.', localPlayer:getData('prison.tickets') or 0),
		ix+iw, ty-3,
		ix+iw, ty+th,
		tocolor(255,255,255,255),
		0.5, 0.5, getFont('montserrat_semibold', 27, 'light', true),
		'left', 'center'
	)

	local text = '#d96081DELETE#ffffff - использовать пропуск'
	local ct = 'DELETE - использовать пропуск'
	dxDrawTextShadow(text, 
		tx+tw+10, ty,
		tx+tw+10, ty+th,
		tocolor(255,255,255,255),
		0.5, getFont('montserrat_semibold', 25, 'light', true),
		'left', 'center', 2, tocolor(0, 0, 0, 50), ct, dxDrawText 

	)


end
addEventHandler('onClientRender', root, renderPrisonInterface)
