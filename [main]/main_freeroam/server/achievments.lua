
----------------------------------------------------
	
	exports.save:addParameter('achievments', true, true, true)

----------------------------------------------------

	function givePlayerAchievment(player, id)

		local achievments = player:getData('achievments') or {}

		local config = Config.achievments[id]

		achievments[id] = {
			progress = config.progressPoints,
		}

		player:setData('achievments', achievments, false)
		ach_queue[player] = true

	end

----------------------------------------------------

	function completeAchievment(player, id)

		local achievments = player:getData('achievments') or {}

		if achievments[id] then

			achievments[id] = { completed = true }

			local config = Config.achievments[id]

			player:setData('achievments', achievments, false)
			ach_queue[player] = true

			exports.main_sounds:playSound( player, 'achievment' )

			if config.type == 'status' then

				givePlayerStatus(player, config.status.id)
				exports['hud_notify']:notify(player, 'Новый титул',
					string.format('«%s»', config.status.name))

			else

				for _, reward in pairs( config.reward ) do
					reward.give(player)
				end

				if config.display ~= false then
					exports['hud_notify']:notify(player, 'Новое достижение',
						string.format('«%s»', config.name))
					triggerClientEvent(player, 'achievments.displayReward', resourceRoot, id, 'achievments')
				end

			end


		end

	end

----------------------------------------------------

	ach_queue = {}

	setTimer(function()

		for player in pairs( ach_queue ) do
			if isElement(player) then
				local achievments = player:getData('achievments') or {}
				triggerClientEvent(player, 'freeroam.receiveClientAchievments', resourceRoot, achievments)
			end
		end

		ach_queue = {}

	end, 20000, 0)

	function addAchievmentProgress(player, id, progress)

		local achievments = player:getData('achievments') or {}

		if achievments[id] then
			achievments[id].progress = 
				achievments[id].progress - progress

			if achievments[id].progress <= 0 then
				return completeAchievment(player, id)
			else
				player:setData('achievments', achievments, false)
				ach_queue[player] = true
			end

		end
		
	end

----------------------------------------------------

	function updatePlayerAchievments(player)

		local achievments = player:getData('achievments') or {}

		for id, achievment in pairs( Config.achievments ) do

			if not achievments[id] then
				givePlayerAchievment(player, id)
			elseif achievments[id] and not achievments[id].completed then

				if achievment.getState and achievment:getState(player) then
					completeAchievment(player, id)
				end

			end

		end

	end

----------------------------------------------------

	local possibleDataNames = {}
	for _, achievment in pairs( Config.achievments ) do
		if achievment.dataName then
			possibleDataNames[achievment.dataName] = true
		end
	end

	addEventHandler('onElementDataChange', root, function(dataName, old, new)

		-- if source:getData('save.uninitialized') then return end
		if not possibleDataNames[dataName] then return end
		if not new then return end
		
		local player = source
		if source.type == 'vehicle' and source:getData('id') then
			player = getVehicleOccupant(source)
		end

		if not player then return end


		local delta = new - (old or 0)
		if delta <= 0 then return end
		local achievments = player:getData('achievments') or {}

		for id, achievment in pairs( achievments ) do

			local config = Config.achievments[id]

			if config and achievment.progress and config.dataName == dataName then
				if config.seriesPoints then
					if delta >= config.seriesPoints then
						addAchievmentProgress(player, id, 1)
					end
				else
					addAchievmentProgress(player, id, delta)
				end
			end
		end

	end)

----------------------------------------------------

	addEventHandler('onPlayerLogin', root, function()

		updatePlayerAchievments(source)
	end, true, 'low-2')

	addCommandHandler('update_ach', function(player, _, login)
		if exports['acl']:isAdmin(player) then
			if login then
				updatePlayerAchievments(getAccount(login).player)
			else
				updatePlayerAchievments(player)
			end
		end
	end)

----------------------------------------------------