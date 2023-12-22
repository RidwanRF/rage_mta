local math_random = math.random
local GLOBAL_TIME = START_TIMES [ math_random ( 1, #START_TIMES) ]
local OBJ_DATA = { }
local ANIM_TIMER = { }

local BLIP_ID = 1

function GetRandomTime ( )
	GLOBAL_TIME = START_TIMES [ math_random ( 1, #START_TIMES) ]
end
Timer ( GetRandomTime, ( 5 * 60000 ), 0 )

function StartResourceJob ( )
	triggerClientEvent ( root, 'StartSound', root )
	CreateDrop ( )
	outputChatBox ( TEXT, root, 0, 255, 0 )
end

function increaseElementData ( self, key, value )
 	local curr_value = self:getData ( key ) or 0
	self:setData ( key, curr_value + tonumber ( value ) )
end

ExecAtTime ( GLOBAL_TIME, function ( ) 
	StartResourceJob ( )
end)

Player.ShowNotify = function ( text )
	exports [ 'hud_notify' ]:actionNotify ( text )
end

function GiveDropPrize ( player, conf )
	local conf = conf or { }
	iprint(conf)
	if conf.winner ~= player then return end

	local item = ITEMS [ conf.id ]
	if item then
		if item.fn_give then
			item.fn_give ( player )
		end
		player:ShowNotify ( 'Поздравляем! ты забрал приз:\n'..item.name )

		outputDebugString ( string.format ( '%s забрал приз: [ %s ] из подарка, шанс выпадения: [ %s ], timestamp: [ %s ], realtime: [ %s ]',
			player.name,
			item.name,
			item.chance..'%',
			getRealTime ( ).timestamp,
			formatTimestamp ( getRealTime ( ).timestamp )
		 ) )
	end
end

addCommandHandler ( 'starting', function ( self ) 
	if isObjectInACLGroup ( 'user.'..self.account.name, aclGetGroup ( 'Admin' ) ) then
		StartResourceJob ( )
	end
end)

math.percentchance = function ( percentage, index )
	local chance = 0

	for i = 1, index do
		local num = math.random ( 0, 10000 ) / 100
		if num <= percentage then
            chance = chance + 1
        end
	end
	return chance
end

function GenerateItem ( )
	local item = { }
	for i = 1, 10 do
		for k, v in ipairs ( ITEMS ) do
			local chance = v.chance * 3
			if chance >= 50 then
				chance = 50
			end
			local real_chance = math.percentchance ( chance, 1 )
			if real_chance ~= 0 then
				item = { k, v }
				break
			end
		end
	end
	return item
end

Player.ShowNotify = function ( self, text )
	exports [ 'hud_notify' ]:notify ( self, 'Уведомление', text, math.random ( 1500, 3000 ) )
end 

function CreateDrop ( )

	for i, v in pairs ( getElementsByType ( 'teleport_points', resourceRoot ) ) do
		if isElement ( v ) then destroyElement ( v ) end
	end

	for i, v in pairs ( getElementsByType ( 'object', resourceRoot ) ) do
		if isElement ( v ) then destroyElement ( v ) end
	end

	local function create ( )
		for i, v in pairs ( OBJECTS_POSITIONS ) do

			local x, y, z = unpack ( v )
			local object = Object ( OBJECT_ID, x, y, z +1 )
			local item = GenerateItem ( )
			
			local tpoint = TeleportPoint ( {
				x = x,
				y = y,
				z = z + 1,
				radius = 1.3,
				keypress = KEY_TAKE,
				text = item [ 2] .name,
				img = item [ 2 ].img,
				color = { 0, 0, 0, 0 },
			} )
			tpoint.elements = { }
			tpoint.elements.object = object
			tpoint.item = item [ 2 ]
			tpoint.item_id = item [ 1 ]
			tpoint.elements.blip = Blip ( x, y, z, 53 )
			tpoint.elements.blip:setData ( 'icon', 'gift' )

			tpoint.PostJoin = function ( self, player )
				local data = {
					item = self.item,
					id = self.item_id,
					winner = player
				}
				GiveDropPrize ( player, data )
				self:destroy ( )
			end
			--iprint(tpoint.element)
		end
	end
	Timer ( create, 1000, 1 )
end