local possibleSymbols = 'qwertyuiopasdfghjklzxcvbnm_1234567890|'

function checkInputSymbols(str)
	local _str = utf8.lower(str)

	for _, symbol in pairs( string.split(possibleSymbols) ) do
		_str = utf8.gsub(_str, symbol, '')
		_str = utf8.gsub(_str, symbol:upper(), '')
	end

	return #_str == 0
end

