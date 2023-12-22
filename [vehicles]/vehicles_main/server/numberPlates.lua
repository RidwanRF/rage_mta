
function checkPlateExists(plate)

	-- local data = dbPoll(dbQuery(db, string.format('SELECT * FROM vehicles WHERE plate="%s";',
	-- 	plate
	-- )), -1)

	-- local numbers_data = dbPoll(dbQuery(db, string.format('SELECT * FROM numbers WHERE plate="%s";',
	-- 	plate
	-- )), -1)

	-- local used_data = dbPoll(dbQuery(db, string.format('SELECT * FROM usedauto WHERE plate="%s";',
	-- 	plate
	-- )), -1)

	return (data and data[1]) or (numbers_data and numbers_data[1]) or (used_data and used_data[1])
end

function nomerIs000(plate)
	return (tonumber( string.sub(plate, 4, 6) ) == 0)
end
function nomerIs0000(plate)
	return (tonumber( string.sub(plate, 3, 6) ) == 0)
end

function generatePlate(plateType, selectedRegion)
	local licCh = {"a", "b", "e", "k", "m", "h", "o", "p", "c", "t", "y", "x"}
	local licReg = {50,150,750, 77,177,777, 90,190,790, 97,197,797, 99,199,799}
	local newPlate
	if (not plateType) or (plateType == "a") then
		repeat
			local region = selectedRegion or licReg[math.random(#licReg)]
			if (region < 100) then
				newPlate = string.format("a-%s%i%i%i%s%s%02i", licCh[math.random(#licCh)], math.random(0,9), math.random(0,9), math.random(0,9), licCh[math.random(#licCh)], licCh[math.random(#licCh)], region)
			else
				newPlate = string.format("a-%s%i%i%i%s%s%03i", licCh[math.random(#licCh)], math.random(0,9), math.random(0,9), math.random(0,9), licCh[math.random(#licCh)], licCh[math.random(#licCh)], region)
			end
		until (not nomerIs000(newPlate)) and (not checkPlateExists(newPlate)) -- Истина - выход из цикла
		return newPlate
		
	elseif (plateType == "b") then
		return string.format("b-%s%i%i%i%i%02i", licCh[math.random(#licCh)], math.random(0,9), math.random(0,9), math.random(0,9), math.random(0,9), string.sub(licReg[math.random(#licReg)], -2, -1))
		
	elseif (plateType == "c") then
		repeat
			local region = string.sub( (selectedRegion or licReg[math.random(#licReg)]), -2, -1)
			newPlate = string.format("c-%i%i%i%i%s%s%02i", math.random(0,9), math.random(0,9), math.random(0,9), math.random(0,9), licCh[math.random(#licCh)], licCh[math.random(#licCh)], region)
		until (not nomerIs0000(newPlate)) and (not checkPlateExists(newPlate)) -- Истина - выход из цикла
		return newPlate
		
	elseif (plateType == "i") then
		return "i-"..licCh[math.random(#licCh)]..licCh[math.random(#licCh)]..math.random(0,9)..math.random(0,9)..math.random(0,9)..string.sub(licReg[math.random(#licReg)], -2, -1)
		
	elseif (plateType == "boat") then
		return "h-Boat"
		
	elseif (plateType == "helicopter") then
		return "h-Helicopter"
		
	end
end

function generateVehiclePlate(model, region)

	local vehicleType = getVehicleType(model)
	local licensePlate

	if (vehicleType == "Bike") or (vehicleType == "Quad") or (vehicleType == "BMX") then
		licensePlate = generatePlate("c", region)
	elseif (vehicleType == "Boat") then
		licensePlate = generatePlate("boat")
	elseif (vehicleType == "Helicopter") then
		licensePlate = generatePlate("helicopter")
	else
		licensePlate = generatePlate("a", region)
	end

	return licensePlate
end