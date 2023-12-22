
for i = 1, Config.floorsCount+1 do
	createObject( Config.byInteriorModel, unpack(Config.interiorPos) ).dimension = i
end
