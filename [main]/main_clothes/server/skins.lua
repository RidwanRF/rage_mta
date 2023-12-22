
addEventHandler('onElementDataChange', root, function(dataName, old, new)
	if dataName == 'character.skin' then
		setElementModel ( source, getElementData ( source, dataName ) )
	end
end)

function addWardrobeClothes(login, model, addSlot)

	local account = getAccount(isElement(login) and login.account.name or login)

	local wardrobe = fromJSON(account:getData('wardrobe') or '[[]]') or {}
	wardrobe[tonumber(model)] = getRealTime().timestamp

	if account.player then

		if addSlot then
			increaseElementData(account.player, 'clothes.extended', 1)
		end

		account.player:setData('wardrobe', wardrobe)

		updatePlayerWardrobeLots(account.player)
		
	else

		if addSlot then
			increaseAccountData(account, 'clothes.extended', 1)
		end

		account:setData('wardrobe', toJSON(wardrobe))

	end


end

addCommandHandler('giveclothes', function(player, _, login, model)
	if exports.acl:isAdmin(player) then
		addWardrobeClothes(login, model)
	end
end)