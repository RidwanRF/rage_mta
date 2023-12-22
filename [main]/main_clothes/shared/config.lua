Config = {}

Config.shops = {
	{ 461.57, -1500.8, 30.95, exit = { 460.03, -1506.85, 31 }, blip = true },
	{ 1656.8, 1733.38, 10.73, exit = { 1655.49, 1726.86, 10.82 }, blip = true  },
	{ -1882.62, 866.22, 35.17, exit = { -1886.15, 863, 35.17 }, blip = true },
}

Config.extendWardrobeCost = 20

Config.rarity = {

	rare = {

		name = 'Редкий',
		color = {50,120,230},
		text_color = {255,255,255},

	},

	premium = {

		name = 'Премиальный',
		color = {255,220,100},
		text_color = {140,120,30},

	},

}

Config.clothes = {
	{
		model = 84,
		cost = 50000,
		noSell = true,
		name = 'Новогодний Эльф',
		
		rarity = false,
	},
	{
		model = 85,
		cost = 50000,
		noSell = true,
		name = 'Снегурочка',
		
		rarity = false,
	},
	{
		model = 87,
		cost = 50000,
		noSell = true,
		name = 'Санта-Клаус',
		
		rarity = false,
	},
	{
		model = 1,
		cost = 50000,
		noSell = true,
		name = 'RICH BICH',
		
		rarity = false,
	},
	{
		model = 2,
		cost = 65000,
		name = 'BALLAS GTA5',
		
		rarity = false,
	},
	{

		model = 98,
		cost = 300,
		name = 'Премиум',
		donate = true,
		rarity = false,
		rarity = 'rare',

	},
	{

		model = 97,
		cost = 300,
		name = 'MORGENSHTERN',
		donate = true,
		rarity = 'rare',

	},
	{

		model = 100,
		cost = 300,
		name = 'Клоун',
		donate = true,
		rarity = 'rare',

	},
	{
		model = 7,
		cost = 80000,
		name = 'Тайный агент',

		rarity = false,
	},
	{
		model = 9,
		cost = 45000,
		name = 'Офисная мышь',
		
		rarity = false,
	},
	{
		model = 10,
		cost = 100000,
		name = 'Уважаемый',
		
		rarity = false,
	},
	{
		model = 11,
		cost = 75000,
		name = 'Клайтон',
		
		rarity = false,
	},
	{
		model = 12,
		cost = 90000,
		name = 'Драг диллер',
		
		rarity = false,
	},
	{
		model = 13,
		cost = 120000,
		name = 'Dybala',
		
		rarity = false,
	},
	{
		model = 14,
		cost = 200000,
		name = 'Bigness',
		
		rarity = false,
	},
	{
		model = 15,
		cost = 250000,
		name = 'Реджи',

		rarity = false,
	},
	{
		model = 16,
		cost = 140000,
		name = 'Блатной',
		
		rarity = false,
	},
	{
		model = 17,
		cost = 300000,
		name = 'Босс мафии',
		
		rarity = false,
	},
	{
		model = 18,
		cost = 110000,
		name = 'Levis',
		
		rarity = false,
	},
	{
		model = 19,
		cost = 300000,
		name = 'Мафиози',
		
		rarity = false,
	},
	{
		model = 20,
		cost = 130000,
		name = 'Нигга',
		
		rarity = false,
	},
	{
		model = 21,
		cost = 280000,
		name = 'Мануель Ланзини',
		
		rarity = false,
	},
	{
		model = 22,
		cost = 60000,
		name = 'Мясник',
		
		rarity = false,
	},
	{
		model = 23,
		cost = 320000,
		name = 'Молодой бизнесмен',
		
		rarity = false,
	},
	{
		model = 24,
		cost = 180000,
		name = 'Phillipe Coutinho',
		
		rarity = false,
	},
	{
		model = 25,
		cost = 550,
		name = 'Sead Kolasinac',
		
		sellCost = 175000,
		
		rarity = 'rare',
		donate = true
	},
	{
		model = 50,
		cost = 99,
		name = 'Петух',
		
		rarity = 'rare',
		donate = true
	},
	{
		model = 26,
		cost = 130000,
		name = 'Тату мастер',
		
		rarity = false,
	},
	{
		model = 36,
		cost = 70000,
		name = 'Тенисистка',
		
		rarity = false,
	},
	{
		model = 28,
		cost = 80000,
		name = 'Тревор',
		
		rarity = false,
	},
	{
		model = 29,
		cost = 95000,
		name = 'Пьяный санта',
		
		rarity = false,
	},
	-- {
	-- 	model = 30,
	-- 	cost = 50000,
	-- 	name = 'Заключенный',
		
	-- 	rarity = false,
	-- },
	{
		model = 31,
		cost = 149,
		name = 'Нефтяной магнат',
		
		rarity = 'rare',
		donate = true
	},
	{
		model = 79,
		cost = 300,
		name = 'Араб',
		
		rarity = 'rare',
		donate = true
	},
	{
		model = 55,
		cost = 150000,
		name = 'Модник',
		
		rarity = false,
	},
	{
		model = 56,
		cost = 75000,
		name = 'Big Tits',
		
		rarity = false,
	},
	{
		model = 57,
		cost = 85000,
		name = 'Тянка',
		
		rarity = false,
	},

}

Config.clothesAssoc = {}

for index, clothes in pairs( Config.clothes ) do
	Config.clothesAssoc[clothes.model] = clothes
end

Config.defaultLotsCount = 2

Config.case_custom = {

	{

		name = 'Азимов',
		cost = 30,
		valute = 'bank.donate',

	},
	
	{

		name = 'Аниме',
		cost = 40000,
		valute = 'money',

	},
	
	{

		name = 'F90',
		cost = 40000,
		valute = 'money',

	},
	
	{

		name = 'FENDI',
		cost = 50000,
		valute = 'money',

	},
	
	{

		name = 'GUCCI',
		cost = 50000,
		valute = 'money',

	},
	
	{

		name = 'Джуди',
		cost = 45000,
		valute = 'money',

	},

	{

		name = 'LV',
		cost = 50000,
		valute = 'money',

	},

	{

		name = 'Весенний',
		cost = 40000,
		valute = 'money',

	},

	{

		name = 'RAGE',
		cost = 40000,
		valute = 'money',

	},

	{

		name = 'ROCKET',
		cost = 40000,
		valute = 'money',

	},

	{

		name = 'ROLEX',
		cost = 30,
		valute = 'bank.donate',

	},

	{

		name = 'YouTube',
		cost = 30000,
		valute = 'money',

	},

}

for index, case in pairs( Config.case_custom ) do
	case.index = index
	case.donate = case.value == 'bank.donate'
end