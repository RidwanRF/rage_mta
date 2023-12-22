
function buyCategory(category)

	local config = Config.categories[category]

	if config.cost > exports.money:getPlayerMoney(client) then
		return exports.hud_notify:notify(client, 'Ошибка', 'Недостаточно денег')
	end

	--[[if client:getData('license.'..category) then
		return exports.hud_notify:notify(client, 'Ошибка', 'Вы имеете эту категорию')
	end]]

	exports.money:takePlayerMoney(client, config.cost)

	client:setData('license.'..category, true)
	exports.hud_notify:notify(client, 'Автошкола', 'Вы приобрели лицензию')

	increaseElementData(client, 'vehicles_autoschool.licenses_bought', 1)

	if category == "B" then
		triggerEvent( "OnPlayerRequestX2", client )
	end


	exports.logs:addLog(
		'[AUTOSCHOOL][LICENSE]',
		{
			data = {
				player = client.account.name,
				cost = cost,
				license = license,
			},	
		}
	)

end
addEvent('autoschool.buyCategory', true)
addEventHandler('autoschool.buyCategory', resourceRoot, buyCategory)


addCommandHandler( "takelicense", function( self ) 
	if exports.acl:isAdmin( self ) then
		self:setData( "license.B", false )
	end
end)