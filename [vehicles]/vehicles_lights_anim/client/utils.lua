local lightStates = {
	['off']=0,
	['hwd']=1,
	['head']=2,
	['strobo']=3,
}

function getLightsState(vehicle)
	return lightStates[vehicle:getData('vehicleLightsState') or 'off'] or 1
end