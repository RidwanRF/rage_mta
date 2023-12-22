-- Shader SKYBOX v1.06 by Ren712
-- knoblauch700@o2.pl

-- Adjust sphere object size (depending on the weather, game mode etc)
local skybox_scale = 3200  -- 3200 (that's the lod object scale)
local object_id = 15057  -- this is an object we are going to replace (interior fake shadow models are the best)
--like  15060 15057 ...56 ...51 ...62
local getLastTick, getLastTock = 0,0
local skybox_shader, technique = dxCreateShader ( "shader_skybox.fx" )

function startShaderResource()
 -----------------------------------------------------
 -- apply shader
 if not skybox_shader then 
  outputChatBox('Could not start Skybox shader!')
  return 
  else
 -- outputChatBox('Using technique '..technique)
 end
 local textureSkybox1= dxCreateTexture ( "textures/cubebox1.dds" )
 dxSetShaderValue ( skybox_shader, "sSkyBoxTexture1", textureSkybox1 )
 -- brighten (-1,1) 
 dxSetShaderValue ( skybox_shader, "gBrighten", 0)
 -- enable alpha 1-true 0-false
 dxSetShaderValue ( skybox_shader, "gEnAlpha", 1)
 -- invert time cycle (0-normal/24h sky 1-nightsky)
  dxSetShaderValue ( skybox_shader, "gInvertTimeCycle", 0)
 -- Should the skybox rotate or be static ? (0- static 1-rotate)
  dxSetShaderValue ( skybox_shader, "animate", 0) 
 -- Rotate speed/ or angle (-1,1)
 -- if animate = 0 you can rotate it by .. let's say 90 degrees = set it like this {...tateX",math.rad(90))  }
 -- if animate = 1 you set rotation speed
  dxSetShaderValue ( skybox_shader, "rotateX", 0) 
  dxSetShaderValue ( skybox_shader, "rotateY", 0) 
  dxSetShaderValue ( skybox_shader, "rotateZ", 0) 
 -- Resize the model (scale x, y and z) (0..1..n) 
 -- You not only can scale the object with mta functions :) .. this time you have more variables. But it's useless imho. 1=normal size 
  dxSetShaderValue ( skybox_shader, "sResize",1,1,1) 
 -- You can also stretch the projected image. May look good with clouds ..  1=normal size (0..1..n)
  dxSetShaderValue ( skybox_shader, "sStretch",1,1,1) 
 -- just experiment with that 
 -- apply to texture
 engineApplyShaderToWorldTexture ( skybox_shader, "skybox_tex" )
 -----------------------------------------------------
 -- apply model
 txd_skybox = engineLoadTXD('models/skybox_model.txd')
 engineImportTXD(txd_skybox, object_id)
 dff_skybox = engineLoadDFF('models/skybox_model.dff', object_id)
 engineReplaceModel(dff_skybox, object_id)  
-- at the first time we will take player coordinates instead of camera coordinates
 local cam_x,cam_y,cam_z = getElementPosition(getLocalPlayer())
 skyBoxBoxa = createObject ( object_id, cam_x, cam_y, cam_z, 0, 0, 0, true )
-- Scale the spheric object on which the skybox is drawn
-- The bigger value, the bigger max distance 
 setObjectScale ( skyBoxBoxa, skybox_scale )
 setCloudsEnabled(false) -- why doesn't it work ?
 setWeather(17) -- works great with setWeather 17 and 12 at theese settings

addEventHandler ( "onClientHUDRender", getRootElement (), renderSphere ) -- draw skybox
addEventHandler ( "onClientHUDRender", getRootElement (), renderTime ) -- add timecycle 
end

function renderTime()
 -- I could attach it to the camera but i don't care ... do it yourself if ya want
 -- Darken the skybox at night (pause 300)
 local hour, minute = getTime ( )
 if getTickCount ( ) - getLastTick < 300  then return end
 if not skybox_shader then return end
 if hour >= 20 then
  local dusk_aspect = ((hour-20)*60+minute)/240
  dusk_aspect = -dusk_aspect
  dxSetShaderValue ( skybox_shader, "gBrighten", dusk_aspect)
 end
	
 if hour <= 2 then
  dxSetShaderValue ( skybox_shader, "gBrighten", -1)
 end
	
 if hour > 2 and hour <= 6 then
  local dawn_aspect = ((hour-3)*60+minute)/180
  dawn_aspect = -(1 - dawn_aspect)
  dxSetShaderValue ( skybox_shader, "gBrighten", dawn_aspect)
 end
	
 if hour > 6 and hour < 20 then
  dxSetShaderValue ( skybox_shader, "gBrighten", 0)
 end

 getLastTick = getTickCount ()
end

function renderSphere()
 -- Updates the position of the sphere object (pause 30)
 if getTickCount ( ) - getLastTock < 30  then return end
 -- Set the skybox model position accordingly to the camera position
 local cam_x, cam_y, cam_z, lx, ly, lz = getCameraMatrix()
 setElementPosition ( skyBoxBoxa, cam_x, cam_y, cam_z ,false )
 getLastTock = getTickCount ()
end

addEventHandler("onClientResourceStart", getResourceRootElement( getThisResource()), startShaderResource)
