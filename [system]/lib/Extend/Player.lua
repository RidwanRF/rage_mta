-- Работа с игроком
-- Только серверная часть

Player.GetMoney = function ( self )
	return exports.money:getPlayerMoney ( self )
end

Player.TakeMoney = function ( self, value )
	return exports.money:takePlayerMoney ( self, tonumber ( value ) )
end

Player.HasMoney = function ( self, value )
	local money = self:GetMoney (  )
	if money - tonumber ( value ) >= 0 then
		self:TakeMoney ( value )
		return true
	end
	return false
end

Player.GiveMoney = function ( self, value )
	return exports.money:givePlayerMoney ( self, tonumber ( value ) )
end

Player.ShowInfo = function ( self, ... )
	return exports.hud_notify:notify ( self, 'Информация', ... )
end

Player.ShowError = function ( self, ... )
	return exports.hud_notify:notify ( self, 'Ошибка', ... )
end

Player.Notify = function ( self, ... )
	return exports.hud_notify:notify ( self, ... )
end

Player.SetHP = function ( self, value )
	local value = value or 100
	player:setHealth ( player:getHealth ( ) + tonumber ( value ) )
end

Player.SetArmor = function ( self, value )
	local value = value or 100
	setPedArmor ( self, getPedArmor ( self ) + tonumber ( value ) )
end

Player.CopyDimension = function ( self, to )
	self.dimension = to.dimension
end

Player.GiveData = function ( self, key, value )
	local data = self:getData ( key ) or 0
	self:setData ( key, tonumber ( data ) + tonumber ( value ) )
end

Player.Teleport = function ( self, pos, int, dim )
	local int, dim = int or 0, dim or 0

	self.position = Vector3 ( pos )
	self.interior = int
	self.dimension = dim
end

Player.TeleportTo = function ( self, to )
	self.position = Vector3 ( to.position )
	self.interior = to.interior

	self:CopyDimension ( to )
end