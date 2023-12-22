
exports.engine:replaceModel(':mapping_autosalon/models/salon', 9582)
exports.engine:replaceModel(':mapping_autosalon/models/salon', 9755)
engineSetModelLODDistance(9582, 200)
engineSetModelLODDistance(9755, 800)

if fileExists(':mapping_autosalon/models/salon.dff') then
	fileDelete(':mapping_autosalon/models/salon.dff')
end