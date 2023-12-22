Config = {}

Config.auction = {
	-- { 2784.16, -2534.05, 12.64, 90, },
	-- { 2784.16, -2549.99, 12.64, 90, },
	{ 2784.16, -2546.15, 12.64, 90, },
	{ 2784.16, -2542.05, 12.64, 90, },
	{ 2784.16, -2538.15, 12.64, 90, },
}

Config.cran = {
	
	base = { 2807.265625,-2521.4921875,20.015625 },
	tower = { 2807.265625,-2521.4921875,20.015625 },

}

Config.displayPosition = {
	-- { 2789.57, -2533.98, 13.43, 90, },
	-- { 2789.57, -2550.08, 13.43, 90, },
	{ 2789.57, -2546.18, 13.43, 90, },
	{ 2789.57, -2541.98, 13.43, 90, },
	{ 2789.57, -2537.98, 13.43, 90, },
}

Config.matrix = { 2777.76, -2549.85, 14.7, 2850.13, -2483.96, -5.8, 0, 70 }

Config.movie = {
	
	from = 104,
	to = 320,

}

Config.cranMovieTime = 40000


-- Config.spawnFrequency = 15*60*1000
Config.auctionTime = 2*60*1000
Config.spawnHours = { [16] = true, [18] = true, [21] = true, [20] = true, }

Config.auction_items = {}

---------------------------------------------------

	loadstring( exports.core:include('common'))()

---------------------------------------------------

	local vehiclesList = exports.vehicles_main:getVehiclesList()

	local minCost = 80000
	local maxCost = 1100000
	local minBetPercentRange = { 50, 65 }
	local sellCostPercent = 70

	for model, vehicle in pairs( vehiclesList ) do

		if isBetween( vehicle.cost, minCost, maxCost ) and getVehicleType(model) == 'Automobile' and not vehicle.noSell then

			local item = {

				type = 'vehicle',
				name = vehicle.mark .. ' ' .. vehicle.name,

				icon = (':vehicles_shop/assets/images/vehicles/%s.png'):format( model ),

				min_bet = {
					math.floor( vehicle.cost * minBetPercentRange[1]/100 ),
					math.floor( vehicle.cost * minBetPercentRange[2]/100 ),
				},

				min_bet_delta = 2000,
				max_bet_delta = 50000,
				sell_cost = math.floor( vehicle.cost * sellCostPercent/100 ),

				model = model,

				give = function( self, player )

					exports.vehicles_main:giveAccountVehicle( player.account.name, self.model, {
						appearance_upgrades = {
							color_1 = RGBToHex(255,255,255),
							color_2 = RGBToHex(255,255,255),
						},
					} )

					exports.main_freeroam:addBoughtCar( player.account.name, self.model )

				end,

				create_display = function( self, position )

					local x,y,z,r = unpack(position)
					local vehicle = createVehicle( self.model, x,y,z, 0, 0, r )
					setVehicleColor(vehicle, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255)

					return vehicle

				end,

			}

			table.insert(Config.auction_items, item)

		end


	end

---------------------------------------------------