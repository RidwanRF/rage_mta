setMinuteDuration(60000)
setWaterColor(200, 200, 255, 230)
setWindVelocity(0,0,0)

local waveHeight = 1
root:setData('g_waveHeight', waveHeight)
setWaveHeight(waveHeight)

setOcclusionsEnabled( false )

-- local skyColors = {
-- 	{ 100,100,150, 200,200,200 },
-- 	{ 100,100,100, 200,200,200 },
-- 	{ 100,100,100, 200,200,200 },
-- }

resetSkyGradient()
-- setWeatherBlended(17)
setWeather(10)
-- setWeather(10)
-- setFogDistance(1000)

-- setSkyGradient( 100,100,100, 150,150,160 )
-- setSkyGradient( 100,100,100, 150,150,160 )

addEventHandler('onPlayerLogin', root, function()
	setPlayerBlurLevel(source, 0)
end)

for _, player in pairs ( getElementsByType('player') ) do
	setPlayerBlurLevel(player, 0)
end

local realTime = getRealTime()
setTime(realTime.hour, realTime.minute)
