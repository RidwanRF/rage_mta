
local teaKey = '230fgdf'

function encode(str)
	return teaEncode(str, teaKey)
end

function decode(str)
	return teaDecode(str, teaKey)
end


