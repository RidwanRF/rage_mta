function getDiscountModels()
	return resourceRoot:getData('vehicles.discount') or {}
end

function getModelDiscount(model)
	local data = resourceRoot:getData('vehicles.discount') or {}
	model = tostring(model)
	if data[model] then
		return data[model].discount
	else
		return 0
	end
end