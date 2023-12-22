
Config = {}

Config.items = {
	{
		item = 'food_1',
		cost = 50,
	},
	{
		item = 'food_2',
		cost = 100,
	},
	{
		item = 'food_3',
		cost = 200,
	},
	{
		item = 'food_4',
		cost = 250,
	},
	{
		item = 'food_5',
		cost = 300,
	},
	{
		item = 'food_6',
		cost = 350,
	},
	{
		item = 'food_7',
		cost = 400,
	},
	{
		item = 'food_8',
		cost = 500,
	},
}

Config.shops = {
	{ position = { 386.47, -1901.97, 6.84, 0, }, int = 0, dims = {0, 0}, blip = true },
	{ position = { 927.03, -1352.86, 12.38, 0, }, int = 0, dims = {0, 0}, blip = true },
	{ position = { 1207.93, -919, 42.06, 0, }, int = 0, dims = {0, 0}, blip = true },
	{ position = { 2466.24, 2033.19, 10.06, 0, }, int = 0, dims = {0, 0}, blip = true },
	-- { position = { 2392.49, 2042.69, 9.82, 0, }, int = 0, dims = {0, 0}, blip = true },
	{ position = { 1878.73, 2072.57, 10.06, 0, }, int = 0, dims = {0, 0}, blip = true },
	{ position = { -2189.66, 1681.8, 6.01, 0, }, int = 0, dims = {0, 0}, blip = true },
	{ position = { -1693.15, 1221.76, 32.21, 0, }, int = 0, dims = {0, 0}, blip = true },
	{ position = { -1993.85, 93.83, 26.76, 0, }, int = 0, dims = {0, 0}, blip = true },
}

function getConfigSetting(index)
	return Config[index]
end

function setConfigSetting(index, value)
	Config[name] = value
end