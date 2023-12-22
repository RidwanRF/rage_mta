
--------------------------------------------

	function logAdminAction( player, action, data )

		local data_str = ''

		for key,value in pairs(data) do
			data_str = data_str .. string.format('%s %s | ', key, inspect(value):gsub('"', ''))
		end

		exports.web_main:sendVKMessage( string.format('ADMIN-ACTION | %s | %s | %s',
			player.account.name, action, data_str
		) )

	end

--------------------------------------------