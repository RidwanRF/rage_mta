--Мероприятия
function sendDiscordEvent(message)
sendOptions = {
    formFields = {
        content=">>> **@everyone\n"..message.."**"
    },
}
fetchRemote ( hookmp, sendOptions, WebhookCallback )
end
--Фракция
function sendDiscordFaction(message)
sendOptions = {
    formFields = {
        content=">>> **@everyone\n"..message.."**"
    },
}
fetchRemote( hookfaction, sendOptions, WebhookCallback )
end
--Логи игроков
function sendDiscordPlayers(message)
    sendOptions = {
        formFields = {
            content=">>> **@everyone\n"..message.."**"
        },
    }
    fetchRemote( hookplayers, sendOptions, WebhookCallback )
end
function sendDiscordTransfers(message)
    sendOptions = {
        formFields = {
            content=">>> **@everyone\n"..message.."**"
        },
    }
    fetchRemote( hooktransfer, sendOptions, WebhookCallback )
end
function sendDiscordJobs(message)
    sendOptions = {
        formFields = {
            content=">>> **@everyone\n"..message.."**"
        },
    }
    fetchRemote( hookJobs, sendOptions, WebhookCallback )
end
function sendDiscordBusinesses(message)
    sendOptions = {
        formFields = {
            content=">>> **@everyone\n"..message.."**"
        },
    }
    fetchRemote( hookBusinesses, sendOptions, WebhookCallback )
end
function sendDiscordCommands(message)
    sendOptions = {
        formFields = {
            content=">>> **@everyone\n"..message.."**"
        },
    }
    fetchRemote( hookcommands, sendOptions, WebhookCallback )
end
function sendDiscordJail(message)
    sendOptions = {
        formFields = {
            content=">>> **@everyone\n"..message.."**"
        },
    }
    fetchRemote( hookjail, sendOptions, WebhookCallback )
end
function sendDiscordClothes(message)
    sendOptions = {
        formFields = {
            content=">>> **@everyone\n"..message.."**"
        },
    }
    fetchRemote( hookClothes, sendOptions, WebhookCallback )
end
function sendDiscordVehicles(message)
    sendOptions = {
        formFields = {
            content=">>> **@everyone\n"..message.."**"
        },
    }
    fetchRemote( hookVehicles, sendOptions, WebhookCallback )
end
function sendDiscordReports(message)
    sendOptions = {
        formFields = {
            content=">>> **@everyone\n"..message.."**"
        },
    }
    fetchRemote( hookreports, sendOptions, WebhookCallback )
end
function sendDiscordFactions(message)
    sendOptions = {
        formFields = {
            content=">>> **@everyone\n"..message.."**"
        },
    }
    fetchRemote( hookfactions, sendOptions, WebhookCallback )
end
function sendDiscordClans(message)
    sendOptions = {
        formFields = {
            content=">>> **@everyone\n"..message.."**"
        },
    }
    fetchRemote( hookclans, sendOptions, WebhookCallback )
end

-- 2 arguments (responseData gives back the response or "ERROR" )
function WebhookCallback(responseData) 

end


function SendMessage( tag, message, date )
	tag = tag or "[]"

    local links = {
        [ "[FREEROAM]" ] = "https://discord.com/api/webhooks/1069743313244139540/7RGVzDfrMtZqsXNPvJ7MamEA5zgzyfYdLgmTCnGyvecAJLEUojl-uX1gB3heRXVJNf56", -- f1
        [ "[VEHICLES]" ] = "https://discord.com/api/webhooks/1069743308366164059/Qj4v4uNAemCaKJ0wBarVzjoS5xslc7j4N25zInNPSA4IBR4haz06-ufhFHlMmrzNY0Qi", -- vehicles
        [ "[MONEY]" ]    = "https://discord.com/api/webhooks/1069999079335141426/1mV0gXGA6XxyqBMYoCskiwmvFnCLgq-G0haeNTax8g6YOqiQsSFYVtlvLXZlOp5ETT6-", -- not using
        [ "[CLAN]" ]	 = "https://discord.com/api/webhooks/1070428242055536710/o18P3SJ9qZfDvc7Bqzr_Y92idreqlBTmHqI_oVMr2Ay99K6fGIdxSd4Gf1qEdafxoPmT", -- clan
        [ "[CYBERQUEST]" ] = "https://discord.com/api/webhooks/1070428810492792862/-5cXijNLQDpRojESISJWS9blGFEtF0iHKQXfdVE-CZJEh18U5qoG6OqiS9Zf8FPjef_3", -- bettle pass (cyberquest)
        [ "[ADMIN]" ]    = "https://discord.com/api/webhooks/1071528554266902548/hFADDl6OjRk0pM6qFymFQa1bLIu5g8Y2tHxBTPw83bqJJlu25K7BNx90iqiefGgY-WpM", -- admin logs
        [ "[CHAT]" ]     = "https://discord.com/api/webhooks/1071531292350484691/rTNfRX0Pur7a4mL4JRE6X0AHrnreNv_6mvFi92fh24i-dNV3IUzF5g8PdRIjfkxDcYeI", -- chat logs
        [ "[DONATION]" ] = "https://discord.com/api/webhooks/1072590296094883900/zxrrl6ph2cb5r4kfvIwUBm0qUoMzNhyzN9mictnw6Ml1iKNs6PtMJSeOIC6fd4NgGYtC", -- donate logs
    }

    local str1 = utf8.find( tag, "]", 1 )

    local link
    local new_tag = ""

    if str1 then
    
    	new_tag = string.sub(tag, 1, str1)
    end

    if new_tag and links[ new_tag ] then
        link = links[ new_tag ]
    else
        link = "https://discord.com/api/webhooks/1069742020752572437/K8OeR7DSLtzCLoNDx2IkpmAhsW8sJ7v-LEBrCNhgQpc5SoeqHVqx0Se0Fo1j9u3wOogr"
    end

    message = message.."\n"..tag.."\n"..date

    sendOptions = {
        formFields = {
            content=">>> **@everyone\n"..message.."**"
        },
    }
    fetchRemote( link, sendOptions, WebhookCallback )
end