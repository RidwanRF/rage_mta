
function convertNumberplateToText(plateID)
	if (not plateID) then return "" end
	local licensep
	local test = string.sub(plateID, 1, 1)
	if (test == "a") or (test == 'k') then
		licensep = "|"..strRep(string.sub(plateID, 3, 8)).."|"..string.sub(plateID, 9, 11).."|"
	elseif (test == "b") then
		licensep = "|"..strRep(string.sub(plateID, 3, 7)).."|"..string.sub(plateID, 8, 10).."|"
	elseif (test == "c") then
		licensep = "|"..string.sub(plateID, 3, 6).."|"..strRep(string.sub(plateID, 7, 8)).."|"..string.sub(plateID, 9, 10).."|"
	elseif (test == "d") then
		licensep = "|"..string.sub(plateID, 3, 6).."|"..strRep(string.sub(plateID, 7, 7)).." |"..string.sub(plateID, 8, 9).."|"
	elseif (test == "e") then
		licensep = "|"..string.sub(plateID, 3, 8).."|"..string.sub(plateID, 9, 10).."|"
	elseif (test == "f") then
		licensep = "|"..string.sub(plateID, 3, 4).." "..string.sub(plateID, 5, 8).." "..string.sub(plateID, 9, 10).."|"
	elseif (test == "g") then
		licensep = "|"..string.sub(plateID, 3, 6).." "..string.sub(plateID, 7, 8).."-"..string.sub(plateID, 9, 9).."|"
	elseif (test == "h") or test == 'n' or test == 'm' or test == 'p' or test == 'q' then
		licensep = "|·"..string.sub(plateID, 3, string.len(plateID)).."·|"
	elseif (test == "i") then
		licensep = "|"..strRep(string.sub(plateID, 3, 7)).."|"..string.sub(plateID, 8, 9).."|"	
	elseif (test == "j") then
		licensep = "|"..strRep(string.sub(plateID, 3, 8)).."|ФЛ|"
	elseif (test == "o") then
		licensep = "|"..strRep(string.sub(plateID, 3, 9)).."|"..string.sub(plateID, 10, 12).."|ДП|"
	else
		return ""
	end
	return licensep
end

function getNumberType(vehicle)

	local plate

	if isElement(vehicle) then
		plate = vehicle:getData('plate')
	else
		plate = vehicle
	end

	if plate then
		local nType = string.sub(plate, 1, 1)
		return nType
	else
		return false
	end
end

function strRep(str)
	str = string.gsub(str, "b", "в")
	str = string.gsub(str, "k", "к")
	str = string.gsub(str, "m", "м")
	str = string.gsub(str, "h", "н")
	str = string.gsub(str, "t", "т")
	return str
end

function isPlateCorrect(nomer)
	local test = string.sub(nomer, 1, 1)
	if (test == "a") or (test == 'k') then
		local shNomer = string.sub(nomer, 3, 8)
		local region = string.sub(nomer, 9)
		return checkNomerA(shNomer, region)
		
	elseif (test == "b") then
		return true
		
	elseif (test == "c") then
		local shNomer = string.sub(nomer, 3, 8)
		local region = string.sub(nomer, 9)
		return checkNomerC(shNomer, region)
		
	elseif (test == "d") then
		return true
		
	elseif (test == "e") then
		local shNomer = string.sub(nomer, 3, 8)
		local region = string.sub(nomer, 9)
		return checkNomerE(shNomer, region)
		
	elseif (test == "f") then
		local shNomer = string.sub(nomer, 3)
		return checkNomerF(shNomer)
		
	elseif (test == "g") then
		local shNomer = string.sub(nomer, 3)
		return checkNomerG(shNomer)
		
	elseif (test == "h") or test == 'm' or test == 'n' or test == 'p' or test == 'q' then
		local shNomer = string.sub(nomer, 3)
		return checkNomerH(shNomer)
		
	elseif (test == "j") then
		local shNomer = string.sub(nomer, 3)
		return checkNomerJ(shNomer)
		
	elseif (test == "l") then
		local shNomer = string.sub(nomer, 3)
		return checkNomerL(shNomer)
		
	elseif (test == "o") then
		local shNomer = string.sub(nomer, 3, 9)
		local region = string.sub(nomer, 10)
		return checkNomerO(shNomer, region)
		
	else
		return false
	end
end

numberExamples = {
	['a'] = 'a123aa123',
	['b'] = '',
	['c'] = '1234aa77',
	['d'] = '',
	['e'] = '208DPA09',
	['f'] = 'AH2413IP',
	['g'] = '1234AB7',
	['h'] = 'RAGE',
	['m'] = 'RAGE',
	['n'] = 'RAGE',
	['i'] = '',
	['j'] = 'a111aa',
	['k'] = 'a123aa123',
	['o'] = '111d555777',
}

local regOf3 = {
	[102] = true, [103] = true, [109] = true, [113] = true, [116] = true, [118] = true,
	[121] = true, [123] = true, [124] = true, [125] = true, [134] = true, [136] = true, [138] = true,
	[142] = true, [150] = true, [152] = true, [154] = true, [159] = true, [161] = true, [163] = true,
	[164] = true, [173] = true, [174] = true, [177] = true, [178] = true, [186] = true, [190] = true,
	[196] = true, [197] = true, [198] = true, [199] = true, [716] = true, [750] = true, [763] = true, [777] = true,
	[790] = true, [797] = true, [799] = true, 
}

local allowedBukv = {
	["a"] = true, ["b"] = true, ["e"] = true, ["k"] = true, ["m"] = true, ["h"] = true, ["o"] = true,
	["p"] = true, ["c"] = true, ["t"] = true, ["y"] = true, ["x"] = true
}
local allowedCifr = {
	["0"] = true, ["1"] = true, ["2"] = true, ["3"] = true, ["4"] = true,
	["5"] = true, ["6"] = true, ["7"] = true, ["8"] = true, ["9"] = true
}

local allowedUkrAndByel = {
	["A"] = true, ["B"] = true, ["E"] = true, ["I"] = true, ["K"] = true, ["M"] = true, ["H"] = true,
	["O"] = true, ["P"] = true, ["C"] = true, ["T"] = true, ["X"] = true
}

local allowedKazakh = {
	["A"] = true, ["B"] = true, ["C"] = true, ["D"] = true, ["E"] = true, ["F"] = true, ["G"] = true,
	["H"] = true, ["I"] = true, ["J"] = true, ["K"] = true, ["L"] = true, ["M"] = true, ["N"] = true,
	["O"] = true, ["P"] = true, ["Q"] = true, ["R"] = true, ["S"] = true, ["T"] = true, ["U"] = true,
	["V"] = true, ["W"] = true, ["X"] = true, ["Y"] = true, ["Z"] = true,
}

-- for letter in pairs(allowedUkrAndByel) do
-- 	allowedUkrAndByel[letter:lower()] = true
-- 	allowedUkrAndByel[letter] = nil
-- end
-- for letter in pairs(allowedKazakh) do
-- 	allowedKazakh[letter:lower()] = true
-- 	allowedKazakh[letter] = nil
-- end

local allowedForH = {
	-- Цифры
	"1", "2", "3", "4", "5", "6", "7", "8", "9", "5", 
	-- Латинские буквы
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", 
	"K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", 
	"U", "V", "W", "X", "Y", "Z", 
	"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", 
	"k", "l", "m", "n", "o", "p", "q", "r", "s", "t", 
	"u", "v", "w", "x", "y", "z", 
	-- Символы
	"!", "@", "#", "$", "%", "^", "&", "*", "(", ")", 
	"-", "_", "=", "+", "[", "]", "{", "}", "/", "|",
	";", ":", "'", "<", ">", ",", ".", "?", "\\", "\"",
	" ", "\t",
}
local tempArray = {}
for _, value in ipairs(allowedForH) do
	tempArray[string.byte(value)] = true
end
allowedForH = tempArray
tempArray = nil

function isSymbolPossible(type, symbol)
	if type == 'k' or type == 'j' or type == 'a' or type == 'c' then
		return allowedBukv[symbol] or allowedCifr[symbol]
	elseif type == 'f' or type == 'g' or type == 'o' then
		return allowedUkrAndByel[symbol] or allowedCifr[symbol]
	elseif type == 'e' then
		return allowedKazakh[symbol] or allowedCifr[symbol]
	elseif type == 'h' or type == 'm' or type == 'n' then
		return allowedForH[string.byte(symbol)]
	end
end

function checkNomerA(nomer, region)		-- Российский номер
	if (not nomer) or (not region) then return false end
	local nomerLength = string.len(nomer)
	local regionLength = string.len(region)
	local nNomer = tonumber( string.sub(nomer, 2, 4) )
	local nRegion = tonumber(region)
	local b1, b2, b3 = string.sub(nomer, 1, 1), string.sub(nomer, 5, 5), string.sub(nomer, 6, 6)
	local c1, c2, c3 = string.sub(nomer, 2, 2), string.sub(nomer, 3, 3), string.sub(nomer, 4, 4)
	local r1, r2, r3 = string.sub(region, 1, 1), string.sub(region, 2, 2), string.sub(region, 3, 3)
	if (r3 == "") then r3 = "0" end
	
	if (nomerLength < 1) or (nomerLength > 6) then return false end
	if (regionLength < 2) or (regionLength > 3) then return false end
	if (not nNomer) or (not nRegion) then return false end
	if (nNomer == 0) or (nRegion == 0) then return false end
	if (nRegion > 99) and (not regOf3[nRegion]) then return false end
	if (nRegion < 100) and (string.len(region) > 2) then return false end
	if not (allowedCifr[r1] and allowedCifr[r2] and allowedCifr[r3]) then return false end
	if not (allowedBukv[b1] and allowedBukv[b2] and allowedBukv[b3]) then return false end
	if not (allowedCifr[c1] and allowedCifr[c2] and allowedCifr[c3]) then return false end
	return true	
end

function checkNomerO(nomer, region)		-- Российский номер
	if (not nomer) or (not region) then return false end
	local nomerLength = string.len(nomer)
	local regionLength = string.len(region)
	local nNomer1 = tonumber( string.sub(nomer, 1, 3) )
	local nNomer2 = tonumber( string.sub(nomer, 5, 7) )
	local nRegion = tonumber(region)
	local b1 = string.sub(nomer, 4, 4)
	local c1, c2, c3 = string.sub(nomer, 1, 1), string.sub(nomer, 2, 2), string.sub(nomer, 3, 3)
	local c4, c5, c6 = string.sub(nomer, 5, 5), string.sub(nomer, 6, 6), string.sub(nomer, 7, 7)
	local r1, r2, r3 = string.sub(region, 1, 1), string.sub(region, 2, 2), string.sub(region, 3, 3)
	if (r3 == "") then r3 = "0" end
	
	if (nomerLength < 1) or (nomerLength > 7) then return false end
	if (regionLength < 2) or (regionLength > 3) then return false end

	if (not nNomer1) or (not nRegion) or (not nNomer2) then return false end
	if (nNomer1 == 0) or (nRegion == 0) or (nNomer2 == 0) then return false end

	if (nRegion > 99) and (not regOf3[nRegion]) then return false end
	if (nRegion < 100) and (string.len(region) > 2) then return false end

	if not (allowedCifr[r1] and allowedCifr[r2] and allowedCifr[r3]) then return false end
	if not (allowedBukv[b1]) then return false end

	if not (
		allowedCifr[c1] and allowedCifr[c2] and allowedCifr[c3]
		and allowedCifr[c4] and allowedCifr[c5] and allowedCifr[c6]
	) then return false end

	return true	
end

function checkNomerJ(nomer)		-- федерал
	if (not nomer) then return false end
	local nomerLength = string.len(nomer)
	local b1, b2, b3 = string.sub(nomer, 1, 1), string.sub(nomer, 5, 5), string.sub(nomer, 6, 6)
	local c1, c2, c3 = string.sub(nomer, 2, 2), string.sub(nomer, 3, 3), string.sub(nomer, 4, 4)
	
	if (nomerLength ~= 6) then return false end
	if not (allowedBukv[b1] and allowedBukv[b2] and allowedBukv[b3]) then return false end
	if not (allowedCifr[c1] and allowedCifr[c2] and allowedCifr[c3]) then return false end
	return true	
end

function checkNomerL(nomer)		-- reborn
	if (not nomer) then return false end
	local nomerLength = string.len(nomer)
	local c1, c2, c3 = string.sub(nomer, 1, 1), string.sub(nomer, 2, 2), string.sub(nomer, 3, 3)
	
	if (nomerLength ~= 3) then return false end
	if not (allowedCifr[c1] and allowedCifr[c2] and allowedCifr[c3]) then return false end
	return true	
end

function checkNomerC(nomer, region)		-- Мотоциклетный номер
	if (not nomer) or (not region) then return false end
	local nomerLength = string.len(nomer)
	local regionLength = string.len(region)
	local nNomer = tonumber( string.sub(nomer, 1, 4) )
	local nRegion = tonumber(region)
	local b1, b2 = string.sub(nomer, 5, 5), string.sub(nomer, 6, 6)
	local c1, c2, c3, c4 = string.sub(nomer, 1, 1), string.sub(nomer, 2, 2), string.sub(nomer, 3, 3), string.sub(nomer, 4, 4)
	local r1, r2, r3 = string.sub(region, 1, 1), string.sub(region, 2, 2), string.sub(region, 3, 3)
	if (r3 == "") then r3 = "0" end
	
	if nomerLength ~= 6 then return false end
	if (regionLength ~= 2) then return false end
	if (not nNomer) or (not nRegion) then return false end
	if (nNomer == 0) or (nRegion == 0) then return false end	
	if (nRegion > 99) and (not regOf3[nRegion]) then return false end	
	if (nRegion < 100) and (string.len(region) > 2) then return false end
	if not (allowedCifr[r1] and allowedCifr[r2] and allowedCifr[r3]) then return false end
	if not (allowedBukv[b1] and allowedBukv[b2]) then return false end
	if not (allowedCifr[c1] and allowedCifr[c2] and allowedCifr[c3] and allowedCifr[c4]) then return false end
	return true	
end

function checkNomerE(nomer, region)		-- Номер Казахстана
	if (not nomer) or (not region) then return false end
	local nomerLength = string.len(nomer)
	local regionLength = string.len(region)
	local nNomer = tonumber( string.sub(nomer, 1, 3) )
	local nRegion = tonumber(region)
	local b1, b2, b3 = string.sub(nomer, 4, 4), string.sub(nomer, 5, 5), string.sub(nomer, 6, 6)
	local c1, c2, c3 = string.sub(nomer, 1, 1), string.sub(nomer, 2, 2), string.sub(nomer, 3, 3)
	local r1, r2 = string.sub(region, 1, 1), string.sub(region, 2, 2)
	
	if nomerLength ~= 6 then return false end
	if (regionLength ~= 2) then return false end
	if (not nNomer) or (not nRegion) then return false end
	if (nNomer == 0) or (nRegion == 0) then return false end
	if (nRegion > 16) then return false end
	if not (allowedCifr[r1] and allowedCifr[r2]) then return false end
	if not (allowedKazakh[b1] and allowedKazakh[b2] and allowedKazakh[b3]) then return false end
	if not (allowedCifr[c1] and allowedCifr[c2] and allowedCifr[c3]) then return false end
	return true	
end

function checkNomerF(nomer)		-- Украинский номер
	if (not nomer) then return false end
	local nomerLength = string.len(nomer)
	local nNomer = tonumber( string.sub(nomer, 3, 6) )
	local b1, b2, b3, b4 = string.sub(nomer, 1, 1), string.sub(nomer, 2, 2), string.sub(nomer, 7, 7), string.sub(nomer, 8, 8)
	local c1, c2, c3, c4 = string.sub(nomer, 3, 3), string.sub(nomer, 4, 4), string.sub(nomer, 5, 5), string.sub(nomer, 6, 6)
	
	if nomerLength ~= 8 then return false end
	if (not nNomer) then return false end
	if (nNomer == 0) then return false end
	if not (allowedUkrAndByel[b1] and allowedUkrAndByel[b2] and allowedUkrAndByel[b3] and allowedUkrAndByel[b4]) then return false end
	if not (allowedCifr[c1] and allowedCifr[c2] and allowedCifr[c3] and allowedCifr[c4]) then return false end
	return true	
end

function checkNomerG(nomer)		-- Белорусский
	if (not nomer) then return false end
	local nomerLength = string.len(nomer)
	local nNomer = tonumber( string.sub(nomer, 1, 4) )
	local nRegion = tonumber( string.sub(nomer, 7, 7) )
	local b1, b2 = string.sub(nomer, 5, 5), string.sub(nomer, 6, 6)
	local c1, c2, c3, c4 = string.sub(nomer, 1, 1), string.sub(nomer, 2, 2), string.sub(nomer, 3, 3), string.sub(nomer, 4, 4)
	
	if nomerLength ~= 7 then return false end
	if (not nNomer) or (not nRegion) then return false end
	if (nNomer == 0) or (nRegion == 0) then return false end
	if (nRegion > 8) then return false end
	if not (allowedUkrAndByel[b1] and allowedUkrAndByel[b2]) then return false end
	if not (allowedCifr[c1] and allowedCifr[c2] and allowedCifr[c3] and allowedCifr[c4]) then return false end
	return true	
end

function checkNomerH(nomer)		-- Надпись
	if (not nomer) then return false end
	
	local bytes = {string.byte(nomer, 1, -1)}
	for _, character in ipairs(bytes) do
		if (not allowedForH[character]) then
			return false
		end
	end
	return true	
end

function convertRusNomerToElements(nomer)
	local b1 = string.sub(nomer, 3, 3)
	local c1 = string.sub(nomer, 4, 4)
	local c2 = string.sub(nomer, 5, 5)
	local c3 = string.sub(nomer, 6, 6)
	local b2 = string.sub(nomer, 7, 7)
	local b3 = string.sub(nomer, 8, 8)
	local reg = tonumber(string.sub(nomer, 9, 11))
	return b1, b2, b3, c1, c2, c3, reg
end

function getPlateCost(newNomer, player)
	local filter = {}
	local prices = {}
	local donatePrices = {}
	local nomerType = string.sub(newNomer, 1, 1)
	
	if (nomerType == "a") or nomerType == 'k' then
		local bukv, cifr, region = {}, {}
		bukv[1], bukv[2], bukv[3], cifr[1], cifr[2], cifr[3], region = convertRusNomerToElements(newNomer)

		local add = 0
		if nomerType == 'k' then
			add = 70000
		end
	
		if (newNomer == "a-x777xx777") then																-- Уникальные
			table.insert(filter, "|х777хх|777|")
			table.insert(donatePrices, 1000)
		elseif (bukv[1] == bukv[2]) and (bukv[2] == bukv[3]) and (cifr[1] == cifr[2]) and (cifr[2] == cifr[3]) then
			table.insert(filter, "|zYYYzz|**| (все повторяющиеся буквы И цифры)")
			table.insert(prices, 280000 + add)
			table.insert(donatePrices, 800)
		-- elseif (bukv[1] == "p") and (bukv[2] == "h") and (bukv[3] == "a") and (region == 97) then
		-- 	table.insert(filter, "|р***на|97|")
		-- 	table.insert(donatePrices, 300)
		else
			if (bukv[1] == "a") and (bukv[2] == "m") and (bukv[3] == "p") and (region == 77) then		-- Правила букв
				table.insert(filter, "|a***мр|97|")
				table.insert(prices, 480000 + add)
				table.insert(donatePrices, 800)
			elseif (bukv[1] == "a") and (bukv[2] == "m") and (bukv[3] == "p") and (region == 97) then
				table.insert(filter, "|a***мр|77|")
				table.insert(prices, 450000 + add)
				table.insert(donatePrices, 750)
			elseif (bukv[1] == bukv[2]) and (bukv[2] == bukv[3]) then
				table.insert(filter, "|z***zz|**| (любые ТРИ повторяющиеся буквы)")
				table.insert(prices, 210000 + add)
				table.insert(donatePrices, 700)	
			elseif (bukv[1] == "e") and (bukv[2] == "k") and (bukv[3] == "x") then
				table.insert(filter, "|е***кх|**|")
				table.insert(prices, 360000 + add)
				table.insert(donatePrices, 600)
			elseif (bukv[1] == "b") and (bukv[2] == "o") and (bukv[3] == "p") then
				table.insert(filter, "|в***ор|**|")
				table.insert(prices, 360000 + add)
				table.insert(donatePrices, 600)
			elseif (bukv[1] == "x") and (bukv[2] == "a") and (bukv[3] == "m") then
				table.insert(filter, "|х***ам|**|")
				table.insert(prices, 360000 + add)
				table.insert(donatePrices, 600)
			end
			if (cifr[1] == cifr[2]) and (cifr[2] == cifr[3]) then										-- Правила цифр
				table.insert(filter, "|*YYY**|**| (любые ТРИ повторяющиеся цифры)")
				table.insert(prices, 210000 + add)
				table.insert(donatePrices, 700)
			elseif (cifr[1] == cifr[2]) or (cifr[1] == cifr[3]) or (cifr[2] == cifr[3]) then
				table.insert(filter, "|*YYG**|**| (любые ДВЕ повторяющиеся цифры)")
				table.insert(prices, 120000 + add)
				table.insert(donatePrices, 600)
			end
		end
		if (#filter == 0) then
			table.insert(filter, "обычный номер")
			table.insert(prices, 50000 + add)
		end
	
	
	elseif (nomerType == "o") then
		table.insert(filter, "Дипломатический номер")
		table.insert(donatePrices, 2000)
	elseif (nomerType == "p") then
		table.insert(filter, "Российский именной")
		table.insert(donatePrices, 1000)
	elseif (nomerType == "q") then
		table.insert(filter, "Федеральный именной")
		table.insert(donatePrices, 1000)
	elseif (nomerType == "b") then
		table.insert(filter, "номер полиции")
		table.insert(prices, 1000000000)
		
	elseif (nomerType == "c") then
		table.insert(filter, "мотоциклетный номер")
		table.insert(prices, 500*1000)
	
	elseif (nomerType == "d") then
		table.insert(filter, "номер полицейского мотоцикла")
		table.insert(prices, 1000000000)
	
	elseif (nomerType == "e") then
		local n1, n2, n3, b1, b2, b3 = string.sub(newNomer, 3, 3), string.sub(newNomer, 4, 4), string.sub(newNomer, 5, 5), string.sub(newNomer, 6, 6), string.sub(newNomer, 7, 7), string.sub(newNomer, 8, 8)
		if (n1==n2 and n2==n3) or (b1==b2 and b2==b3) then
			table.insert(filter, "номер Казахстана (3 одинаковых символа)")
			table.insert(prices, 200000)
			table.insert(donatePrices, 800)
		else
			table.insert(filter, "номер Казахстана")
			table.insert(prices, 20000)
			table.insert(donatePrices, 800)
		end
		
	elseif (nomerType == "f") then
		local b1, b2, n1, n2, n3, n4, b3, b4 = string.sub(newNomer, 3, 3), string.sub(newNomer, 4, 4), string.sub(newNomer, 5, 5), string.sub(newNomer, 6, 6), string.sub(newNomer, 7, 7), string.sub(newNomer, 8, 8), string.sub(newNomer, 9, 9), string.sub(newNomer, 10, 10)
		if ((b1..b2 == "AA") or (b1..b2 == "II")) and ((b3..b4 == "BC") or (b3..b4 == "KA") or (b3..b4 == "KI") or (b3..b4 == "KM") or (b3..b4 == "KC") or (b3..b4 == "BP")) then
			table.insert(filter, "номер Украины (специальный)")
			table.insert(donatePrices, 800)
		elseif (n1==n2 and n2==n3 and n3==n4) then
			table.insert(filter, "номер Украины (4 одинаковые цифры)")
			table.insert(prices, 200000)
			table.insert(donatePrices, 800)
		elseif (n1==n2 and n2==n3) or (n1==n2 and n2==n4) or (n1==n3 and n3==n4) or (n2==n3 and n3==n4) then
			table.insert(filter, "номер Украины (3 повторяющиеся цифры)")
			table.insert(prices, 150000)
			table.insert(donatePrices, 800)
		else
			table.insert(filter, "номер Украины")
			table.insert(prices, 20000)
			table.insert(donatePrices, 800)
		end
		
	elseif (nomerType == "g") then
		local n1, n2, n3, n4 = string.sub(newNomer, 3, 3), string.sub(newNomer, 4, 4), string.sub(newNomer, 5, 5), string.sub(newNomer, 6, 6)
		if (n1==n2 and n2==n3 and n3==n4) then
			table.insert(filter, "номер Белоруссии (4 одинаковые цифры)")
			table.insert(prices, 200000)	
			table.insert(donatePrices, 800)		
		elseif (n1==n2 and n2==n3) or (n1==n2 and n2==n4) or (n1==n3 and n3==n4) or (n2==n3 and n3==n4) then
			table.insert(filter, "номер Белоруссии (3 одинаковые цифры)")
			table.insert(prices, 150000)	
			table.insert(donatePrices, 800)		
		else
			table.insert(filter, "номер Белоруссии")
			table.insert(prices, 20000)
			table.insert(donatePrices, 800)
		end
		
	elseif (nomerType == "h") or (nomerType == "m") or (nomerType == "n") then
		table.insert(filter, "надпись")
		table.insert(donatePrices, 
			800)
	elseif (nomerType == "j") then
		table.insert(filter, "Федеральный")
		table.insert(donatePrices, 
			1500)
	end
	
	local filtersText, donatePriceText, priceText, donatSum, sum = "", "", "", 0, false
	filtersText = table.concat(filter, ",\n")
	filtersText = string.format("Шаблон%s номера:\n", ((#filtersText > 1) and "ы" or ""), filtersText)

	donatePriceText = table.concat(donatePrices, " + ")
	for _, row in ipairs(donatePrices) do
		donatSum = donatSum + row
	end
	if (donatSum == 0) then
		donatSum = false
	end
	
	for _, row in ipairs(prices) do
		if (not sum) or (sum < row) then
			sum = row
		end
	end

	local isFree = false

	if isElement(player) then

		local free = player:getData('numbers.free') or {}

		if (free[nomerType] or 0) > 0 then
			isFree = true
			donatSum = 0
			sum = 0
		end

	end

	return donatSum, sum, isFree, nomerType
end