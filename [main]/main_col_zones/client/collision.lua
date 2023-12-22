
loadstring( exports.core:include('common'))()

local collision = false
local allElements = {}

function getAllElements()
	return {
		vehicle = getElementsByType('vehicle', getResourceRoot('vehicles_main'), true),
		player = getElementsByType('player', root, true),
	}
end

function toggleElementCollision(e_element, flag)

	for _, elements in pairs( allElements ) do

		for _, element in pairs( elements ) do
			if e_element ~= element then
				if isElementOnScreen(element) then
					setElementCollidableWith(e_element, element, flag)
				end
			end
		end

	end

end

function toggleCollision(flag)

	collision = flag
	allElements = getAllElements()

	for _, elements in pairs( allElements ) do

		for _, element in pairs( elements ) do
			if isElementOnScreen(element) then

				if flag and element.type == 'vehicle' then
					flag = not element:getData('vehicle.handbrake')
				end

				toggleElementCollision(element, flag)

			end
		end

	end

end

local prev_col_flag

setTimer(function()

	local _col_flag = not isPlayerInWhiteZone(localPlayer)
	-- if prev_col_flag ~= _col_flag then
		toggleCollision( _col_flag )
		-- prev_col_flag = _col_flag
	-- end

end, 1000, 0)