
local models = {
	-- ['camomile'] = 1174,
	-- ['tulip'] = 1175,
	-- ['rose'] = 1176,
	-- ['car'] = 598,
	-- ['Cadillac_Escalade'] = 579,
	-- ['BMW_X6M'] = 400,
	-- ['Toyota_Camry_V40'] = 529,
	-- ['Toyota_Camry_V55'] = 585,
	-- ['Toyota_Camry_V50'] = 477,
	-- ['370'] = 400,
	-- ['Toyota_Camry'] = 426,
	-- ['f10'] = 507,
	-- ['Golf'] = 580,
	-- ['gt63'] = 438,
	-- ['x5m'] = 477,
	-- ['760li'] = 507,

	[':temp_models/models/roulette_base'] = 3026,
	[':engine/assets/models/casino/roulette_ball'] = 3025,
	[':engine/assets/models/casino/roulette_wheel'] = 3027,
	[':engine/assets/models/casino/roulette_chip'] = 3024,
	-- ['Bentley_Continental'] = 549,

	-- ['VAZ_2109_2'] = 466,
	-- ['MORGENSHTERN'] = 21,
	-- ['Lamborghini_Huracan'] = 415,
}


for path, model in pairs(models) do
	exports.engine:replaceModel(path, model, { txd = ':engine/assets/models/casino/roulette' })
end
