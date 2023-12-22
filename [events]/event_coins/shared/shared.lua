

function getCurrentSeason()
	return resourceRoot:getData('current_season') or 0
end

function getPlayersTop()
	return resourceRoot:getData('players_top') or { top = {}, places = {} }
end

local defaultFarm = {
	active = 1,
	passive = 0,
}

function getPlayerFarmAmount( player, farm_type )

	local amount = defaultFarm[farm_type]
	local upgrades = player:getData('event_coins.upgrades') or {}

	for upgrade_id, count in pairs( upgrades ) do

		local config = Config.upgrades[upgrade_id]
		if config.farm_type == farm_type then
			amount = amount + count * config.add
		end

	end

	return amount

end
