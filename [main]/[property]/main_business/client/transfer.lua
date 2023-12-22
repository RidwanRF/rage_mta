
function sellBusinessOffer(data, seller, cost)
	if not isElement(seller) then return end

	currentBusinessData = data
	currentBusinessData.seller = seller
	currentBusinessData.sellerName = clearColorCodes(seller.name)
	currentBusinessData.sellCost = cost

	dialog('Покупка бизнеса',
	{
		string.format('Игрок %s предлагает купить бизнес', currentBusinessData.sellerName),
		string.format('Выплата - %s $', splitWithPoints( currentBusinessData.payment_sum, '.' )),
		string.format('Стоимость - %s $', splitWithPoints( currentBusinessData.sellCost, '.' )),
	},
	function(result)
		triggerServerEvent('business.sellResponse', resourceRoot,
			currentBusinessData.id, currentBusinessData.seller, currentBusinessData.sellCost, result)
	end)

end
addEvent('business.sellOffer', true)
addEventHandler('business.sellOffer', root, sellBusinessOffer)

