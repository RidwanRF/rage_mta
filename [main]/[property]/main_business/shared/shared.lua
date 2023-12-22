
function getBusinessName(payment_sum)
	for _, data in pairs(Config.businessNames) do
		if isBetween(payment_sum, unpack(data.payment_sum)) then
			return data.name
		end
	end
end

function getBusinessType(cost)
	for _, data in pairs(Config.businessTypes) do
		if isBetween(cost, unpack(data.cost)) then
			return data.type
		end
	end
end

function getUpgradeCost(data, upgradeId)
	local type = getBusinessType(data.cost)
	return Config.upgrades[upgradeId].cost[type]
end