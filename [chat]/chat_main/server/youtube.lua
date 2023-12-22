
local reload = 15*60
local youtubeNotifies = {}


addCommandHandler('yt', function(player, _, ...)
	local promo = exports.main_freeroam:getPlayerPromo(player)
    if promo then

    	local realTime = getRealTime().timestamp

    	local lastTime = youtubeNotifies[ player.account.name ]
    	if lastTime then
	    	local delta = reload - (realTime - lastTime)
	    	if delta > 0 then
				local minutes = math.floor(delta/60)
	    		return exports.chat_main:displayInfo(player, string.format('До следующего объявления %s %s',
	    			minutes, getWordCase(minutes, 'минута', 'минуты', 'минут')
				), {255, 20, 20})
	    	end
    	end

    	youtubeNotifies[ player.account.name ] = realTime

        handleMessage(player, string.format('#00FF00Сейчас на моем канале %s проходит прямая трансляция! Рекомендую тебе посетить ее!', promo), 0, 999999)
    end
end)