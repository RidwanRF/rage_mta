
local ads = {
	'#bdffd0ВНИМАНИЕ! Пополнение игрового #cd4949счета#bdffd0, покупка игровых #cd4949наборов#bdffd0 осуществляется только на сайте #cd4949xragemta.trademc.org#bdffd0!',
	'#bdffd0Если вам нужна помощь по серверу, нажмите #cd4949F2',
	'#bdffd0Где-то застрял и не можешь выбраться? Зажми #cd4949DEL#bdffd0 на клавиатуре!',
	-- 'Участвуй в мероприятии #cd4949RCoin#ffffff и получай крутые призы! #cd4949Жми F4',
	-- 'Участвуй в мероприятии #cd4949Весенний движ#ffffff и получай крутые призы! #cd4949Жми F6',
	'Список актуальных объявлений >> #cd4949F2#ffffff',
	'#bdffd0Вводи бонус-код #cd4949XRAGE #bdffd0чтобы получить стартовый бонус!',
}

function doNotify()

	local text = ads[math.random(#ads)]
	exports.chat_main:displayInfo(text, {255,255,255})

end

setTimer(doNotify, 15*60000, 0)
doNotify()