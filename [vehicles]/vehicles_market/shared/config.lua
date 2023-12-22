

loadstring( exports['core']:include('common'))()

Config = {}

Config.destroy_cost_percent = 70

Config.start_dim = 1

Config.rentDays = 7
Config.rentCost = 30000
Config.sellComission = 1

local slots = {

	{ position = { 8.48, -16.27, 12.4, }, rotation = {0, 0, 270,}, dimension = 0, interior = 0 },
	-- { position = { 8.48, -57.87, 12.4, }, rotation = {0, 0, 270,}, dimension = 0, interior = 0 },
	{ position = { 8.48, -53.47, 12.4, }, rotation = {0, 0, 270,}, dimension = 0, interior = 0 },
	-- { position = { 8.48, -48.87, 12.4, }, rotation = {0, 0, 270,}, dimension = 0, interior = 0 },
	{ position = { 8.48, -44.37, 12.4, }, rotation = {0, 0, 270,}, dimension = 0, interior = 0 },
	-- { position = { 8.48, -39.67, 12.4, }, rotation = {0, 0, 270,}, dimension = 0, interior = 0 },
	{ position = { 8.48, -34.87, 12.4, }, rotation = {0, 0, 270,}, dimension = 0, interior = 0 },
	-- { position = { 8.48, -29.97, 12.4, }, rotation = {0, 0, 270,}, dimension = 0, interior = 0 },
	{ position = { 8.48, -25.47, 12.4, }, rotation = {0, 0, 270,}, dimension = 0, interior = 0 },
	-- { position = { 8.48, -20.87, 12.4, }, rotation = {0, 0, 270,}, dimension = 0, interior = 0 },

	-- { position = { 30.15, -16.27, 12.4, }, rotation = {0, 0, 90,}, dimension = 0, interior = 0 },
	{ position = { 30.15, -57.87, 12.4, }, rotation = {0, 0, 90,}, dimension = 0, interior = 0 },
	-- { position = { 30.15, -53.47, 12.4, }, rotation = {0, 0, 90,}, dimension = 0, interior = 0 },
	{ position = { 30.15, -48.87, 12.4, }, rotation = {0, 0, 90,}, dimension = 0, interior = 0 },
	-- { position = { 30.15, -44.37, 12.4, }, rotation = {0, 0, 90,}, dimension = 0, interior = 0 },
	{ position = { 30.15, -39.67, 12.4, }, rotation = {0, 0, 90,}, dimension = 0, interior = 0 },
	-- { position = { 30.15, -34.87, 12.4, }, rotation = {0, 0, 90,}, dimension = 0, interior = 0 },
	{ position = { 30.15, -29.97, 12.4, }, rotation = {0, 0, 90,}, dimension = 0, interior = 0 },
	-- { position = { 30.15, -25.47, 12.4, }, rotation = {0, 0, 90,}, dimension = 0, interior = 0 },
	{ position = { 30.15, -20.87, 12.4, }, rotation = {0, 0, 90,}, dimension = 0, interior = 0 },

}

Config.slots = {}

Config.markers = {
	{ 2621.09, 1238.52, 9.92 },
}
Config.destroy_markers = {
	{ 2640.28, 1174.31, 9.92 },
	{ 134.34, -1928.97, 0.04, 0, },
}

Config.byInteriorModel = 1170
-- Config.byInteriorModel = 1089
Config.interiorPos = { 19.43, -37.54, 13.92, }

Config.floorsCount = 40
-- Config.floorsCount = 20

Config.exitKey = 'tab'

for i = 1, Config.floorsCount do

	for _, slot in pairs( slots ) do

		local data = table.copy(slot)
		data.dimension = Config.start_dim + (i-1)

		table.insert(Config.slots, data)

	end

end

Config.floors = {
	[0] = { position = { coords = { 2622.19, 1205.7, 9.92 }, int = 0, dim = 0 }, },
}

local other_floor = { 19.73, -58.21, 11.81 }

for i = 1, Config.floorsCount do
	table.insert( Config.floors, { position = { coords = other_floor, int = 0, dim = Config.start_dim + (i-1) } } )
end