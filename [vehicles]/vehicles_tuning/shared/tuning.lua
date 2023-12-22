

Config.vehicleColorsAccess = {
	[580] = { [3] = true, },
	[566] = { [3] = true, },
	[604] = { [3] = true, },
	[526] = { [3] = true, },
}

function getVehicleColorAccess( vehicle, color_index )

	local vehicle_access = Config.vehicleColorsAccess[ vehicle.model ]
	return ( vehicle_access or {} )[color_index] 

end

Config.tuningSectionNames = {

	sirens = { name = 'СГУ' },
	strobo = { name = 'Стробоскопы' },
	tint = { name = 'Тонировка' },
	wheels = { name = 'Диски' },
	complects = { name = 'Комплекты' },

	lights = { name = 'Фары' },
	tail_lights = { name = 'Задние фары' },

	tail_lights_glass = { name = 'Стекло зад. фар' },
	head_lights_glass = { name = 'Стекло перед. фар' },


	bumper_glass_r = { name = 'Стекло зад. фар' },
	bumper_glass_f = { name = 'Стекло перед. фар' },

	zerkala = { name = 'Зеркала' },
	packets = { name = 'Пакеты' },

	fenders = { name = 'Фендеры' },
	fenders_f = { name = 'Передние фендеры' },
	fenders_r = { name = 'Задние фендеры' },

	bumpers_f = { name = 'Передние бампера' },
	bumpers_r = { name = 'Задние бампера' },
	trunk_lights = { name = 'Задние фонари' },
	trunk_glass = { name = 'Задние стекла' },
	interior = { name = 'Интерьер V2' },

	porogi = { name = 'Пороги' },
	grill = { name = 'Решетки' },
	skirts = { name = 'Пороги' },
	complects = { name = 'Комплекты' },
	interiorparts = { name = 'Интерьер' },
	bonnet = { name = 'Капот' },
	bonnets = { name = 'Капот' },
	spoilers = { name = 'Спойлера' },
	spoiler = { name = 'Спойлера' },
	exhaust = { name = 'Выхлоп' },
	misc = { name = 'Разное' },
	doors = { name = 'Двери' },
	turns = { name = 'Поворотники' },
	roof = { name = 'Крышa' },
	scoop = { name = 'Крышa' },
	grid = { name = 'Решётки' },
	zapaska = { name = 'Запасные колеса' },
	bagazhnik = { name = 'Багажники' },
	trunk_badge = { name = 'Шильдики' },
	splitters = { name = 'Сплиттеры' },
	splitter = { name = 'Сплиттеры' },
	diffuser = { name = 'Диффузоры' },
	shildik = { name = 'Шильдики' },
	parts = { name = 'Интерьер' },
	trunk = { name = 'Багажники' },
	access = { name = 'Аксессуары' },
	head_lights = { name = 'Передние фары' },
	door_dside = { name = 'Накладки на двери' },
	door_pside = { name = 'Накладки на двери 2' },
        doorfender_lr = { name = 'Передние молдинги' },
	doorfender_rr = { name = 'Задние молдинги' },
	license_frame = { name = 'Номерные рамки' },

	wheels_config  = { name =  'Настройка колёс' },
	wheels  = { name =  'Диски' },
	inserts  = { name =  'Вставки' },
	steering  = { name =  'Руль' },
	effects  = { name =  'Эффекты' },
	seats  = { name =  'Сиденья' },
	plate_curtain  = { name =  'Шторка' },
	neon  = { name =  'Неон' },
	coverType  = { name =  'Материал покраски' },
	wheel_coverType  = { name =  'Материал дисков' },
	paint  = { name =  'Покраска' },
	sirens_position  = { name =  'Настройка СГУ' },
	fso_position  = { name =  'Настройка ФСО' },
	mirror  = { name =  'Зеркала' },
	lip_f  = { name =  'Передние накладки' },
	lip_r  = { name =  'Задние накладки' },
	door_nakladki  = { name =  'Дверные накладки' },
	bonnet_attach  = { name =  'Накладка на капот' },
	fso  = { name =  'ФСО Вспышки' },
	pneumo  = { name =  'Пневмоподвеска' },
	wheels_tire  = { name =  'Резина' },
	stages = { name = 'Стейджи' },

}

Config.defaultTuning = {

	stages = {
		value_type = 'default',
		components = {
			{ name = 'Stage #1', price = 35000 },
			{ name = 'Stage #2', price = 75000 },
			{ name = 'Stage #3', price = 150000 },
		},
		description = 'gfdg',
	},

	license_frame = {

		value_type = 'default',

		components = {
			[0] = {name = 'Стандартная рамка', price = 0, default = true},
			{name = 'Рамка #1', price = 15000},
			{name = 'Рамка #2', price = 15000},
			{name = 'Рамка #3', price = 15000},
			{name = 'Рамка #4', price = 15000},
			{name = 'Рамка #5', price = 15000},
			{name = 'Рамка #6', price = 15000},
			{name = 'Рамка #7', price = 15000},
			{name = 'Рамка #8', price = 15000},
			{name = 'Рамка #9', price = 15000},
			{name = 'Рамка #10', price = 15000},
			{name = 'Рамка #11', price = 15000},
			{name = 'Рамка #12', price = 15000},
			{name = 'Рамка #13', price = 15000},
			{name = 'Рамка #14', price = 15000},
			{name = 'Рамка #15', price = 15000},
			{name = 'Рамка #16', price = 15000},
			{name = 'Рамка #17', price = 15000},
			{name = 'Рамка #18', price = 15000},
			{name = 'Рамка #19', price = 15000},
			{name = 'Рамка #20', price = 15000},
			{name = 'Рамка #21', price = 15000},
			{name = 'Рамка #22', price = 15000},
			{name = 'Рамка #23', price = 15000},
			{name = 'Рамка #24', price = 15000},
			{name = 'Рамка #25', price = 15000},
			{name = 'Рамка #26', price = 15000},
			{name = 'Рамка #27', price = 15000},
			{name = 'Рамка #28', price = 15000},
			{name = 'Рамка #29', price = 15000},
			{name = 'Рамка #30', price = 15000},
			{name = 'Рамка #31', price = 15000},
			{name = 'Рамка #32', price = 15000},
			{name = 'Рамка #33', price = 15000},
			{name = 'Рамка #34', price = 15000},
			{name = 'Рамка #35', price = 15000},
			{name = 'Рамка #36', price = 15000},
			{name = 'Рамка #37', price = 15000},
			{name = 'Рамка #38', price = 15000},
			{name = 'Рамка #39', price = 15000},
			{name = 'Рамка #40', price = 15000},
			{name = 'Рамка #41', price = 15000},
			{name = 'Рамка #42', price = 15000},
			{name = 'Рамка #43', price = 15000},
			{name = 'Рамка #44', price = 15000},
			{name = 'Рамка #45', price = 15000},
			{name = 'Рамка #46', price = 15000},
			{name = 'Рамка #47', price = 15000},
		},

	},

	plate_curtain = {

		value_type = 'default',

		components = {
			[0] = {name = 'Без шторки', price = 0, default = true},
			{name = 'Шторка', price = 65000},
		},

	},

	sirens = {

		value_type = 'default',

		components = {
			[0] = {name = 'Без СГУ', price = 0, default = true},
			{name = 'СГУ #1', price = 140000},
			{name = 'СГУ #2', price = 140000},
		},

	},

	fso = {

		value_type = 'default',

		components = {
			[0] = {name = 'Без ФСО', price = 0, default = true},
			{name = 'Белые', price = 200000},
			{name = 'Цвет', price = 350000},
		},

	},

	pneumo = {

		value_type = 'default',

		components = {
			[0] = {name = 'Не установлено', price = 0, default = true},
			{name = 'Пневмоподвеска', price = 350000},
		},

	},

	sirens_position = {

		value_type = 'position',
		prerequisities = {'sirens'},

		edit_text = {
			'Выберите высоту',
			'Выберите вращение',
		},

		edit_image = 'assets/images/car.png',

		components = {
			{ name = 'Настроить позицию', price = 2000, dataName = 'sirens_position' },
		},

	},

	fso_position = {

		value_type = 'position',
		prerequisities = {'fso'},

		edit_text = {
			'Выберите расстояние',
			'Выберите вращение',
		},

		edit_image = 'assets/images/car2.png',

		components = {
			{ name = 'Настроить позицию', price = 2000, dataName = 'fso_position' },
		},

	},

	coverType = {

		value_type = 'default',

		components = {
			default = {name = 'Стандартная покраска', price = 0, default = true},
			chrome = {name = 'Хром', price = 80000},
			mat = {name = 'Мат', price = 40000},
			perlamutr = {name = 'Перламутр', price = 80000},
		},

	},

	wheel_coverType = {

		value_type = 'default',
		prerequisities = {'wheels'},

		components = {
			default = {name = 'Стандартная покраска', price = 0, default = true},
			chrome = {name = 'Хром', price = 80000},
			mat = {name = 'Мат', price = 40000},
		},

	},

	wheels_tire = {

		value_type = 'default',
		prerequisities = {'wheels'},

		components = {
			[0] = {name = 'Стандартная', price = 0, default = true},
			[1] = {name = 'Покрышки #1', price = 30000},
			[2] = {name = 'Покрышки #2', price = 30000},
			[3] = {name = 'Покрышки #3', price = 30000},
			[4] = {name = 'Покрышки #4', price = 30000},
			[5] = {name = 'Покрышки #5', price = 30000},
			[6] = {name = 'Покрышки #6', price = 30000},
			[7] = {name = 'Покрышки #7', price = 30000},
			[8] = {name = 'Покрышки #8', price = 30000},
			[9] = {name = 'Покрышки #9', price = 30000},
		},

	},

	tint = {

		value_type = 'float',

		slider = {
			range = {30, 100},
			divide = 100,
		},

		components = {
			{ name = 'Переднее стекло', price = 3000, dataName = 'tint_front' },
			{ name = 'Боковое стекло', price = 3000, dataName = 'tint_side' },
			{ name = 'Заднее стекло', price = 3000, dataName = 'tint_rear' },
			{ name = 'Тонировка фар', price = 3000, dataName = 'tint_light_glass' },
		},

	},

	wheels = {

		value_type = 'default',
		sortBy = 'index',

		components = {
			[0] = { name = 'Стандартные диски', price = 0, default = true },
			{ name = 'Диски #1', price = 10000 },
			{ name = 'Диски #2', price = 30000 },
			{ name = 'Диски #3', price = 12000 },
			{ name = 'Диски #4', price = 20000 },
			{ name = 'Диски #5', price = 31000 },
			{ name = 'Диски #6', price = 35000 },
			{ name = 'Диски #7', price = 28000 },
			{ name = 'Диски #8', price = 23000 },
			{ name = 'Диски #9', price = 30000 },
			{ name = 'Диски #10', price = 36000 },
			{ name = 'Диски #11', price = 50000 },
			{ name = 'Диски #12', price = 55000 },
			{ name = 'Диски #13', price = 19000 },
			{ name = 'Диски #14', price = 38000 },
			{ name = 'Диски #15', price = 17000 },
			{ name = 'Диски #16', price = 36000 },
			{ name = 'Диски #17', price = 42000 },
			{ name = 'Диски #18', price = 24000 },
			{ name = 'Диски #19', price = 48000 },
			{ name = 'Диски #20', price = 22000 },
			{ name = 'Диски #21', price = 58000 },
			{ name = 'Диски #22', price = 32000 },
			{ name = 'Диски #23', price = 27000 },
			{ name = 'Диски #24', price = 31000 },
			{ name = 'Диски #25', price = 26000 },
			{ name = 'Диски #26', price = 60000 },
			{ name = 'Диски #27', price = 53000 },
			{ name = 'Диски #28', price = 31000 },
			{ name = 'Диски #29', price = 16000 },
			{ name = 'Диски #30', price = 19000 },
			{ name = 'Диски #31', price = 40000 },
			{ name = 'Диски #32', price = 34000 },
			{ name = 'Диски #33', price = 33000 },
			{ name = 'Диски #34', price = 25000 },
			{ name = 'Диски #35', price = 42000 },
			{ name = 'Диски #36', price = 30000 },
			{ name = 'Диски #37', price = 22000 },
			{ name = 'Диски #38', price = 28000 },
			{ name = 'Диски #39', price = 20000 },
			{ name = 'Диски #40', price = 23000 },
			{ name = 'Диски #41', price = 27000 },
			{ name = 'Диски #42', price = 34000 },
			{ name = 'Диски #43', price = 37000 },
			{ name = 'Диски #44', price = 17000 },
			{ name = 'Диски #45', price = 23000 },
			{ name = 'Диски #46', price = 20000 },
			{ name = 'Диски #47', price = 27000 },
			{ name = 'Диски #48', price = 33000 },
			{ name = 'Диски #49', price = 28000 },
			{ name = 'Диски #50', price = 33000 },
			{ name = 'Диски #51', price = 31000 },
			{ name = 'Диски #52', price = 21000 },
			{ name = 'Диски #53', price = 14000 },
			{ name = 'Диски #54', price = 19000 },
			{ name = 'Диски #55', price = 19000 },
			{ name = 'Диски #56', price = 26000 },
			{ name = 'Диски #57', price = 60000 },
			{ name = 'Диски #58', price = 22000 },
			{ name = 'Диски #59', price = 23000 },
			{ name = 'Диски #60', price = 24000 },
			{ name = 'Диски #61', price = 24000 },

		},

	},

	strobo = {

		value_type = 'default',

		toggle = function(self, flag)

			if flag then
				exports.vehicles_controls:updateState( 'strobo', true )
			else
				exports.vehicles_controls:updateState( 'hwd', true )
			end

		end,

		components = {
			[0] = { name = 'Без стробоскопов', price = 0, default = true },
			{ name = 'Резкие', price = 80000 },
			{ name = 'Плавные', price = 120000 },
			{ name = 'Плавные цветные', price = 150000 },

		},

	},

	paint = {

		value_type = 'color',

		components = {
			{ name = 'Покраска кузова', price = 5000, dataName = 'color_1' },
			{ name = 'Покраска салона', price = 8000, dataName = 'color_2' },
			{ name = 'Второй цвет кузова', price = 8000, dataName = 'color_3', check_access = { getVehicleColorAccess, 3 } },
			{ name = 'Цвет блика', price = 15000, dataName = 'color_cover' },
			{ name = 'Покраска дисков', price = 15000, dataName = 'wheels_color' },
			{ name = 'Покраска фар', price = 15000, dataName = 'xenon_color' },
			{ name = 'Покраска тонировки', price = 15000, dataName = 'color_tint' },
			{ name = 'Дым от шин', price = 15000, dataName = 'color_smoke' },
		},

	},

}


Config.componentsTuning = {

	[458] = {
		["complects"] = {
			["bumper_f0 bumper_r0 fenders_f0 fenders_r0 misc0 trunk_badge0 skirts0"] = { name="M-Power", price=0, default = true, show = true },
			["bumper_f1 bumper_r1 fenders_f0 fenders_r0 misc0 trunk_badge0 skirts0"] = { name="Alpina", price=20800, default = false, show = true },
			["bumper_f2 bumper_r2 fenders_f0 fenders_r0 misc0 trunk_badge0 skirts0"] = { name="Stock", price=10200, default = false, show = true },
	 	        ["bumper_f3 bumper_r3 fenders_f1 fenders_r1 misc1 trunk_badge1 skirts1"] = { name="Nightline", price=15200, default = false, show = true },
		},
	},

	[580] = {

		["packets"] = {
			["bumper_r0 doorfender_rf0 doorfender_lf0 doorfender_rr0 doorfender_lr0 lip_r0 fenders_f0 grill0"] = { name="Стандартный пакет", price=0, default = true, show = true },
			["bumper_r1 doorfender_rf1 doorfender_lf1 doorfender_rr1 doorfender_lr1 lip_r1 fenders_f1 grill1"] = { name="Пакет Антихром", price=50000, default = false, show = true },
		},
	},

	[438] = {

		["bumpers_f"] = {
			["bumper_f0"] = { name="Стоковый передний бампер", price=0, default = true, show = true },
			["bumper_f1"] = { name="Передний бампер #1", price=25000, default = false, show = true },
			["bumper_f2"] = { name="Передний бампер #2", price=45000, default = false, show = true },
		},
		["bumpers_r"] = {
			["bumper_r0"] = { name="Стоковый задний бампер", price=0, default = true, show = true },
			["bumper_r1"] = { name="Задний бампер #1", price=15000, default = false, show = true },
		},
		["spoilers"] = {
			["spoiler1"] = { name="Спойлер", price=15000, default = false, show = true },
		},
	},

	[418] = {

		["bumpers_f"] = {
			["bumper_f0"] = { name="Стоковый передний бампер", price=0, default = true, show = true },
			["bumper_f1"] = { name="Передний бампер #1", price=50000, default = false, show = true },
			["bumper_f2"] = { name="Передний бампер #2", price=60000, default = false, show = true },
		},
		["bumpers_r"] = {
			["bumper_r0"] = { name="Стоковый задний бампер", price=0, default = true, show = true },
			["bumper_r1"] = { name="Задний бампер #1", price=50000, default = false, show = true },
			["bumper_r2"] = { name="Задний бампер #2", price=50000, default = false, show = true },
		},
		["grill"] = {
			["misc0"] = { name="Стоковая решетка", price=0, default = true, show = true },
			["misc1"] = { name="Решетка #1", price=35000, default = false, show = true },
			["misc2"] = { name="Решетка #2", price=35000, default = false, show = true },
		},
		["trunk_badge"] = {
			["trunk_badge0"] = { name="Стоковый шильдик", price=0, default = true, show = true },
			["trunk_badge1"] = { name="Шильдик #1", price=25000, default = false, show = true },
			["trunk_badge2"] = { name="Шильдик #2", price=35000, default = false, show = true },
		},
		["skirts"] = {
			["skirts0"] = { name="Стоковые пороги", price=0, default = true, show = true },
			["skirts1"] = { name="Пороги #1", price=20000, default = false, show = true },
		},
	},
	[474] = {
		["complects"] = {
			["spoiler0 bonnet0 misc0"] = { name="Black", price=0, default = true, show = true },
			["spoiler1 bonnet1 misc1"] = { name="В цвет", price=20000, default = false, show = true },
		},
	},
	[526] = {

		["interior"] = {
			["interior0"] = { name="Бампер #0", price=0, default = true, show = true },
			["interior1"] = { name="Бампер #1", price=22000, default = false, show = true },
		},
		["interiorparts"] = {
			["interiorparts0"] = { name="Бампер #0", price=0, default = true, show = true },
			["interiorparts1"] = { name="Бампер #1", price=22000, default = false, show = true },
		},
		["fenders_f"] = {
			["fenders_f0"] = { name="Фендеры #0", price=0, default = true, show = true },
			["fenders_f1"] = { name="Фендеры #1", price=20000, default = false, show = true },
			["fenders_f2"] = { name="Фендеры #2", price=20000, default = false, show = true },
		},

		["trunk"] = {
			["trunk0"] = { name="Капот #1", price=0, default = true, show = true },
			["trunk1"] = { name="Капот #2", price=14000, default = false, show = true },
			["trunk2"] = { name="Капот #3", price=14000, default = false, show = true },
		},
		["head_lights"] = {
			["head_lights0"] = { name="Фары #1", price=0, default = true, show = true },
			["head_lights1"] = { name="Фары #2", price=18000, default = false, show = true },
		},
		["tail_lights"] = {
			["tail_lights0"] = { name="Фары #1", price=0, default = true, show = true },
			["tail_lights1"] = { name="Фары #2", price=18000, default = false, show = true },
		},
		["diffuser"] = {
			["diffuser0"] = { name="Пороги #1", price=12000, default = false, show = true },
			["diffuser1"] = { name="Пороги #2", price=12000, default = false, show = true },
		},
	},

	-- [478] = {

	-- 	["bonnets"] = {
	-- 		["bonnet0"] = { name="Капот #0", price=0, default = true, show = true },
	-- 		["bonnet1"] = { name="Капот #1", price=15000, default = false, show = true },
	-- 		["bonnet2"] = { name="Капот #2", price=15000, default = false, show = true },
	-- 		["bonnet3"] = { name="Капот #3", price=15000, default = false, show = true },
	-- 		["bonnet4"] = { name="Капот #4", price=15000, default = false, show = true },
	-- 	},

	-- 	['grill'] = {
	-- 		['misc0'] = { name="Решетка #0", price=0, default = true, show = true },
	-- 		['misc1'] = { name="Решетка #1", price=15000, default = false, show = true },
	-- 		['misc2'] = { name="Решетка #2", price=15000, default = false, show = true },
	-- 		['misc3'] = { name="Решетка #3", price=15000, default = false, show = true },
	-- 	},

	-- 	['bumpers_f'] = {
	-- 		['bumper_f0'] = { name="Бампер #0", price=0, default = true, show = true },
	-- 		['bumper_f1'] = { name="Бампер #1", price=30000, default = false, show = true },
	-- 		['bumper_f2'] = { name="Бампер #2", price=30000, default = false, show = true },
	-- 		['bumper_f3'] = { name="Бампер #3", price=30000, default = false, show = true },
	-- 	},

	-- 	['bumpers_r'] = {
	-- 		['bumper_r0'] = { name="Бампер #0", price=0, default = true, show = true },
	-- 		['bumper_r1'] = { name="Бампер #1", price=30000, default = false, show = true },
	-- 		['bumper_r2'] = { name="Бампер #2", price=30000, default = false, show = true },
	-- 	},

	-- 	['spoilers'] = {
	-- 		['spoiler1'] = { name="Спойлер #1", price=20000, default = false, show = true },
	-- 		['spoiler3'] = { name="Спойлер #2", price=20000, default = false, show = true },
	-- 		['spoiler2'] = { name="Спойлер #3", price=50000, default = false, show = true },
	-- 	},

	-- 	['exhaust'] = {
	-- 		["trunk_badge0"] = { name="Стоковый выхлоп", price=0, default = true, show = true },
	-- 		["trunk_badge1"] = { name="Выхлоп #1", price=15000, default = false, show = true },
	-- 		["trunk_badge2"] = { name="Выхлоп #2", price=15000, default = false, show = true },
	-- 		["trunk_badge3"] = { name="Выхлоп #3", price=15000, default = false, show = true },
	-- 		["trunk_badge4"] = { name="Выхлоп #4", price=15000, default = false, show = true },
	-- 		["trunk_badge5"] = { name="Выхлоп #5", price=15000, default = false, show = true },
	-- 		["trunk_badge6"] = { name="Выхлоп #6", price=15000, default = false, show = true },
	-- 		["trunk_badge7"] = { name="Выхлоп #7", price=15000, default = false, show = true },
	-- 	},

	-- 	['fenders'] = {
	-- 		['fenders_f0 fenders_r0'] = { name="Фендеры #0", price=0, default = true, show = true },
	-- 		['fenders_f1 fenders_r1'] = { name="Фендеры #1", price=30000, default = false, show = true },
	-- 		['fenders_f2 fenders_r2'] = { name="Фендеры #2", price=30000, default = false, show = true },
	-- 		['fenders_f3 fenders_r3'] = { name="Фендеры #3", price=30000, default = false, show = true },
	-- 	},

	-- 	['bagazhnik'] = {
	-- 		['trunk0'] = { name="Багажник #0", price=0, default = true, show = true },
	-- 		['trunk1'] = { name="Багажник #1", price=15000, default = false, show = true },
	-- 	},

	-- 	['scoop'] = {
	-- 		['scoop1'] = { name="Крыша #1", price=15000, default = false, show = true },
	-- 		['scoop2'] = { name="Крыша #2", price=15000, default = false, show = true },
	-- 		['scoop3'] = { name="Крыша #3", price=15000, default = false, show = true },
	-- 		['scoop4'] = { name="Крыша #4", price=15000, default = false, show = true },
	-- 	},

	-- 	['skirts'] = {
	-- 		['skirts0'] = { name="Пороги #0", price=0, default = true, show = true },
	-- 		['skirts1'] = { name="Пороги #1", price=20000, default = false, show = true },
	-- 		['skirts2'] = { name="Пороги #2", price=20000, default = false, show = true },
	-- 		['skirts3'] = { name="Пороги #3", price=20000, default = false, show = true },
	-- 	},

	-- },

	[561] = {

		["fenders"] = {
			["fenders_f1 fenders_r1 doorfender_lr1 doorfender_rr1"] = { name="Фендеры #1", price=25000, default = false, show = true },
		},
		["splitter"] = {
			["splitter1"] = { name="Сплиттер", price=15000, default = false, show = true },
		},

		["skirts"] = {
			["skirts1"] = { name="Пороги", price=10000, default = false, show = true },
		},

		["packets"] = {
			["door_rf0 door_lf0 door_rr0 door_lr0 door_pside_f0 door_dside_f0"] = { name="Стандартный", price=0, default = true, show = true },
			["door_rf1 door_lf1 door_rr1 door_lr1 door_pside_f1 door_dside_f1"] = { name="Карбон", price=17000, default = false, show = true },
		},

		["spoilers"] = {
			["spoiler0"] = { name="Стоковый спойлер", price=0, default = true, show = true },
			["spoiler1"] = { name="Спойлер #1", price=10000, default = false, show = true },
			["spoiler2"] = { name="Спойлер карбон", price=10000, default = false, show = true },
		},
	},

	[439] = {

		["complects"] = {
			["splitter0 diffuser0 skirts0 door_pside_f0 door_dside_f0 misc0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["splitter1 diffuser1 skirts1 door_pside_f1 door_dside_f1 misc1"] = { name="Комплект #1", price=95000, default = false, show = true },
		},

		["spoilers"] = {
			["spoiler0"] = { name="Без спойлера", price=0, default = true, show = true },
			["spoiler1"] = { name="Карбоновый спойлер", price=10000, default = false, show = true },
		},
	},
	[549] = {

		["complects"] = {
			["misc0 fenders_f0 fenders_r0 bumper_f0 bumper_r0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["misc1 fenders_f0 fenders_r0 bumper_f1 bumper_r1 diffuser1 skirts1 splitter1"] = { name="Комплект #1", price=20000, default = false, show = true },
			["misc2 fenders_f1 fenders_r1 bumper_f2 bumper_r2 diffuser2 skirts2 splitter2"] = { name="Комплект #2", price=20000, default = false, show = true },
			["misc1 fenders_f0 fenders_r0 bumper_f3 bumper_r1 diffuser1 skirts3 splitter3"] = { name="Комплект #3", price=20000, default = false, show = true },
			["misc2 fenders_f1 fenders_r1 bumper_f4 bumper_r3 diffuser3 skirts4 splitter4"] = { name="Комплект #4", price=20000, default = false, show = true },
		},

		["spoilers"] = {
			["spoiler1"] = { name="Спойлер", price=6000, default = false, show = true },
		},
	},
	[559] = {

		["complects"] = {
			["scoop0 interiorparts0 bumper_f0 diffuser0 bumper_r0 "] = { name="Стоковый комплект", price=0, default = true, show = true },
			["fenders_r1 fenders_f1 bumper_f1 diffuser0 bumper_r1 skirts1 scoop1"] = { name="Комплект #1", price=130000, default = false, show = true },
			["bumper_f2 diffuser1 bumper_r2 skirts2 scoop1"] = { name="Комплект #2", price=110000, default = false, show = true },
		},

		["spoilers"] = {
			["spoiler1"] = { name="Спойлер #1", price=10000, default = false, show = true },
			["spoiler2"] = { name="Спойлер #2", price=10000, default = false, show = true },
			["spoiler3"] = { name="Спойлер #3", price=10000, default = false, show = true },
		},
		["exhaust"] = {
			["misc0"] = { name="Стоковый выхлоп", price=0, default = true, show = true },
			["misc1"] = { name="Выхлоп #1", price=12000, default = false, show = true },
			["misc2"] = { name="Выхлоп #2", price=13000, default = false, show = true },
			["misc3"] = { name="Выхлоп #3", price=15000, default = false, show = true },
			["misc4"] = { name="Выхлоп #4", price=20000, default = false, show = true },
			["misc5"] = { name="Выхлоп #5", price=25000, default = false, show = true },
			["misc6"] = { name="Выхлоп #6", price=30000, default = false, show = true },
		},
	},
	[506] = {

		["complects"] = {
			["misc0 interiorparts0 door_dside_f0 door_pside_f0"] = { name="Стоковые полоски", price=0, default = true, show = true },
			["misc1 interiorparts0 door_dside_f1 door_pside_f1"] = { name="Черные полоски", price=150000, default = false, show = true },
			["misc2 interiorparts1 door_dside_f2 door_pside_f2"] = { name="Голубые полоски", price=100000, default = false, show = true },
		},
	},
	[415] = {

		["complects"] = {
			["bumper_f0 bumper_r0 skirts0 fenders_r0 scoop1"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["bumper_f0 bumper_r0 skirts1 fenders_r0 "] = { name="Кабриолет", price=150000, default = false, show = true },
			["bumper_f1 bumper_r1 skirts1 fenders_r1 fenders_f1 scoop1 splitter1 diffuser1"] = { name="Гоночный комплект", price=180000, default = false, show = true },
		},

		["spoilers"] = {
			["spoiler0"] = { name="Спойлер #1", price=10000, default = false, show = true },
			["spoiler1"] = { name="Спойлер #2", price=10000, default = false, show = true },
			["spoiler2"] = { name="Спойлер #3", price=10000, default = false, show = true },
			["spoiler3"] = { name="Спойлер #4", price=10000, default = false, show = true },
		},
	},
	[422] = {

		["skirts"] = {
			["skirts_1"] = { name="Карбоновые пороги", price=8000, default = false, show = true },
		},

		["splitter"] = {
			["splitter_1"] = { name="Карбоновый сплиттер", price=5000, default = false, show = true },
		},
	},
	[412] = {
		["spoiler"] = {
			["spoiler1"] = { name="Спойлер", price=8000, default = false, show = true },
		},
		["misc"] = {
			["misc1"] = { name="#1", price=0, default = false, show = true },
			["misc2"] = { name="#2", price=8000, default = false, show = true },
		},
		["bonnet"] = {
			["bonnet0"] = { name="Сток", price=0, default = true, show = true },
			["bonnet1"] = { name="#1", price=8000, default = false, show = true },
			["bonnet2"] = { name="#2", price=8000, default = false, show = true },
		},
		["splitter"] = {
			["splitter1"] = { name="Сплиттер", price=5000, default = false, show = true },
		},
	},
	[551] = {

		["splitter"] = {
			["splitter1"] = { name="Сплиттер #1", price=1500, default = false, show = true },
			["splitter2"] = { name="Сплиттер #2", price=1500, default = false, show = true },
			["splitter3"] = { name="Сплиттер #3", price=1500, default = false, show = true },
			["splitter4"] = { name="Сплиттер #4", price=1500, default = false, show = true },
		},

		["spoilers"] = {
			["spoiler1"] = { name="Спойлер #1", price=2000, default = false, show = true },
			["spoiler2"] = { name="Спойлер #2", price=2000, default = false, show = true },
		},

		["head_lights"] = {
			["head_lights1"] = { name="Фары #1", price=3000, default = false, show = true },
		},

		["roof"] = {
			["roof_1"] = { name="Крыша #1", price=1000, default = false, show = true },
		},

		["grill"] = {
			["grill0"] = { name="Решетка #0", price=0, default = true, show = true },
			["grill1"] = { name="Решетка #1", price=1500, default = false, show = true },
			["grill2"] = { name="Решетка #2", price=1500, default = false, show = true },
		},

		["fenders_f"] = {
			["FrontFends1"] = { name="Фендеры #0", price=1500, default = false, show = true },
			["FrontFends2"] = { name="Фендеры #1", price=1500, default = false, show = true },
		},

		["bumpers_r"] = {
			["bumper_r0"] = { name="Бампер #0", price=0, default = true, show = true },
			["bumper_r1"] = { name="Бампер #1", price=3000, default = false, show = true },
			["bumper_r2"] = { name="Бампер #2", price=3000, default = false, show = true },
			["bumper_r3"] = { name="Бампер #3", price=3000, default = false, show = true },
		},

		["bumpers_f"] = {
			["bumper_f0"] = { name="Бампер #0", price=0, default = true, show = true },
			["bumper_f1"] = { name="Бампер #1", price=3000, default = false, show = true },
			["bumper_f2"] = { name="Бампер #2", price=3000, default = false, show = true },
			["bumper_f3"] = { name="Бампер #3", price=3000, default = false, show = true },
			["bumper_f4"] = { name="Бампер #4", price=3000, default = false, show = true },
		},

	},
	[475] = {
		["complects"] = {
			["Exhaust0 Bonnets0 FrontLights0 RearLights0 shild0 FrontBump0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["Exhaust1 Bonnets1 FrontLights1 RearLights1 shild0 shild1 FrontBump1 RearBump1 scoop1"] = { name="Комплект #1", price=1200, default = false, show = true },
			["Exhaust2 Bonnets2 FrontLights2 RearLights0 shild2 FrontBump2 RearBump2"] = { name="Комплект #2", price=1200, default = false, show = true },
			["Exhaust1 Bonnets3 FrontLights3 RearLights1 shild0 shild1 FrontBump1 RearBump1 scoop1"] = { name="Комплект #3", price=1200, default = false, show = true },
		},

		["spoilers"] = {
			["Spoilers1"] = { name="Спойлер #1", price=700, default = false, show = true },
			["Spoilers2"] = { name="Спойлер #2", price=600, default = false, show = true },
		},
	},
	[500] = {
		["complects"] = {
			["door_pside_f0 doorpart_pside_f0 door_dside_f0 doorpart_dside_f0 head_lights0 tail_lights0 tail_lights0_glass splitter0 bonnet0 bumper_f0 bumper_r0 diffuser0 interiorparts0 fenders_f0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["door_pside_f1 doorpart_pside_f1 door_dside_f1 doorpart_dside_f1 head_lights1 tail_lights1 tail_lights1_glass splitter1 bonnet1 bumper_f1 bumper_r1 diffuser1 misc1 interiorparts1 fenders_f1 skirts1"] = { name="Комплект #1", price=1500, default = false, show = true },
			["door_pside_f0 doorpart_pside_f0 door_dside_f0 doorpart_dside_f0 head_lights2 tail_lights1 tail_lights1_glass splitter2 bonnet1 bumper_f3 bumper_r3 diffuser1 interiorparts1 fenders_f2 skirts1"] = { name="Комплект #2", price=2000, default = false, show = true },
			["door_pside_f1 doorpart_pside_f1 door_dside_f1 doorpart_dside_f1 head_lights1 tail_lights0 tail_lights0_glass splitter1 bonnet0 bumper_f2 bumper_r2 diffuser0 interiorparts0 fenders_f1 scoop1"] = { name="Комплект #3", price=2100, default = false, show = true },
		},

		["spoilers"] = {
			["spoiler1"] = { name="Спойлер", price=800, default = false, show = true },
		},
	},
	[451] = {
		["complects"] = {
			["bumper_f0 bumper_r0 fenders_f0 fenders_r0 bonnet0 skirts0 trunk_badge0"] = {name = "Стоковый комплект", price = 0, default = true, show = true},
			["bumper_f1 bumper_r1 fenders_f1 fenders_r1 bonnet1 skirts2 trunk_badge1 splitter1"] = {name = "Комплект #1", price = 10000, default = false, show = true},
			["bumper_f2 bumper_r2 fenders_f2 fenders_r0 bonnet1 skirts1 diffuser1 trunk_badge2 splitter3"] = {name = "Комплект #2", price = 12000, default = false, show = true},
			["bumper_f3 bumper_r3 fenders_f2 fenders_r0 bonnet1 skirts3 diffuser1 trunk_badge8 splitter8"] = {name = "Комплект #3", price = 15000, default = false, show = true},
			["bumper_f1 bumper_r1 fenders_f1 fenders_r1 bonnet1 skirts2 trunk_badge9 splitter10"] = {name = "Комплект #4", price = 12000, default = false, show = true},
			["bumper_f3 bumper_r3 fenders_f2 fenders_r0 bonnet1 skirts4 trunk_badge6 splitter6"] = {name = "Комплект #5", price = 14000, default = false, show = true},
		},
		["spoiler"] = {
			["spoiler0"] = {name = "Спойлер #1", price = 3000, default = false, show = true},
			["spoiler1"] = {name = "Спойлер #2", price = 3500, default = false, show = true},
			["spoiler2"] = {name = "Спойлер #3", price = 3000, default = false, show = true},
			["spoiler3"] = {name = "Спойлер #4", price = 4000, default = false, show = true},
			["spoiler4"] = {name = "Спойлер #5", price = 3500, default = false, show = true},
			["spoiler5"] = {name = "Спойлер #6", price = 4100, default = false, show = true},
			["spoiler6"] = {name = "Спойлер #7", price = 4000, default = false, show = true},
			["spoiler7"] = {name = "Спойлер #8", price = 4000, default = false, show = true},
		},

		["diffuser"] = {
			["diffuser2"] = {price = 1500, default = false, show = false},
		},
		["splitter"] = {
			["splitter2"] = {price = 1100, default = false, show = false},
			["splitter4"] = {price = 1200, default = false, show = false},
			["splitter5"] = {price = 1150, default = false, show = false},
			["splitter7"] = {price = 1300, default = false, show = false},
			["splitter9"] = {price = 1150, default = false, show = false},
		},
		["trunk_badge"] = {
			["trunk_badge3"] = {price = 330, default = false, show = false},
			["trunk_badge4"] = {price = 500, default = false, show = false},
			["trunk_badge5"] = {price = 500, default = false, show = false},
			["trunk_badge7"] = {price = 600, default = false, show = false},
			["trunk_badge10"] = {price = 550, default = false, show = false},
			["trunk_badge11"] = {price = 700, default = false, show = false},
		},
	},
	[492] = {
		["complects"] = {
			["doorfender_lr0 door_dside_f0 doorfender_rr0 door_pside_f0 kit0 splitter0 bonnet0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["doorfender_lr1 door_dside_f1 doorfender_rr1 door_pside_f1 kit1 splitter1 bonnet1 chassis_skirts_ok"] = { name="Комплект #1", price=35000, default = false, show = true },
		},

		["spoilers"] = {
			["spoiler1"] = { name="Спойлер", price=10000, default = false, show = true },
		},
	},
	[507] = {
		-- ["complects"] = {
		-- 	["mirror_lf0 mirror_rf0 diffuser0 bonnet_0 exhaust0 grill0 splitter0 front_fenders0 roof0"] = { name="Стоковый комплект", price=0, default = true, show = true },
		-- 	["skirts1 lip_f1 mirror_lf1 mirror_rf1 diffuser1 bonnet_1 exhaust0 grill1 splitter1 front_fenders1 roof1"] = { name="Комплект #1", price=50000, default = false, show = true },
		-- 	["skirts1 lip_f1 mirror_lf2 mirror_rf2 diffuser2 bonnet_1 exhaust0 grill2 spoiler1 splitter1 front_fenders2 roof2"] = { name="Комплект #2", price=50000, default = false, show = true },
		-- },
		-- ["hide"] = {
		-- 	["grill5 grill4 grill3 tail_lights_glass0_1"] = { name="", price=0, default = false, show = false },
		-- },

		["mirror"] = {
			["mirror_lf0 mirror_rf0"] = { name="Стоковые зеркала", price=0, default = true, show = true },
			["mirror_lf1 mirror_rf1"] = { name="Зеркала #1", price=1000, default = false, show = true },
			["mirror_lf2 mirror_rf2"] = { name="Зеркала #2", price=1000, default = false, show = true },
		},
		["door_nakladki"] = {
			["doorfender_rr0 doorfender_lr0 doorfender_rf0 doorfender_lf0"] = { name="Стоковые накладки", price=0, default = true, show = true },
			["doorfender_rr1 doorfender_lr1 doorfender_rf1 doorfender_lf1"] = { name="Накладки #1", price=1000, default = false, show = true },
			["doorfender_rr2 doorfender_lr2 doorfender_rf2 doorfender_lf2"] = { name="Накладки #2", price=1000, default = false, show = true },
		},
		["exhaust"] = {
			["exhaust0"] = { name="Стоковый выхлоп", price=0, default = true, show = true },
			["exhaust1"] = { name="Выхлоп #1", price=1000, default = false, show = true },
		},
		["grill"] = {
			["grill0"] = { name="Стоковая решетка", price=0, default = true, show = true },
			["grill1"] = { name="Решетка #1", price=1000, default = false, show = true },
			["grill2"] = { name="Решетка #2", price=1000, default = false, show = true },
			["grill3"] = { name="Решетка #3", price=1000, default = false, show = true },
			["grill4"] = { name="Решетка #4", price=1000, default = false, show = true },
			["grill5"] = { name="Решетка #5", price=1000, default = false, show = true },
		},
		["splitter"] = {
			["splitter1"] = { name="Сплиттер", price=1000, default = false, show = true },
		},
		["skirts"] = {
			["skirts1"] = { name="Пороги", price=1000, default = false, show = true },
		},
		["spoiler"] = {
			["spoiler1"] = { name="Спойлер", price=1000, default = false, show = true },
		},
		["diffuser"] = {
			["diffuser0"] = { name="Стоковый диффузор", price=0, default = true, show = true },
			["diffuser1"] = { name="Диффузор #1", price=1000, default = false, show = true },
			["diffuser2"] = { name="Диффузор #2", price=1000, default = false, show = true },
		},
		["roof"] = {
			["roof0"] = { name="Стоковая крыша", price=0, default = true, show = true },
			["roof1"] = { name="Крыша #1", price=1000, default = false, show = true },
			["roof2"] = { name="Крыша #2", price=1000, default = false, show = true },
		},
		["trunk_badge"] = {
			["trunk_badge0"] = { name="Стоковый шильдик", price=0, default = true, show = true },
			["trunk_badge1"] = { name="Шильдик #1", price=1000, default = false, show = true },
		},
		["fenders"] = {
			["front_fenders0"] = { name="Стоковые фендеры", price=0, default = true, show = true },
			["front_fenders1"] = { name="Фендеры #1", price=1000, default = false, show = true },
			["front_fenders2"] = { name="Фендеры #2", price=1000, default = false, show = true },
		},
		["hide"] = {
			["tail_lights_glass0_1"] = { name="", price=0, default = false, show = false },
		},
	},
	[445] = {
		["bonnet"] = {
			["bonnet0"] = { name="Стоковый бампер", price=0, default = true, show = true },
			["bonnet1"] = { name="Бампер #1", price=10000, default = false, show = true },
		},
		["spoilers"] = {
			["spoiler1"] = { name="Спойлер #1", price=5000, default = false, show = true },
		},
		["head_lights"] = {
			["head_lights0 head_lights_glass0"] = { name="Стоковые фары", price=0, default = true, show = true },
			["head_lights1 head_lights_glass1"] = { name="Фары #1", price=10000, default = false, show = true },
		},
	},
	[413] = {
		["complects"] = {
			["bumper_f0 skirts0 door_pside_f0 door_dside_f0 misc0 trunk_badge0 scoop0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["bumper_f1 skirts1 door_pside_f1 door_dside_f1 misc1 trunk_badge1 scoop1"] = { name="Night", price=50000, default = false, show = true },
		},
	},
	[420] = {
		["complects"] = {
			["FrontBump0 RearBump0 Bonnets0 FrontLights0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["FrontBump1 RearBump1 Bonnets1 FrontLights1 SideSkirts1 FrontDef1 Acces1"] = { name="Комплект #1", price=5800, default = false, show = true },
			["FrontBump2 RearBump1 Bonnets1 FrontLights0 SideSkirts1 FrontDef1 Acces1"] = { name="Комплект #2", price=6200, default = false, show = true },
		},
	},
	[602] = {
		["complects"] = {
			["bonnet0 doorfender_lf0 doorfender_rf0 exhaust0 diffuser0 bumper_f0 bumper_r0 spoiler0 fenders_f0 fenders_r0 trunk_badge0 scoop0 misc0 trunk0 head_lights0 head_lights_glass0 tail_lights0 tail_lights_glass0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["bonnet0 doorfender_lf1 doorfender_rf1 exhaust1 diffuser1 bumper_f0 bumper_r0 spoiler1 fenders_f0 fenders_r0 trunk_badge0 scoop1 misc0 trunk0 head_lights1 head_lights_glass1 tail_lights1 tail_lights_glass1 splitter1"] = { name="Restyling", price=50000, default = false, show = true },
			["bonnet1 doorfender_lf2 doorfender_rf2 exhaust2 diffuser2 bumper_f0 bumper_r0 spoiler2 fenders_f0 fenders_r0 trunk_badge1 skirts1 scoop2 misc1 trunk0 head_lights1 head_lights_glass1 tail_lights1 tail_lights_glass1 splitter2"] = { name="Cs", price=70000, default = false, show = true },
			["bonnet0 doorfender_lf2 doorfender_rf2 exhaust2 diffuser3 bumper_f0 bumper_r0 spoiler3 fenders_f0 fenders_r0 trunk_badge2 skirts1 scoop2 misc1 trunk0 head_lights1 head_lights_glass1 tail_lights1 tail_lights_glass1 splitter3"] = { name="Schnitzer", price=70000, default = false, show = true },
		},
	},
	-- Mercedes W140
	[516] = {
		["complects"] = {
			["scoop0 bumper_f0 bonnet0 bumper_r0 trunk0 trunk_badge0 doorfender_rr0 doorfender_lr0 door_pside_f0 door_dside_f0 fenders_r0 fenders_f0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["scoop1 bumper_f1 bonnet1 bumper_r1 trunk0 trunk_badge1 doorfender_rr1 doorfender_lr1 door_pside_f1 door_dside_f1 fenders_r1 fenders_f1"] = { name="Brabus", price=6200, default = false, show = true },
		},
		["door_nakladki"] = {
			["doorfender_lr0 doorfender_rr0 door_dside_f0 door_pside_f0 fenders_r0 fenders_f0"] = { name="Стоковые накладки", price=0, default = true, show = true },
			["doorfender_rr1 door_dside_f1 door_pside_f1 fenders_r1 fenders_f1"] = { name="Накладки #1", price=1000, default = false, show = true },
		},
	},
	[419] = {
		["diffuser"] = {
			["diffuser0"] = {name = "Стандартный", price = 0, style = 0, default = true, show = true},
			["diffuser1"] = {name = "M-Performance", price = 150000, style = 40, default = false, show = true},
		},
		["bumper_f"] = {
			["bumper_f0"] = {name = "Стандартный", price = 0, style = 0, default = true, show = true},
			["bumper_f1"] = {name = "M-Performance", price = 420000, style = 40, default = false, show = true},
		},
		["bumper_r"] = {
			["bumper_r0"] = {name = "Стандартный", price = 0, style = 0, default = true, show = true},
			["bumper_r1"] = {name = "M-Performance", price = 420000, style = 40, default = false, show = true},
		},
		["skirts"] = {
			["skirts0"] = {name = "Стандартный", price = 0, style = 0, default = true, show = true},
			["skirts1"] = {name = "M-Performance", price = 240000, style = 40, default = false, show = true},
		},
		["spoiler"] = {
			["spoiler0"] = {name = "Без спойлера", price = 0, style = 0, default = true, show = true},
			["spoiler1"] = {name = "M-Performance", price = 120000, style = 40, default = false, show = true},
		},
	},
	[550] = {
		["complects"] = {
			["bumper_f0 bumper_r0 skirts0 diffuser0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["bumper_f0 bumper_r1 skirts1"] = { name="Lumma", price=18000, default = false, show = true },
		},
		["tail_lights"] = {
			["tail_lights0"] = { name="Красная", price=0, default = true, show = true },
			["tail_lights1"] = { name="Серая", price=1450, default = false, show = true },
		},
		["scoop"] = {
			["scoop0"] = { name="Stock", price=0, default = true, show = true },
			["scoop1"] = { name="Black", price=1450, default = false, show = true },
		},
		["spoilers"] = {
			["spoiler0"] = { name="Stock", price=0, default = true, show = true },
			["spoiler1"] = { name="Carbon", price=1450, default = false, show = true },
			["spoiler2"] = { name="Black", price=1450, default = false, show = true },
		},
		["misc"] = {
			["misc0"] = { name="Stock", price=0, default = true, show = true },
			["misc1"] = { name="Black", price=1450, default = false, show = true },
			["misc2"] = { name="F10 style", price=1450, default = false, show = true },
			["misc3"] = { name="F10 black", price=1450, default = false, show = true },
			["misc4"] = { name="M Power", price=1450, default = false, show = true },
			["misc5"] = { name="M Black", price=1450, default = false, show = true },
			["misc6"] = { name="Chrome", price=1450, default = false, show = true },
		},
		["fenders_f"] = {
			["fenders_f0"] = { name="Stock", price=0, default = true, show = true },
			["fenders_f1"] = { name="Black", price=1450, default = false, show = true },
		},
		["trunk_badge"] = {
			["trunk_badge0"] = { name="Stock", price=0, default = true, show = true },
			["trunk_badge1"] = { name="Black", price=1450, default = false, show = true },
			["trunk_badge2"] = { name="Carbon", price=1450, default = false, show = true },
		},
		["splitter"] = {
			["splitter0"] = { name="Stock", price=0, default = true, show = true },
			["splitter1"] = { name="Black", price=1450, default = false, show = true },
		},
		["diffuser"] = {
			["diffuser0"] = { name="Stock", price= 0, default = true, show = true },
			["diffuser1"] = { name="Carbon", price=1450, default = false, show = true },
			["diffuser2"] = { name="Black", price=1450, default = false, show = true },
			["diffuser3"] = { name="Akrapovic", price=1450, default = false, show = true },
			["diffuser4"] = { name="Lumma", price=1450, default = false, show = true },
			["diffuser5"] = { name="Carbon Exhaust", price=1450, default = false, show = true },
		},
		["head_lights"] = {
			["head_lights0"] = { name="Stock", price=0, default = true, show = true },
			["head_lights1"] = { name="Оранжевые", price=1450, default = false, show = true },
		},
	},
	[479] = {
		["complects"] = {
			["interiorparts0 trunk0 tail_lights0 tail_lights_glass0 trunk_glass0 head_lights0 head_lights_glass0 fenders_r0 interior0 scoop0 bumper_f0 bumper_r0 diffuser0 bonnet0 spoiler1 trunk0 trunk_badge0"] = { name="Сompetition", price=0, default = true, show = true },
			["interiorparts0 trunk1 tail_lights1 tail_lights_glass1 trunk_glass1 head_lights1 head_lights_glass1 fenders_r1 interior0 scoop0 bumper_f1 bumper_r1 diffuser0 bonnet0 spoiler1 trunk1 trunk_badge0"] = { name="'21", price=100000, default = false, show = true },
			["interiorparts1 trunk1 tail_lights1 tail_lights_glass1 trunk_glass1 head_lights2 head_lights_glass2 fenders_r1 interior1 scoop1 bumper_f2 bumper_r1 diffuser1 bonnet1 spoiler2 trunk1 trunk_badge1"] = { name="Cs", price=140000, default = false, show = true },
		},
	},
	[490] = {
		["complects"] = {
			["Exhaust0 Nozdri0 RearDef0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["Exhaust1 Nozdri1 RearDef1 FrontDef1"] = { name="Аксессуары", price=37000, default = false, show = true },
		},

		['hide']= {
			["RearDef2 Roof_Parts1"] = {price = 0, default = false, show = false},
		}
	},
	[527] = {
		["complects"] = {
			["FrontBump0 SideSkirts0 Roof0 RearFends0 FrontFends0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["FrontBump1 SideSkirts1 Roof1 RearFends1 FrontFends1"] = { name="Комплект #1", price=27000, default = false, show = true },
		},

		["spoilers"] = {
			["Spoilers0"] = { name="Спойлер #1", price=1500, default = false, show = true },
			["Spoilers1"] = { name="Спойлер #2", price=2500, default = false, show = true },
			["Spoilers2"] = { name="Спойлер #3", price=3000, default = false, show = true },
		},

		["bonnets"] = {
			["Bonnets0"] = { name="Капот #1", price=5000, default = true, show = true },
			["Bonnets1"] = { name="Капот #2", price=5000, default = false, show = true },
			["Bonnets2"] = { name="Капот #3", price=5000, default = false, show = true },
			["Bonnets3"] = { name="Капот #4", price=5000, default = false, show = true },
			["Bonnets4"] = { name="Капот #5", price=5000, default = false, show = true },
		},
	},
	[491] = {
		["complects"] = {
			["bonnet0 bumper_r0 bumper_f0 skirts0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["fenders_f1 fenders_r1 bumper_r1 bumper_f1 bonnet1 skirts1"] = { name="Комплект #1", price=120000, default = false, show = true },
			["bumper_r1 bumper_f2 bonnet1 skirts2"] = { name="Комплект #2", price=80000, default = false, show = true },
			["fenders_f1 fenders_r1 bumper_r1 bumper_f2 bonnet1 skirts2"] = { name="Комплект #3", price=120000, default = false, show = true },
		},

		["spoilers"] = {
			["spoiler1"] = { name="Спойлер #1", price=20000, default = false, show = true },
			["spoiler2"] = { name="Спойлер #2", price=19000, default = false, show = true },
		},
	},
	[536] = {
		["scoop"] = {
			["scoop0"] = { name="Стоковая крыша", price=0, default = true, show = true },
			["scoop1"] = { name="Открытый верх", price=250000, default = false, show = true },
		},
	},
	[596] = {
		["complects"] = {
			["diffuser0 scoop0 bonnet_attach0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["diffuser1 skirts1 splitter1 scoop1 bonnet_attach1"] = { name="Комплект #1", price=32000, default = false, show = true },
		},

		["spoilers"] = {
			["spoiler0"] = { name="Спойлер #1", price=5000, default = false, show = true },
			["spoiler1"] = { name="Спойлер #2", price=5000, default = false, show = true },
		},

		['bonnets']= {
			["bonnet_attach2"] = {price = 0, default = false, show = false},
		}
	},
	[567] = {
		["complects"] = {
			["diffuser0 misc0 skirts0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["diffuser1 misc1 skirts1 splitter1 fenders_f1 fenders_r1 doorfender_rr1 doorfender_lr1"] = { name="Аксессуары", price=45000, default = false, show = true },
		},
		["spoilers"] = {
			["spoiler1"] = { name="Спойлер", price=7000, default = false, show = true },
		},
	},
	-- [600] = {
	-- 	["misc"] = {
	-- 		["misc0"] = { name="Стоковая решетка", price=0, default = true, show = true },
	-- 		["misc1"] = { name="Мелкая решетка", price=35000, default = false, show = true },
	-- 	},
	-- 	["trunk_badge"] = {
	-- 		["trunk_badge0"] = { name="Стоковый логотип", price=0, default = true, show = true },
	-- 		["trunk_badge1"] = { name="Логотип #1", price=35000, default = false, show = true },
	-- 	},
	-- },
	[402] = {
		["bonnets"] = {
			["Bonnets0"] = { name="Стоковый капот", price=0, default = true, show = true },
			["Bonnets1"] = { name="Капот с турбо", price=50000, default = false, show = true },
		},
		["bumpers_f"] = {
			["FrontBump0"] = { name="Стоковый бампер", price=0, default = true, show = true },
			["FrontBump1"] = { name="Бампер #1", price=52000, default = false, show = true },
			["FrontBump2"] = { name="Бампер #2", price=52000, default = false, show = true },
		},
		["exhaust"] = {
			["Exhaust0"] = { name="Стоковый выхлоп", price=0, default = true, show = true },
			["Exhaust1"] = { name="Выхлоп #1", price=60000, default = false, show = true },
			["Exhaust2"] = { name="Выхлоп #2", price=60000, default = false, show = true },
			["Exhaust3"] = { name="Выхлоп #3", price=60000, default = false, show = true },
			["Exhaust4"] = { name="Выхлоп #4", price=60000, default = false, show = true },
			["Exhaust5"] = { name="Выхлоп #5", price=60000, default = false, show = true },
			["Exhaust6"] = { name="Выхлоп #6", price=60000, default = false, show = true },
			["Exhaust7"] = { name="Выхлоп #7", price=60000, default = false, show = true },
		},

		["morgenshtern"] = {
			["morgenshtern_1"] = { name="MILLION DOLLAR", price=15000, default = false, show = false },
		},

	},
	[401] = {
		["complects"] = {
			["skirts0 misc0 diffuser0 splitter0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["skirts1 misc1 diffuser1 splitter1 trunk_badge1 fenders_f1"] = { name="Аксессуары", price=40000, default = false, show = true },
		},
		["spoilers"] = {
			["spoiler1"] = { name="Спойлер", price=8000, default = false, show = true },
		},
	},
	[467] = {
		["complects"] = {
			["trunk_badge0 Exhaust0 Nozdri0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["trunk_badge1 Exhaust1 Nozdri1"] = { name="Аксессуары", price=25000, default = false, show = true },
		},
		["spoilers"] = {
			["Spoilers0"] = { name="Спойлер #1", price=7000, default = false, show = true },
			["Spoilers1"] = { name="Спойлер #2", price=7000, default = false, show = true },
		},
	},
	[405] = {
		["complects"] = {
			["fenders_r1 doorfender_lr1 doorfender_rr1 door_dside_f1 door_pside_f1 bonnet0 bumper_r0 bumper_f0 fenders_f0 splitter0 diffuser0 interior0 skirts0 misc1"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["fenders_r3 doorfender_lr3 doorfender_rr3 door_dside_f3 door_pside_f3 bonnet1 bumper_r1 bumper_f2 fenders_f2 splitter1 interior0 skirts1 scoop1 misc2"] = { name="Комплект #1 Lumma", price=100000, default = false, show = true },
			["fenders_r2 doorfender_lr2 doorfender_rr2 door_dside_f2 door_pside_f2 bonnet0 bumper_r0 bumper_f1 fenders_f1 splitter2 diffuser1 interior1 skirts0 misc2"] = { name="Комплект #2 AMG", price=100000, default = false, show = true },
			["doorfender_lr4 doorfender_rr4 door_dside_f4 door_pside_f4 bonnet2 fenders_r4 bumper_r2 bumper_f3 fenders_f3 interior0 skirts2 misc0"] = { name="Комплект #3 Brabus", price=100000, default = false, show = true },

		},
		["lights"] = {
			["lights_f_2"] = { name="Стоковые фары", price=0, default = true, show = true },
			["lights_f_1"] = { name="Фары #1", price=15000, default = false, show = true },
		},
		["abu"] = {
			["abu_bandit"] = { price=0, default = false, show = false },
		},
		["zapaska"] = {
			["trunk_badge0"] = { name="Запаска #1", price=20000, default = false, show = true },
			["trunk_badge1"] = { name="Запаска #2", price=20000, default = false, show = true },
			["trunk_badge2"] = { name="Запаска #3", price=20000, default = false, show = true },
			["trunk_badge3"] = { name="Запаска #4", price=20000, default = false, show = true },
		},
		["spoilers"] = {
			["spoiler1"] = { name="Спойлер #1", price=12000, default = false, show = true },
			["spoiler2"] = { name="Спойлер #2", price=12000, default = false, show = true },
		},

		["fenders"] = {
			["fenders_r0"] = { price=0, default = false, show = false },
			["doorfender_lr0"] = { price=0, default = false, show = false },
			["doorfender_rr0"] = { price=0, default = false, show = false },
			["door_dside_f0"] = { price=0, default = false, show = false },
			["door_pside_f0"] = { price=0, default = false, show = false },
		},
		["splitters"] = {
			["splitter3"] = { price=0, default = false, show = false },
		},
	},
	[470] = {
		["complects"] = {
			["bumper_r0 bumper_f0 bonnet0 doorfender_rr0 skirts0 doorfender_lr0 door_dside_f0 door_pside_f0 fenders_r0 misc0 interiorparts0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["bumper_r1 bumper_f1 bonnet1 doorfender_rr1 skirts1 doorfender_lr1 door_dside_f1 door_pside_f1 fenders_r1 misc1 interiorparts1"] = { name="Комплект #1", price=100000, default = false, show = true },
			["bumper_r2 bumper_f2 bonnet0 doorfender_rr0 skirts0 doorfender_lr0 door_dside_f0 door_pside_f0 fenders_r0 misc2 interiorparts0"] = { name="Комплект #1", price=100000, default = false, show = true },
			["bumper_r3 bumper_f3 bonnet1 doorfender_rr1 skirts1 doorfender_lr1 door_dside_f1 door_pside_f1 fenders_r1 misc3 interiorparts1"] = { name="Комплект #1", price=100000, default = false, show = true },
		},
		["trunk_badge"] = {
			["trunk0"] = { name="Запаска", price=12000, default = false, show = true },
		},
		["spoilers"] = {
			["spoiler1"] = { name="Спойлер", price=15000, default = false, show = true },
			["spoiler0"] = { price=0, default = false, show = false },
		},
	},

	[562] = {
		["bumpers_f"] = {
			["bumper_f0"] = { name="Спойлер #1", price=6000, default = true, show = true },
			["bumper_f1"] = { name="Спойлер #2", price=6000, default = false, show = true },
			["bumper_f2"] = { name="Спойлер #3", price=6000, default = false, show = true },
		},
		["bumpers_r"] = {
			["bumper_r0"] = { name="Спойлер #1", price=6000, default = true, show = true },
			["bumper_r1"] = { name="Спойлер #2", price=6000, default = false, show = true },
			["bumper_r2"] = { name="Спойлер #3", price=6000, default = false, show = true },
		},
		["skirts"] = {
			["skirt0"] = { name="Спойлер #1", price=6000, default = true, show = true },
			["skirt1"] = { name="Спойлер #2", price=6000, default = false, show = true },
			["skirt2"] = { name="Спойлер #3", price=6000, default = false, show = true },
		},
		["roof"] = {
			["roof0"] = { name="Спойлер #1", price=6000, default = true, show = true },
			["roof2"] = { name="Спойлер #2", price=6000, default = false, show = true },
		},
		["bonnet"] = {
			["bonnet0"] = { name="Спойлер #1", price=6000, default = true, show = true },
			["bonnet1"] = { name="Спойлер #2", price=6000, default = false, show = true },
		},
		["spoilers"] = {
			["spoiler0"] = { name="Спойлер #1", price=6000, default = true, show = true },
			["spoiler1"] = { name="Спойлер #2", price=6000, default = false, show = true },
			["spoiler2"] = { name="Спойлер #3", price=6000, default = false, show = true },
		},
	},

	[603] = {
		["complects"] = {
			["bonnet0 bumper_f0 skirts0 fenders_f0 trunk_badge0 interiorparts0 interiorparts0_glass steeringwheel_ok head_lights0 head_lights0_glass tail_lights0 tail_lights0_glass doorfender_lr0 door_dside_f0 door_pside_f0 doorfender_rr0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["bonnet1 bumper_f1 diffuser1 skirts0 fenders_f1 trunk_badge1 interiorparts1 interiorparts1_glass steeringwheel_ok1 head_lights1 head_lights1_glass tail_lights1  tail_lights1_glass doorfender_lr1 door_dside_f1 door_pside_f1 doorfender_rr1"] = { name="Комплект #1", price=100000, default = false, show = true },
			["bonnet2 bumper_f0 splitter1 diffuser1 skirts1 fenders_f0 trunk_badge0 interiorparts0 interiorparts0_glass steeringwheel_ok head_lights2 head_lights2_glass tail_lights0 tail_lights0_glass doorfender_lr0 door_dside_f0 door_pside_f0 doorfender_rr0 misc1"] = { name="Комплект #2", price=100000, default = false, show = true },
			["bonnet3 bumper_f0 splitter2 diffuser1 skirts1 fenders_f1 trunk_badge1 interiorparts1 interiorparts1_glass steeringwheel_ok1 head_lights1 head_lights1_glass tail_lights1 tail_lights1_glass doorfender_lr1 door_dside_f1 door_pside_f1 doorfender_rr1 misc1"] = { name="Комплект #3", price=100000, default = false, show = true },
			["bonnet4 bumper_f2 diffuser2 skirts2 fenders_f2 trunk_badge0 interiorparts0 interiorparts0_glass steeringwheel_ok head_lights3 head_lights3_glass tail_lights0 tail_lights0_glass doorfender_lr0 door_dside_f0 door_pside_f0 doorfender_rr0 misc2"] = { name="Комплект #4", price=100000, default = false, show = true },
			["bonnet4 bumper_f3 diffuser2 skirts2 fenders_f2 trunk_badge1 interiorparts1 interiorparts1_glass steeringwheel_ok1 head_lights4 head_lights4_glass tail_lights1_glass tail_lights1 doorfender_lr1 door_dside_f1 door_pside_f1 doorfender_rr1 misc2"] = { name="Комплект #5", price=100000, default = false, show = true },
		},
		["spoilers"] = {
			["spoiler1"] = { name="Спойлер#1", price=15000, default = false, show = true },
			["spoiler2"] = { name="Спойлер#2", price=15000, default = false, show = true },
		},
		["trunk_badge"] = {
			["trunk_badge2"] = { price=0, default = false, show = false },
		},
	},

	[560] = {
		["misc"] = {
			["misc_0"] = {name = "Stock", price = 0, default = true, show = true},
			["misc_1"] = {name = "Антихром", price = 35000, default = false, show = true},
		},
		["roof"] = {
			["roof_0"] = {name = "Stock", price = 0, default = true, show = true},
			["roof_1"] = {name = "Антихром", price = 35000, default = false, show = true},
		},
		["exhaust"] = {
			["exhaust_0"] = {name = "Stock", price = 0, default = true, show = true},
			["exhaust_1"] = {name = "Антихром", price = 35000, default = false, show = true},
		},
		["spoiler"] = {
			["spoiler_0"] = {name = "Stock", price = 0, default = true, show = true},
			["spoiler_1"] = {name = "Спойлер", price = 35000, default = false, show = true},
		},
	},
	[496] = {
		["spoilers"] = {
			["Spoilers1"] = { name="Спойлер #1", price=1200, default = false, show = true },
			["Spoilers2"] = { name="Спойлер #2", price=1500, default = false, show = true },
			["Spoilers3"] = { name="Спойлер #3", price=1300, default = false, show = true },
		},
		["bumpers_f"] = {
			["FrontBump0"] = { name="Стоковый передний бампер", price=0, default = true, show = true },
			["FrontBump1"] = { name="Передний бампер #1", price=2500, default = false, show = true },
			["FrontBump2"] = { name="Передний бампер #2", price=2000, default = false, show = true },
		},
		["bumpers_r"] = {
			["RearBump0"] = { name="Стоковый задний бампер", price=0, default = true, show = true },
			["RearBump1"] = { name="Задний бампер #1", price=2000, default = false, show = true },
		},
		["skirts"] = {
			["SideSkirts1"] = { name="Пороги", price=1800, default = false, show = true },
		},
	},
	[558] = {
		["complects"] = {
			["skirts0 bumper_f0 bumper_r0 fenders_r0 fenders_f0 bonnet0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["skirts1 diffuser1 bumper_f1 bumper_r1 fenders_r0 fenders_f1 bonnet1"] = { name="Комплект #1", price=7000, default = false, show = true },
			["skirts3 bumper_f3 bumper_r2 fenders_r1 fenders_f2 bonnet2"] = { name="Комплект #2", price=6000, default = false, show = true },
			["skirts4 bumper_f4 bumper_r4 fenders_r1 fenders_f1 bonnet3"] = { name="Комплект #3", price=8000, default = false, show = true },
			["skirts5 diffuser2 bumper_f6 bumper_r0 fenders_r0 fenders_f1 bonnet4"] = { name="Комплект #4", price=8000, default = false, show = true },
		},
		["spoilers"] = {
			["spoiler0"] = { name="Спойлер #1", price=1200, default = false, show = true },
			["spoiler1"] = { name="Спойлер #2", price=1500, default = false, show = true },
			["spoiler2"] = { name="Спойлер #3", price=1550, default = false, show = true },
			["spoiler3"] = { name="Спойлер #4", price=1600, default = false, show = true },
			["spoiler4"] = { name="Спойлер #5", price=1400, default = false, show = true },
			["spoiler5"] = { name="Спойлер #6", price=1500, default = false, show = true },
			["spoiler6"] = { name="Спойлер #7", price=1500, default = false, show = true },
		},

		["bumpers_f"] = {
			["bumper_f2"] = { price=0, default = false, show = false },
			["bumper_f5"] = { price=0, default = false, show = false },
			["bumper_f7"] = { price=0, default = false, show = false },
		},
		["bumpers_r"] = {
			["bumper_r3"] = { price=0, default = false, show = false },
			["bumper_r5"] = { price=0, default = false, show = false },
		},
		["trunk_badge"] = {
			["trunk_badge1"] = { price=0, default = false, show = false },
		},
		["head_lights"] = {
			["head_lights1"] = { price=0, default = false, show = false },
		},
		["skirts"] = {
			["skirts2"] = { price=0, default = false, show = false },
		},
	},
	[494] = {
		["complects"] = {
			["bonnet0 bumper_f0 bumper_r0 fenders_r0 fenders_f0 skirts0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["bonnet1 diffuser1 bumper_f1 bumper_r1 fenders_r0 fenders_f0 skirts1"] = { name="Комплект #1", price=32000, default = false, show = true },
			["bonnet0 bumper_f2 bumper_r2 fenders_r0 fenders_f0 skirts2"] = { name="Комплект #2", price=35000, default = false, show = true },
			["bonnet1 bumper_f3 bumper_r3 fenders_f0 fenders_r0 skirts3"] = { name="Комплект #3", price=32000, default = false, show = true },
			["bonnet1 diffuser2 bumper_f5 bumper_r5 fenders_r2 fenders_f2 skirts4"] = { name="Комплект #4", price=35000, default = false, show = true },
		},
		["spoilers"] = {
			["spoiler0"] = { name="Спойлер #1", price=4000, default = false, show = true },
			["spoiler1"] = { name="Спойлер #2", price=4000, default = false, show = true },
			["spoiler2"] = { name="Спойлер #3", price=4000, default = false, show = true },
			
			["spoiler3"] = { price=0, default = false, show = false },
		},
		["head_lights"] = {
			["head_lights1"] = { name="Стоковые фары", price=0, default = true, show = true },
			["head_lights0"] = { name="Фары #1", price=15000, default = false, show = true },
		},

		["skirts"] = {
			["skirts2"] = { price=0, default = false, show = false },
			["skirts5"] = { price=0, default = false, show = false },
		},
		["trunk"] = {
			["trunk1"] = { price=0, default = false, show = false },
		},
		["bumpers_f"] = {
			["bumper_f4"] = { price=0, default = false, show = false },
			["bumper_f6"] = { price=0, default = false, show = false },
		},
		["bumpers_r"] = {
			["bumper_r4"] = { price=0, default = false, show = false },			
			["bumper_r6"] = { price=0, default = false, show = false },			
		},
		["fenders"] = {
			["fenders_f1"] = { price=0, default = false, show = false },			
			["fenders_r1"] = { price=0, default = false, show = false },			
		},
	},
	[489] = {
		["complects"] = {
			["head_lights0 tail_lights0 head_lights0_glass tail_lights0_glass bumper_f0 bumper_r0 fenders_f0 skirts0 fenders_r0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["head_lights1 tail_lights1 head_lights1_glass tail_lights1_glass bumper_f1 bumper_r1 fenders_f1 skirts1 fenders_r1"] = { name="Комплект #1", price=7000, default = false, show = true },
			["head_lights0 tail_lights2 head_lights0_glass tail_lights2_glass bumper_f5 bumper_r2 fenders_f2 skirts2 fenders_r0"] = { name="Комплект #2", price=6500, default = false, show = true },
			["head_lights1 tail_lights3 head_lights1_glass tail_lights3_glass bumper_f7 bumper_r7 fenders_f4 skirts7 fenders_r4"] = { name="Комплект #3", price=7000, default = false, show = true },
			["head_lights0 tail_lights3 head_lights0_glass tail_lights3_glass bumper_f6 bumper_r6 fenders_f3 skirts4 fenders_r3"] = { name="Комплект #4", price=6500, default = false, show = true },
		},
		["spoilers"] = {
			["spoiler0"] = { name="Спойлер #1", price=1200, default = false, show = true },
			["spoiler1"] = { name="Спойлер #2", price=1200, default = false, show = true },
			["spoiler2"] = { name="Спойлер #3", price=1200, default = false, show = true },
			["spoiler3"] = { name="Спойлер #4", price=1200, default = false, show = true },
			["spoiler4"] = { name="Спойлер #5", price=1200, default = false, show = true },
			["spoiler5"] = { name="Спойлер #6", price=1200, default = false, show = true },
			["spoiler6"] = { name="Спойлер #7", price=1200, default = false, show = true },
			["spoiler7"] = { name="Спойлер #8", price=1200, default = false, show = true },
		},
		["misc"] = {
			["misc1"] = { name="Брови на фары", price=2200, default = false, show = true },
		},
		["interiorparts"] = {
			["interiorparts0"] = { name="Стоковый салон", price=0, default = true, show = true }, 
			["interiorparts1"] = { name="Усиленный салон", price=1500, default = false, show = true }, 
		},
		["zerkala"] = {
			["doorpart_dside_f0 doorpart_pside_f0"] = { name="Стоковые зеркала", price=0, default = true, show = true }, 
			["doorpart_dside_f1 doorpart_pside_f1"] = { name="Зеркала #1", price=1000, default = false, show = true }, 
			["doorpart_dside_f2 doorpart_pside_f2"] = { name="Зеркала #2", price=1000, default = false, show = true }, 
		},
		["trunk"] = {
			["trunk0"] = { name="Стоковый багажник", price=0, default = true, show = true }, 
			["trunk1"] = { name="Карбоновый багажник", price=2200, default = false, show = true }, 
		},
		["bonnets"] = {
			["bonnet0"] = { name="Стоковый капот", price=0, default = true, show = true }, 
			["bonnet1"] = { name="Капот #1", price=2200, default = false, show = true }, 
			["bonnet2"] = { name="Капот #2", price=2000, default = false, show = true }, 
			["bonnet3"] = { name="Капот #3", price=2000, default = false, show = true }, 
			["bonnet4"] = { name="Капот #4", price=2000, default = false, show = true }, 
		},

		["trunk_badge"] = {
			["trunk_badge2"] = { price=0, default = false, show = false },
		},
		["bumpers_f"] = {
			["bumper_f2"] = { price=0, default = false, show = false },
			["bumper_f3"] = { price=0, default = false, show = false },
			["bumper_f4"] = { price=0, default = false, show = false },
		},
		["bumpers_r"] = {
			["bumper_r3"] = { price=0, default = false, show = false },
			["bumper_r4"] = { price=0, default = false, show = false },
			["bumper_r5"] = { price=0, default = false, show = false },
		},
		["skirts"] = {
			["skirts3"] = { price=0, default = false, show = false },
			["skirts5"] = { price=0, default = false, show = false },
			["skirts6"] = { price=0, default = false, show = false },
		},
	},
	[541] = {
		["bumpers_f"] = {
			["bumper_f0"] = { name="Стоковый передний бампер", price=0, default = true, show = true },
			["bumper_f1"] = { name="Передний бампер #1", price=15000, default = false, show = true },
		},
		["bumpers_r"] = {
			["bumper_r0"] = { name="Стоковый задний бампер", price=0, default = true, show = true },
			["bumper_r1"] = { name="Задний бампер #1", price=22000, default = false, show = true },
			["bumper_r2"] = { name="Задний бампер #2", price=20000, default = false, show = true },
		},
		["skirts"] = {
			["porogi0"] = { name="Стоковые пороги", price=0, default = true, show = true },
			["porogi1"] = { name="Пороги #1", price=20000, default = false, show = true },
		},
		["misc"] = {
			["grid0"] = { name="Стоковая решетка", price=0, default = true, show = true },
			["grid1"] = { name="Решетка #1", price=15000, default = false, show = true },
		},
		["scoop"] = {
			["roof0"] = { name="Стоковая крыша", price=0, default = true, show = true },
			["roof1"] = { name="Крыша #1", price=20000, default = false, show = true },
			["roof2"] = { name="Крыша #2", price=20000, default = false, show = true },
		},
		["bonnets"] = {
			["bonnet0"] = { name="Стоковый капот", price=0, default = true, show = true },
			["bonnet1"] = { name="Капот #1", price=20000, default = false, show = true },
			["bonnet2"] = { name="Капот #2", price=25000, default = false, show = true },
			["bonnet3"] = { name="Капот #3", price=25000, default = false, show = true },
		},
		["trunk_badge"] = {
			["trunk_badge0"] = { name="Стоковый логотип", price=0, default = true, show = true },
			["trunk_badge1"] = { name="Логотип #1", price=12000, default = false, show = true },
			["trunk_badge2"] = { name="Логотип #2", price=12000, default = false, show = true },
			["trunk_badge3"] = { name="Логотип #3", price=12000, default = false, show = true },
		},

		["morgenshtern"] = {
			["morgenshtern_1"] = { name="666", price=15000, default = false, show = false },
		},

	},
	[566] = {
		["complects"] = {
			["chassis_0 bumber_r0 bumber_f0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["chassis_1 bumber_r1 bumber_f1 fender_f1"] = { name="Комплект #1", price=150000, default = false, show = true },
		},
		["spoilers"] = {
			["spoiler_1"] = { name="Спойлер", price=40000, default = false, show = true },
		},
		["packets"] = {
			["chassis_0 doorfender_lf0 doorfender_rr0 doorfender_lr0 doorfender_rf0"] = { name="Стандартный", price=0, default = true, show = true },
			["chassis_1 doorfender_lf1 doorfender_rr1 doorfender_lr1 doorfender_rf1"] = { name="Антихром", price=65000, default = false, show = true },
		},
	},
	[436] = {
		["bumpers_f"] = {
			["bumper_f0"] = { name="Стоковый передний бампер", price=0, default = true, show = true },
			["bumper_f1"] = { name="Передний бампер #1", price=50000, default = false, show = true },
		},
		["head_lights"] = {
			["head_lights0 head_lights0_glass"] = { name="Стоковые передние фары", price=0, default = true, show = true },
			["head_lights1 head_lights1_glass"] = { name="Передние фары hihg-tech", price=40000, default = false, show = true },
		},
	},
	[426] = {
		complects={
			['bumper_f0 bumper_r0 diffuser0 door_pside_f0 door_dside_f0 doorfender_rr0 doorfender_lr0 spoiler0 scoop0']={default = true, show = true, price = 0, name = 'Stock'},
			['bumper_f1 bumper_r0 diffuser1 door_pside_f1 door_dside_f1 doorfender_rr1 doorfender_lr1 spoiler0 scoop0']={show = true, price = 10000, name = 'Stock black'},
			['bumper_f1 bumper_r0 diffuser1 door_pside_f1 door_dside_f1 doorfender_rr1 doorfender_lr1 spoiler0 scoop0']={show = true, price = 12000, name = 'XV black'},
			['bumper_f2 bumper_r1 diffuser2 door_pside_f0 door_dside_f0 doorfender_rr0 doorfender_lr0 spoiler1 scoop1']={show = true, price = 25000, name = 'Khann'},
			['bumper_f2 bumper_r1 diffuser3 door_pside_f1 door_dside_f1 doorfender_rr1 doorfender_lr1 spoiler1 scoop1']={show = true, price = 27000, name = 'Khann black'},
		},
	},
	[597] = {

		["complects"] = {
			["misc0 bumper_f0 bumper_r0"] = { name="Сток", price=0, default = true, show = true },
			["misc1 bumper_f1 bumper_r1"] = { name="Комплект #1", price=70000, default = false, show = true },
			["misc0 bumper_f2 bumper_r2"] = { name="Комплект #2", price=90000, default = false, show = true },
		},

		["bonnet"] = {
			["bonnet0"] = { name="Сток", price=0, default = true, show = true },
			["bonnet1"] = { name="Капот #1", price=15000, default = false, show = true },
		},

		["trunk_badge"] = {
			["trunk_badge0"] = { name="Шильдик #1", price=15000, default = false, show = true },
			["trunk_badge1"] = { name="Шильдик #2", price=15000, default = false, show = true },
		},

		["spoiler"] = {
			["spoiler1"] = { name="Спойлер #1", price=15000, default = false, show = true },
		},

	},
	[540] = {
		["complects"] = {
			["misc0 bonnet0 bumper_r0 bumper_f0 interiorparts0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["misc1 bonnet1 bumper_r1 bumper_f1 interiorparts1 skirts1"] = { name="Комплект #1", price=9000, default = false, show = true },
		},
		["spoilers"] = {
			["spoiler1"] = { name="Спойлер #1", price=1200, default = false, show = true },
			["spoiler2"] = { name="Спойлер #2", price=1200, default = false, show = true },
			["spoiler3"] = { name="Спойлер #3", price=1200, default = false, show = true },
		},
	},

	[429] = {
		["complects"] = {
              	        ["bumper_f0"] = { name="Стоковый комплект", price=0, default = true, show = true },
		        ["bumper_f1"] = { name="Комплект #1", price=50000, default = false, show = true },
		        ["bumper_f2"] = { name="Комплект #2", price=50000, default = false, show = true },
		        ["bumper_f3"] = { name="Комплект #3", price=50000, default = false, show = true },
	        },
		["spoilers"] = {
			["spoiler1"] = { name="Спойлер #1", price=1200, default = false, show = true },
			["spoiler2"] = { name="Спойлер #2", price=1200, default = false, show = true },
			["spoiler3"] = { name="Спойлер #3", price=1200, default = false, show = true },
			["spoiler4"] = { name="Спойлер #4", price=1200, default = false, show = true },
		},
	},

	-- [429] = {
	-- 	["complects"] = {
	-- 		["kit0 bonnet0 door_pside_f0 door_dside_f0"] = { name="Стоковый комплект", price=0, default = true, show = true },
	-- 		["kit1 bonnet1 door_pside_f1 door_dside_f1"] = { name="Комплект #1", price=20000, default = false, show = true },
	-- 	},
	-- 	["spoilers"] = {
	-- 		["spoiler1"] = { name="Спойлер #1", price=3000, default = false, show = true },
	-- 		["spoiler2"] = { name="Спойлер #2", price=3000, default = false, show = true },
	-- 		["spoiler3"] = { name="Спойлер #3", price=3000, default = false, show = true },
	-- 		["spoiler4"] = { name="Спойлер #4", price=3000, default = false, show = true },
	-- 		["spoiler5"] = { name="Спойлер #5", price=3000, default = false, show = true },
	-- 	},
	-- 	["splitters"] = {
	-- 		["bumper_f1"] = { name="Сплиттер #1", price=2500, default = false, show = true },
	-- 		["bumper_f2"] = { name="Сплиттер #2", price=2500, default = false, show = true },
	-- 	},

	-- 	["misc"] = {
	-- 		["misc1"] = { price=0, default = false, show = false },
	-- 		["misc2"] = { price=0, default = false, show = false },
	-- 		["misc3"] = { price=0, default = false, show = false },
	-- 		["misc4"] = { price=0, default = false, show = false },
	-- 		["misc5"] = { price=0, default = false, show = false },
	-- 	},
	-- },
	[411] = {
		["complects"] = {
			["skirts0 Bonnets0 door_pside_f0 door_dside_f0 FrontBump0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["Acces1 Splitters1 door_pside_f1 Diffuzor1 door_dside_f1 SideSkirts1 Bonnets1 FrontBump1 RearFends1"] = { name="Комплект #1", price=6000, default = false, show = true },
			["Acces1 door_pside_f1 door_dside_f1 SideSkirts1 RearDef2 Bonnets2 FrontBump2"] = { name="Комплект #2", price=6000, default = false, show = true },
		},
		["spoilers"] = {
			["Spoilers0"] = { name="Спойлер #1", price=1000, default = false, show = true },
			["Spoilers1"] = { name="Спойлер #2", price=1000, default = false, show = true },
			["Spoilers2"] = { name="Спойлер #3", price=1000, default = false, show = true },
		},
	},
	[404] = {
		["spoilers"] = {
			["spoiler1"] = { name="Спойлер #1", price=400, default = false, show = true },
			["spoiler2"] = { name="Спойлер #2", price=400, default = false, show = true },
			["spoiler3"] = { name="Спойлер #3", price=400, default = false, show = true },
			["spoiler4"] = { name="Спойлер #4", price=400, default = false, show = true },
		},
		["trunk"] = {
			["trunk0"] = { name="Стоковый багажник", price=0, default = true, show = true },
			["trunk1"] = { name="Багажник #1", price=600, default = false, show = true },
		},
		["trunk_badge"] = {
			["trunk_badge0"] = { name="Стоковый логотип", price=0, default = true, show = true },
			["trunk_badge1"] = { name="Логотип #1", price=300, default = false, show = true },
		},
		["head_lights"] = {
			["head_lights0"] = { name="Стоковые передние фары", price=0, default = true, show = true },
			["head_lights1"] = { name="Передние фары #1", price=800, default = false, show = true },
			["head_lights2"] = { name="Передние фары #2", price=800, default = false, show = true },
			["head_lights3"] = { name="Передние фары #3", price=800, default = false, show = true },
			["head_lights4"] = { name="Передние фары #4", price=800, default = false, show = true },
			["head_lights5"] = { name="Передние фары #5", price=800, default = false, show = true },
			["head_lights6"] = { name="Передние фары #6", price=800, default = false, show = true },
		},
		["tail_lights"] = {
			["tail_lights0 tail_lights0_glass"] = { name="Стоковые задние фары", price=0, default = true, show = true },
			["tail_lights1 tail_lights1_glass"] = { name="Задние фары #1", price=800, default = false, show = true },
		},
		["bonnets"] = {
			["bonnet0"] = { name="Стоковый капот", price=0, default = true, show = true },
			["bonnet1"] = { name="Капот #1", price=950, default = false, show = true },
			["bonnet2"] = { name="Капот #2", price=950, default = false, show = true },
			["bonnet3"] = { name="Капот #3", price=950, default = false, show = true },
			["bonnet4"] = { name="Капот #4", price=950, default = false, show = true },
		},
		["misc"] = {
			["misc1"] = { name="Аксессуар #1", price=400, default = false, show = true },
			["misc2"] = { name="Аксессуар #2", price=400, default = false, show = true },
			["misc3"] = { name="Аксессуар #3", price=400, default = false, show = true },
			["misc4"] = { name="Аксессуар #4", price=400, default = false, show = true },
			["misc5"] = { name="Аксессуар #5", price=400, default = false, show = true },
		},
		["fenders"] = {
			["fenders_f1 fenders_r1"] = { name="Фендеры #1", price=400, default = false, show = true },
			["fenders_f2 fenders_r1"] = { name="Фендеры #2", price=400, default = false, show = true },
			["fenders_f3"] = { name="Выхлоп", price=250, default = false, show = true },
		},
		["splitters"] = {
			["splitter1"] = { name="Сплиттер #1", price=350, default = false, show = true },
			["splitter2"] = { name="Сплиттер #2", price=350, default = false, show = true },
			["splitter3"] = { name="Сплиттер #3", price=350, default = false, show = true },
		},
		["bumpers_f"] = {
			["bumper_f0"] = { name="Стоковый передний бампер", price=0, default = true, show = true },
			["bumper_f1"] = { name="Передний бампер #1", price=950, default = false, show = true },
			["bumper_f2"] = { name="Передний бампер #2", price=950, default = false, show = true },
			["bumper_f3"] = { name="Передний бампер #3", price=950, default = false, show = true },
			["bumper_f4"] = { name="Передний бампер #4", price=950, default = false, show = true },
			["bumper_f5"] = { name="Передний бампер #5", price=950, default = false, show = true },
		},
		["bumpers_r"] = {
			["bumper_r0"] = { name="Стоковый задний бампер", price=0, default = true, show = true },
			["bumper_r1"] = { name="Задний бампер #1", price=999, default = false, show = true },
			["bumper_r2"] = { name="Задний бампер #2", price=999, default = false, show = true },
			["bumper_r3"] = { name="Задний бампер #3", price=999, default = false, show = true },
		},
		["interiorparts"] = {
			["interiorparts0"] = { name="Стоковый интерьер", price=0, default = true, show = true },
			["interiorparts1"] = { name="Улучшенная приборная панель", price=150, default = false, show = true },
		},
	},
	[466] = {
		["bonnets"] = {
			["rpb_bonnet_stock"] = { name="Стоковый капот", price=0, default = true, show = true },
			["rpb_bonnet_1"] = { name="Капот #1", price=800, default = false, show = true },
			["rpb_bonnet_2"] = { name="Капот #2", price=800, default = false, show = true },
			["rpb_bonnet_3"] = { name="Капот #3", price=800, default = false, show = true },
		},
		["bumpers_f"] = {
			["rpb_front_bump_stock"] = { name="Стоковый передний бампер", price=0, default = true, show = true },
			["rpb_front_bump_1"] = { name="Передний бампер #1", price=1000, default = false, show = true },
			["rpb_front_bump_2"] = { name="Передний бампер #2", price=1000, default = false, show = true },
			["rpb_front_bump_3"] = { name="Передний бампер #3", price=1000, default = false, show = true },
			["rpb_front_bump_4"] = { name="Передний бампер #4", price=1000, default = false, show = true },
			["rpb_front_bump_5"] = { name="Передний бампер #5", price=1000, default = false, show = true },
		},
		["bumpers_r"] = {
			["rpb_rear_bump_stock"] = { name="Стоковый задний бампер", price=0, default = true, show = true },
			["rpb_rear_bump_1"] = { name="Задний бампер #1", price=1000, default = false, show = true },
			["rpb_rear_bump_2"] = { name="Задний бампер #2", price=1000, default = false, show = true },
			["rpb_rear_bump_3"] = { name="Задний бампер #3", price=1000, default = false, show = true },
			["rpb_rear_bump_4"] = { name="Задний бампер #4", price=1000, default = false, show = true },
		},
		["skirts"] = {
			["rpb_side_skirts_stock"] = { name="Стоковые пороги", price=0, default = true, show = true },
			["rpb_side_skirts_1"] = { name="Пороги #1", price=800, default = false, show = true },
			["rpb_side_skirts_2"] = { name="Пороги #2", price=800, default = false, show = true },
			["rpb_side_skirts_3"] = { name="Пороги #3", price=800, default = false, show = true },
			["rpb_side_skirts_4"] = { name="Пороги #4", price=800, default = false, show = true },
		},
		["spoilers"] = {
			["rpb_wing_1"] = { name="Спойлер #1", price=550, default = false, show = true },
			["rpb_wing_2"] = { name="Спойлер #2", price=550, default = false, show = true },
			["rpb_wing_3"] = { name="Спойлер #3", price=550, default = false, show = true },
		},
	},
	[547] = {
		["bumpers_r"] = {
			["bumper_r0"] = { name="Стоковый бампер", price=0, default = true, show = true },
			["bumper_r1"] = { name="Бампер #1", price=10000, default = false, show = true },
			["bumper_r2"] = { name="Бампер #2", price=12000, default = false, show = true },
		},
		["exhaust"] = {
			["exhaust0"] = { name="Стоковый выхлоп", price=0, default = true, show = true },
			["exhaust1"] = { name="Выхлоп #1", price=10000, default = false, show = true },
			["exhaust2"] = { name="Выхлоп #2", price=12000, default = false, show = true },
		},
		["bumpers_f"] = {
			["bumper_f0 grill0"] = { name="Стоковый бампер", price=0, default = true, show = true },
			["bumper_f1 grill1"] = { name="Бампер #1", price=10000, default = false, show = true },
			["bumper_f2 grill2"] = { name="Бампер #2", price=12000, default = false, show = true },
			["grill3"] = { name="Решетка #3", price=5000, default = false, show = false },
		},
		["mirror"] = {
			["mirror_rf0 mirror_lf0"] = { name="Стоковые зеркала", price=0, default = true, show = true },
			["mirror_rf1 mirror_lf1"] = { name="Зеркала #1", price=6000, default = false, show = true },
			["mirror_rf2 mirror_lf2"] = { name="Зеркала #2", price=8000, default = false, show = true },
		},
		["head_lights"] = {
			["head_lights0"] = { name="Стоковые фары", price=0, default = true, show = true },
			["head_lights1"] = { name="Фары #1", price=6000, default = false, show = true },
			["head_lights2"] = { name="Фары #2", price=8000, default = false, show = true },
		},
		["tail_lights"] = {
			["tail_lights0 tail_lights0_tail2"] = { name="Стоковые фары", price=0, default = true, show = true },
			["tail_lights1 tail_lights1_tail2"] = { name="Фары #1", price=6000, default = false, show = true },
			["tail_lights2"] = { name="Фары #2", price=8000, default = false, show = true },
		},
		["bonnet_attach"] = {
			["bonnet_attach0"] = { name="Стоковая накладка", price=0, default = true, show = true },
			["bonnet_attach1"] = { name="Накладка #1", price=2000, default = false, show = true },
		},
		-- ["grill"] = {
		-- 	["grill0"] = { name="Решетка #0", price=0, default = true, show = true, compatible_with = { 'bumper_f0' } },
		-- 	["grill1"] = { name="Решетка #1", price=3000, default = false, show = true, compatible_with = { 'bumper_f1', 'bumper_f2' } },
		-- 	["grill2"] = { name="Решетка #2", price=4000, default = false, show = true, compatible_with = { 'bumper_f1', 'bumper_f2' } },

		-- 	["grill3"] = { name="Решетка #3", price=5000, default = false, show = false },
		-- },
		["bonnets"] = {
			["bonnet_0"] = { name="Стоковый капот", price=0, default = true, show = true, },
			["bonnet_1"] = { name="Капот #1", price=3000, default = false, show = true },
		},
		["skirts"] = {
			["skirts0"] = { name="Стоковые пороги", price=0, default = true, show = true, },
			["skirts1"] = { name="Пороги #1", price=3000, default = false, show = true },
		},
		["spoilers"] = {
			["spoiler1"] = { name="Спойлер #1", price=2600, default = false, show = true, },
		},
		["trunk_badge"] = {
			["trunk_badge0"] = { name="Стоковый шильдик", price=0, default = true, show = true, },
			["trunk_badge1"] = { name="Шильдик #1", price=2000, default = false, show = true, },
			["trunk_badge2"] = { name="Шильдик #2", price=4000, default = false, show = true, },
		},
		["trunk"] = {
			["trunk0"] = { name="Стоковый багажник", price=0, default = true, show = true, },
			["trunk1"] = { name="Багажник #1", price=2000, default = false, show = true, },
		},
	},

	[598] = {
		complects={
			['tail_lights0 trunk0 trunk_badge0 fenders_f0 bumper_f0 head_lights0 diffuser0']=
				{show = true, price = 0, name = 'Stock', default = true},
			['tail_lights0 trunk0 trunk_badge1 fenders_f1 bumper_f0 head_lights0 diffuser1']=
				{show = true, price = 800000, name = 'Dorest Black'},
			['tail_lights1 trunk1 trunk_badge0 fenders_f0 bumper_f1 head_lights1 diffuser2']=
				{show = true, price = 2000000, name = '21'},
			['tail_lights1 trunk1 trunk_badge1 fenders_f1 bumper_f1 head_lights1 diffuser3']=
				{show = true, price = 2000000, name = '21 black'},
		},
	},
	[579] = {

		["bumpers_f"] = {
			["bumper_f0"] = { name="Бампер #0", price=0, default = true, show = true },
			["bumper_f0 splitter1"] = { name="Бампер #1", price=40000, default = false, show = true },
			["bumper_f1"] = { name="Бампер #2", price=50000, default = false, show = true },
		},

		["bumpers_r"] = {
			["bumper_r0 diffuser2"] = { name="Бампер #0", price=0, default = true, show = true },
			["bumper_r0 diffuser0"] = { name="Бампер #1.1", price=40000, default = false, show = true },
			["bumper_r0 diffuser1"] = { name="Бампер #1.2", price=40000, default = false, show = true },
			["bumper_r1"] = { name="Бампер #2", price=50000, default = false, show = true },
		},

		["skirts"] = {
			["skirts1"] = { name="Юбка #1", price=24000, default = false, show = true },
		},

		["spoilers"] = {
			["spoiler1"] = { name="Спойлер #1", price=32000, default = false, show = true },
		},

		["trunk_badge"] = {
			["trunk_badge0"] = { name="Сток", price=0, default = true, show = true },
			["trunk_badge1"] = { name="Шильдик #1", price=25000, default = false, show = true },
		},

	},
	[400] = {
		["spoilers"] = {
			["spoiler0"] = { name="Спойлер #1", price=0, default = true, show = true },
			["spoiler1"] = { name="Спойлер #2", price=15000, default = false, show = true },
			["spoiler2"] = { name="Спойлер #3", price=15000, default = false, show = true },
			["spoiler3"] = { name="Спойлер #4", price=15000, default = false, show = true },
		},
		["complects"] = {
			["trunk_badge0 scoop0 fenders_f0 vyhlop0 bumper_r0 door_pside_f0 door_dside_f0 doorfender_rr0 doorfender_lr0 trunk0 bumper_f0 bonnet_attach0"] = { name="Стоковый комплект", price=0, default = true, show = true },
			["trunk_badge1 scoop1 fenders_f1 bumper_r1 door_pside_f1 door_dside_f1 doorfender_rr1 doorfender_lr1 trunk1 bumper_f1 bonnet_attach1"] = { name="Комплект #1", price=40000, default = false, show = true },
		},
		["exhaust"] = {
			["vyhlop1"] = { name="", price=0, default = false, show = false },
		},
	},
	[555] = {

		["interiorparts"] = {
			["interiorparts0"] = { name="Приборка #1", price=0, default = true, show = true },
			["interiorparts1"] = { name="Приборка #2", price=5000, default = false, show = true },
		},
		["splitter"] = {
			["splitter0"] = { name="Сплиттер 1", price=5000, default = true, show = true },
			["splitter1"] = { name="Сплиттер 2", price=5000, default = false, show = true },
		},

		["fenders_f"] = {
			["fenders_f0"] = { name="1", price=15000, default = true, show = true },
			["fenders_f1"] = { name="Юбка", price=5000, default = false, show = true },
		},

		["spoiler"] = {
			["spoiler1"] = { name="Спойлер", price=5000, default = false, show = true },
		},

		["bumpers_r"] = {
			["bumper_r0"] = { name="Сток", price=0, default = true, show = true },
			["bumper_r1"] = { name="Бампер #1", price=5000, default = false, show = true },
		},

		["diffuser"] = {
			["diffuser0"] = { name="Сток", price=0, default = true, show = true },
			["diffuser1"] = { name="Бампер #1", price=5000, default = false, show = true },
		},
		["scoop"] = {
			["scoop0"] = { name="Сток", price=0, default = true, show = true },
			["scoop1"] = { name="Выхлоп #1", price=5000, default = false, show = true },
			["scoop2"] = { name="Выхлоп #1", price=5000, default = false, show = true },
		},

	},

}


for model, tuning in pairs( Config.componentsTuning ) do
	for section, components in pairs( tuning ) do
		local default = false
		for name, component in pairs( components ) do
			default = default or component.default
		end

		if not default then
			table.insert(components, 1, {show = true, price = 0, name = 'По умолчанию', default = true})
		end


		for name, component in pairs( components ) do
			component.componentName = component.componentName or name
		end
	end
end

Config.fsoDisable = {
	
	[576] = true,
	[489] = true,
	[411] = true,
	[558] = true,
	[496] = true,
	[429] = true,
	[585] = true,
	[541] = true,
	[402] = true,
	[559] = true,
	[415] = true,
	[491] = true,
	[506] = true,
	[536] = true,
	[565] = true,
	[545] = true,
	[457] = true,
	[542] = true,
	[518] = true,
	[587] = true,

}

Config.StageDisable = {
	[444] = true,
}

Config.pneumoDisable = {
}

Config.allowedTuning = {

	['Automobile'] = {
		sirens = true,
		strobo = true,
		tint = true,
		curtain = true,
		wheels = true,
		wheels_config = true,
		plate_curtain = true,
		license_frame = true,
		coverType = true,
		paint = true,
		sirens_position = true,
		xenon_color = true,
		wheel_coverType = true,
		stages = true,
		-- wheels_tire = true,

		fso = function(vehicle)
			if Config.fsoDisable[vehicle.model] then return false end
			local components = getVehicleComponents( vehicle )
			return components.fso_dummy
		end,

		fso_position = function(vehicle)
			if Config.fsoDisable[vehicle.model] then return false end
			local components = getVehicleComponents( vehicle )
			return components.fso_dummy
		end,

		pneumo = function(vehicle)
			if Config.pneumoDisable[vehicle.model] then return false end
			return true
		end,

		stages = function ( vehicle )
			if Config.StageDisable [ vehicle.model ] then return false end
			return true
		end,

	},

	['Bike'] = {
		strobo = true,
	},

}

function getAllowedComponents( vehicle, components )

	local allowed = {}

	for index, component in pairs( components ) do

		if not component.check_access then
			allowed[index] = component
		else

			local func = component.check_access[1]
			if func( vehicle, unpack( table.slice(component.check_access, 2) ) ) then
				allowed[index] = component
			end

		end

	end

	return allowed

end

function getVehicleTuningList(vehicle)

	local model = vehicle.model

	local tuningSections = {}
	local allowedTuning = Config.allowedTuning[ getVehicleType(vehicle) ] or {}

	local componentsTuning = Config.componentsTuning[ model ] or {}

	for key, c_value in pairs( allowedTuning ) do

		if (type( c_value ) == 'function' and c_value(vehicle)) or (type( c_value ) ~= 'function' and c_value) then

			if Config.defaultTuning[key] then

				table.insert(tuningSections, {

					key = key,
					config_link = {'defaultTuning', key, 'components'},

					name = Config.tuningSectionNames[ key ].name,

					data = Config.defaultTuning[key],

					sortBy = Config.defaultTuning[key].sortBy,
					toggle = Config.defaultTuning[key].toggle,

					value_type = Config.defaultTuning[key].value_type or 'default',
					type = 'default',

					-- components =
					-- 	key == 'paint' and
					-- 	getAllowedComponents( vehicle, table.copy( Config.defaultTuning[key].components ) ) or
					-- 	table.copy( Config.defaultTuning[key].components ),

					components = getAllowedComponents( vehicle, table.copy( Config.defaultTuning[key].components ) ),

				})

			end
			
		end


	end

	for key, components in pairs( componentsTuning ) do

		local visible, non_standard = {}, {}

		for index, component in pairs( components ) do
			if component.show ~= false then
				visible[index] = component

				if not component.default then
					non_standard[index] = component
				end

			end
		end

		if getTableLength(non_standard) > 0 then
			table.insert(tuningSections, {

				key = key,
				config_link = {'componentsTuning', model, key},

				name = Config.tuningSectionNames[ key ] and Config.tuningSectionNames[ key ].name or key,

				value_type = 'default',
				type = 'component',
				components = table.copy( visible ),

			})
		end


	end

	return tuningSections

end

function findTuningComponent(link)

	local result = Config

	for _, nextDir in pairs( link ) do
		result = result[nextDir]
	end

	return result

end

function hasVehicleTuning(vehicle)

	local model = isElement(vehicle) and vehicle.model or vehicle
	if not tonumber(model) then return end

	return Config.componentsTuning[model] and true or false
	
end

function isTuningComponentCompatible(vehicle, section, component)

	local config = Config.componentsTuning[vehicle.model][section][component]

	local d_names = split(component, ' ')

	local flag = true

	for _, d_name in pairs( d_names ) do

		if not getVehicleComponentVisible(vehicle, d_name) then
			flag = false
			break
		end

	end

	if flag then

		if config and config.compatible_with then

			local flags = {}

			for _, c_component in pairs( config.compatible_with ) do

				local names = split(c_component, ' ')

				local _flag = true

				for _, name in pairs( names ) do

					if not getVehicleComponentVisible(vehicle, name) then
						_flag = false
						break
					end

				end

				table.insert(flags, _flag)

			end

			for _, flag in pairs( flags ) do
				if flag then return true end
			end

			return false

		end

	end


	return true

end

function checkTuningCompatibility(vehicle)

	local config = Config.componentsTuning[vehicle.model]

	if config then

		for section, components in pairs( config ) do

			for component in pairs( components ) do

				if not isTuningComponentCompatible(vehicle, section, component) then
					return false
				end

			end

		end

	end

	return true

end