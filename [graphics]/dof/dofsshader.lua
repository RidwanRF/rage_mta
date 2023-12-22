
loadstring( exports.core:include('common'))()
loadstring( exports.core:include('animations'))()

local screenWidth, screenHeight = guiGetScreenSize()
local player = getLocalPlayer()
local blurStrength = 5
local saturation = 1.25
local brightness = 0.63
local contrast = 1.2
local distance = 0
local testMode = "true"


addEventHandler("onClientResourceStart", resourceRoot,
function()
end)

function getDOFShader()
	return dofShader
end

setAnimData('dof-speed', 0.1)

function hudrender()
	if (isLoaded) then
        screenSource:update()
				
		local x, y, z, lx, ly, lz = getCameraMatrix()
		local playerPos = player:getPosition()
		local viewDistance = getDistanceBetweenPoints3D(x, y, z, playerPos.x, playerPos.y, playerPos.z)
		
		-- distance = 10 - viewDistance

		local blurLevel = (localPlayer:getData('settings.dof_level') or 0)/100

		local speed_bool = (localPlayer.vehicle and localPlayer.vehicle.upgrades[1] == 1010)
		animate('dof-speed', speed_bool and 1 or 0)

		local dof_speed = getAnimData('dof-speed')

		blurLevel = blurLevel + dof_speed*0.4

		distance = 100*(blurLevel)
		-- distance = 10
		 
		-- if (distance <= 0) then
		-- 	distance = 0
		-- end
		
		blurStrength = 5*blurLevel
		-- blurStrength = 6 - viewDistance
		
		-- if (blurStrength <= 0) then
		-- 	blurStrength = 0
		-- end
        
        blurShader4x4:setValue("screenSource", screenSource)
		blurShader4x4:setValue("screenSize", {screenWidth, screenHeight})
        blurShader4x4:setValue("blurStrength", blurStrength)
		
		dxSetRenderTarget(renderTarget4x4, true)
        dxDrawImage(0, 0, screenWidth, screenHeight, blurShader4x4)
		dxSetRenderTarget()
		
		blurShader8x8:setValue("screenSource", renderTarget4x4)
		blurShader8x8:setValue("screenSize", {screenWidth, screenHeight})
        blurShader8x8:setValue("blurStrength", blurStrength)
		
		dxSetRenderTarget(renderTarget8x8, true)
        dxDrawImage(0, 0, screenWidth, screenHeight, blurShader8x8)
		dxSetRenderTarget()
		
		blurShader16x16:setValue("screenSource", renderTarget8x8)
		blurShader16x16:setValue("screenSize", {screenWidth, screenHeight})
        blurShader16x16:setValue("blurStrength", blurStrength)
		
		dxSetRenderTarget(renderTarget16x16, true)
        dxDrawImage(0, 0, screenWidth, screenHeight, blurShader16x16)
		dxSetRenderTarget()
		
		blurShader32x32:setValue("screenSource", renderTarget16x16)
		blurShader32x32:setValue("screenSize", {screenWidth, screenHeight})
        blurShader32x32:setValue("blurStrength", blurStrength)
		
		dxSetRenderTarget(renderTarget32x32, true)
        dxDrawImage(0, 0, screenWidth, screenHeight, blurShader32x32)
		dxSetRenderTarget()
		
		--dxDrawImage(0, 0, screenWidth, screenHeight, renderTarget32x32)
		
		farPlaneShader:setValue("distance", distance)
		
		dxSetRenderTarget(renderTargetFarPlane, true)
        dxDrawImage(0, 0, screenWidth, screenHeight, farPlaneShader)
		dxSetRenderTarget()
		
		--dxDrawImage(0, 0, screenWidth, screenHeight, renderTargetFarPlane)
		
		dofShader:setValue("screenSource", screenSource)
		dofShader:setValue("farPlane", renderTargetFarPlane)
		dofShader:setValue("blurredSource", renderTarget32x32)
		dofShader:setValue("screenSize", {screenWidth, screenHeight})
		dofShader:setValue("saturation", saturation)
		dofShader:setValue("brightness", brightness)
		dofShader:setValue("contrast", contrast)
		
		dxDrawImage(0, 0, screenWidth, screenHeight, dofShader)
    end
end

function start()
	screenSource = dxCreateScreenSource(screenWidth, screenHeight)
	
	blurShader4x4 = dxCreateShader("shaders/blur.fx")
	renderTarget4x4 = dxCreateRenderTarget(screenWidth, screenHeight, true)
	blurShader8x8 = dxCreateShader("shaders/blur.fx")
	renderTarget8x8 = dxCreateRenderTarget(screenWidth, screenHeight, true)
	blurShader16x16 = dxCreateShader("shaders/blur.fx")
	renderTarget16x16 = dxCreateRenderTarget(screenWidth, screenHeight, true)
	blurShader32x32 = dxCreateShader("shaders/blur.fx")
	renderTarget32x32 = dxCreateRenderTarget(screenWidth, screenHeight, true)
	
	farPlaneShader = dxCreateShader("shaders/farPlane.fx")
	renderTargetFarPlane = dxCreateRenderTarget(screenWidth, screenHeight, true)
	
	dofShader = dxCreateShader("shaders/dof.fx")
	
	isLoaded = screenSource and blurShader4x4 and blurShader8x8 and blurShader16x16 and blurShader32x32 and renderTarget4x4 and renderTarget8x8 and renderTarget16x16 and renderTarget32x32 and farPlaneShader and renderTargetFarPlane and dofShader
	
	if (not isLoaded) then
		-- outputChatBox("Couldn`t create dof shader. Please use ´/debugscript 3` for further details.")
	end

	addEventHandler("onClientHUDRender", root, hudrender, true, 'high+100')
end

function stop()
	if (screenSource) then
		screenSource:destroy()
		screenSource = nil
	end
	
	if (blurShader4x4) then
		blurShader4x4:destroy()
		blurShader4x4 = nil
	end
	
	if (blurShader8x8) then
		blurShader8x8:destroy()
		blurShader8x8 = nil
	end
	
	if (blurShader16x16) then
		blurShader16x16:destroy()
		blurShader16x16 = nil
	end
	
	if (blurShader32x32) then
		blurShader32x32:destroy()
		blurShader32x32 = nil
	end
	
	if (farPlaneShader) then
		farPlaneShader:destroy()
		farPlaneShader = nil
	end
	
	if (renderTarget4x4) then
		renderTarget4x4:destroy()
		renderTarget4x4 = nil
	end
	
	if (renderTarget8x8) then
		renderTarget8x8:destroy()
		renderTarget8x8 = nil
	end
	
	if (renderTarget16x16) then
		renderTarget16x16:destroy()
		renderTarget16x16 = nil
	end
	
	if (renderTarget32x32) then
		renderTarget32x32:destroy()
		renderTarget32x32 = nil
	end
	
	if (renderTargetFarPlane) then
		renderTargetFarPlane:destroy()
		renderTargetFarPlane = nil
	end

	removeEventHandler("onClientHUDRender", root, hudrender)
end
addEventHandler("onClientResourceStop", resourceRoot, stop)



addEventHandler('onClientResourceStart', resourceRoot, function()

	if localPlayer:getData('settings.dof') then
		start()
	else
		stop()
	end

end)

addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

	if dn == 'settings.dof' then
		if new then
			start()
		else
			stop()
		end
	end


end)