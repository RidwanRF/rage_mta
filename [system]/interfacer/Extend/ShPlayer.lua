-- ShPlayer.lua

function increaseElementData(element, dataName, incNumber, noSync)
    setElementData(element, dataName, 
        (getElementData(element, dataName) or 0) + incNumber, not noSync
    )
end
function increaseAccountData(element, dataName, incNumber)
	setAccountData(element, dataName, 
		(getAccountData(element, dataName) or 0) + incNumber
	)
end

Player.IsAdmin = function( self )
	return exports.acl:isAdmin( self )
end

Player.GetMoney = function( self )
	return exports.money:getPlayerMoney( self )
end

Player.GiveMoney = function( self, amount )
	return exports.money:givePlayerMoney( self, amount )
end

Player.TakeMoney = function( self, amount )
	local money = self:GetMoney( )
	if money - tonumber( amount ) >= 0 then
		exports.money:takePlayerMoney( self, amount )
		return true
	end
	return false
end

Player.HasMoney = function( self, amount )
	return self:GetMoney( ) - amount >= 0
end

Player.GetBankMoney = function( self, eType )
	local eType = eType or "rub"

	return self:getData( string.format( "bank.%s", eType ) ) or 0
end

Player.GetDonate = function( self )
	return self:GetBankMoney( "donate" ) or 0
end

Player.HasDonate = function( self, amount )
	return self:GetDonate( ) - amount >= 0
end

Player.TakeDonate = function( self, amount )
	if not self:HasDonate( amount ) then
		return false;
	end
	increaseElementData( self, 'bank.donate', -amount )
	return true
end

Player.GiveDonate = function( self, amount )
	increaseElementData( self, 'bank.donate', amount )
end

Player.GiveVehicle = function( self, model, ... )
	return exports.vehicles_main:giveAccountVehicle( self.account.name, model, ... )
end

Player.TakeVehicle = function( self, id, ... )
	return exports.vehicles_main:wipeVehicle( id, ... )
end

Player.UpdateVehicles = function( self )
	return exports.vehicles_main:returnPlayerVehicles( self )
end

Player.GetFaction = function( self )
	return self:getData( "faction_id" ) or 0
end

Player.IsInFaction = function( self, faction_id )
	return faction_id and ( self:GetFaction( ) == faction_id ) or self:GetFaction( ) > 0
end

Player.GetFactionRank = function( self )
	return self:getData( "faction_rank" ) or 1
end

Player.GetFactionEXP = function( self )
	return self:getData( "faction_exp" ) or 0
end

Player.IsFactionOwner = function( self, faction_id )
	local id = faction_id or 1

	local rank = self:GetFactionRank( )
	local max_faction_rank = GetFactionMaxLevel( id )

	return rank == max_faction_rank
end

Player.SetFactionRank = function( self, rank_id )
	self:setData( "faction_rank", rank_id )
	triggerEvent( "OnPlayerFactionRankChanged", self, self:GetFaction( ), rank_id )
end

Player.SetFaction = function( self, faction_id, rank )
	local rank = rank or 1

	return exports.main_factions:SetPlayerFaction( self, faction_id, rank )
end

Player.SetFactionEXP = function( self, exp )
	return self:setData( "faction_exp", exp )
end

Player.GiveFactionEXP = function( self, exp )
	return self:SetFactionEXP( self:GetFactionEXP( ) + exp )
end

Player.UpdateFactionRank = function( self, rank )
	return self:SetFactionRank( self:GetFactionRank( ) + rank )
end

Player.SetLeader = function( self, faction_id )
	return exports.main_factions:SetFactionLeader( self, faction_id )
end
SetFactionLeader = Player.SetLeader

GetFactionLeader = function( faction_id )
	return exports.main_factions:GetFactionLeader( faction_rank )
end