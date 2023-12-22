
--------------------------------------------------------------------

	local function giveQuest(player, slot, _questId)

		local quests = player:getData('cyberquest.quests') or {}

		local usedQuestIds = {}
		local usedDataNames = {}

		for _, quest in pairs(quests) do

			if quest.questId then

				local config = Config.dailyQuests[quest.questId]
				
				if config then
					usedQuestIds[quest.questId] = true
					usedDataNames[ config.dataName ] = true
				end


			end

		end

		if getTableLength(usedQuestIds) >= #Config.dailyQuests then
			return false
		end

		local questId, configQuestData

		if _questId then
			configQuestData = Config.dailyQuests[_questId]
			questId = _questId
		else
			for id, _quest in pairs( randomSort( table.copy(Config.dailyQuests) ) ) do
				if not usedQuestIds[_quest.id] and not usedDataNames[_quest.dataName] then


					questId = _quest.id
					configQuestData = _quest
					break

				end
			end
		end

		if not questId then return end

		local questData = {

			state = 'active',
			progressPoints = configQuestData.progressPoints,
			finish_at = getRealTime().timestamp + Config.questCompleteTime,
			questId = questId,

		}

		local slotId = slot or (#quests + 1)
		quests[slotId] = questData

		player:setData('cyberquest.quests', quests)
		-- player:setData('cyberquest.quests', quests, false)
		quests_queue[player] = true

	end

--------------------------------------------------------------------

	function resetQuestProgress( player, dataName )

		local quests = player:getData('cyberquest.quests') or {}

		for slot, quest in pairs( quests ) do

			local config = Config.dailyQuests[ quest.questId ]
			if config and config.dataName == dataName then

				quest.progressPoints = config.progressPoints
				quests_queue[player] = true

				return player:setData('cyberquest.quests', quests, false)

			end

		end

	end

--------------------------------------------------------------------

	local function completeQuest(player, slot, successfully)

		local quests = player:getData('cyberquest.quests') or {}
		local questId = quests[slot].questId

		if successfully then

			local questConfig = Config.dailyQuests[ questId ]

			local rewardConfig = questConfig.reward
			for _, item in pairs( rewardConfig.items ) do
				item.give(player)
			end

		end

		quests[slot] = {
			renew_timestamp = getRealTime().timestamp + Config.questReloadTime,
		}

		if successfully then
			exports['hud_notify']:notify(player, 'Задание выполнено', 'F6 >> Задания')
		end

		player:setData('cyberquest.quests', quests, false)
		quests_queue[player] = true

		exports.main_sounds:playSound( player, 'quest' )

	end

	local function addQuestProgress(player, slot, amount)

		local quests = player:getData('cyberquest.quests') or {}

		if quests[slot] and quests[slot].progressPoints then

			quests[slot].progressPoints = quests[slot].progressPoints - amount

			if quests[slot].progressPoints <= 0 then
				completeQuest(player, slot, true)
			else
				player:setData('cyberquest.quests', quests)
				-- player:setData('cyberquest.quests', quests, false)
				quests_queue[player] = true
			end

		end

	end

--------------------------------------------------------------------

	quests_queue = {}

	setTimer(function()

		for player in pairs( quests_queue ) do
			if isElement(player) then
				local quests = player:getData('cyberquest.quests') or {}
				triggerClientEvent(player, 'cyberquest.receiveClientQuests', resourceRoot, quests)
			end
		end

		quests_queue = {}

	end, 1000, 0)
	-- end, 20000, 0)

--------------------------------------------------------------------

	local possibleDataNames = {}

	for _, quest in pairs(Config.dailyQuests) do
		possibleDataNames[quest.dataName] = true
	end

	addEventHandler('onElementDataChange', root, function(dataName, old, new)

		if possibleDataNames[dataName] and new and new > (old or 0) then

			local player = source
			if source.type == 'vehicle' then
				player = getVehicleOccupant(source)
			end

			if not player then return end

			local quests = player:getData('cyberquest.quests') or {}

			for slot, quest in pairs(quests) do

				if quest.questId then

					local questConfig = Config.dailyQuests[quest.questId]
					if questConfig.dataName == dataName then

						if not questConfig.condition or questConfig.condition(player) then

							local delta = new - (old or 0)
							if questConfig.seriesPoints then

								if delta >= questConfig.seriesPoints then
									addQuestProgress(player, slot, 1)
								end

							else

								addQuestProgress(player, slot, delta)

							end

						end

					end

				end

			end

		end

	end)

--------------------------------------------------------------------

	local function updatePlayerQuests(player)

		local quests = player:getData('cyberquest.quests') or {}

		local maxQuests = Config.maxQuests

		if #quests < maxQuests then
			for i = 1, (maxQuests - #quests) do
				giveQuest(player)
			end
		end

		local realTime = getRealTime().timestamp

		for slot, quest in pairs(quests) do
			if quest.renew_timestamp and quest.renew_timestamp < realTime then
				giveQuest(player, slot)
			end
		end

		local failed = 0

		for slot, quest in pairs( quests ) do

			if quest.finish_at and quest.finish_at < realTime then
				completeQuest(player, slot, false)
				failed = failed + 1
			end

		end

	end

	addEventHandler('onPlayerLogin', root, function()
		updatePlayerQuests(source)
	end)

	setTimer(function()

		for _, player in pairs( getElementsByType('player') ) do
			updatePlayerQuests(player)
		end

	end, 15000, 0)

--------------------------------------------------------------------