--
--	CLIENTSIDE RESOURCE START PROCEDURE
--
local colshapes = {}
local function resourceStart()
	--Load the clientside configuration file, or create a new one if it does not exist.
	local rootNode = xmlLoadFile(client_config_file) or xmlCreateFile(client_config_file, "config")
	
	--Ensure all important setting nodes exist.
	for settingKey, defaultValue in pairs(setting) do
		if not xmlFindChild(rootNode, settingKey, 0) then
			local newNode = xmlCreateChild(rootNode, settingKey)
			xmlNodeSetValue(newNode, tostring(defaultValue))
		end
	end
	
	--Remove deprecated/unused setting nodes.
	for _, subNode in ipairs(xmlNodeGetChildren(rootNode)) do
		local nodeName = xmlNodeGetName(subNode)
		if not setting[nodeName] then
			xmlDestroyNode(subNode)
		end
	end
	
	xmlSaveFile(rootNode)
	xmlUnloadFile(rootNode)

	--Cache the client-side handling saves.
	cacheClientSaves()

	--Query the server for admin rights.
	triggerServerEvent("requestRights", root)

	--Build the GUI.
	startBuilding()
	
	-- Создаем коробочки внутри сто ЧЕНДЖ

	colshapes = {
		createColSphere( 1869.69, 2241.68, 11.09, 10 ),
		createColSphere( 565.12, -1301.94, 17.49, 10 ),
		createColSphere( -2325.92, -156.2, 35.48, 10 ),
		createColSphere( -1085.7, -214.39, 14.36, 8 ),
		createColSphere( -2974.91, -230.51, 5.64, 25 ),
	}

	for _, colshape in pairs( colshapes ) do

		colshape:setData('handling', true)

		local x,y,z = getElementPosition(colshape)
		-- local blip = createBlip(x,y,z, 0)
		-- blip:setData('icon', 'handling')

	end
	
end

addEventHandler('onClientColShapeHit', resourceRoot, function(player)
	if player == localPlayer and localPlayer.vehicle and localPlayer.vehicleSeat == 0 then
		exports.hud_notify:actionNotify('B', 'Настроить хэндлинг', 3000)
	end
end)

addEventHandler("onClientResourceStart", resourceRoot, resourceStart)

function isVehicleInsideRepairStation(pVehicle)
	local ok = false
	for _, colShape in ipairs(colshapes) do
		local vehTable = getElementsWithinColShape(colShape, "vehicle")
		for _, veh in ipairs(vehTable) do
			if pVehicle == veh then
				ok = true
				break
			end
		end
		if ok == true then
			break
		end
	end
	return ok
end

function isPlayerInsideRepairStation(checkingPlayer)
	local ok = false
	for _, colShape in ipairs(colshapes) do
		local playerTable = getElementsWithinColShape(colShape, "player")
		for _, player in ipairs(playerTable) do
			if checkingPlayer == player then
				ok = true
				break
			end
		end
		if ok == true then
			break
		end
	end
	return ok
end

--
--	CLIENTSIDE RESOURCE STOP PROCEDURE
--
local function resourceStop()
	--Unload the clientside configuration file.
	xmlUnloadFile(client_handling_file)
end
addEventHandler("onClientResourceStop", resourceRoot, resourceStop)