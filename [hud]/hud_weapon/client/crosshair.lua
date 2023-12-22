-- local size = 30

-- function drawCrosshair() 

--     local tx,ty,tz = getPedTargetEnd ( localPlayer )
--     local x,y = getScreenFromWorldPosition ( tx,ty,tz )

--     dxDrawRectangle(
--         x-size/2, y-size/2, size, size,
--         tocolor(255,255,255,255)
--     )

-- end 

-- bindKey("aim_weapon", "both", function(key, state)        
--     local weapon = getPlayerWeapon( localPlayer )
--     if weapon ~= 0 and weapon ~= 1 then
--         if state == "down" then 
--             addEventHandler("onClientRender", root, drawCrosshair)
--         else
--             removeEventHandler("onClientRender", root, drawCrosshair) 
--         end 
--     end
-- end)