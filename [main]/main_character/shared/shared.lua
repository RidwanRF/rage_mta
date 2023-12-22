
local teaKey = '230fgdf'

function encode(str)
	return teaEncode(str, teaKey)
end

function decode(str)
	return teaDecode(str, teaKey)
end

local possibleSymbols = 'qwertyuiopasdfghjklzxcvbnm_123456789'

function checkInputSymbols(str)
	local _str = utf8.lower(str)

	for _, symbol in pairs( string.split(possibleSymbols) ) do
		_str = utf8.gsub(_str, symbol, '')
	end

	return #_str == 0
end

