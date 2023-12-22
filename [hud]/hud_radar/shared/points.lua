

function displayPoint(player, x,y, time)

	if localPlayer then
		_displayPoint(player, x,y)
	else
		triggerClientEvent(player, 'hud_radar.displayPoint', resourceRoot, x,y, time)
	end

end

if localPlayer then

	local pointsDisplay = {}

	function _displayPoint(x,y, time)

		local blip = createBlip(x,y, 0, 0)
		blip:setData('icon', 'important_point')

		pointsDisplay[blip] = setTimer(function(blip)
			if isElement(blip) then
				destroyElement(blip)
			end
			pointsDisplay[blip] = nil
		end, time, 1, blip)

		table.insert(delayedBlips, blip)

	end

	addEvent('hud_radar.displayPoint', true)
	addEventHandler('hud_radar.displayPoint', resourceRoot, _displayPoint)

	addCommandHandler('radar_point', function(_, x,y)
		_displayPoint( tonumber(x), tonumber(y), 5000 )
	end)

end