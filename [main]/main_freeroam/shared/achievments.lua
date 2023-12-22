
Config.achievments = {

	{

		name = 'Водитель',
		progressPoints = 1,

		dataName = 'vehicles_autoschool.licenses_bought',
		title = 'Приобрести любые права\nна транспорт',

		reward = {
			{
				text = '$7.000',
				icon = 'assets/images/bonuses/money.png',
				tooltip = 'деньги',
				give = function(player)
					exports.money:givePlayerMoney(player, 7000)
				end,
			},
		},

	},

	{

		name = 'Поехали!',
		progressPoints = 1,

		dataName = 'vehicles_shop.vehicles_bought',
		title = 'Приобрести автомобиль\nв автосалоне',

		reward = {
			{
				text = '$7.000',
				icon = 'assets/images/bonuses/money.png',
				tooltip = 'деньги',
				give = function(player)
					exports.money:givePlayerMoney(player, 7000)
				end,
			},
		},

	},

	{

		name = 'Трудяга',
		progressPoints = 1,

		dataName = 'jobs_main.jobs_started',
		title = 'Устроиться на любую работу',

		reward = {
			{
				text = '$4.000',
				icon = 'assets/images/bonuses/money.png',
				tooltip = 'деньги',
				give = function(player)
					exports.money:givePlayerMoney(player, 4000)
				end,
			},
		},

	},

	{

		name = 'Стилёво',
		progressPoints = 1,

		dataName = 'main_clothes.clothes_bought',
		title = 'Купить скин в магазине\nодежды',

		reward = {
			{
				text = '$15.000',
				icon = 'assets/images/bonuses/money.png',
				tooltip = 'деньги',
				give = function(player)
					exports.money:givePlayerMoney(player, 15000)
				end,
			},
		},

	},

	{

		name = 'Взрослый',
		progressPoints = 1,

		title = 'Получить любой титул',

		getState = function(self, player)

			local statuses = player:getData('statuses') or {}
			return getTableLength(statuses) > 0

		end,

		reward = {
			{
				text = 'Кейс Абу Бандит',
				icon = 'assets/images/packs/6.png',
				tooltip = 'деньги',
				give = function(player)
					givePlayerPack(player, 6, 1)
				end,
			},
		},

	},

	{

		name = 'Император',
		progressPoints = 1,

		title = 'Получить титулы Азартный,\nВербовщик, Филантроп',

		getState = function(self, player)

			local statuses = player:getData('statuses') or {}

			local flag = true

			local include = { crown_gold = true, packs = true, referal = true }

			for _, status in pairs( Config.status ) do

				if include[status.id] then

					if not statuses[status.id] then
						flag = false
						break
					end

				end

			end

			return flag

		end,

		reward = {
			{
				text = 'Mercedes Абу Бандит',
				-- icon = 'assets/images/packs/abu_bandit.png',
				icon = 'assets/images/packs/6.png',
				tooltip = 'деньги',
				give = function(player)
					exports.vehicles_main:giveAccountVehicle(player.account.name, 405,
						{ unique_mark = 'abu_bandit', appearance_upgrades = { tuning = {abu = 'abu_bandit'}, } })
				end,
			},
		},

	},

	{

		name = 'Шахтер',
		progressPoints = 100000,
		dataName = 'job.temp_stats.job_miner.raised_money',

		title = 'Заработать $100.000 шахтером\nсуммарно',

		reward = {
			{
				text = 'Кейс Новичок х2',
				icon = 'assets/images/packs/1.png',
				give = function(player)
					givePlayerPack(player, 1, 2)
				end,
			},
		},

	},

	{

		name = 'Почтальон',
		progressPoints = 100000,
		dataName = 'job.temp_stats.job_post.raised_money',

		title = 'Заработать $100.000 почтальоном\nсуммарно',

		reward = {
			{
				text = 'Кейс Новичок х2',
				icon = 'assets/images/packs/1.png',
				give = function(player)
					givePlayerPack(player, 1, 2)
				end,
			},
		},

	},

	{

		name = 'Газонокосильщик',
		progressPoints = 200000,
		dataName = 'job.temp_stats.job_green.raised_money',

		title = 'Заработать $200.000 газонокосильщиком\nсуммарно',

		reward = {
			{
				text = 'Кейс RAGE х1',
				icon = 'assets/images/packs/2.png',
				give = function(player)
					givePlayerPack(player, 2, 1)
				end,
			},
		},

	},

	{

		name = 'Водитель автобуса',
		progressPoints = 200000,
		dataName = 'job.temp_stats.job_bus.raised_money',

		title = 'Заработать $200.000 водителем\nавтобуса суммарно',

		reward = {
			{
				text = 'Кейс RAGE х2',
				icon = 'assets/images/packs/2.png',
				give = function(player)
					givePlayerPack(player, 2, 2)
				end,
			},
		},

	},

	rubbusher = {

		name = 'Уборщик отходов',
		progressPoints = 1500000,
		dataName = 'job.temp_stats.job_rubbisher.raised_money',

		title = 'Заработать $1.500.000\nмусоровозом суммарно',

		reward = {
			{
				text = 'Кейс Королевский х1',
				icon = 'assets/images/packs/4.png',
				give = function(player)
					givePlayerPack(player, 4, 1)
				end,
			},
		},

	},

	{

		name = 'Водитель такси',
		progressPoints = 300000,
		dataName = 'job.temp_stats.job_taxi.raised_money',

		title = 'Заработать $300.000 водителем\nтакси суммарно',

		reward = {
			{
				text = 'Кейс Джуди х1',
				icon = 'assets/images/packs/3.png',
				give = function(player)
					givePlayerPack(player, 3, 1)
				end,
			},
		},

	},

	{

		name = 'Лесоруб',
		progressPoints = 500000,
		dataName = 'job.temp_stats.job_lumberjack.raised_money',

		title = 'Заработать $500.000 лесорубом\nсуммарно',

		reward = {
			{
				text = 'Кейс Джуди х2',
				icon = 'assets/images/packs/3.png',
				give = function(player)
					givePlayerPack(player, 3, 2)
				end,
			},
		},

	},

	{

		name = 'Логист',
		progressPoints = 500000,
		dataName = 'job.temp_stats.job_logist.raised_money',

		title = 'Заработать $500.000 логистом\nсуммарно',

		reward = {
			{
				text = 'Кейс Королевский х1',
				icon = 'assets/images/packs/4.png',
				give = function(player)
					givePlayerPack(player, 4, 1)
				end,
			},
		},

	},

	{

		name = 'Б.У Продавец',
		progressPoints = 1,
		dataName = 'vehicles_used.sold',
		display = false,

		title = 'Продать автомобиль на\nБ.У. Рынок',

		reward = {
			{
				text = 'VIP 1 день',
				icon = 'assets/images/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400)
				end,
			},
		},

	},

	{

		name = 'Б.У Покупатель',
		progressPoints = 1,
		dataName = 'vehicles_used.bought',
		display = false,

		title = 'Купить автомобиль с\nБ.У. Рынка',

		reward = {
			{
				text = 'VIP 1 день',
				icon = 'assets/images/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400)
				end,
			},
		},

	},

	{

		name = 'VIP Персона',
		progressPoints = 1,
		dataName = 'vip_status.bought',

		title = 'Приобрести VIP-статус',

		reward = {
			{
				text = '$10.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 10000)
				end,
			},
		},

	},

	{

		name = 'Дрифт',
		progressPoints = 1000000000,
		dataName = 'sessionDrift',

		title = 'Набрать 1.000.000.000\nдрифт-очков суммарно',

		reward = {
			{
				text = 'Бесплатный VIP-номер',
				icon = 'assets/images/vip.png',
				give = function(player)
					exports.vehicles_numbers:addFreeNumber(player.account.name, 'h', 1)
				end,
			},
		},

	},

	{

		name = 'Полет',
		progressPoints = 1000,
		dataName = 'vehicle_fly',

		title = 'Пролететь на автомобиле\n1.000 секунд суммарно',

		reward = {
			{
				text = 'Скидочный промокод 50%',
				icon = 'assets/images/vip.png',
				give = function(player)
					addConvertPromo(player, nil, 50)
				end,
			},
		},

	},

	{

		name = 'Переезд',
		progressPoints = 5000,
		dataName = 'odometer',

		title = 'Проехать суммарно 5.000 км',

		reward = {
			{
				text = '+300 литров бензина',
				icon = 'assets/images/vip.png',
				give = function(player)
					if player.vehicle then
						increaseElementData(player.vehicle, 'fuel', 300)
					end
				end,
			},
		},

	},

	{

		name = 'Магнат',
		progressPoints = 1,
		dataName = 'derricks.bought',

		title = 'Приобрести нефтевышку',

		reward = {
			{
				text = 'Скин Мафиози',
				icon = 'assets/images/vip.png',
				give = function(player)
					exports.main_clothes:addWardrobeClothes(player.account.name, 19, true)
				end,
			},
		},

	},

	{

		name = 'Бизнесмен',
		progressPoints = 1,
		dataName = 'business.bought',

		title = 'Приобрести бизнес',

		reward = {
			{
				text = 'VIP 1 день',
				icon = 'assets/images/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400*1)
				end,
			},
			{
				text = '$10.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 10000)
				end,
			},
		},

	},

	{

		name = 'Домовладелец',
		progressPoints = 1,
		dataName = 'houses.bought',

		title = 'Приобрести дом',

		reward = {
			{
				text = 'VIP 1 день',
				icon = 'assets/images/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400*1)
				end,
			},
			{
				text = '$10.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 10000)
				end,
			},
		},

	},

	{

		name = 'Грузчик',
		progressPoints = 100000,
		dataName = 'job.temp_stats.job_cargo.raised_money',

		title = 'Заработать $100.000 грузчиком\nсуммарно',

		reward = {
			{
				text = 'Кейс Новичок х2',
				icon = 'assets/images/packs/1.png',
				give = function(player)
					givePlayerPack(player, 1, 2)
				end,
			},
		},

	},

	{

		name = 'Стаж 1',
		progressPoints = 1,
		dataName = 'levels.reached.30',

		title = 'Отыграть 30 часов',

		reward = {
			{
				text = 'VIP 3 дня',
				icon = 'assets/images/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400*3)
				end,
			},
		},

	},

	{

		name = 'Стаж 2',
		progressPoints = 1,
		dataName = 'levels.reached.50',

		title = 'Отыграть 50 часов',

		reward = {
			{
				text = 'Кейс RAGE',
				icon = 'assets/images/packs/2.png',
				give = function(player)
					givePlayerPack(player, 2, 1)
				end,
			},
		},

	},

	{

		name = 'Стаж 3',
		progressPoints = 1,
		dataName = 'levels.reached.100',

		title = 'Отыграть 100 часов',

		reward = {
			{
				text = 'Кейс Королевский х1',
				icon = 'assets/images/packs/4.png',
				give = function(player)
					givePlayerPack(player, 4, 1)
				end,
			},
		},

	},

	{

		name = 'Олд',
		progressPoints = 1,
		dataName = 'levels.reached.500',

		title = 'Отыграть 500 часов',

		reward = {
			{
				text = 'Кейс Абу Бандит х3',
				icon = 'assets/images/packs/6.png',
				give = function(player)
					givePlayerPack(player, 6, 3)
				end,
			},
		},

	},

	bandit = {

		name = 'Бандит',
		progressPoints = 1,

		title = 'Создать клан',

		getState = function(self, player)

			if player.team then


				local team_data = player.team:getData('team.data') or {}
				return team_data.creator == player.account.name

			end

		end,

		reward = {
			{
				text = '$30.000',
				icon = 'assets/images/bonuses/money.png',
				tooltip = 'деньги',
				give = function(player)
					exports.money:givePlayerMoney(player, 30000)
				end,
			},
			{
				text = 'VIP 3 дня',
				icon = 'assets/images/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400*3)
				end,
			},
		},

	},

	weapon_10 = {

		name = 'Оружейник',
		progressPoints = 10,

		title = 'Купить 10 ед. оружия\nв магазине',
		dataName = 'weapons.bought',

		reward = {
			{
				text = 'Аптечка x10',
				icon = ':main_inventory/assets/images/items/first_aid_kit.png',
				give = function(player)
					exports.main_inventory:addInventoryItem( {
						player = player,
						item = 'first_aid_kit',	
						count = 10,
					} )
				end,
			},
		},

	},

	bonus_10 = {

		name = 'Бонус',
		progressPoints = 10,

		title = 'Активировать 10 бонус-кодов',

		getState = function( self, player )
			return ( getTableLength( player:getData('bonus.used') or {} ) or 0 ) >= self.progressPoints
		end,

		getProgress = function( self, player )
			return getTableLength( player:getData('bonus.used') or {} ) or 0
		end,

		reward = {
			{
				text = 'Кейс Джуди',
				icon = 'assets/images/packs/3.png',
				tooltip = 'деньги',
				give = function(player)
					givePlayerPack(player, 3, 1)
				end,
			},
		},

	},

	clan_war = {

		name = 'Боец',
		progressPoints = 1,

		title = 'Принять участие в\nклановой битве',
		dataName = 'team.areas.wars',

		reward = {
			{
				text = '$30.000',
				icon = 'assets/images/bonuses/money.png',
				tooltip = 'деньги',
				give = function(player)
					exports.money:givePlayerMoney(player, 30000)
				end,
			},
			{
				text = 'АК-47',
				icon = ':main_inventory/assets/images/items/ak47.png',
				give = function(player)
					exports.main_inventory:addInventoryItem( {
						player = player,
						item = 'weapon_ak47',
						count = 1,
					} )
				end,
			},
		},

	},

	kill_10 = {

		name = 'Убийца 1',
		title = 'Убить 10 игроков\nв красной зоне',

		dataName = 'kills',
		progressPoints = 10,

		reward = {
			{
				text = '1 прокрут в колесе фортуны',
				icon = 'assets/images/status/casino.png',
				tooltip = 'деньги',
				give = function(player)
					increaseElementData( player, 'casino.default_tickets', 1 )
				end,
			},
		},

	},

	kill_50 = {

		name = 'Убийца 2',
		title = 'Убить 50 игроков\nв красной зоне',

		dataName = 'kills',
		progressPoints = 50,


		reward = {
			{
				text = '3 прокрута в колесе фортуны',
				icon = 'assets/images/status/casino.png',
				tooltip = 'деньги',
				give = function(player)
					increaseElementData( player, 'casino.default_tickets', 3 )
				end,
			},
		},

	},

	kill_100 = {

		name = 'Убийца 3',
		title = 'Убить 100 игроков\nв красной зоне',

		dataName = 'kills',
		progressPoints = 100,

		reward = {
			{
				text = '1 прокрут в колесе фортуны VIP',
				icon = 'assets/images/status/casino.png',
				tooltip = 'деньги',
				give = function(player)
					increaseElementData( player, 'casino.vip_tickets', 1 )
				end,
			},
		},

	},

	active_10 = {

		name = 'Марафонец',
		title = 'Посетить игру 10 дней подряд',
		progressPoints = 10,

		getState = function(self, player)
			return (player:getData('active_ach.series') or 0) >= self.progressPoints
		end,

		getProgress = function( self, player )
			return (player:getData('active_ach.series') or 0)
		end,

		reward = {
			{
				text = '$30.000',
				icon = 'assets/images/bonuses/money.png',
				tooltip = 'деньги',
				give = function(player)
					exports.money:givePlayerMoney(player, 30000)
				end,
			},
			{
				text = 'VIP 1 день',
				icon = 'assets/images/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400)
				end,
			},
		},

	},

	active_30 = {

		name = 'Марафонец 2',
		title = 'Посетить игру 30 дней подряд',
		progressPoints = 30,

		getState = function(self, player)
			return (player:getData('active_ach.series') or 0) >= self.progressPoints
		end,

		getProgress = function( self, player )
			return (player:getData('active_ach.series') or 0)
		end,

		reward = {
			{
				text = '$50.000',
				icon = 'assets/images/bonuses/money.png',
				tooltip = 'деньги',
				give = function(player)
					exports.money:givePlayerMoney(player, 50000)
				end,
			},
			{
				text = 'VIP 7 дней',
				icon = 'assets/images/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400*7)
				end,
			},
		},

	},

	active_90 = {

		name = 'Марафонец 3',
		title = 'Посетить игру 90 дней подряд',
		progressPoints = 90,

		getState = function(self, player)
			return (player:getData('active_ach.series') or 0) >= self.progressPoints
		end,

		getProgress = function( self, player )
			return (player:getData('active_ach.series') or 0)
		end,

		reward = {
			{
				text = 'Кейс EXCLUSIVE',
				icon = 'assets/images/packs/9.png',
				tooltip = 'деньги',
				give = function(player)
					givePlayerPack(player, 8, 1)
				end,
			},
		},

	},

	hours_1 = {

		name = 'Активный игрок',
		title = 'Отыграть непрерывно 1 час',
		progressPoints = 1,

		getState = function(self, player)
			return (player:getData('hour_ach.series') or 0) >= self.progressPoints
		end,

		getProgress = function( self, player )
			return (player:getData('hour_ach.series') or 0)
		end,

		reward = {
			{
				text = '$10.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 10000)
				end,
			},
		},

	},

	hours_10 = {

		name = 'Активный игрок 2',
		title = 'Отыграть непрерывно 10 часов',
		progressPoints = 10,

		getState = function(self, player)
			return (player:getData('hour_ach.series') or 0) >= self.progressPoints
		end,

		getProgress = function( self, player )
			return (player:getData('hour_ach.series') or 0)
		end,

		reward = {
			{
				text = '$20.000',
				icon = 'assets/images/bonuses/money.png',
				tooltip = 'деньги',
				give = function(player)
					exports.money:givePlayerMoney(player, 20000)
				end,
			},
			{
				text = 'VIP 1 день',
				icon = 'assets/images/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 86400)
				end,
			},
		},

	},

	hours_15 = {

		name = 'Активный игрок 3',
		title = 'Отыграть непрерывно 15 часов',
		progressPoints = 15,

		getState = function(self, player)
			return (player:getData('hour_ach.series') or 0) >= self.progressPoints
		end,

		getProgress = function( self, player )
			return (player:getData('hour_ach.series') or 0)
		end,

		reward = {
			{
				text = '1 прокрут',
				icon = 'assets/images/status/casino.png',
				tooltip = 'деньги',
				give = function(player)
					increaseElementData( player, 'casino.default_tickets', 1 )
				end,
			},
			{
				text = '20 RC',
				icon = 'assets/images/donate.png',
				give = function(player)
					increaseElementData(player, 'bank.donate', 20)
				end,
			},
		},

	},

	inkos_1kk = {

		name = 'Инкассатор',
		title = 'Заработать $1.000.000 суммарно\nна работе инкассатора',
		progressPoints = 1000000,

		dataName = 'job.temp_stats.job_incassator.raised_money',

		reward = {
			{
				text = 'Кейс Мажор',
				icon = 'assets/images/packs/5.png',
				give = function(player)
					givePlayerPack(player, 5, 1)
				end,
			},
		},

	},

	inkos_10lvl = {

		name = 'Карьера инкассатора',
		title = 'Достигнуть 10 уровня\nна работе инкассатора',
		progressPoints = 10,

		getState = function(self, player)

			local level = exports.job_incassator:getPlayerLevel( player )
			return level >= self.progressPoints

		end,

		getProgress = function( self, player )
			return exports.job_incassator:getPlayerLevel( player )
		end,

		reward = {
			{
				text = 'Кейс Королевский',
				icon = 'assets/images/packs/4.png',
				give = function(player)
					givePlayerPack(player, 4, 1)
				end,
			},
		},

	},


	market_sold = {

		name = 'Продавец',
		progressPoints = 1,
		dataName = 'vehicles_market.sold',

		title = 'Продать автомобиль на\nавторынок',

		reward = {

			{
				text = 'Билет свободы x5',
				icon = 'assets/images/packs/items/ticket.png',
				give = function(player)
					increaseElementData(player, 'prison.tickets', 5)
				end,
			},
			{
				text = '$10.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney( player, 10000 )
				end,
			},
		},

	},

	market_bought = {

		name = 'Покупатель',
		progressPoints = 1,
		dataName = 'vehicles_market.bought',

		title = 'Купить автомобиль с\nавторынка',

		reward = {
			{
				text = 'VIP 3 часа',
				icon = 'assets/images/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 3600*3)
				end,
			},
		},

	},

	market_destroy = {

		name = 'Разборка',
		progressPoints = 1,
		dataName = 'vehicles_market.destroyed',

		title = 'Отправить автомобиль\nна разборку',

		reward = {
			{
				text = 'VIP 1 час',
				icon = 'assets/images/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 3600*1)
				end,
			},
		},

	},

	kill_ak47 = {

		name = 'Убийца АК-47',
		progressPoints = 300,

		dataName = 'kills.30',

		title = 'Убить 300 игроков с АК-47',

		reward = {
			{
				text = 'Кейс Джуди',
				icon = 'assets/images/packs/3.png',
				give = function(player)
					givePlayerPack( player, 3, 1 )
				end,
			},
			{
				text = 'VIP 3 часа',
				icon = 'assets/images/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 3600*3)
				end,
			},
		},

	},

	kill_scar = {

		name = 'Убийца SCAR',
		progressPoints = 300,

		dataName = 'kills.31',

		title = 'Убить 300 игроков с FN SCAR',

		reward = {
			{
				text = 'Кейс Джуди',
				icon = 'assets/images/packs/3.png',
				give = function(player)
					givePlayerPack( player, 3, 1 )
				end,
			},
			{
				text = 'Аптечка x20',
				icon = ':main_inventory/assets/images/items/first_aid_kit.png',
				give = function(player)
					exports.main_inventory:addInventoryItem( {
						player = player,
						item = 'first_aid_kit',	
						count = 20,
					} )
				end,
			},
		},

	},

	kill_mk14 = {

		name = 'Убийца MK14',
		progressPoints = 300,

		dataName = 'kills.34',

		title = 'Убить 300 игроков\nс MK 14 EBR',

		reward = {
			{
				text = 'Кейс Джуди',
				icon = 'assets/images/packs/3.png',
				give = function(player)
					givePlayerPack( player, 3, 1 )
				end,
			},
			{
				text = 'Аптечка x30',
				icon = ':main_inventory/assets/images/items/first_aid_kit.png',
				give = function(player)
					exports.main_inventory:addInventoryItem( {
						player = player,
						item = 'first_aid_kit',	
						count = 30,
					} )
				end,
			},
		},

	},

	kill_uzi = {

		name = 'Убийца UZI',
		progressPoints = 200,

		dataName = 'kills.28',

		title = 'Убить 200 игроков с UZI',

		reward = {
			{
				text = 'VIP 1 день',
				icon = 'assets/images/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 1*86400)
				end,
			},
			{
				text = '$40.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 40000)
				end,
			},
		},

	},

	kill_mp5 = {

		name = 'Убийца MP5',
		progressPoints = 200,

		dataName = 'kills.29',

		title = 'Убить 200 игроков с MP5',

		reward = {
			{
				text = 'VIP 1 день',
				icon = 'assets/images/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 1*86400)
				end,
			},
			{
				text = '$40.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 40000)
				end,
			},
		},

	},

	kill_kriss = {

		name = 'Убийца KRISS',
		progressPoints = 200,

		dataName = 'kills.32',

		title = 'Убить 200 игроков\nс KRISS VECTOR',

		reward = {
			{
				text = 'VIP 1 день',
				icon = 'assets/images/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 1*86400)
				end,
			},
			{
				text = '$40.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 40000)
				end,
			},
		},

	},

	kill_magnum = {

		name = 'Убийца MAGNUM',
		progressPoints = 100,

		dataName = 'kills.24',

		title = 'Убить 100 игроков\nс MAGNUM',

		reward = {
			{
				text = 'VIP 1 день',
				icon = 'assets/images/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 1*86400)
				end,
			},
			{
				text = '$30.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 30000)
				end,
			},
		},

	},

	kill_m1911 = {

		name = 'Убийца M1911',
		progressPoints = 100,

		dataName = 'kills.22',

		title = 'Убить 100 игроков\nс M1911',

		reward = {
			{
				text = 'VIP 1 день',
				icon = 'assets/images/vip.png',
				give = function(player)
					exports.main_vip:giveVip(player.account.name, 1*86400)
				end,
			},
			{
				text = '$30.000',
				icon = 'assets/images/bonuses/money.png',
				give = function(player)
					exports.money:givePlayerMoney(player, 30000)
				end,
			},
		},

	},

}

for _, status in pairs( Config.status ) do

	if status.achievment then

		status.achievment.status = status
		status.achievment.display = false
		status.achievment.type = 'status'

		if status.achievment.key then
			Config.achievments[status.achievment.key] = status.achievment
		else
			table.insert( Config.achievments, status.achievment )
		end
		
	end

end

table.insert( Config.achievments, {

	name = 'Безопасность',
	progressPoints = 1,
	dataName = 'password.changes',

	title = 'Сменить пароль\nНа более надежный',

	reward = {
		{
			text = '10 RC',
			icon = 'assets/images/donate.png',
			give = function(player)
				increaseElementData(player, 'bank.donate', 10)
			end,
		},
	},

})

for index, ach in pairs( Config.achievments ) do
	ach.index = index
end

Config.hideAch = {15,16}