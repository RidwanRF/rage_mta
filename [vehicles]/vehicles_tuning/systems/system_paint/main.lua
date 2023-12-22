
colorLoadFunctions = {
	color_1 = function(vehicle, color)
		local _,_,_, r2,g2,b2, r3,g3,b3 = vehicle:getColor(true)
		local r1,g1,b1 = hexToRGB(color)
		vehicle:setColor(r1,g1,b1, r2,g2,b2, r3,g3,b3)
	end,
	color_2 = function(vehicle, color)
		local r1,g1,b1, _,_,_, r3,g3,b3 = vehicle:getColor(true)
		local r2,g2,b2 = hexToRGB(color)
		vehicle:setColor(r1,g1,b1, r2,g2,b2, r3,g3,b3)
	end,
	color_3 = function(vehicle, color)
		local r1,g1,b1, r2,g2,b2, _,_,_ = vehicle:getColor(true)
		local r3,g3,b3 = hexToRGB(color)
		vehicle:setColor(r1,g1,b1, r2,g2,b2, r3,g3,b3)
	end,
}

addEventHandler('onClientElementDataChange', root, function(dataName, old, new)
	if source.type == 'vehicle' and isElementStreamedIn(source) then
		if colorLoadFunctions[dataName] then
			colorLoadFunctions[dataName](source, new)
		end
	end
end, true, 'low')

-- addEventHandler('onClientElementStreamIn', root, function()

-- 	if source.type ~= 'vehicle' then return end

-- 	for _, type in pairs( Config.paintTypes ) do
-- 		if colorLoadFunctions[type.name] then
-- 			local color = source:getData(type.name) or '#ffffff'
-- 			if color then
-- 				colorLoadFunctions[type.name]( source, color )
-- 			end
-- 		end
-- 	end

-- end, true, 'low')