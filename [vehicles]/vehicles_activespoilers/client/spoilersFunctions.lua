
local componentPositions = {}
local componentRotations = {}

function saveSpoilerPosition(v, name)
    local model = getElementModel(v)
    if componentPositions[model] and componentPositions[model][name] then
    	return componentPositions[model][name]
	end
    resetVehicleComponentPosition(v, name)
    componentPositions[model] = componentPositions[model] or {}
    componentPositions[model][name] = {getVehicleComponentPosition(v, name)}
    return componentPositions[model][name]
end

function saveSpoilerRotation(v, name)
    local model = getElementModel(v)
    if componentRotations[model] and componentRotations[model][name] then
    	return componentRotations[model][name]
	end
    resetVehicleComponentRotation(v, name)
    componentRotations[model] = componentRotations[model] or {}
    componentRotations[model][name] = {getVehicleComponentRotation(v, name)}
    return componentRotations[model][name]
end

spoilersFunctions = {


	[506]={1000, function(v, step)
		for k,v1 in pairs({'spoiler_wing', 'spoiler_bar'}) do
			local spoilerName = v1
			local defaultPos = saveSpoilerPosition(v, spoilerName)
			local defaultRot = saveSpoilerRotation(v, spoilerName)

			setVehicleComponentPosition(v, spoilerName,
				defaultPos[1],
				defaultPos[2] - step*0.18,
				defaultPos[3] + step*0.3
			)

			setVehicleComponentRotation(v, spoilerName,
				defaultRot[1] + 10*step,
				defaultRot[2],
				defaultRot[3]
			)
		end
	end},

	[561]={1000, function(v, step)

		if getVehicleComponentVisible( v, 'spoiler1' ) then step = 0 end

		for _, spoilerName in pairs({'spoiler0'}) do

			local defaultPos = saveSpoilerPosition(v, spoilerName)
			local defaultRot = saveSpoilerRotation(v, spoilerName)

			setVehicleComponentPosition(v, spoilerName,
				defaultPos[1],
				defaultPos[2] - step*0.12,
				defaultPos[3] + step*0.27
			)

			setVehicleComponentRotation(v, spoilerName,
				defaultRot[1] + 10*step,
				defaultRot[2],
				defaultRot[3]
			)

		end

	end},

	[559]={1000, function(v, step)
		local tuning = getElementData(v, 'tuning') or {}
		if tuning['spoilers'] then return end

		local spoilerName,defaultPos,defaultRot
		local names = {
			['movspoiler']={0.1, -20, 0}
		}

		for k1,v1 in pairs(names) do
			spoilerName = k1
			defaultPos = saveSpoilerPosition(v, spoilerName)
			defaultRot = saveSpoilerRotation(v, spoilerName)

			setVehicleComponentPosition(v, spoilerName,
				defaultPos[1],
				defaultPos[2] + v1[3]*step,
				defaultPos[3] + v1[1]*step
			)

			setVehicleComponentRotation(v, spoilerName,
				defaultRot[1] - v1[2]*step,
				defaultRot[2],
				defaultRot[3]
			)
		end
	end},

	[536]={1000, function(v, step)
		local tuning = getElementData(v, 'tuning') or {}
		if tuning['spoilers'] then return end

		local spoilerName,defaultPos,defaultRot
		spoilerName = 'movspoiler'
		defaultPos = saveSpoilerPosition(v, spoilerName)
		defaultRot = saveSpoilerRotation(v, spoilerName)

		setVehicleComponentRotation(v, spoilerName,
			defaultRot[1] + 20*step,
			defaultRot[2],
			defaultRot[3]
		)

	end},

	[545]={1000, function(v, step)
		local spoilerName = 'Spoiler123'
		local defaultPos = saveSpoilerPosition(v, spoilerName)
		setVehicleComponentPosition(v, spoilerName,
			defaultPos[1],
			defaultPos[2] - step * 0.1,
			defaultPos[3] + step*0.2
		)
	end},


	[409]={1000, function(v, step)
		local spoilerName = 'spoiler_wing'
		local defaultPos = saveSpoilerPosition(v, spoilerName)
		local defaultRot = saveSpoilerRotation(v, spoilerName)

		setVehicleComponentPosition(v, spoilerName,
			defaultPos[1],
			defaultPos[2],
			defaultPos[3] + step*0.05
		)

		setVehicleComponentRotation(v, spoilerName,
			defaultRot[1] -20*step,
			defaultRot[2],
			defaultRot[3]
		)
	end},



	[565]={1000, function(v, step)

		for _, spoilerName in pairs( {'movspoiler_15.0_1000', 'movspoiler_15.0_1000_re'} ) do

			local defaultPos = saveSpoilerPosition(v, spoilerName)
			setVehicleComponentPosition(v, spoilerName,
				defaultPos[1],
				defaultPos[2] - step * 0.1,
				defaultPos[3] + step*0.1
			)

		end

	end},

}