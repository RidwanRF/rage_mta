
	function isPlayerMuted(player)
		return (player:getData('mute.time') or 0) > 0
	end

------------------------------------------------------------

	function removePlayerMute(player)
		player:setData('mute.time', false)
	end

	function addPlayerMute(player, time)
		player:setData('mute.time', time)
		-- increaseElementData(player, 'mute.time', time)
	end

	setTimer(function()

		for _, player in pairs( getElementsByType('player') ) do

			if player:getData('mute.time') then
				increaseElementData(player, 'mute.time', -5)
			end

		end

	end, 5000, 0)

	addEventHandler('onElementDataChange', root, function(dn, old, new)
		if dn == 'mute.time' then

			if not new then
				if old then
					exports.chat_main:displayInfo(source, '[ЧАТ] Срок действия мута истек', {50, 255, 50})
				end
			elseif new <= 0 then
				removePlayerMute(source)
			end

		end

	end)