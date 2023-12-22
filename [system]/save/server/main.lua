
function getParameters()
	return saveDataNames, clientCancelDataNames
end

function addParameter(name, isJSON, clientCancel, cancelSync)

	saveDataNames[name] = isJSON and 'json' or true

	if clientCancel then
		clientCancelDataNames[name] = true
	end

	if cancelSync then
		cancelSyncDataNames[name] = true
	end

end

function removeParameter(name)
	saveDataNames[name] = nil
	clientCancelDataNames[name] = nil
end