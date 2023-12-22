Vehicle.SetHand = function ( self, key, value )
	local curr = getVehicleHandling ( self ) [ key ]
	setVehicleHandling ( self, key, curr + value )
	self:setData ( 'handling', getVehicleHandling(self) )
	exports.vehicles_main:saveVehicleData ( self )
end

Vehicle.ResetHend = function ( self, key, value )
	local curr = getVehicleHandling ( self ) [ key ]
	local cet = STAGES_CONFIG [ tonumber ( value ) ].maxVelocity
	if cet then
		setVehicleHandling ( self, key, curr - cet )
		exports.vehicles_main:saveVehicleData ( self )
	end
end

local db = Connection ( 'sqlite', 'stages.db' )
db:exec ( 'CREATE TABLE IF NOT EXISTS Stages ( id, stage )' )

function SaveStage ( vehicle )
    local id = vehicle:getData ( 'id' ) or false
    local stage = vehicle:getData ( 'stages' ) or 0

    if not id then return end
    db:query ( function ( q, veh ) 
        local result = q:poll ( -1 )
        if result and #result > 0 then
            db:exec ( 'UPDATE Stages SET stage = ? WHERE id = ?', stage, id )
        else
            db:exec ( 'INSERT INTO Stages VALUES ( ?, ? )', id, stage )
        end

    end, { vehicle }, 'SELECT * FROM Stages WHERE id = ?', id)
end

function getVehFromID ( id )
    local id = tonumber ( id )
    for i, v in pairs ( getElementsByType ( 'vehicle' ) ) do
        local v_id = tonumber ( v:getData ( 'id' ) ) or false
        if v_id and v_id == id then
            return v;
        end
    end
    return false;
end

function LoadStage ( id )

    db:query ( function ( query ) 
        local result = query:poll ( -1 )
        if result and #result > 0 then
            result = result [ 1 ]
            local vehicle = getVehFromID ( id )
            if not vehicle then return end
            if result.stage and result.stage > 0 then
            	vehicle:setData ( 'stages', result.stage )
            end
            --[[local default_property = exports.vehicles_main:getVehicleProperty ( vehicle, 'max_velocity' )
            if default_property then
           		setVehicleHandling ( vehicle, 'maxVelocity', tonumber ( default_property ) )
           	end

            
            
            local curr_speed = getVehicleHandling ( vehicle ) [ 'maxVelocity' ]
            local new_speed = STAGES_CONFIG [ tonumber ( result.stage ) ]
            iprint('stage', result.stage, new_speed, curr_speed, default_property)
            if new_speed then
	            for i, v in pairs ( new_speed ) do
	                vehicle:SetHand ( i, tonumber ( v ) )
	            end
	        end]]
        end
    end, { }, 'SELECT * FROM Stages WHERE id = ?', id)
end

addEventHandler ( 'onElementDataChange', root, function ( key, old ) 
	if source.type == 'vehicle' then
		if key == 'stages' then
			local value = source:getData ( key ) or false
			if old and tonumber ( old ) then
				source:ResetHend ( 'maxVelocity', old )
			end
			local default_property = exports.vehicles_main:getVehicleProperty ( source, 'max_velocity' )
            if default_property then
           		setVehicleHandling ( source, 'maxVelocity', tonumber ( default_property ) )
           	end
           
			if value then
				local curr_speed = getVehicleHandling ( source ) [ 'maxVelocity' ]
				local new_speed = STAGES_CONFIG [ tonumber ( value ) ]

				if not new_speed then return end

				for i, v in pairs ( new_speed ) do
					source:SetHand ( i, tonumber ( v ) )
				end
				iprint('STAGE UPDATE vehicleId:', source:getData('id') or 0, 'default speed:', curr_speed or 'false', 'new speed', new_speed, 'new stage', value, 'old stage',old)
			end
		end
	end
end)

addEventHandler ( 'onVehicleStartEnter', root, function ( ) 
	iprint(getVehicleHandling(source)['maxVelocity'], source:getData('stages'))
end)