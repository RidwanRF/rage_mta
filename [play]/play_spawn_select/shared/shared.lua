
function getNearestHospital(player)
	local nearestHospital = Config.hospitals[1]
	local nearestDistance = 65535
	local posX, posY, posZ = getElementPosition(player)
	for i, hosp in pairs(Config.hospitals) do
		local distance = ((hosp[1]-posX)^2+(hosp[2]-posY)^2+(hosp[3]-posZ)^2)^(0.5)
		if (distance < nearestDistance) then
			nearestDistance = distance
			nearestHospital = hosp
		end
	end
	return nearestHospital
end