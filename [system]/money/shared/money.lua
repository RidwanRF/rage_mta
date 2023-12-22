

addEvent('onServerMoneyGive', true)

function getPlayerMoney(ePlayer)
    local player = ePlayer or localPlayer
    if not isElement(player) then return 0 end
    return getElementData(player, 'money') or 0
end

function setPlayerMoney(player, amount)
    if not isElement(player) then return end
    if localPlayer then return false end
    --exports.nrp_webhook:SendMessage( "[MONEY]", string.format( "%s change money, func: setPlayerMoney\n currmoney: %s", player.account.name, amount ), getRealTime( ).timestamp )

    return setElementData(player, 'money', math.ceil(amount))
end

function givePlayerMoney(player, eAmount)
    if not isElement(player) then return end
    if localPlayer then return false end
    local money = getPlayerMoney(player)

    local amount = math.ceil(eAmount)

    triggerEvent('onServerMoneyGive', player, 'money',
    	money, money + amount, getResourceName(sourceResource))
    
    return setPlayerMoney(player, money + amount)
end

function takePlayerMoney(player, amount, write_stats, sound)

    if not isElement(player) then return end
    if localPlayer then return false end

    if write_stats ~= false then
        addMoneySpentStats( player, amount )
    end

    if sound ~= false then
        exports.main_sounds:playSound( player, 'money' )
    end

    return givePlayerMoney(player, -(math.ceil(amount)))

end
