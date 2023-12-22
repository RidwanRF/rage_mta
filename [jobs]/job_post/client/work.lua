

addEvent('post.createBind_takePost', true)
addEventHandler('post.createBind_takePost', resourceRoot, function(marker)

	createBindHandler(marker, 'f', 'Взять посылку', function(marker)

		triggerServerEvent('post.takePost', resourceRoot)
		removeBindHandler(marker)

	end)

end)

addEvent('post.createBind_deliverPost', true)
addEventHandler('post.createBind_deliverPost', resourceRoot, function(marker)

	createBindHandler(marker, 'f', 'Положить посылку', function(marker)

		triggerServerEvent('post.deliverPost', resourceRoot)
		removeBindHandler(marker)

	end)

end)