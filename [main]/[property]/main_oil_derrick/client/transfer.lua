
function sellBusinessOffer(data, seller, cost)
	if not isElement(seller) then return end

	currentBusinessData = data
	currentBusinessData.seller = seller
	currentBusinessData.sellerName = clearColorCodes(seller.name)
	currentBusinessData.sellCost = cost

	dialog('Покупка нефтевышки',
	{
		string.format('Игрок %s предлагает купить нефтевышку', currentBusinessData.sellerName),
		string.format('Уровень - %s', currentBusinessData.upgrades_level),
		string.format('Стоимость - %s $', splitWithPoints( currentBusinessData.sellCost, '.' )),
	},
	function(result)
		triggerServerEvent('derrick.sellResponse', resourceRoot,
			currentBusinessData.id, currentBusinessData.seller, currentBusinessData.sellCost, result)
	end)

end
addEvent('derrick.sellOffer', true)
addEventHandler('derrick.sellOffer', root, sellBusinessOffer)

