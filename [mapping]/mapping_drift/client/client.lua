
for i in pairs(Config.objects) do

	local txd = ':mapping_drift/assets/models/main'

	exports.engine:replaceModel(':mapping_drift/assets/models/' .. i, Config.objects[i].model, { txd = txd } )
	exports.engine:replaceModel(':mapping_drift/assets/models/' .. i, Config.objects[i].lod, { txd = txd } )

	engineSetModelLODDistance(Config.objects[i].lod, 1000)
	engineSetModelLODDistance(Config.objects[i].model, 200)

	local op = (':mapping_drift/assets/models/' .. i .. '.dff')
	if fileExists(op) then
		fileDelete(op)
	end

end