
-- local sx,sy = guiGetScreenSize()

-- function renderWindow()


-- 	dxDrawRectangle(0, 0, sx,sy, tocolor(0,0,0,255), true)

-- 	dxDrawText('На вашем аккаунте был обнаружен отрицательный денежный баланс.\nСистема безопасности полагает, что вы пытались использовать вредоносное ПО на сервере.\nВ целях безопасности, ваш аккаунт заморожен, обратитесь в группу VK\nhttps://vk.com/ragemtateh с запросом о разморозке аккаунта.\nТакже укажите в запросе информацию, каким образом ваш баланс стал отрицательным.',
-- 		0, 0, sx,sy, tocolor(255,255,255,255),
-- 		2.5, 2.5, 'default-bold',
-- 		'center', 'center', false, false, true
-- 	)


-- end

-- function toggleWindow(flag)
-- 	local func = flag and addEventHandler or removeEventHandler
-- 	func('onClientRender', root, renderWindow, true, 'low-100')
-- end

-- addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

-- 	if dn == 'cheater' then

-- 		toggleWindow(new == 1)

-- 	end

-- end)