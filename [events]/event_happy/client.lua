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

Player.ShowNotify = function ( text )
	exports [ 'hud_notify' ]:actionNotify ( text )
end

addEvent ( 'StartSound', true )
addEventHandler ( 'StartSound', resourceRoot, function ( ) 
	playSound ( 'assets/sfx/drop.mp3' ).volume = 0.7
end)

--[[local OBJ_DATA = { }
local ANIM_TIMER = { }

function StartupObjects ( )
	DestroyObjects ( )
	for i, v in pairs ( OBJECTS_POSITIONS ) do
		local x, y, z = unpack ( v )
		z = z + 0.5
		local object = Object ( OBJECT_ID, x, y, z )
		local sphere = createColSphere ( x, y, z, 1 )

		local item = GET_ITEM_GENERATION and GenerateItem ( ) or false

		OBJ_DATA [ sphere ] =  {
			object = object,
			sphere = sphere,
			item   = item and item [ 2 ] or false,
			id 	   = item and item [ 1 ] or false,
		}

		ANIM_TIMER [ object ] = Timer ( function ( obj ) 
			local rx, ry, rz = getElementRotation ( obj )
			setElementRotation ( obj, rx, ry, rz+11 )
		end, 50, 0, object)
	end
	playSound ( 'assets/sfx/drop.mp3' ).volume = 0.7
end
addEvent ( 'StartupObjects', true )
addEventHandler ( 'StartupObjects', resourceRoot, StartupObjects )

function DestroyObjects ( )
	for i, v in pairs ( OBJ_DATA ) do
		
		if isTimer ( ANIM_TIMER [ v.object ] ) then
			killTimer ( ANIM_TIMER [ v.object ] )
			ANIM_TIMER [ v.object ] = nil
		end

		if isElement ( v.object ) then
			v.object:destroy ( )
		end
		if isElement ( v.sphere ) then
			v.sphere:destroy ( )
		end

	end
end

addEventHandler ( 'onClientColShapeHit', resourceRoot, function ( el, dim ) 
	if el == localPlayer and dim then
		local data = OBJ_DATA [ source ]
		if data then
			if data.winner then return end

			if not data.item then
				local item =  GenerateItem ( )
				data.id = item [ 1 ]
				data.item = item [ 2 ]
			end
			localPlayer:setData ( 'obj_data', source, false )
			localPlayer:ShowInfo ( data.item.name, data.item.img )
		end
	end
end)


addEventHandler ( 'omClientColShapeLeave', resourceRoot, function ( el, dim ) 
	if el == localPlayer and dim then
		if localPlayer:getData ( 'obj_data' ) then
			localPlayer:setData ( 'obj_data', false, false )
		end
	end
end)

addEvent ( '123Huynya', true )
addEventHandler ( '123Huynya', root, function ( data ) 
	killTimer ( ANIM_TIMER [ data.object ] )
	ANIM_TIMER [ data.object ] = nil

	data.sphere:destroy ( )
	data.object:destroy ( )
	OBJ_DATA [ data.sphere ] = nil
end)

bindKey ( KEY_TAKE, 'down', function ( ) 
	if localPlayer:getData ( 'obj_data' ) then
		local sphere = localPlayer:getData ( 'obj_data' )
		if not isElement ( sphere ) then localPlayer:setData ( 'obj_data', false, false ) return end
		local data = OBJ_DATA [ sphere ]
		if data.winner and data.winner ~= localPlayer then localPlayer:setData ( 'obj_data', false, false ) return end
		if data then
			data.winner = localPlayer -- сразу заносим игрока в виннеры, т.к. могут налететь несколько человек и будет уже непонятно

			triggerServerEvent ( 'OnPlayerRequestPrize', resourceRoot, { id = data.id, winner = data.winner } )
			localPlayer:setData ( 'obj_data', false, false )
			triggerEvent ( '123Huynya', root, data )
		end
	end
end)]]