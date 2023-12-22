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

function strRep(str)
	str = string.gsub(str, "b", "в")
	str = string.gsub(str, "k", "к")
	str = string.gsub(str, "m", "м")
	str = string.gsub(str, "h", "н")
	str = string.gsub(str, "t", "т")
	return str
end

