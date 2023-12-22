
function isVip(player)
	if not isElement(player) then return end
	return player:getData('vip')
end


function getWorksMultiplier(player, work)

	local boost = work and exports.jobs_common:getPlayerBoost(player, work) or 0

	if isVip(player) and (boost or 0) <= 0 then
		return 1 + Config.workMul
	else
		return 1
	end
end