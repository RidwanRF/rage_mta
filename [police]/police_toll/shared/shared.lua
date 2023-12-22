
function getCurrentPassCost()
	local h = getTime()
	for _, data in pairs( Config.costs ) do
		if h >= data.dtime[1] and h <= data.dtime[2] then
			return data.cost, data.ticket
		end
	end
end