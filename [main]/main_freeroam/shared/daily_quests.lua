
Config.dailyQuests = {
	
	{

		reward = {
			items = {
				{
					text = '$3.000',
					icon = 'assets/images/bonuses/money.png',
					give = function(player)
						exports['money']:givePlayerMoney(player, 3000)
					end,
				},
				
			},
		},

		name = 'Посетить работу\nпочтальона',
		dataName = 'visits.job_post',
		progressPoints = 1,
		
	},
	
	{

		reward = {
			items = {
				{
					text = '$3.000',
					icon = 'assets/images/bonuses/money.png',
					give = function(player)
						exports['money']:givePlayerMoney(player, 3000)
					end,
				},
				
			},
		},

		name = 'Посетить работу\nводителя автобуса',
		dataName = 'visits.job_bus',
		progressPoints = 1,
		
	},
	
	{

		reward = {
			items = {
				{
					text = '$3.000',
					icon = 'assets/images/bonuses/money.png',
					give = function(player)
						exports['money']:givePlayerMoney(player, 3000)
					end,
				},
				
			},
		},

		name = 'Посетить работу\nлесоруба',
		dataName = 'visits.job_lumberjack',
		progressPoints = 1,
		
	},
	
	{

		reward = {
			items = {
				{
					text = '$3.000',
					icon = 'assets/images/bonuses/money.png',
					give = function(player)
						exports['money']:givePlayerMoney(player, 3000)
					end,
				},
				
			},
		},

		name = 'Посетить работу\nтаксиста',
		dataName = 'visits.job_taxi',
		progressPoints = 1,
		
	},
	
	{

		reward = {
			items = {
				{
					text = '$3.000',
					icon = 'assets/images/bonuses/money.png',
					give = function(player)
						exports['money']:givePlayerMoney(player, 3000)
					end,
				},
				
			},
		},

		name = 'Посетить работу\nгазонокосильщика',
		dataName = 'visits.job_green',
		progressPoints = 1,
		
	},
	
	{

		reward = {
			items = {
				{
					text = '$3.000',
					icon = 'assets/images/bonuses/money.png',
					give = function(player)
						exports['money']:givePlayerMoney(player, 3000)
					end,
				},
				
			},
		},

		name = 'Посетить работу\nлогиста',
		dataName = 'visits.job_logist',
		progressPoints = 1,
		
	},
	
	{

		reward = {
			items = {
				{
					text = '$3.000',
					icon = 'assets/images/bonuses/money.png',
					give = function(player)
						exports['money']:givePlayerMoney(player, 3000)
					end,
				},
				
			},
		},

		name = 'Посетить работу\nшахтера',
		dataName = 'visits.job_miner',
		progressPoints = 1,
		
	},
	
	{

		reward = {
			items = {
				{
					text = '$5.000',
					icon = 'assets/images/bonuses/money.png',
					give = function(player)
						exports['money']:givePlayerMoney(player, 5000)
					end,
				},
				
			},
		},

		name = 'Проехать 100км\nна автомобиле',
		dataName = 'odometer',
		progressPoints = 100,
		
	},
	
	{

		reward = {
			items = {
				{
					text = '$3.000',
					icon = 'assets/images/bonuses/money.png',
					give = function(player)
						exports['money']:givePlayerMoney(player, 3000)
					end,
				},
				
			},
		},

		name = 'Посетить закусочную',
		dataName = 'visits.main_food_shop',
		progressPoints = 1,
		
	},
	
	{

		reward = {
			items = {
				{
					text = '$5.500',
					icon = 'assets/images/bonuses/money.png',
					give = function(player)
						exports['money']:givePlayerMoney(player, 5500)
					end,
				},
				
			},
		},

		name = 'Набрать 100.000\nдрифт-очков суммарно',
		dataName = 'sessionDrift',
		progressPoints = 100000,
		
	},
	
	{

		reward = {
			items = {
				{
					text = '$10.000',
					icon = 'assets/images/bonuses/money.png',
					give = function(player)
						exports['money']:givePlayerMoney(player, 10000)
					end,
				},
				
			},
		},

		name = 'Набрать 500.000\nдрифт-очков суммарно',
		dataName = 'sessionDrift',
		progressPoints = 500000,
		
	},
	
	{

		reward = {
			items = {
				{
					text = '$12.000',
					icon = 'assets/images/bonuses/money.png',
					give = function(player)
						exports['money']:givePlayerMoney(player, 12000)
					end,
				},
				
			},
		},

		name = 'Набрать 1.000.000\nдрифт-очков суммарно',
		dataName = 'sessionDrift',
		progressPoints = 1000000,
		
	},
	
	{

		reward = {
			items = {
				{
					text = 'VIP 1 час',
					icon = 'assets/images/vip.png',
					give = function(player)
						exports.main_vip:giveVip(player.account.name, 3600)
					end,
				},
				
			},
		},

		name = 'Заработать $20.000\nпочтальоном',
		dataName = 'job.temp_stats.job_post.raised_money',
		progressPoints = 20000,
		
	},
	
	{

		reward = {
			items = {
				{
					text = 'VIP 1 час',
					icon = 'assets/images/vip.png',
					give = function(player)
						exports.main_vip:giveVip(player.account.name, 3600)
					end,
				},
				
			},
		},

		name = 'Заработать $20.000\nшахтером',
		dataName = 'job.temp_stats.job_miner.raised_money',
		progressPoints = 20000,
		
	},
	
	{

		reward = {
			items = {
				{
					text = '$5.000',
					icon = 'assets/images/bonuses/money.png',
					give = function(player)
						exports['money']:givePlayerMoney(player, 5000)
					end,
				},
				
			},
		},

		name = 'Отыграть 1 час',
		dataName = 'temp.level',
		progressPoints = 1,
		
	},
	
	{

		reward = {
			items = {
				{
					text = '$7.000',
					icon = 'assets/images/bonuses/money.png',
					give = function(player)
						exports['money']:givePlayerMoney(player, 7000)
					end,
				},
				
			},
		},

		name = 'Отыграть 3 часа',
		dataName = 'temp.level',
		progressPoints = 3,
		
	},
	
	{

		reward = {
			items = {
				{
					text = 'Скид. промо 20%',
					icon = 'assets/images/vip.png',
					give = function(player)
						addConvertPromo(player, nil, 20)
					end,
				},
				
			},
		},

		name = 'Отыграть 5 часов',
		dataName = 'temp.level',
		progressPoints = 5,
		
	},
	
	{

		reward = {
			items = {
				{
					text = 'Кейс Новичок',
					icon = 'assets/images/packs/1.png',
					give = function(player)
						givePlayerPack(player, 1, 1)
					end,
				},
				
			},
		},

		name = 'Открыть кейс Новичок',
		dataName = 'packs.opened.1',
		progressPoints = 1,
		
	},
	
	{

		reward = {
			items = {
				{
					text = 'Кейс RAGE',
					icon = 'assets/images/packs/2.png',
					give = function(player)
						givePlayerPack(player, 2, 1)
					end,
				},
				
			},
		},

		name = 'Открыть кейс RAGE',
		dataName = 'packs.opened.2',
		progressPoints = 1,
		
	},

}

for id, quest in pairs(Config.dailyQuests) do
	quest.id = id
end


Config.maxQuests = 6
Config.questReloadTime = 8*60*60
Config.questCompleteTime = 8*60*60
