
loadstring( exports.core:include('common'))()

local shaders = {
	background = dxCreateShader('assets/shaders/tone.fx', 1000000, 0, true),
	frame = dxCreateShader('assets/shaders/tone.fx', 1000000, 0, true),
	image = dxCreateShader('assets/shaders/image.fx'),
}

local bgcolor = {0,1,0}

local sx,sy = guiGetScreenSize()
local x,y,z = unpack(Config.vehiclePosition)

local vehicle = createVehicle(500, x,y,z+1.5)
local ped = createPed(0, 0, 0, 0)

local screenshootPed = createPed(0, 0, 0, 0)
ped.alpha = 0
screenshootPed.dimension = 1
screenshootPed.interior = 1
vehicle.dimension = 1
vehicle.interior = 1
ped.dimension = 1
ped.interior = 1
ped.vehicle = vehicle

wheels = {}

-- setVehicleGravity(vehicle, 0,0,0)

for i = 1, 30 do

	local add = 2*(i-10)

	local object = createObject(3571, x-5,y+add,z-1)
	object.dimension = 1
	object.interior = 1
	object.alpha = 0

	local object = createObject(3571, x,y+add,z-1)
	object.dimension = 1
	object.interior = 1
	object.alpha = 0

	local object = createObject(3571, x+5,y+add,z-1)
	object.dimension = 1
	object.interior = 1
	object.alpha = 0
end

vehicle:setRotation(0, 0, 90+45)
vehicle:setData('tint_front', 100)
vehicle:setData('tint_side', 100)
vehicle:setData('tint_rear', 100)
vehicle:setData('tint_light_glass', 0)
vehicle:setData('coverType', 'chrome')
vehicle:setData('plate', '')
setVehicleOverrideLights(vehicle, 1)

function setElementHidden(element, flag)
	if isElement(element) then
		setElementCollisionsEnabled(element, not flag)
		element.frozen = flag
		element.alpha = flag and 0 or 255
	end
end

vinils = {
	[466] = 'police_2107.png',
	-- [426] = 'police_camry.png',
	[567] = 'police_lexus.png',
	-- [458] = 'vesta_advan.png',
}

local image = 500
-- local image = 1920
-- local coef = 1
local coef = 2
-- local coef = 1/1.4

function takeVehicleScreenShoot(model, r,g,b)

	if model < 400 then
		screenshootPed.model = model
		setElementHidden(screenshootPed, false)
		setElementHidden(vehicle, true)
	else
		vehicle.model = model
		setElementHidden(screenshootPed, true)
		setElementHidden(vehicle, false)
	end

	vehicle:setColor(r,g,b, r,g,b)
	vehicle:setPosition(x,y,z+1)
	screenshootPed:setPosition(x,y,z+1)
	screenshootPed:setRotation(0,0,180)

	-- vehicle:setRotation(0,0,400)
	-- vehicle:setRotation(0,0,200)

	vehicle:setEngineState(false)
	vehicle:setData('engine.disabled', true)

	exports.vehicles_tuning:setupVehicleLicenseFrames(vehicle)

	vehicle:setData('coverType', 'chrome')
	if vinils[vehicle.model] then
		vehicle:setData('paintjob', {
			{
				path = vinils[vehicle.model],
				x = 0, y = 0,
				w = 2048, h = 2048,
				r = 0,
				color = {130,130,130},
				id = 1,
			}
		})
	end
	-- vehicle:setData('sirens', 3)

	local x,y,z = getElementPosition(vehicle)

	setTime(12, 0)
	setCloudsEnabled(false)
	setWeather(0)

	setElementPosition(localPlayer, x + 100, y, z)

	local intx, inty, intz = 0, 5, 0
	local type = getVehicleType(model)
	if type == 'Bike' then
		inty = 4
	elseif type == 'Automobile' then
		inty = 8
		intz = 0.5
	elseif type == 'Boat' then
		inty = 10
	elseif type == 'Monster Truck' then
		inty = 8
	elseif type == 'Helicopter' then
		inty,intz = 20,2
	end

	if model < 400 then
		inty = 4
		intx = -2
	end

	if model == 417 then
		inty,intz = 50,2
	end
	-- if model == 567 then
	-- 	inty,intz = 8,1
	-- end
	if model == 515 then
		inty,intz = 13,2
	end
	if model == 453 then
		inty,intz = 25,2
	end
	if model == 454 then
		inty,intz = 30,4
	end

	if model == 495 then
		setVehicleHandling(vehicle, 'handlingFlags', 13056)
		setVehicleHandling(vehicle, 'suspensionLowerLimit', -0.2)
	elseif model == 547 then
		setVehicleHandling(vehicle, 'suspensionLowerLimit', -0.1)
	elseif model == 458 then
		setVehicleHandling(vehicle, 'suspensionLowerLimit', 0)
		setVehicleHandling(vehicle, 'suspensionForceLevel', 0.6)
	else
		setVehicleHandling(vehicle, 'handlingFlags', 0)
		setVehicleHandling(vehicle, 'suspensionLowerLimit', -0.1)
	end

	local xd = -0.5
	if model < 400 then xd = 0 end
	setCameraMatrix(x - intx*coef - 2*coef,y - inty*coef,z + intz*coef, x,y,z)
	-- setCameraMatrix(x - intx*coef - 2*coef,y - inty*coef,z + intz*coef, x,y,z)

	local r,g,b = unpack(bgcolor)
	setSkyGradient(255*r, 255*g, 255*b, 255*r, 255*g, 255*b)
	pr1,pg1,pb1, pr2,pg2,pb2 = getSkyGradient()

	-- dxSetShaderValue(shaders.background, 'color', bgcolor)
	dxSetShaderValue(shaders.frame, 'color', {0,0,0})

	dxSetShaderValue(shaders.image, 'bgcolor', bgcolor)

	engineApplyShaderToWorldTexture(shaders.frame, 'ramka')
	engineApplyShaderToWorldTexture(shaders.frame, 'license_frame')
	engineApplyShaderToWorldTexture(shaders.frame, 'ram')
	-- engineApplyShaderToWorldTexture(shaders.glass, 'lob_steklo')
	-- engineApplyShaderToWorldTexture(shaders.glass, 'pered_steklo')
	-- engineApplyShaderToWorldTexture(shaders.background, '*')
	-- engineRemoveShaderFromWorldTexture(shaders.background, '*', vehicle)

	setTimer(function(model)

		local source = dxCreateScreenSource( sx,sy )
		dxUpdateScreenSource(source)

		shaders.image:setValue('gTexture', source)


		local target = dxCreateRenderTarget( sx,sx, true )

		dxSetRenderTarget(target, true)
			dxDrawImage( 0, 0 + sx/2 - sy/2, sx,sy, shaders.image )
		dxSetRenderTarget()

		local size = image

		local tex1 = copyTexture(target)
		local target2 = dxCreateRenderTarget( size,size, true )
		dxSetRenderTarget(target2, true)

			local x,y,w,h = 0 + size/2 - sx/2, 0 + size/2 - sx/2, sx,sx

			dxDrawImage( x-1,y-1,w+2,h+2, tex1 )
			dxDrawImage( x,y,w,h, tex1 )

		dxSetRenderTarget()

		local pixels

		if model < 400 then
			pixels = dxGetTexturePixels(target2)
		else
			local tex2 = copyTexture(target2)
			local target3 = dxCreateRenderTarget( image,image, true )

			dxSetRenderTarget(target3, true)
				dxDrawImage( 0,0,image,image, tex2 )
			dxSetRenderTarget()

			pixels = dxGetTexturePixels(target3)

			destroyElement(target3)
			destroyElement(tex2)
		end

		pixels = dxConvertPixels(pixels, 'png')


		local file = fileCreate(model..'.png')
		print(getTickCount(  ), model)
		fileWrite(file, pixels)
		fileClose(file)

		-- engineRemoveShaderFromWorldTexture(shaders.glass, '*')
		-- engineRemoveShaderFromWorldTexture(shaders.background, '*')

		destroyElement(source)
		destroyElement(target)
		destroyElement(target2)
		destroyElement(tex1)

		wheels[vehicle.model] = {
	        wheel_rf_dummy = { vehicle:getComponentPosition('wheel_rf_dummy') },
	        wheel_rb_dummy = { vehicle:getComponentPosition('wheel_rb_dummy') },
	        wheel_lf_dummy = { vehicle:getComponentPosition('wheel_lf_dummy') },
	        wheel_lb_dummy = { vehicle:getComponentPosition('wheel_lb_dummy') },
		}

		setClipboard(inspect(wheels))

	end, 3000, 2, model)

end


coverride = {
	-- [458] = {0,0,0},
}

addCommandHandler('screenshoot', function()
	if exports.acl:isAdmin(localPlayer) then

		localPlayer.dimension = 1
		localPlayer.interior = 1
		localPlayer.frozen = true
		setElementPosition(localPlayer, unpack(Config.ped))

		local vehicles = exports.vehicles_main:getVehiclesList()

		local list = {}
		for model in pairs(vehicles) do
			table.insert(list, model)
		end

		table.sort(list, function(a,b)
			return getVehicleType(a) < getVehicleType(b)
		end)

		-- list = {458}
		list = {566}
		-- list = {410, 517, 576, 597, 566, 474, 527}

		local colors = {}
		for name, color in pairs(Config.colors) do
			table.insert(colors, color)
		end

		exports.main_weather:overrideWeather(0)

		for index, model in pairs(list) do
			local color = colors[math.random(#colors)]
			setTimer(takeVehicleScreenShoot, 10000*index, 1, model, unpack(coverride[model] or color))
		end

		addEventHandler('onClientRender', root, function()
			setPedControlState(ped, 'vehicle_right', getVehicleType(vehicle) ~= 'Helicopter')
			vehicle:setEngineState(false)
			vehicle:setData('engine.disabled', true)
			vehicle.frozen = getVehicleType(vehicle) == 'Helicopter' or getVehicleType(vehicle) == 'Boat'
			-- vehicle.frozen = true

			dxDrawRectangle(
				sx/2 - image/2,
				sy/2 - image/2,
				image, image, tocolor(255, 0, 0, 100)
			)
			
			local r,g,b = unpack(bgcolor)
			setSkyGradient(255*r, 255*g, 255*b, 255*r, 255*g, 255*b)

		end)

	end
end)

