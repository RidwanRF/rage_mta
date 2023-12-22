
local score = 0
local last_tick = getTickCount()
local flying = false

local queue = 0

setTimer(function()

	local bool = (localPlayer.vehicle and not isVehicleOnGround(localPlayer.vehicle))

	if bool then

		if not flying then
			last_tick = getTickCount()
			flying = true
		end

	else

		if flying then
			local time = getTickCount() - last_tick
			if time > 500 then
				queue = queue + time/1000
			end
			flying = false
		end

	end

end, 300, 0)


setTimer(function()
	if queue > 0 then
		triggerServerEvent('main_freeroam.ach.receiveFly', resourceRoot, queue)
		queue = 0
	end
end, 5000, 0)