Config = {}


Config.markers = {

	{
		position = { 1884.86, 2232.63, 10.82, 0, 0, 0 },
		exit = { 1888.73, 2228.6, 11.82, -0, 0, 178.98 },
		blip = true,
		dim = 0,
	},
	{
		position = { 1878.96, 2232.63, 10.82, 0, 0, 0 },
		exit = { 1888.73, 2228.6, 11.82, -0, 0, 178.98 },
		blip = false,
		window = 'vinils',
		dim = 0,
	},

	{
		position = { 548.73, -1295.98, 17.23 },
		exit = { 538.89, -1296.05, 17.83, 0, 0, 6.98 },
		blip = true,
		dim = 0,
	},
	{
		position = { 554.25, -1294.74, 17.23 },
		exit = { 538.89, -1296.05, 17.83, 0, 0, 6.98 },
		blip = false,
		window = 'vinils',
		dim = 0,
	},

	{
		position = { -2341.07, -147.3, 35.32 },
		exit = { -2316.61, -154.59, 35.32, 0, 0, 180 },
		blip = true,
		dim = 0,
	},
	{
		position = { -2335.29, -147.3, 35.32 },
		exit = { -2316.61, -154.59, 35.32, 0, 0, 180 },
		blip = false,
		window = 'vinils',
		dim = 0,
	},
}

Config.interior = {
	pos = { 40.32, -6.71, 987.22, 90 },
	interior = 0,
	object = {40, 0, 990, 0},
}

Config.paintTypes = {
	{name = 'color_1', cost = 100000, text = 'Покраска кузова'},
	{name = 'color_2', cost = 100000, text = 'Дополнительный цвет'},
	{name = 'color_3', cost = 100000, text = 'Дополнительный цвет'},
	{name = 'wheels_color', cost = 100000, text = 'Цвет дисков'},
	{name = 'color_cover', cost = 100000, text = 'Цвет блика'},
	{name = 'color_smoke', cost = 250000, text = 'Дым от шин'},
	-- [6] = {name = 'color_neon', cost = 250000, text = 'Цвет неона'},
}

Config.coverTypes = {
	[1] = {name = 'default', cost = 0, text = 'Стандартное покрытие'},
	[2] = {name = 'chrome', cost = 800000, text = 'Хром'},
	[3] = {name = 'perlamutr', cost = 700000, text = 'Металлик'},
	-- [4] = {name = 'chameleon', cost = 123234, text = 'Хамелеон'},
	[4] = {name = 'mat', cost = 300000, text = 'Матовое покрытие'},
}

Config.paintCosts = {}

for name, section in pairs( { color=Config.paintTypes, cover=Config.coverTypes } ) do
	for _, type in pairs(section) do
		Config.paintCosts[name .. '_' .. type.name] = type.cost
	end
end

Config.vinilRTSize = 2048

Config.tint = {
	front = { cost = 15000, textures = {'lob_steklo', 'toner1'}, name = 'Переднее стекло', },
	side = {cost = 15000, textures = {'pered_steklo', 'toner2'}, name = 'Боковое стекло',},
	rear = {cost = 15000, textures = {'zad_steklo', 'toner3'}, name = 'Заднее стекло',},
	light_glass = {cost = 15000, textures = {'glass_light_0'}, name = 'Тонировка фар', power=1, coef = 0.9, check_access = true},
}

Config.validTypes = {
	Automobile = true,
	Bike = true,
}

function getConfigSetting(name)
	return Config[name]
end

Config.vinilBrightness = 0.6