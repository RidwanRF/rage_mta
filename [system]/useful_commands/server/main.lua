
function getValueFromString(eValue)
	local value = tonumber(eValue) or eValue

	if eValue == 'false' then
		return false
	elseif eValue == 'nil' then
		return nil
	elseif eValue == 'true' then
		return true
	end

	return value
end

addCommandHandler('setdata', function(player, _, key, value)
	if isAdmin(player) and key and value then
		player:setData(key, getValueFromString(value))
	end
end)

addCommandHandler('setvehicledata', function(player, _, key, value, raw)
	if isAdmin(player) and player.vehicle and key and value then
		local handling = player.vehicle:getHandling()
		if handling[key] then
			player.vehicle:setHandling(key, getValueFromString(value))
		else
			player.vehicle:setData(key, raw and value or getValueFromString(value))
		end
	end
end)

addEvent('useful.anim', true)
addEventHandler('useful.anim', resourceRoot, function(...)

	if exports.acl:isAdmin(client) then
		setPedAnimation(...)
	end

end)


------------------------------------------------------
	
	addEvent('useful.returnResources', true)
	addEventHandler('useful.returnResources', resourceRoot, function()

		if exports.acl:isAdmin( client ) then

			local resources = {}

			for _, resource in pairs( getResources() ) do
				table.insert( resources, resource.name)
			end

			triggerClientEvent(client, 'useful.receiveResources', resourceRoot, resources)

		end

	end)

------------------------------------------------------