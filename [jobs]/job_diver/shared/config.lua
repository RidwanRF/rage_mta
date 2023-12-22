
Config = {}

Config.resourceName = getThisResource().name

Config.defaultOxygen = 30

Config.stations = {
	{
		marker = { 530.55, -1816.97, 6.58 },
		shop = { 525.13, -1817.81, 6.57 },
		destination = { 526.37, -1807.79, 6.68 },
	},
}

Config.skin = 40

Config.loot = {
	
	{
		name = 'Драгоценный камень',
		icon = 'assets/images/items/1.png',
		cost = {550,950},
	},
	
	{
		name = 'Утонувшее оружие',
		icon = 'assets/images/items/2.png',
		cost = {400,750},
	},
	
	{
		name = 'Золотой слиток',
		icon = 'assets/images/items/3.png',
		cost = {1000,1200},
	},

}

Config.shop = {
	
	{

		name = 'Малый баллон O2',
		title = 'Запас кислорода 180 сек',
		cost = 1200,

		give = function(player)
			return givePlayerOxygen(player, 180)
		end,

	},
	
	{

		name = 'Большой баллон O2',
		title = 'Запас кислорода 360 сек',
		cost = 2200,

		give = function(player)
			return givePlayerOxygen(player, 360)
		end,

	},
	
	{

		name = 'Рюкзак',
		title = '+3 слота для предметов',
		cost = 1500,

		give = function(player)

			local size = Config.defaultInventorySize + 3

			if player:getData('diver.inventory_size') == size then
				exports.hud_notify:notify(player, 'Ошибка', 'Вы уже купили рюкзак')
				return false
			end

			player:setData('diver.inventory_size', size)
			return true

		end,

	},
	
	{

		name = 'Лодка',
		title = 'Доступна в F3',
		cost = 2500,

		give = function(player)

			if exports.jobs_main:getPlayerSessionData( player, 'boat_id' ) then
				exports.hud_notify:notify(player, 'Ошибка', 'Вы уже купили лодку')
				return false
			end

			local boat_id = exports.vehicles_main:giveAccountVehicle(
				player.account.name, 473, nil, 18000
			)

			exports.jobs_main:setPlayerSessionData( player, 'boat_id', boat_id )

			return true

		end,

	},

}

Config.defaultInventorySize = 3

Config.points = {
	{ 760.75, -2090.64, -23.48, 0, },
	{ 631.21, -2154.08, -32.64, 0, },
	{ 461.97, -2144.37, -29.26, 0, },
	{ 327.39, -2138.29, -29.26, 0, },
	{ 268.6, -2133.98, -29.26, 0, },
	{ 167.15, -2132.45, -29.26, 0, },
	{ 170.53, -2107.69, -29.26, 0, },
	{ 282.37, -2120.79, -29.26, 0, },
	{ 305.96, -2120.75, -29.26, 0, },
	{ 557.43, -2151.07, -29.26, 0, },
	{ 662.88, -2126.43, -34.28, 0, },
	{ 763.98, -2031.72, -20.88, 0, },
	{ 752.65, -2110.45, -24.91, 0, },
	{ 614.72, -2179.02, -31.03, 0, },
	{ 428.74, -2153.95, -29.26, 0, },
}

function getConfigSetting(name)
	return Config[name]
end

function setConfigSetting(name, value)
	Config[name] = value
end
