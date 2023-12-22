
function isPlayerInQuadra( player )
	return player.vehicle and player.vehicle.model == 587 and player.vehicleSeat == 0
end

Config.dailyQuests = {
	
	{

		reward = {
			items = {
				{
					text = '$15.000',
					icon = ':main_freeroam/assets/images/bonuses/money.png',
					give = function(player)
						exports['money']:givePlayerMoney(player, 15000)
					end,
				},
				{
					text = '50',
					icon = 'assets/images/c_energy.png',
					give = function(player)
						givePlayerEnergy( player, 50 )
					end,
				},
				
			},
		},

		name = 'Набрать 500.000 дрифта\nна Quadra V-TECH',
		dataName = 'sessionDrift',
		progressPoints = 500000,

		condition = isPlayerInQuadra,
		
	},
	
	{

		reward = {
			items = {
				{
					text = '7.62 x90',
					icon = 'assets/images/icons/ammo_1.png',
					give = function(player)

						exports.main_inventory:addInventoryItem({
							player = player,	
							item = 'ammo_1',
							count = 90,
						})

					end,
				},
				{
					text = '50',
					icon = 'assets/images/c_energy.png',
					give = function(player)
						givePlayerEnergy( player, 50 )
					end,
				},
				
			},
		},

		name = 'Проехать 100км\nна Quadra V-TECH',
		dataName = 'odometer',
		progressPoints = 100,

		condition = isPlayerInQuadra,
		
	},
	
	{

		reward = {
			items = {
				{
					text = 'VIP 2 часа',
					icon = 'assets/images/icons/vip.png',
					give = function(player)
						exports.main_vip:giveVip( player.account.name, 3600*2 )
					end,
				},
				{
					text = '60',
					icon = 'assets/images/c_energy.png',
					give = function(player)
						givePlayerEnergy( player, 60 )
					end,
				},
				
			},
		},

		name = 'Проехать 60км на Quadra V-TECH\nСкорость минимум 400км/ч',
		dataName = 'odometer',
		progressPoints = 60,

		condition = function(player)

			if isPlayerInQuadra( player ) then

				return getElementSpeed( player.vehicle, 'kmh' ) >= 400

			end

		end,
		
	},
	
	{

		reward = {
			items = {
				{
					text = '$12.000',
					icon = ':main_freeroam/assets/images/bonuses/money.png',
					give = function(player)
						exports.money:givePlayerMoney( player, 12000 )
					end,
				},
				{
					text = '35',
					icon = 'assets/images/c_energy.png',
					give = function(player)
						givePlayerEnergy( player, 35 )
					end,
				},
				
			},
		},

		name = 'Заправить 350 литров\nна Quadra V-TECH',
		dataName = 'fuel',
		progressPoints = 350,

		condition = isPlayerInQuadra,
		
	},
	
	{

		reward = {
			items = {
				{
					text = '$25.000',
					icon = ':main_freeroam/assets/images/bonuses/money.png',
					give = function(player)
						exports.money:givePlayerMoney( player, 25000 )
					end,
				},
				{
					text = '35',
					icon = 'assets/images/c_energy.png',
					give = function(player)
						givePlayerEnergy( player, 35 )
					end,
				},
				
			},
		},

		name = 'Пролететь 200с суммарно\nна Quadra V-TECH',
		dataName = 'vehicle_fly',
		progressPoints = 200,

		condition = isPlayerInQuadra,
		
	},
	
	{

		reward = {
			items = {
				{
					text = '$25.000',
					icon = ':main_freeroam/assets/images/bonuses/money.png',
					give = function(player)
						exports.money:givePlayerMoney( player, 25000 )
					end,
				},
				{
					text = '50',
					icon = 'assets/images/c_energy.png',
					give = function(player)
						givePlayerEnergy( player, 50 )
					end,
				},
				
			},
		},

		name = 'Отыграть 2 часа в гетто,\nни разу не умерев',
		dataName = 'ghetto.played',
		progressPoints = 2,

	},
	
	{

		reward = {
			items = {
				{
					text = '$20.000',
					icon = ':main_freeroam/assets/images/bonuses/money.png',
					give = function(player)
						exports.money:givePlayerMoney( player, 20000 )
					end,
				},
				{
					text = '60',
					icon = 'assets/images/c_energy.png',
					give = function(player)
						givePlayerEnergy( player, 60 )
					end,
				},

				
			},
		},

		name = 'Собрать 5 красных\nсгустков подряд',
		dataName = 'cyberquest.series.bunch_collect.red',
		progressPoints = 5,

	},
	
	{

		reward = {
			items = {
				{
					text = '$20.000',
					icon = ':main_freeroam/assets/images/bonuses/money.png',
					give = function(player)
						exports.money:givePlayerMoney( player, 20000 )
					end,
				},
				{
					text = '60',
					icon = 'assets/images/c_energy.png',
					give = function(player)
						givePlayerEnergy( player, 60 )
					end,
				},

				
			},
		},

		name = 'Сломать 5 желтых сгустков\nподряд (используя импульс)',
		dataName = 'cyberquest.series.bunch_break.yellow',
		progressPoints = 5,

	},
	
	{

		reward = {
			items = {
				{
					text = '$20.000',
					icon = ':main_freeroam/assets/images/bonuses/money.png',
					give = function(player)
						exports.money:givePlayerMoney( player, 20000 )
					end,
				},
				{
					text = '60',
					icon = 'assets/images/c_energy.png',
					give = function(player)
						givePlayerEnergy( player, 60 )
					end,
				},

				
			},
		},

		name = 'Сломать 5 зеленых сгустков\nподряд (используя импульс)',
		dataName = 'cyberquest.series.bunch_break.green',
		progressPoints = 5,

	},
	
	{

		reward = {
			items = {
				{
					text = '$20.000',
					icon = ':main_freeroam/assets/images/bonuses/money.png',
					give = function(player)
						exports.money:givePlayerMoney( player, 20000 )
					end,
				},
				{
					text = '60',
					icon = 'assets/images/c_energy.png',
					give = function(player)
						givePlayerEnergy( player, 60 )
					end,
				},

				
			},
		},

		name = 'Собрать 5 синих\nсгустков подряд',
		dataName = 'cyberquest.series.bunch_collect.blue',
		progressPoints = 5,

	},

}

for id, quest in pairs(Config.dailyQuests) do
	quest.id = id
end


Config.maxQuests = 4
Config.questReloadTime = 3*60*60
Config.questCompleteTime = 6*60*60
