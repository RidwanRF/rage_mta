
for i in pairs(Config.objects) do

	local txd = ':lv_burj_khalifa/assets/objects/main'

	exports.engine:replaceModel(':lv_burj_khalifa/assets/objects/' .. i, Config.objects[i].model, { txd = txd } )
	exports.engine:replaceModel(':lv_burj_khalifa/assets/objects/' .. i, Config.objects[i].lod, { txd = txd } )

	engineSetModelLODDistance(Config.objects[i].lod, 1000)
	engineSetModelLODDistance(Config.objects[i].model, 2000)

end

local water = createWater(
	2344, 1230, 8.5,
	2384, 1230, 8.5,
	2344, 1337, 8.5,
	2384, 1337, 8.5
)

local marker = createMarker( 2322.11, 1273.09, 16.78, 'corona', 200, 0, 0, 0, 0 )

local function toggleKhalifaWaves(flag)

	local waveHeight = root:getData('g_waveHeight') or 2
	setWaveHeight( flag and 0 or waveHeight )

end

addEventHandler('onClientResourceStart', resourceRoot, function()

	toggleKhalifaWaves( isElementWithinMarker(localPlayer, marker) )

end)


local function handleMarker(player, mDim)

	if player == localPlayer and mDim then
		toggleKhalifaWaves( eventName == 'onClientMarkerHit' )
	end

end

addEventHandler('onClientMarkerHit', marker, handleMarker)
addEventHandler('onClientMarkerLeave', marker, handleMarker)

