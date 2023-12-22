function RemoveStringHex(self)
    return utf8.gsub( self, "#%x%x%x%x%x%x", "" )
end


function handleMessage(player, message, messageType, _distance, _prefix, _players)

    if isPlayerMuted(player) and messageType ~= 2 then

        local time = player:getData('mute.time') or 0
        local min = math.ceil(time/60)

        exports.chat_main:displayInfo(player, string.format(
            '[ЧАТ] Вы находитесь в муте еще %s %s!',
            min, getWordCase(min, 'минуту', 'минуты', 'минут')
        ), {255, 50, 50})

        return cancelEvent()
    end

    if handlePlayerFlood(player) then
        return exports.chat_main:displayInfo(player, string.format(
            '[ЧАТ] Вы получили мут за флуд на %s %s!',
            Config.floodDetect.mute/60, getWordCase(Config.floodDetect.mute, 'минуту', 'минуты', 'минут')
        ), {255, 50, 50})
    end

    local groups = ''
    local distance = _distance or Config.chatDistance

    if not exports.acl:isPlayerInGroup(player, 'admin_hide') then
        if exports.acl:isAdmin(player) then
            groups = groups .. '#ff0000[ADMIN]#ffffff'
        elseif exports.acl:isModerator(player) then
            groups = groups .. '#ff0000[M]#ffffff'
        end
    end

    -- if exports.acl:isModerator(player) then
    --     distance = 999999
    -- end

    local player_color = player:getData('character.nickname_color') or '#ffffff'

    message = string.format('%s %s%s#ffffff: %s', groups, player_color, player.name, message)

    if _prefix then
        message = _prefix .. ' ' .. message
    end

    if messageType == 0 then

        local x,y,z = getElementPosition(player)

        for id, player in ipairs( _players or  getElementsByType('player') ) do
            local px,py,pz = getElementPosition(player)
            if getDistanceBetweenPoints3D(x,y,z, px,py,pz) <= distance or exports.acl:isModerator(player) then
                outputChatBox(message, player, 231, 217, 176, true)
            end
        end

    elseif messageType == 2 and player.team then

        message = string.format('%s[КЛАН]#ffffff', RGBToHex( getTeamColor(player.team) ))..message

        for id, player in ipairs( player.team.players ) do
            outputChatBox(message, player, 231, 217, 176, true)
        end

    end

    exports.logs:addLog(
        '[CHAT][HANDLEMESSAGE]',
        {
            data = {
                player = player.account.name,
                message = RemoveStringHex( message ),
                messageType = messageType
            },  
        }
    )

end

addEventHandler('onPlayerChat', root, function(message, messageType)

    handleMessage(source, message, messageType)
    cancelEvent()

end)

addCommandHandler('n', function(player, _, ...)
    if exports.acl:isModerator(player) then
        handleMessage(player, table.concat({...}, ' '), 0, 999999)
    end
end)