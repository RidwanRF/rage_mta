
Config.status = {
	
	{

		id = 'zbt',
		name = 'Ветеран ЗБТ',
		title = 'За активное участие в\nзакрытом бета-тестировании',
		bonus = 'Бонус отсутствует',

	},
	
	{

		id = 'obt',
		name = 'Ветеран ОБТ',
		title = 'За активное участие в\nоткрытом бета-тестировании',
		bonus = 'Бонус отсутствует',

	},
	
	{

		id = 'referal',
		name = 'Вербовщик',
		title = 'За приглашение\n30 и более игроков',
		bonus = 'VIP 3ч. ежедневно',

		achievment = {

			progressPoints = 30,
			dataName = 'referal.players.invited',

		},

		give = function(player)
			exports.main_vip:giveVip(player.account.name, 3600*3)
		end,

	},
	
	{

		id = 'ruby',
		name = 'Инвестор',
		title = 'Пополнить игровой баланс\nна 1000+ рублей',
		bonus = 'Vip 1ч, прокрут колеса ежедневно',

		achievment = {

			progressPoints = 1000,
			getState = function(self, player)

				local donations = player:getData('donations') or {}
				local sum = 0

				for _, donation in pairs( donations ) do
					sum = sum + (donation.sum or 0)
				end

				if sum >= self.progressPoints then
					return true
				end

				return false

			end,

		},

		give = function(player)
			increaseElementData(self, 'casino.vip_tickets', 1)
			exports.main_vip:giveVip(player.account.name, 3600*1)
		end,

	},
	
	{

		id = 'crown',
		name = 'Благотворитель',
		title = 'Пополнить игровой баланс\nна 5000+ рублей',
		bonus = 'Vip 3ч., 2 прокрута колеса ежедневно',

		achievment = {

			progressPoints = 5000,
			getState = function(self, player)

				local donations = player:getData('donations') or {}
				local sum = 0

				for _, donation in pairs( donations ) do
					sum = sum + (donation.sum or 0)
				end

				if sum >= self.progressPoints then
					return true
				end

				return false

			end,

		},

		give = function(player)
			exports.main_vip:giveVip(player.account.name, 3600*3)
			increaseElementData(player, 'casino.vip_tickets', 2)
		end,

	},
	
	{

		id = 'crown_gold',
		name = 'Филантроп',
		title = 'Пополнить игровой баланс\nна 10000+ рублей',
		bonus = 'Vip 6ч, 3 прокрута колеса ежедневно',

		achievment = {

			progressPoints = 10000,
			getState = function(self, player)

				local donations = player:getData('donations') or {}
				local sum = 0

				for _, donation in pairs( donations ) do
					sum = sum + (donation.sum or 0)
				end

				if sum >= self.progressPoints then
					return true
				end

				return false

			end,

		},

		give = function(player)
			exports.main_vip:giveVip(player.account.name, 3600*6)
			increaseElementData(player, 'casino.vip_tickets', 3)
		end,

	},
	
	{

		id = 'packs',
		name = 'Азартный',
		title = 'Открыть 50+ кейсов\nсуммарно',
		bonus = 'Бонус отсутствует',

		achievment = {

			dataName = 'packs.opened',
			progressPoints = 50,

		},

	},
	
	{

		id = 'tester',
		name = 'Тестер',
		title = 'Выдается игрокам, активно\nучаствующим в тестировании',
		bonus = 'Бонус отсутствует',
		default_visible = false,
		
	},
	
	{

		id = 'youtube',
		name = 'Youtube',
		title = 'Выдается игрокам, снимающим\nролики по RAGE на Youtube',
		bonus = 'Бонус отсутствует',
		default_visible = false,

	},
	
	{

		id = 'firehand',
		name = 'Огненная Рука',
		title = 'За топ-10 в гонке RCoin\n(выдается в конце сезона)',
		bonus = 'Бонус отсутствует',

	},
	
	{

		id = 'razrab',
		name = 'Разработчик',
		title = 'За участие в разработке\nпроекта RAGE',
		bonus = 'Ежемесячная З/П $500.000',
		default_visible = false,

	},
	
	{

		id = 'moderator',
		name = 'Модератор',
		title = 'Выдается модераторам\nсервера',
		bonus = '',
		default_visible = false,

	},
	
	{

		id = 'admin',
		name = 'Администратор',
		title = 'Выдается администраторам\nсервера',
		bonus = '',
		default_visible = false,

	},
	
	{

		id = 'tiktok',
		name = 'Тиктокер',
		title = 'Для тиктокеров проекта',
		bonus = 'Бонус отсутствует',
		default_visible = false,

	},
	
	{

		id = 'diamond1',
		name = 'Олигарх',
		title = 'Пополнить игровой баланс\nна 20000+ рублей',
		bonus = 'Кейс Новичок ежедневно',

		achievment = {

			progressPoints = 20000,
			getState = function(self, player)

				local donations = player:getData('donations') or {}
				local sum = 0

				for _, donation in pairs( donations ) do
					sum = sum + (donation.sum or 0)
				end

				if sum >= self.progressPoints then
					return true
				end

				return false

			end,

		},

		give = function(player)
			givePlayerPack(player, 1, 1)
		end,

	},
	
	{

		id = 'diamond2',
		name = 'Магнат',
		title = 'Пополнить игровой баланс\nна 30000+ рублей',
		bonus = 'Кейс Новичок х2 ежедневно',

		achievment = {

			progressPoints = 30000,
			getState = function(self, player)

				local donations = player:getData('donations') or {}
				local sum = 0

				for _, donation in pairs( donations ) do
					sum = sum + (donation.sum or 0)
				end

				if sum >= self.progressPoints then
					return true
				end

				return false

			end,

		},

		give = function(player)
			givePlayerPack(player, 1, 2)
		end,

	},
	
	{

		id = 'diamond3',
		name = 'Президент',
		title = 'Пополнить игровой баланс\nна 50000+ рублей',
		bonus = 'Кейс Новичок х3 ежедневно',

		achievment = {

			progressPoints = 50000,
			getState = function(self, player)

				local donations = player:getData('donations') or {}
				local sum = 0

				for _, donation in pairs( donations ) do
					sum = sum + (donation.sum or 0)
				end

				if sum >= self.progressPoints then
					return true
				end

				return false

			end,

		},

		give = function(player)
			givePlayerPack(player, 1, 3)
		end,

	},

	{

		id = 'money_1',
		name = 'Транжира',
		title = 'Потратить 100.000.000\nигровой валюты',
		bonus = 'Бонус отсутствует',

		achievment = {

			progressPoints = 100000000,
			getState = function(self, player)
				return (player:getData('money.spent') or 0) >= self.progressPoints
			end,

		},

	},

	{

		id = 'clan_war',
		name = 'Клановый боец',
		title = 'Отыграть 100\nклановых боев',
		bonus = 'Бонус отсутствует',

		achievment = {

			progressPoints = 100,
			getState = function(self, player)
				return (player:getData('team.areas.wars') or 0) >= self.progressPoints
			end,

		},

	},

	{

		id = 'knife_killer',
		name = 'Головорез',
		title = 'Убить 300 противников\nножом',
		bonus = 'Бонус отсутствует',

		achievment = {

			progressPoints = 300,
			getState = function(self, player)
				return (player:getData('knife_kills') or 0) >= self.progressPoints
			end,

		},

	},

	{

		id = 'killer',
		name = 'Серийный убийца',
		title = 'Убить 2000 противников\nоружием',
		bonus = 'Бонус отсутствует',

		achievment = {

			progressPoints = 2000,
			getState = function(self, player)
				return (player:getData('kills') or 0) >= self.progressPoints
			end,

		},

	},

	{

		id = 'clan_win_1',
		name = 'Гонка кланов',
		title = 'Занять первое место\nв гонке кланов',
		bonus = 'Бонус отсутствует',

	},

	{

		id = 'clan_win_2',
		name = 'Гонка кланов',
		title = 'Занять второе место\nв гонке кланов',
		bonus = 'Бонус отсутствует',

	},

	{

		id = 'clan_win_3',
		name = 'Гонка кланов',
		title = 'Занять третье место\nв гонке кланов',
		bonus = 'Бонус отсутствует',

	},

	{

		id = 'vk',
		name = 'VK',
		title = 'Для VK-шников проекта',
		bonus = 'Бонус отсутствует',
		default_visible = false,
	},

	{

		id = 'screenshoot',
		name = 'Скриншотер',
		title = 'Для скриншотеров проекта',
		bonus = 'Бонус отсутствует',
		default_visible = false,
	},


	{

		id = 'cyber1',
		name = 'Кибер-боец',
		title = 'За прохождение\nпропуска CyberQuest',
		bonus = 'Бонус отсутствует',
	},

	{

		id = 'cyber2',
		name = 'Кибер-рейнджер',
		title = 'За прохождение\nVIP-пропуска CyberQuest',
		bonus = 'Бонус отсутствует',
	},

	{

		id = 'casino',
		name = 'Казино',
		title = 'Сделать ставок на сумму\nболее 100.000 фишек',
		bonus = '1 прокрут колеса фортуны ежедневно',

		achievment = {

			progressPoints = 100000,
			getState = function(self, player)
				return (player:getData('casino.spent_chips') or 0) >= self.progressPoints
			end,

			key = 'status_casino',

		},

		give = function(player)
			increaseElementData( player, 'casino.default_tickets', 1 )
		end,

	},

	{

		id = 'status_70k',
		name = 'Босс',
		title = 'Пополнить игровой баланс\nна 70000+ рублей',
		bonus = 'Кейс RAGE ежедневно',

		achievment = {

			progressPoints = 70000,
			getState = function(self, player)

				local donations = player:getData('donations') or {}
				local sum = 0

				for _, donation in pairs( donations ) do
					sum = sum + (donation.sum or 0)
				end

				if sum >= self.progressPoints then
					return true
				end

				return false

			end,

			key = 'status_70k',

		},

		give = function(player)
			givePlayerPack(player, 2, 1)
		end,

	},

	{

		id = 'status_100k',
		name = 'Хозяин',
		title = 'Пополнить игровой баланс\nна 100000+ рублей',
		bonus = 'Кейс Джуди ежедневно',

		achievment = {

			progressPoints = 100000,
			getState = function(self, player)

				local donations = player:getData('donations') or {}
				local sum = 0

				for _, donation in pairs( donations ) do
					sum = sum + (donation.sum or 0)
				end

				if sum >= self.progressPoints then
					return true
				end

				return false

			end,

			key = 'status_100k',

		},

		give = function(player)
			givePlayerPack(player, 3, 1)
		end,

	},

	{

		id = 'status_150k',
		name = 'Глава мирового банка',
		title = 'Пополнить игровой баланс\nна 150000+ рублей',
		bonus = 'Кейс RAGE + Джуди ежедневно',

		achievment = {

			progressPoints = 150000,
			getState = function(self, player)

				local donations = player:getData('donations') or {}
				local sum = 0

				for _, donation in pairs( donations ) do
					sum = sum + (donation.sum or 0)
				end

				if sum >= self.progressPoints then
					return true
				end

				return false

			end,

			key = 'status_150k',

		},

		give = function(player)
			givePlayerPack(player, 2, 1)
			givePlayerPack(player, 3, 1)
		end,

	},

	{

		id = 'status_old',
		name = 'Олд',
		title = 'Отыграть 1000 часов',
		bonus = 'Бонус отсутствует',

		achievment = {

			progressPoints = 1000,
			getState = function(self, player)

				local sum = player:getData('level') or 0

				if sum >= self.progressPoints then
					return true
				end

				return false

			end,

			key = 'status_old',

		},

		give = function(player)
		end,

	},

	{

		id = 'status_job',
		name = 'Мультимиллинонер',
		title = 'Заработать $50.000.000\nна работах суммарно',
		bonus = 'Бонус отсутствует',

		achievment = {

			progressPoints = 50000000,
			getState = function(self, player)

				local sum = 0

				local stats = player:getData('jobs.stats') or {}

				for job, data in pairs( stats ) do
					sum = sum + ( data.raised_money or 0 )
				end

				if sum >= self.progressPoints then
					return true
				end

				return false

			end,

			key = 'status_job',

		},

		give = function(player)
		end,

	},

	{

		id = 'status_car',
		name = 'Автолюбитель',
		title = 'Купить за все время 60\nразных автомобилей\nв автосалоне или на аукционе',
		bonus = 'Бонус отсутствует',

		achievment = {

			progressPoints = 60,
			getState = function(self, player)

				local total = getPlayerTotalCarsBought( player.account.name ) or 0

				if total >= self.progressPoints then
					return true
				end

				return false

			end,

			key = 'status_car',

		},

		give = function(player)
		end,

	},

}

Config.statusAssoc = {}

function getPlayerStatus(player)

	local status = player:getData('status.current')
	local statuses = player:getData('statuses') or {}

	return statuses[status]

end

for index, status in pairs( Config.status ) do
	status.index = index

	Config.statusAssoc[status.id] = status

end
