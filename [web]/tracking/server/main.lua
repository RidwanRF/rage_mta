
URL = 'http://92.63.103.87/api.php?pass=bb34ff11'

function callback_sendData( result, info, data, json, attempt )
	-- print(result, inspect(info))
end

function sendData( data )
    local json = toJSON( data, true ):sub( 2, -2 )
    local options = {
        queueName = "tracking_api",
        connectionAttempts = 10,
        connectTimeout = 10000,
        postData = json,
        method = "POST",
        headers = {
            ["charset"] = "UTF-8",
		    ["Content-Type"] = "application/json",
        }
    }
    fetchRemote( URL, options, callback_sendData, { data, json } )
end

function trackAction(data)

    local _data = {}

    for acc_name, tr_data in pairs(data) do
        if not exports.acl:hasAccountGroups( getAccount(acc_name) ) then
            _data[acc_name] = tr_data
        end
    end

	sendData(_data)
end
