
function updatePlatesFonts()

	local quality = localPlayer:getData('settings.plates_quality') or 2
	local quality_list = { 0.5, 1, 2, 4 }

	currentPlateScale = quality_list[quality] or 1

	clearTableElements(fonts or {})
	clearTableElements(shaders or {})
	clearTableElements(textures or {})

	fonts = {

		font20 = dxCreateFont("assets/fonts/RoadNumbers2.0.ttf", 20*currentPlateScale),
		font18 = dxCreateFont("assets/fonts/RoadNumbers2.0.ttf", 18*currentPlateScale),
		font22 = dxCreateFont("assets/fonts/RoadNumbers2.0.ttf", 22*currentPlateScale),
		font21 = dxCreateFont("assets/fonts/RoadNumbers2.0.ttf", 21*currentPlateScale),
		font23 = dxCreateFont("assets/fonts/RoadNumbers2.0.ttf", 23*currentPlateScale),
		font17 = dxCreateFont("assets/fonts/RoadNumbers2.0.ttf", 17*currentPlateScale),
		font15 = dxCreateFont("assets/fonts/RoadNumbers2.0.ttf", 15*currentPlateScale),

		arial23 = dxCreateFont("assets/fonts/arial.ttf", 23*currentPlateScale),
		kzfont23 = dxCreateFont("assets/fonts/kz.ttf", 45*currentPlateScale),

		gost_bu31 = dxCreateFont("assets/fonts/gost_bu.ttf", 31*currentPlateScale),
		gost_bu37 = dxCreateFont("assets/fonts/gost_bu.ttf", 37*currentPlateScale),
		nominal = dxCreateFont("assets/fonts/arial.ttf", 27*currentPlateScale),
		nominal_sm = dxCreateFont("assets/fonts/arial.ttf", 20*currentPlateScale),

	}

	font18 = fonts.font18
	font20 = fonts.font20
	font22 = fonts.font22
	font21 = fonts.font21
	font23 = fonts.font23
	font17 = fonts.font17
	font15 = fonts.font15
	arial23 = fonts.arial23
	gost_bu31 = fonts.gost_bu31
	gost_bu37 = fonts.gost_bu37
	nominal = fonts.nominal
	nominal_sm = fonts.nominal_sm
	kzfont23 = fonts.kzfont23

end

addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

	if dn == 'settings.plates_quality' then
		updatePlatesFonts()
		apllyPlatesToAllCars()
	end

end)

addEventHandler('onClientResourceStart', resourceRoot, function()

	updatePlatesFonts()

end, true, 'high+10')

delayedPlates = {}
gameScreenState = false


-- Типы номеров:
-- a-a123bc123, либо a-a123bc12		обычный номер
-- b-a1234123, либо b-a123412		полицейская машина
-- с-1234ab12						обычный мотоцикл
-- d-1234a12						полицейский мотоцикл
-- e-123abc12						казахский номер
-- f-ab1234cd						украинский номер
-- g-1234ab5						белорусский номер	
-- h-huinia							надпись	
-- i-ab12312						желтые номера (общ. транспорт)
-- j-a123bc							федеральные номера (с флагом вместо региона)


function _drawText(offsetX, offsetY, mul, text, x,y,ex,ey, c, s, ...)
	return dxDrawText(text,
		(x)*mul + offsetX,
		(y)*mul + offsetY,
		(ex)*mul + offsetX,
		(ey)*mul + offsetY,
		c, s*mul*(1/currentPlateScale),
		...
	)
end

function _drawImage(offsetX, offsetY, mul, x,y,ex,ey, ...)
	return dxDrawImage(
		(x)*mul + offsetX,
		(y)*mul + offsetY,
		(ex)*mul,
		(ey)*mul,
		...
	)
end

function drawPlate(plateID, oX, oY, width, alpha)
	local plateType = string.sub(plateID, 1, 1)


	local mul = width/235
	if plateType == 'c' or plateType == 'd' then
		mul = width/110
	end

	local black = tocolor(0, 0, 0, 255*alpha)
	local white = tocolor(255,255,255,255*alpha)

	plateID = plateID:gsub('_', '')

	if plateID == 'empty' or plateID == '' or not plateID then
		dxDrawRectangle(0, 0, 500, 500, black)
	elseif plateType == 'a' or plateType == 'k' then

		local ch1, dig1, dig2, dig3, ch2, ch3, reg1, reg2, reg3 = explodePlateID(plateID)

		_drawImage(oX, oY, mul, 0, 0, 235, 50, "assets/images/plate_"..plateType..".png", 0, 0, 0, white)

		_drawText(oX, oY, mul, ch1, 11, 14, 41, 44, black, 1.00, font22, "center", "bottom")
		_drawText(oX, oY, mul, dig1, 38, 14, 68, 44, black, 1.00, font22, "center", "bottom")

		_drawText(oX, oY, mul, dig2, 64, 14, 94, 44, black, 1.00, font22, "center", "bottom")

		_drawText(oX, oY, mul, dig3, 91, 14, 121, 44, black, 1.00, font22, "center", "bottom")
		_drawText(oX, oY, mul, ch2, 118, 14, 148, 44, black, 1.00, font22, "center", "bottom")
		_drawText(oX, oY, mul, ch3, 144, 14, 174, 44, black, 1.00, font22, "center", "bottom")
		if (reg3 == "") then
			_drawText(oX, oY, mul, reg1, 178, 1, 208, 31, black, 1.00, font15, "center", "bottom")
			_drawText(oX, oY, mul, reg2, 195, 1, 225, 31, black, 1.00, font15, "center", "bottom")
		else
			_drawText(oX, oY, mul, reg1, 178, 1, 195, 31, black, 1.00, font15, "center", "bottom")
			_drawText(oX, oY, mul, reg2, 195, 1, 212, 31, black, 1.00, font15, "center", "bottom")
			_drawText(oX, oY, mul, reg3, 212, 1, 229, 31, black, 1.00, font15, "center", "bottom")
		end
		
	elseif plateType == 'o' then

		local l1,l2,l3, ld, g1,g2,g3, r1,r2,r3 = explodePlateID(plateID)

		_drawImage(oX, oY, mul, 0, 0, 235, 50, "assets/images/plate_"..plateType..".png", 0, 0, 0, white)

		_drawText(oX, oY, mul, l1, 22, 7, 22, 42, white, 1.00, font20, "center", "bottom")
		_drawText(oX, oY, mul, l2, 44, 7, 44, 42, white, 1.00, font20, "center", "bottom")
		_drawText(oX, oY, mul, l3, 66, 7, 66, 42, white, 1.00, font20, "center", "bottom")
		_drawText(oX, oY, mul, ld, 75, 7, 106, 42, white, 1.00, font18, "center", "bottom")

		_drawText(oX, oY, mul, g1, 120, 7, 120, 42, white, 1.00, font15, "center", "bottom")
		_drawText(oX, oY, mul, g2, 140, 7, 140, 42, white, 1.00, font15, "center", "bottom")
		_drawText(oX, oY, mul, g2, 160, 7, 160, 42, white, 1.00, font15, "center", "bottom")

		if (r3 == "") then
			_drawText(oX, oY, mul, r1, 178, 1, 208, 31, white, 1.00, font15, "center", "bottom")
			_drawText(oX, oY, mul, r2, 195, 1, 225, 31, white, 1.00, font15, "center", "bottom")
		else
			_drawText(oX, oY, mul, r1, 178, 1, 195, 31, white, 1.00, font15, "center", "bottom")
			_drawText(oX, oY, mul, r2, 195, 1, 212, 31, white, 1.00, font15, "center", "bottom")
			_drawText(oX, oY, mul, r3, 212, 1, 229, 31, white, 1.00, font15, "center", "bottom")
		end

	elseif plateType == 'b' then

		local ch1, dig1, dig2, dig3, dig4, reg1, reg2, reg3 = explodePlateID(plateID)
        _drawImage(oX, oY, mul, 0, 0, 235, 50, "assets/images/plate_b.png", 0, 0, 0, white)
        _drawText(oX, oY, mul, ch1, 19, 15, 46, 44, white, 1.00, font22, "center", "bottom")
        _drawText(oX, oY, mul, dig1, 54, 15, 81, 44, white, 1.00, font22, "center", "bottom")
        _drawText(oX, oY, mul, dig2, 81, 15, 108, 44, white, 1.00, font22, "center", "bottom")
        _drawText(oX, oY, mul, dig3, 109, 15, 136, 44, white, 1.00, font22, "center", "bottom")
        _drawText(oX, oY, mul, dig4, 136, 15, 163, 44, white, 1.00, font22, "center", "bottom")
		if (reg3 == "") then
			_drawText(oX, oY, mul, reg1, 182, 2, 209, 31, white, 1.00, font15, "center", "bottom")
			_drawText(oX, oY, mul, reg2, 199, 2, 226, 31, white, 1.00, font15, "center", "bottom")
		else
			_drawText(oX, oY, mul, reg1, 172, 2, 199, 31, white, 1.00, font15, "center", "bottom")
			_drawText(oX, oY, mul, reg2, 187, 2, 214, 31, white, 1.00, font15, "center", "bottom")
			_drawText(oX, oY, mul, reg3, 202, 2, 229, 31, white, 1.00, font15, "center", "bottom")
		end	
		
	elseif plateType == 'c' then
		local dig1, dig2, dig3, dig4, ch1, ch2, reg1, reg2 = explodePlateID(plateID)
      	_drawImage(oX, oY, mul, 0, 0, 110, 82, "assets/images/plate_c.png", 0, 0, 0, white)
        _drawText(oX, oY, mul, dig1, 12, 17, 32, 37, black, 1.00, font17, "center", "bottom")
        _drawText(oX, oY, mul, dig2, 34, 17, 54, 37, black, 1.00, font17, "center", "bottom")
        _drawText(oX, oY, mul, dig3, 56, 17, 76, 37, black, 1.00, font17, "center", "bottom")
        _drawText(oX, oY, mul, dig4, 78, 17, 98, 37, black, 1.00, font17, "center", "bottom")
        _drawText(oX, oY, mul, ch1, 06, 57, 26, 77, black, 1.00, font21, "center", "bottom")
        _drawText(oX, oY, mul, ch2, 30, 57, 50, 77, black, 1.00, font21, "center", "bottom")
		_drawText(oX, oY, mul, reg1, 60, 57, 80, 77, black, 1.00, font17, "center", "bottom")
		_drawText(oX, oY, mul, reg2, 82, 57, 102, 77, black, 1.00, font17, "center", "bottom")
		
	elseif plateType == 'd' then
		local dig1, dig2, dig3, dig4, ch1, reg1, reg2 = explodePlateID(plateID)
      	_drawImage(oX, oY, mul, 0, 0, 110, 82, "assets/images/plate_d.png", 0, 0, 0, white)
        _drawText(oX, oY, mul, dig1, 12, 17, 32, 37, white, 1.00, font17, "center", "bottom")
        _drawText(oX, oY, mul, dig2, 34, 17, 54, 37, white, 1.00, font17, "center", "bottom")
        _drawText(oX, oY, mul, dig3, 56, 17, 76, 37, white, 1.00, font17, "center", "bottom")
        _drawText(oX, oY, mul, dig4, 78, 17, 98, 37, white, 1.00, font17, "center", "bottom")
        _drawText(oX, oY, mul, ch1,  17, 57, 37, 77, white, 1.00, font21, "center", "bottom")
        _drawText(oX, oY, mul, reg1, 60, 57, 80, 77, white, 1.00, font17, "center", "bottom")
        _drawText(oX, oY, mul, reg2, 82, 57, 102, 77, white, 1.00, font17, "center", "bottom")
		
	elseif plateType == 'e' then
		local dig1, dig2, dig3, ch1, ch2, ch3, reg1, reg2 = explodePlateID(plateID)
      	_drawImage(oX, oY, mul, 0, 0, 235, 50, "assets/images/plate_e.png", 0, 0, 0, white)
      	oX = oX - 7*currentPlateScale
        _drawText(oX, oY, mul, dig1, 37, 23, 57, 43, black, 1.00, font21, "center", "bottom")
        _drawText(oX, oY, mul, dig2, 61, 23, 81, 43, black, 1.00, font21, "center", "bottom")
        _drawText(oX, oY, mul, dig3, 85, 23, 105, 43, black, 1.00, font21, "center", "bottom")

        oX = oX + 2*currentPlateScale

        if currentPlateScale == 4 then

	        _drawText(oX, oY, mul, ch1, 110, 15, 130, 86, black, 1.20, kzfont23, "center", "bottom")
	        _drawText(oX, oY, mul, ch2, 133, 15, 153, 86, black, 1.20, kzfont23, "center", "bottom")
	        _drawText(oX, oY, mul, ch3, 156, 15, 176, 86, black, 1.20, kzfont23, "center", "bottom")

        else
	        _drawText(oX, oY, mul, ch1, 110, 15, 130, 84, black, 1.00, kzfont23, "center", "bottom")
	        _drawText(oX, oY, mul, ch2, 133, 15, 153, 84, black, 1.00, kzfont23, "center", "bottom")
	        _drawText(oX, oY, mul, ch3, 156, 15, 176, 84, black, 1.00, kzfont23, "center", "bottom")
        end


        oX = oX + 2*currentPlateScale
        _drawText(oX, oY, mul, reg1, 184, 23, 204, 43, black, 1.00, font21, "center", "bottom")
        _drawText(oX, oY, mul, reg2, 208, 23, 228, 43, black, 1.00, font21, "center", "bottom")
		
	elseif plateType == 'f' then
		local ch1, ch2, dig1, dig2, dig3, dig4, ch3, ch4 = explodePlateID(plateID)
      	_drawImage(oX, oY, mul, 0, 0, 235, 50, "assets/images/plate_f.png", 0, 0, 0, white)
        _drawText(oX, oY, mul, ch1, 30, 15, 50, 35, black, 1.00, gost_bu31, "center", "center")
        _drawText(oX, oY, mul, ch2, 57, 15, 77, 35, black, 1.00, gost_bu31, "center", "center")
        _drawText(oX, oY, mul, dig1, 87, 15, 107, 35, black, 1.00, gost_bu31, "center", "center")
        _drawText(oX, oY, mul, dig2, 107, 15, 127, 35, black, 1.00, gost_bu31, "center", "center")
        _drawText(oX, oY, mul, dig3, 127, 15, 147, 35, black, 1.00, gost_bu31, "center", "center")
        _drawText(oX, oY, mul, dig4, 147, 15, 167, 35, black, 1.00, gost_bu31, "center", "center")
        _drawText(oX, oY, mul, ch3, 176, 15, 196, 35, black, 1.00, gost_bu31, "center", "center")
        _drawText(oX, oY, mul, ch4, 203, 16, 223, 36, black, 1.00, gost_bu31, "center", "center")
		
	elseif plateType == 'g' then
		local dig1, dig2, dig3, dig4, ch1, ch2, dig5 = explodePlateID(plateID)
      	_drawImage(oX, oY, mul, 0, 0, 235, 50, "assets/images/plate_g.png", 0, 0, 0, white)
        _drawText(oX, oY, mul, dig1, 35, 16, 55, 36, black, 1.00, gost_bu37, "center", "center")
        _drawText(oX, oY, mul, dig2, 57, 16, 77, 36, black, 1.00, gost_bu37, "center", "center")
        _drawText(oX, oY, mul, dig3, 78, 16, 98, 36, black, 1.00, gost_bu37, "center", "center")
        _drawText(oX, oY, mul, dig4, 101, 16, 121, 36, black, 1.00, gost_bu37, "center", "center")
        _drawText(oX, oY, mul, ch1, 137, 16, 157, 36, black, 1.00, gost_bu37, "center", "center")
        _drawText(oX, oY, mul, ch2, 168, 16, 188, 36, black, 1.00, gost_bu37, "center", "center")
        _drawText(oX, oY, mul, dig5, 207, 16, 227, 36, black, 1.00, gost_bu37, "center", "center")
		
	elseif plateType == 'h' then
		local text = string.sub(plateID, 3, string.len(plateID))
      	_drawImage(oX, oY, mul, 0, 0, 235, 50, "assets/images/plate_h.png", 0, 0, 0, white)
        _drawText(oX, oY, mul, text, 0, 0, 235, 50, black, 1.00, nominal, "center", "center")
        
	elseif plateType == 'p' then

		local text = string.sub(plateID, 3, string.len(plateID))
      	_drawImage(oX, oY, mul, 0, 0, 235, 50, "assets/images/plate_k.png", 0, 0, 0, white)

      	local _f = utf8.len( text ) > 5 and nominal_sm or nominal
        _drawText(oX, oY, mul, text, 0, 0, 185, 50, black, 1.00, _f, "center", "center")

		_drawText(oX, oY, mul, '7', 178, 1, 195, 31, black, 1.00, font15, "center", "bottom")
		_drawText(oX, oY, mul, '7', 195, 1, 212, 31, black, 1.00, font15, "center", "bottom")
		_drawText(oX, oY, mul, '7', 212, 1, 229, 31, black, 1.00, font15, "center", "bottom")

	elseif plateType == 'q' then

		local text = string.sub(plateID, 3, string.len(plateID))
      	_drawImage(oX, oY, mul, 0, 0, 235, 50, "assets/images/plate_j.png", 0, 0, 0, white)

      	local _f = utf8.len( text ) > 5 and nominal_sm or nominal
        _drawText(oX, oY, mul, text, 0, 0, 185, 50, black, 1.00, _f, "center", "center")


	elseif plateType == 'n' then
		local text = string.sub(plateID, 3, string.len(plateID))
      	_drawImage(oX, oY, mul, 0, 0, 235, 50, "assets/images/plate_n.png", 0, 0, 0, white)
        _drawText(oX, oY, mul, text, 0, 0, 235, 50, white, 1.00, nominal, "center", "center")
	elseif plateType == 'm' then
		local text = string.sub(plateID, 3, string.len(plateID))
      	_drawImage(oX, oY, mul, 0, 0, 235, 50, "assets/images/plate_m.png", 0, 0, 0, white)
        _drawText(oX, oY, mul, text, 0, 0, 235, 50, black, 1.00, nominal, "center", "center")
		
	elseif plateType == 'i' then
		local ch1, ch2, dig1, dig2, dig3, reg1, reg2 = explodePlateID(plateID)
      	_drawImage(oX, oY, mul, 0, 0, 235, 50, "assets/images/plate_i.png", 0, 0, 0, white)
        _drawText(oX, oY, mul, ch1, 26, 24, 46, 44, black, 1.00, font22, "center", "bottom")
        _drawText(oX, oY, mul, ch2, 52, 24, 72, 44, black, 1.00, font22, "center", "bottom")
        _drawText(oX, oY, mul, dig1, 85, 24, 105, 44, black, 1.00, font22, "center", "bottom")
        _drawText(oX, oY, mul, dig2, 111, 24, 131, 44, black, 1.00, font22, "center", "bottom")
        _drawText(oX, oY, mul, dig3, 137, 24, 157, 44, black, 1.00, font22, "center", "bottom")
        _drawText(oX, oY, mul, reg1, 185, 11, 205, 31, black, 1.00, font15, "center", "bottom")
        _drawText(oX, oY, mul, reg2, 202, 11, 222, 31, black, 1.00, font15, "center", "bottom")
		
	elseif plateType == 'j' then
		local ch1, dig1, dig2, dig3, ch2, ch3 = explodePlateID(plateID)
      	_drawImage(oX, oY, mul, 0, 0, 235, 50, "assets/images/plate_j.png", 0, 0, 0, white)
		_drawText(oX, oY, mul, ch1, 11, 14, 41, 44, black, 1.00, font22, "center", "bottom")
		_drawText(oX, oY, mul, dig1, 38, 14, 68, 44, black, 1.00, font22, "center", "bottom")
		_drawText(oX, oY, mul, dig2, 64, 14, 94, 44, black, 1.00, font22, "center", "bottom")
		_drawText(oX, oY, mul, dig3, 91, 14, 121, 44, black, 1.00, font22, "center", "bottom")
		_drawText(oX, oY, mul, ch2, 118, 14, 148, 44, black, 1.00, font22, "center", "bottom")
		_drawText(oX, oY, mul, ch3, 144, 14, 174, 44, black, 1.00, font22, "center", "bottom")
	elseif plateType == 'l' then
		local l1, l2, l3 = explodePlateID(plateID)
      	_drawImage(oX, oY, mul, 0, 0, 235, 50, "assets/images/plate_l.png", 0, 0, 0, white)
		_drawText(oX, oY, mul, l1..l2..l3, -20, 0, 235, 50, black, 0.55, fonts.gotham.bold, "center", "center")
	end
end

emptyTexture = dxCreateTexture(1,1)
-- local pixels = dxGetTexturePixels(emptyTexture)
-- dxSetPixelColor(pixels, 0, 0, 0, 0, 0, 0)
-- dxSetTexturePixels(emptyTexture, pixels)

function generatePlate(plateID, model)
	local plateType = string.sub(plateID, 1, 1)

	local size, offset = {235*currentPlateScale,50*currentPlateScale}, {0,0}
	if plateType == 'c' or plateType == 'd' then
		size = {110,82}
	end

	-- if plateID == 'empty' then
	-- 	textures[plateID] = emptyTexture
	-- 	return textures[plateID]
	-- end

	local width = size[1]

	-- for _, name in pairs( engineGetModelTextureNames(model) ) do
	-- 	if name == 'rpbox_nomer' then
	-- 		size = {512,512}
	-- 		offset = {11,204}
	-- 		width = 480
	-- 		break
	-- 	end
	-- end

	local plate = dxCreateRenderTarget(size[1], size[2], false)
	if not plate then return end

	dxSetRenderTarget(plate, false)
	drawPlate(plateID, offset[1], offset[2], width, 1)
	dxSetRenderTarget()

	local platePixels = dxGetTexturePixels(plate)
	if not platePixels then return end

	local quality = 'dxt1'
	if currentPlateScale >= 2 then
		quality = 'dxt5'
	end

	textures[plateID] = dxCreateTexture(platePixels, quality)
	-- if (string.sub(plateID, 1, 1) ~= "h") then
		-- platePixels = dxConvertPixels(platePixels, 'png')
		--local plateFile = fileCreate("images/"..plateID..".png")
		--fileWrite(plateFile, platePixels)
		--fileClose(plateFile)
	-- end
	return textures[plateID], platePixels
end

function explodePlateID(plateID)
	return utf8.sub(plateID, 3, 3), utf8.sub(plateID, 4, 4), utf8.sub(plateID, 5, 5), utf8.sub(plateID, 6, 6), utf8.sub(plateID, 7, 7), utf8.sub(plateID, 8, 8), utf8.sub(plateID, 9, 9), utf8.sub(plateID, 10, 10), utf8.sub(plateID, 11, 11), utf8.sub(plateID, 12, 12)
end

function initGameState()
	gameScreenState = true
	removeEventHandler("onClientCursorMove", root, initGameState)
	drawDelayedPlates()
end
addEventHandler("onClientCursorMove", root, initGameState)

addEventHandler("onClientRestore",root,
	function()
		gameScreenState = true
		drawDelayedPlates()
	end
)

addEventHandler("onClientMinimize",root,
	function()
		gameScreenState = false
		--setElementHealth( localPlayer, 0 )
	end
)

function drawDelayedPlates()
	for i, vehicle in pairs(delayedPlates) do
		if isElement(vehicle) then
			if isElementOnScreen( vehicle ) and getDistanceBetween(vehicle, localPlayer) < 50 then
				applyPlateToVehicle(vehicle)
				delayedPlates[i] = nil
			end
		else
			delayedPlates[i] = nil
		end
	end	
end