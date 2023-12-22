
function sellHouseOffer(data, seller, cost)
	if not isElement(seller) then return end

	currentHouseData = data
	currentHouseData.seller = seller
	currentHouseData.sellerName = clearColorCodes(seller.name)
	currentHouseData.sellCost = cost

	dialog('Покупка дома',
	{
		string.format('Игрок %s предлагает купить дом', currentHouseData.sellerName),
		string.format('Парковочные места - %s', currentHouseData.lots),
		string.format('Стоимость - %s', splitWithPoints( currentHouseData.sellCost, '.' )),
	},
	function(result)
		triggerServerEvent('house.sellResponse', resourceRoot,
			currentHouseData.id, currentHouseData.seller, currentHouseData.sellCost, result)
	end)


end
addEvent('house.sellOffer', true)
addEventHandler('house.sellOffer', root, sellHouseOffer)

