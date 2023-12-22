

Config = {}

Config.key = 'i'

Config.items = {
	

	job_miner_pickaxe = {

		name = 'Кирка',
		type = 'tool',

		max_stack = 1,

		health = 30,

		model = 1855,
		objScale = 1,
		offsets = {0, 0, 0, 0, -90, 0},

		icon = 'assets/images/items/first_aid_kit.png',
		-- icon = 'assets/images/items/item_pickaxe.png',
	},

	job_lumberjack_axe = {

		name = 'Топор',
		type = 'tool',

		max_stack = 1,

		health = 30,

		model = 338,
		objScale = 1.5,
		offsets = {0, -0.05, -0.06, 0, -90, 0},

		icon = 'assets/images/items/first_aid_kit.png',
		-- icon = 'assets/images/items/item_pickaxe.png',
	},

	first_aid_kit = {

		name = 'Аптечка',
		icon = 'assets/images/items/first_aid_kit.png',
		max_stack = 10,

		title = {
			'Восполняет здоровье',
		},

		type = 'medicine',

		use = function(config, player)
			player.health = 100
			exports.hud_notify:notify(player, 'Аптечка', 'Вы пополнили здоровье')
			return 1
		end,

	},

	weapon_ak47 = {

		name = 'АК-47',
		icon = 'assets/images/items/ak47.png',
		max_stack = 1,

		max_ammo = 180,
		ammo = 30,

		title = '',

		type = 'weapon',

		model = 30,
		health = 600,

		ammo_access = 'ammo_1',

	},

	weapon_m4 = {

		name = 'FN SCAR',
		icon = 'assets/images/items/scar.png',
		max_stack = 1,

		max_ammo = 120,
		ammo = 20,

		properties = {
			damage = 40,
			maximum_clip_ammo = 20,
		},

		title = '',

		type = 'weapon',

		model = 31,
		health = 600,

		ammo_access = 'ammo_2',

	},

	weapon_uzi = {

		name = 'UZI',
		icon = 'assets/images/items/uzi.png',
		max_stack = 1,

		max_ammo = 180,
		ammo = 30,

		title = '',

		type = 'weapon',

		model = 28,
		health = 900,

		ammo_access = 'ammo_3',

	},

	weapon_deagle = {

		name = 'Colt Magnum',
		icon = 'assets/images/items/deagle.png',
		max_stack = 1,

		max_ammo = 50,
		ammo = 6,

		properties = {
			maximum_clip_ammo = 6,
		},

		title = '',

		type = 'weapon',

		model = 24,
		health = 120,

		ammo_access = 'ammo_4',

	},

	weapon_mp5 = {

		name = 'H&K MP5',
		icon = 'assets/images/items/mp5.png',
		max_stack = 1,

		max_ammo = 180,
		ammo = 30,

		title = '',

		type = 'weapon',

		model = 29,
		health = 900,

		ammo_access = 'ammo_3',

	},

	weapon_colt = {

		name = 'M1911',
		icon = 'assets/images/items/colt.png',
		max_stack = 1,

		max_ammo = 50,
		ammo = 12,

		title = '',

		-- properties = {
		-- 	maximum_clip_ammo = 12,
		-- },

		type = 'weapon',

		model = 22,
		health = 90,

		ammo_access = 'ammo_5',

	},

	weapon_krissv = {

		name = 'KRISS Vector',
		icon = 'assets/images/items/krissv.png',
		max_stack = 1,

		max_ammo = 180,
		ammo = 30,

		title = '',

		properties = {
			maximum_clip_ammo = 30,
		},

		type = 'weapon',

		model = 32,
		health = 900,

		ammo_access = 'ammo_3',

	},

	weapon_mk14 = {

		name = 'Mk14 EBR',
		icon = 'assets/images/items/mk14ebr.png',
		max_stack = 1,

		max_ammo = 60,
		ammo = 30,

		title = '',

		properties = {
			damage = 80,
			maximum_clip_ammo = 30,
		},

		type = 'weapon',

		model = 33,
		health = 300,

		ammo_access = 'ammo_6',

	},

	weapon_awp = {

		name = 'AWP',
		icon = 'assets/images/items/awp.png',
		max_stack = 1,

		max_ammo = 60,
		ammo = 30,

		title = '',

		properties = {
			damage = 150,
			maximum_clip_ammo = 30,
		},

		type = 'weapon',

		model = 34,
		health = 300,

		ammo_access = 'ammo_6',

	},

	case_1 = {

		name = 'Кейс',
		icon = 'assets/images/items/case.png',
		max_stack = 1,

		model = 1210,
		objScale = 1,
		offsets = {0, 0.07, 0.25, 0, -180, 0},

		title = {
			'Выдается, когда наличных',
			'денег больше $1.000.000',
		},

		type = 'case',

	},

	weapon_knife = {

		name = 'Нож',
		icon = 'assets/images/items/knife.png',
		max_stack = 1,

		title = '',

		type = 'weapon',

		model = 4,

	},

	weapon_bat = {

		name = 'Бита',
		icon = 'assets/images/items/bat.png',
		max_stack = 1,

		title = '',

		properties = {
			damage = 50,
		},

		type = 'weapon',

		model = 5,

	},

	ammo_1 = {

		name = '7.62x39',
		icon = 'assets/images/items/ammo_1.png',
		max_stack = 120,

		title = '',

		type = 'ammo',

	},

	ammo_2 = {

		name = '5.56',
		icon = 'assets/images/items/ammo_2.png',
		max_stack = 120,

		title = '',

		type = 'ammo',

	},

	ammo_3 = {

		name = '9x19',
		icon = 'assets/images/items/ammo_3.png',
		max_stack = 120,

		title = '',

		type = 'ammo',

	},

	ammo_4 = {

		name = '.50cal',
		icon = 'assets/images/items/ammo_4.png',
		max_stack = 50,

		title = '',

		type = 'ammo',

	},

	ammo_5 = {

		name = '.45 ACP',
		icon = 'assets/images/items/ammo_5.png',
		max_stack = 80,

		title = '',

		type = 'ammo',

	},

	ammo_6 = {

		name = '7.62x51',
		icon = 'assets/images/items/ammo_6.png',
		max_stack = 80,

		title = '',

		type = 'ammo',

	},

	food_1 = {

		name = 'Крылышки KFC',
		icon = 'assets/images/items/food_1.png',
		max_stack = 1,

		title = '',

		type = 'food',

		heal = 10,

	},

	food_2 = {

		name = 'Доширак',
		icon = 'assets/images/items/food_2.png',
		max_stack = 1,

		title = '',

		type = 'food',

		heal = 20,

	},

	food_3 = {

		name = 'Лапша',
		icon = 'assets/images/items/food_3.png',
		max_stack = 1,

		title = '',

		type = 'food',

		heal = 30,

	},

	food_4 = {

		name = 'Салат',
		icon = 'assets/images/items/food_4.png',
		max_stack = 1,

		title = '',

		type = 'food',

		heal = 40,

	},

	food_5 = {

		name = 'Бургер',
		icon = 'assets/images/items/food_5.png',
		max_stack = 1,

		title = '',

		type = 'food',

		heal = 50,

	},

	food_6 = {

		name = 'Хот-дог',
		icon = 'assets/images/items/food_6.png',
		max_stack = 1,

		title = '',

		type = 'food',

		heal = 60,

	},

	food_7 = {

		name = 'Пицца',
		icon = 'assets/images/items/food_7.png',
		max_stack = 1,

		title = '',

		type = 'food',

		heal = 70,

	},

	food_8 = {

		name = 'Курица',
		icon = 'assets/images/items/food_8.png',
		max_stack = 1,

		title = '',

		type = 'food',

		heal = 100,

	},



}

Config.item_extends = {
	food = {

		use = function(item, player)
			player.health = math.clamp(player.health + item.heal, 0, 100)
			exports.hud_notify:notify(player, 'Еда', 'Вы пополнили здоровье')
		end,

	},
}

Config.item_types = {
	other = 'Разное',
	medicine = 'Медикаменты',
	weapon = 'Оружие',
	ammo = 'Снаряжение',
	food = 'Еда',
	case = 'Предмет',
}

Config.item_access = {
	other = { inventory = true, },
	medicine = { inventory = true, },
	weapon = { inventory = true, weapon = true },
	ammo = { inventory = true, },
	food = { inventory = true, },
	tool = { inventory = true, weapon = true },
	case = { inventory = true, weapon = true },
}

for id, item in pairs( Config.items ) do

	if Config.item_access[item.type].weapon then
		item.is_weapon = true
	end 

	if Config.item_extends[item.type] then
		setmetatable(item, {__index=Config.item_extends[item.type]})
	end

end


function getConfigSetting(name)
	return Config[name]
end


Config.weaponSlots = {
	[0] = 0,
	[1] = 0,
	[2] = 1,
	[3] = 1,
	[4] = 1,
	[5] = 1,
	[6] = 1,
	[7] = 1,
	[8] = 1,
	[9] = 1,
	[22] = 2,
	[23] = 2,
	[24] = 2,
	[25] = 3,
	[26] = 3,
	[27] = 3,
	[28] = 4,
	[29] = 4,
	[32] = 4,
	[30] = 5,
	[31] = 5,
	[33] = 6,
	[34] = 6,
	[35] = 7,
	[36] = 7,
	[37] = 7,
	[38] = 7,
	[16] = 8,
	[17] = 8,
	[18] = 8,
	[39] = 8,
	[41] = 9,
	[42] = 9,
	[43] = 9,
	[10] = 10,
	[11] = 10,
	[12] = 10,
	[14] = 10,
	[15] = 10,
	[44] = 11,
	[45] = 11,
	[46] = 11,
	[40] = 12,
}