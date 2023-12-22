Config = {}


Config.creationCost = 1000
Config.changeNameCost = 300
Config.changeColorCost = 30
Config.changeIconCost = 50

Config.prepareWarTime = 5*60
Config.maxWarMembers = 10

Config.extendSlots = {
	amount = 10,
	cost = 50,
}

Config.mansionSell = 0.5

Config.mansionInterior = {
	
	enter = { 140.21, 1366.75, 1083.86 },
	interior = 5,

	inventory = { 148.97, 1373.09, 1083.86 },

}

Config.areasData = {
	
	{
		income = 17000,
		rating = 100,
	},
	{
		income = 23000,
		rating = 200,
	},
	{
		income = 33000,
		rating = 300,
	},

}

Config.rank_rights = {
	
	{
		name = 'Зарплата',
		right = 'salary',
	},
	{
		name = 'Брать оружие из общака',
		right = 'inventory_weapon',
	},
	{
		name = 'Брать патроны из общака',
		right = 'inventory_ammo',
	},
	{
		name = 'Брать деньги из общака',
		right = 'take_balance',
	},
	{
		name = 'Захватывать территории',
		right = 'area_capture',
	},
	{
		name = 'Брать деньги с территорий (в общак)',
		right = 'area_take_money',
	},
	{
		name = 'Участвовать в боях за территории',
		right = 'area_war',
	},
	{
		name = 'Объявлять бои',
		right = 'area_create_war',
	},
	{
		name = 'Исключать игроков из боя',
		right = 'area_war_kick',
	},
	{
		name = 'Приглашать игроков',
		right = 'invite',
	},
	{
		name = 'Исключать игроков',
		right = 'kick',
	},
	{
		name = 'Менять ранги участников',
		right = 'edit_rank',
	},
	{
		name = 'Участника нельзя исключить',
		right = 'no_kick',
	},

}
Config.clan_rules = {
	
	{

		name = 'Общие правила',
		content = {
			'1. Запрещен слив склада. Наказание: Обнуление игрока',
			'2. Передать управление бандой не возможно, можно только расформировать.',
			'3. Запрещено мешать игровому процессу, находясь в клане.',
			'Наказание: Штраф $100.000',
		},

	},

	{

		name = 'Лидеру/заместителю:',
		content = {

			'1. Запрещено вымогать деньги или делать сборы.',
			'Наказание: Штраф $1.000.000',
			'',
			'2. Запрещено выгонять без весомых причин игроков,',
			'с которых была взята плата за вход в клан.',
			'Наказание: Штраф $100.000',

		},

	},

}

function getConfigSetting(name)
	return Config[name]
end