
--------------------------------------------------------

	loadstring( exports.core:include('common'))()

--------------------------------------------------------

	exports.save:addParameter('money', false, true)
	exports.save:addParameter('money.spent', false, true)

--------------------------------------------------------

	local queue = {}

	setTimer(function()

		local index = 0

		for player, amount in pairs( queue ) do

			if isElement( player ) then
				increaseElementData( player, 'money.spent', amount )
				exports.main_freeroam:updatePlayerAchievments( player )
			end

			queue[player] = nil
			index = index + 1

			if index >= 10 then break end

		end

	end, 5000, 0)

--------------------------------------------------------
	
	function addMoneySpentStats( player, amount )
		queue[player] = (queue[player] or 0) + amount
	end

--------------------------------------------------------