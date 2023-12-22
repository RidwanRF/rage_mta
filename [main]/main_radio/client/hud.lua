
-- setAnimData('radio-notify', 0.1)

-- local notifications = {
-- 	{
-- 		'#3c7fe2Тима Белорусских#ffffff уже ждёт тебя',
-- 		'в нашем музыкальном плеере!',
-- 	},
-- 	{
-- 		'#3c7fe2MORGENSHTERN#ffffff врывается на новом',
-- 		'кадиллаке в наш музыкальный плеер!',
-- 	},
-- 	{
-- 		'#3c7fe2Макс Корж#ffffff в шоке, ты до сих пор',
-- 		'не навалил музла в машине!',
-- 	},
-- 	{
-- 		'#3c7fe2Miyagi & Andy Panda#ffffff раздают тепло',
-- 		'в нашем музыкальном плеере!',
-- 	},
-- }

-- addEventHandler('onClientRender', root, function()

-- 	local animData = getAnimData('radio-notify')
-- 	if animData < 0.05 then return end

-- 	local w,h = 360, 103
-- 	local x,y = 30, sy/2 - h/2

-- 	x = x - (w*2 * (1-animData))

-- 	local alpha = getEasingValue(animData, 'InOutQuad')

-- 	dxDrawImage(x,y,w,h,
-- 		'assets/images/ads_bg.png',
-- 		0, 0, 0, tocolor(255,255,255,255*alpha)
-- 	)

-- 	local startY = y+17

-- 	for _, row in pairs(currentNotifyText) do
-- 		dxDrawText(row,
-- 			x + 20, startY,
-- 			x + 20, startY,
-- 			tocolor(255,255,255,255*alpha),
-- 			0.5, 0.5, getFont('proximanova_semibold', 25, 'bold'),
-- 			'left', 'top', false, false, false, true
-- 		)

-- 		startY = startY + 20
-- 	end

-- 	dxDrawText('#3c7fe2M#aeafaf - Музыкальный плеер #3c7fe2DAILY',
-- 		x + 20, y+h-20,
-- 		x + 20, y+h-20,
-- 		tocolor(255,255,255,255*alpha),
-- 		0.5, 0.5, getFont('proximanova', 26, 'light'),
-- 		'left', 'bottom', false, false, false, true
-- 	)

-- end, true, 'low-10')

-- function doNotify()

-- 	if not localPlayer.vehicle then
-- 		currentNotifyCheck = setTimer(function()

-- 			if localPlayer.vehicle then
-- 				doNotify()
-- 				killTimer(currentNotifyCheck)
-- 			end

-- 		end, 1000, 0)

-- 		return

-- 	end

-- 	if isTimer(currentNotifyTimer) then
-- 		killTimer(currentNotifyTimer)
-- 	end

-- 	if isTimer(currentNotifyReload) then
-- 		killTimer(currentNotifyReload)
-- 	end

-- 	animate('radio-notify', 1)
-- 	currentNotifyText = notifications[math.random(#notifications)]
-- 	currentNotifyTimer = setTimer(animate, 10000, 1, 'radio-notify', 0)

-- 	currentNotifyReload = setTimer(doNotify, 15*60*1000, 1)

-- end

-- addCommandHandler('radio_notify', function()
-- 	if exports['shared_utils']:isAdmin(localPlayer) then
-- 		doNotify()
-- 	end
-- end)

-- currentNotifyReload = setTimer(doNotify, 15*60*1000, 1)