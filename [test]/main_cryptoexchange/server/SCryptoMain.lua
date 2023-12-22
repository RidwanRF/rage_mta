loadstring ( exports.lib:extend ( 'Interfacer' ) ) ( )
Extend ( 'Player' )

string.IsRunning = function ( self )
	local res = getResourceFromName ( self )
	return res and res.state == 'running'
end

if ('save'):IsRunning ( ) then
	exports.save:addParameter('crypto_currencies', true)
end

conf = { }
for i, v in pairs ( Config.currencies ) do
	table.insert ( conf, v.short_name )
end


UPDATE_TIME = math.random ( Config.course_update_time [ 1 ], Config.course_update_time [ 2 ] ) * 60000

local db = Connection ( 'sqlite', ':databases/cryptocurrencies.db' )
db:exec ( 'CREATE TABLE IF NOT EXISTS Crypto ( crypt, data )' )

DATA = { }
local CACHE = { }
LAST_CHANGED_CRYPT = 'Btc'

function InitDatabase ( )
	db:query ( function ( query ) 
		local result = query:poll ( -1 )

		if #result <= 0 then -- если крипты нету в базе
			-- добавляем
			for i, v in pairs ( Config.currencies ) do
				local data = {
					course = v.course,
					id = v.short_name,
					name = v.name,
					last_course = 0,
					change_time = getRealTime().timestamp,
					last_change_value = 0,
					history = { },
				}
				db:exec ( 'INSERT INTO Crypto VALUES ( ?, ? )', v.name, toJSON ( data ) )
				DATA [ v.short_name ] = data
			end
		else -- если есть
			for _, v in pairs ( result ) do

				-- загружаем
				local _data = fromJSON ( v.data or toJSON ( { } ) )
				DATA [ _data.id ] = _data
				--DATA [ _data.id ].history = DATA [ _data.id ].history or { }
			end
		end
		triggerClientEvent ( 'UpdateData', resourceRoot, DATA )
		Timer ( UpdateCourse, 0.5 * 60000, 1 ) -- сразу обновим что бы данные успели сохраниться
	end, { }, 'SELECT * FROM Crypto')

end
addEventHandler ( 'onResourceStart', resourceRoot, InitDatabase )


addEvent ( 'UpdateServerData', true )
addEventHandler ( 'UpdateServerData', resourceRoot, function ( ) 
	triggerClientEvent ( client, 'UpdateData', resourceRoot, DATA, true )
end)

addEventHandler ( 'onResourceStop', resourceRoot, function ( )  -- сохранение данных при остановке ресурса
	if DATA then
		for i, v in pairs ( DATA ) do
			db:exec ( 'UPDATE Crypto SET data = ? WHERE crypt = ?', toJSON ( v ), v.name )
		end
	end
end)

function GetRandomValue ( course )
	local value = course < 0 and math.random ( 50, 250 ) or math.random ( -70, 100 )
	return value
end

function UpdateCourse ( crypt_id )
	local id = crypt_id or GetRandomCrypt ( conf )
	local data = DATA [ id ]
	if not data then return end
	local new_course = GetRandomValue ( data.course or 0 )
	LAST_CHANGED_CRYPT = id
	data.change_course = new_course
	data.change_time = getRealTime ( ).timestamp
	data.last_course = data.course
	data.course = data.course + new_course 
	local history = data.history or { }
	table.insert ( history, {
		new_course = new_course,
		time = data.change_time,
		last_course = data.last_course,
		course = data.course
	} )
	local text = ( 'Изменение курса криптовалют, новый курс: [%s = %s], старый курс: [%s = %s], изменение: [%s] ' ):format ( data.name, data.course, data.name, data.last_course, new_course < 0 and new_course or '+'..new_course )
	outputChatBox ( text, root, 255, 0, 0 )
	triggerClientEvent ( 'UpdateData', resourceRoot, DATA )
	DATA [ id ] = data
end

Timer ( UpdateCourse, math.random ( Config.course_update_time[1], Config.course_update_time[2] ) * 60000, 0 )

function GetCryptCourse ( id )
	return DATA [ id ] and DATA [ id ].course or false
end

function GetCryptData ( id )
	return id and DATA [ id ] or DATA
end

function GetCryptValue ( id, value )
	return DATA [ id ] and DATA [ id ] [ value ]
end

function ExplodeValue ( id, value )
	local value = value or localPlayer:GetCryptValue ( id ) or 0
	if value == -0 or value == '-0' then value = 0 end
	local course = DATA [ id ].course
	if not course then return false end
	return value * course == -0 and 0 or value * course
end

Player.GiveCryptValue = function ( self, id, value )
	local data = self:getData ( 'crypto_currencies' ) or { }
	if not data [ id ] then
		data [ id ] = {
			value = tonumber ( value )
		}
	else
		data [ id ].value = data [ id ].value + tonumber ( value )
	end
	self:setData ( 'crypto_currencies', data )
	return true
end

Player.HasCryptValue = function ( self, id, value )
	local data = self:getData ( 'crypto_currencies' ) or { }
	if not data [ id ] then return end
	local curr_value = data [ id ].value
	if curr_value - value < 0 then return false end
	curr_value = curr_value - value
	data [ id ].value = curr_value
	self:setData ( 'crypto_currencies', data )
	return true
end

addEvent ( 'TransferCrypt', true )
addEventHandler ( 'TransferCrypt', resourceRoot, function ( action, conf ) 
	if action == 2 then
		if not DATA [ conf.id ] then return end
		if not client:HasMoney ( conf.cost * DATA [ conf.id ].course ) then
			client:ShowError ( 'Недостаточно средств' )
			return
		end
		local value = conf.cost
		client:GiveCryptValue ( conf.id, value )
		client:ShowInfo ( ( 'Вы успешно купили %s %s\nза %s руб.' ):format ( value, DATA[conf.id].name, conf.cost * DATA [ conf.id ].course ) )
	elseif action == 1 then
		if not client:HasCryptValue ( conf.id, conf.cost ) then
			client:ShowError ( 'Недостаточно крипто-валюты\nдля обмена' )
			return
		end
		local value = ExplodeValue ( conf.id, conf.cost )
		client:GiveMoney ( value )
		client:ShowInfo ( ( 'Вы успешно обменяли\n%s %s на %s руб.' ):format ( conf.cost, DATA[conf.id].name, value ) )
	end
end)

addCommandHandler ( 'changecourse', function ( self, cmd, c ) 
	if not exports.acl:isAdmin ( self ) then return end
	UpdateCourse ( c and tostring ( c ) or false )
end)