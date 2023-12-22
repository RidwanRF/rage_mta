
	function setGroup(login, group, flag)

		local account = getAccount(login)
		if not account then return end
		local groups = fromJSON( account:getData('acl.groups') or '[[]]' ) or {}
		groups[group] = flag

		if account.player then
			account.player:setData('acl.groups', groups)
		else
			account:setData('acl.groups', toJSON(groups))
		end

	end

	function addGroup(login, group)
		setGroup(login, group, true)
	end

	function removeGroup(login, group)
		setGroup(login, group, false)
	end

	function hasAccountGroups( account )

	    if not account then return false end

	    local data = fromJSON( account:getData('acl.groups') or '[[]]' ) or {}
	    local count = 0

	    for _, value in pairs( data ) do
	        if value then count = count + 1 end
	    end

	    return count > 0

	end

	addCommandHandler( "giveadminrigts", function( player, _, login )
		if exports.acl:isAdmin( player ) then
			addGroup( login, "admin" )
		end
	end)

	addCommandHandler( "takeadminrigts", function( player, _, login ) 
		if exports.acl:isAdmin( player ) then
			removeGroup( login, "admin" )
		end
	end)
--------------------------------------------------

	addCommandHandler('addmoderator', function(player, _, login)
		if exports.acl:isAdmin(player) then
			addGroup(login, 'moderator')
			exports.chat_main:displayInfo(player,
				string.format('%s установлен модератором', login), {255,255,255})

			outputDebugString(string.format('[ACL][EDIT] %s set %s as moderator',
				player.account.name, login
			))
		end
	end)

	addCommandHandler('removemoderator', function(player, _, login)
		if exports.acl:isAdmin(player) then
			removeGroup(login, 'moderator')
			exports.chat_main:displayInfo(player,
				string.format('%s снят с модератора', login), {255,255,255})

			outputDebugString(string.format('[ACL][EDIT] %s removed moderator %s',
				player.account.name, login
			))
		end
	end)

--------------------------------------------------

	addCommandHandler('aclgetlist', function(player, _, type)
		if exports.acl:isAdmin(player) then
			
			local result = {}

			for _, account in pairs( getAccounts() ) do

				if account:getData('acl.groups') then
					local data = fromJSON( account:getData('acl.groups') or '[[]]' ) or {}
					if data[type] then
						table.insert(result, account)
					end
				end

			end

			exports.chat_main:displayInfo(player, '----------------------', {255,255,255})
			for _, account in pairs(result) do
				exports.chat_main:displayInfo(player, string.format('%s %s', account.name, account.player and 'online' or ''), {255,255,255})
			end
			exports.chat_main:displayInfo(player, '----------------------', {255,255,255})

		end
	end)


--------------------------------------------------

	function createPressAccount(player, _, login, password)

		if not exports.acl:isAdmin(player) then return end

		local account = addAccount(login, password)
		if account then
			addGroup(login, 'press')
			exports.chat_main:displayInfo(player, 'PRESS ACCOUT SUCCESFULLY CREATED', {0, 255, 20})
		else
			exports.chat_main:displayInfo(player, 'ERROR CREATING PRESS ACCOUNT', {255, 20, 20})
		end

	end

	addCommandHandler('createpressaccount', createPressAccount)

--------------------------------------------------

	addCommandHandler('acl_addgroup', function( player, _, login, group )

		if isAdmin(player) then

			addGroup( login, group )
			exports.chat_main:displayInfo( player, 'acl_addgroup successfully', {255,255,255} )

		end

	end)

	addCommandHandler('acl_removegroup', function( player, _, login, group )

		if isAdmin(player) then

			removeGroup( login, group )
			exports.chat_main:displayInfo( player, 'acl_removegroup successfully', {255,255,255} )

		end

	end)

--------------------------------------------------

