TPOINT_FNS = {
	SetGPS = function( self, state )
		self.gps = state
		self.element:setData( "gps", state )
	end, 

	SetText = function( self, text )
		self.marker_text = text
		self.element:setData( "text", text )
	end, 

	GetText = function( self )
		return self.element:getData( "text" )
	end, 

	SetImage = function( self, image )
		local is_table = type( image ) == "table"
		local image_file = is_table and image[ 1 ] or image
		image_file = image_file:sub( 1, 1 ) == ":" and image_file or ":"..THIS_RESOURCE_NAME .. "/" .. image_file

		if is_table then
			image[ 1 ] = image_file
		else
			image = image_file
		end
		self.marker_image = image
		self.element:setData( "image", image )
	end, 

	GetImage = function( self )
		return self.element:getData( "image" )
	end, 

	SetDropImage = function( self, image )
		local is_table = type( image ) == "table"
		local image_file = is_table and image[ 1 ] or image
		image_file = image_file:sub( 1, 1 ) == ":" and image_file or ":"..THIS_RESOURCE_NAME .. "/" .. image_file

		if is_table then
			image[ 1 ] = image_file
		else
			image = image_file
		end

		self.dropimage = image
		self.element:setData( "dropimage", image )
	end, 

	GetDropImage = function( self )
		return self.element:getData( "dropimage" )
	end, 

	StartLookingForVehicleActions = function( self, player )
		if self.handled_events[ player ] == nil then
			addEventHandler( "onPlayerVehicleEnter", player, self.OnVehicleActionEnter )
			addEventHandler( "onPlayerVehicleExit", player, self.OnVehicleActionExit )
			self.handled_events[ player ] = true
		end
	end, 

	StopLookingForVehicleActions = function( self, player )
		if self.handled_events[ player ] ~= nil then
			removeEventHandler( "onPlayerVehicleEnter", player, self.OnVehicleActionEnter )
			removeEventHandler( "onPlayerVehicleExit", player, self.OnVehicleActionExit )
			self.handled_events[ player ] = nil
		end
	end, 

	destroy = function( self )
		if type( self.elements ) == "table" then
			for i, element in pairs( self.elements ) do

				if isTimer( i ) then killTimer( i ) end
				if isTimer( element ) then killTimer( element ) end

				if isElement( i ) then destroyElement( i ) end
				if isElement( element ) then destroyElement( element ) end

			end

			self.elements = { }
		end
		if isElement( self.element ) then destroyElement( self.element ) end
		if isElement( self.colshape ) then destroyElement( self.colshape ) end
		if isElement( self.marker ) then destroyElement( self.marker ) end

		for i, v in pairs( self.handled_events ) do
			self.OnLeave( i )
		end

		setmetatable( self, nil )
		return true
	end, 
}

function TeleportPoint( config )
	local self = config
	if not self then return end
	if not self.x or not self.y or not self.z then return end
	local teleport_points   = getElementsByType( "teleport_points" )
	local teleport_point_id = self.id or ( "teleport_point_%s" ):format( #teleport_points )
	local teleport_element  = Element( "teleport_points", teleport_point_id )

	setmetatable( self, { __index = TPOINT_FNS } )

	self.id                   = teleport_point_id
	self.element_id           = teleport_point_id
	self.element              = teleport_element
	self.radius               = self.radius or 1
	self.name                 = self.name or self.id
	self.ignore               = { }
	self.slowdown_coefficient = self.slowdown_coefficient or 5

	self.handled_events = { }
	self.element:setData( "name", self.name )

	self.interior  = self.interior or 0
	self.dimension = self.dimension or 0

	self.element.position = Vector3( self.x, self.y, self.z )
	self.element.interior = self.interior
	self.element.dimension = self.dimension

	self.accepted_elements = self.accepted_elements or { player = true }
	if self.keypress == nil then self.keypress = "lalt" end
	if self.text == nil and self.keypress then self.text = ( "Нажмите %s" ):format( utf8.upper( self.keypress ) ) end

	-- Точка входа игрока
	if self.polygon then
		self.colshape = ColShape.Polygon( unpack( self.polygon ) )
	elseif self.cuboid then
		self.colshape = ColShape.Cuboid( unpack( self.cuboid ) )
	else
		self.colshape = ColShape.Sphere( self.element.position, self.radius )
	end

	self.colshape.interior = self.element.interior
	self.colshape.dimension = self.element.dimension
	self.colshape:setParent( self.element )

	self.OnVehicleActionEnter = function( vehicle )
		self.OnLeave( vehicle )
		if vehicle:isWithinColShape( self.colshape ) then
			self.OnHit( vehicle, self.colshape.dimension == vehicle.dimension )
		end
	end

	self.OnVehicleActionExit = function( vehicle )
		if self.accepted_elements.vehicle and not self.accepted_elements.player then
			self.OnLeave( vehicle, true, source )
		else
			self.OnLeave( source )
			if source:isWithinColShape( self.colshape ) then
				self.OnHit( source, self.colshape.dimension == source.dimension )
			end
		end
	end

	if not self.ignore_marker then
		local px, py, pz = getElementPosition( self.colshape )
		local r,  g,  b, a  = 255, 0, 0, 255
		if self.color then
			r, g, b, a = unpack( self.color )
			if not a then a = 255 end
		end
		self.marker           = createMarker( px, py, pz - 1 , "cylinder", self.radius, r, g, b, a )
		self.marker.interior  = self.interior
		self.marker.dimension = self.dimension
		self.marker: setParent( self.element )
	end

	if self.marker_text then self:SetText( self.marker_text ) end
	if self.marker_image then self:SetImage( self.marker_image ) end
	if self.gps then self:SetGPS( self.gps ) end

	self.OnHit = function( element, dimension_match )
		if not dimension_match or self.element.interior ~= element.interior then return end
		local element_type = getElementType( element )
		if not self.accepted_elements[ element_type ] then return end
		local player = element
		if element_type == "vehicle" then
			player = getVehicleOccupant( element )
		end
		if player and not self.accepted_elements.vehicle and player.vehicle then return end
		if self.ignore[ element ] then return end
		if not isElement( player ) or not self.accepted_elements[ element_type ] then return end
		if self.locked then return end
		if self.PreJoin then
			local success, err = self:PreJoin( player )
			if not success then
				if err then player:ShowError( err )  end
				return
			end
		end
		if element_type == "vehicle" and self.slowdown_coefficient then
			element.velocity = element.velocity/self.slowdown_coefficient
		end
		if self.vehicle_text and element_type == "vehicle" then
		--	player:ShowInfo( self.vehicle_text )
		elseif self.text then 
			triggerClientEvent ( player, 'addMessage', resourceRoot, self.text, self.img )
		end
	--	triggerClientEvent ( player, 'addMessage', resourceRoot, self.text, self.img )
		--iprint(self.text,self.img)
		
		--self:StartLookingForVehicleActions( player )

		if self.keypress == "ignore" then
			return true
		elseif self.keypress then
			bindKey( player, self.keypress, "down", self.OnJoin )
		else
			self.OnJoin( player )
		end
	end
	addEventHandler( "onColShapeHit", self.colshape, self.OnHit )

	self.OnLeave = function( element, dimension_match, on_vehicle_exit_player )
		local element_type = getElementType( element )
		local player = element
		self.ignore[ player ] = nil
		if element_type == "vehicle" then
			player = on_vehicle_exit_player or getVehicleOccupant( element )
		end
		if not player or not self.accepted_elements[ element_type ] then return end
		if self.PostLeave then self:PostLeave( player ) end

		if self.keypress then unbindKey( player, self.keypress, "down", self.OnJoin ) end

	end
	addEventHandler( "onColShapeLeave", self.colshape, self.OnLeave )

	self.OnJoin = function( player, key, state )
		if self.locked then return end
		if not player:isWithinColShape( self.colshape ) then
			self.OnLeave( player, true )
			return
		end

		if self.PreJoin then
			local success, err = self:PreJoin( player )
			if not success then
				if err then player:ShowError( err )  end
				return
			end
		end
		local old_interior = player.interior
		local old_dimension = player.dimension
		if self.teleport then
			local vehicle = getPedOccupiedVehicle( player )
			if isElement( vehicle ) then
				self.teleport.ignore[ vehicle ] = true
				vehicle:TeleportToColshape( self.teleport.colshape )
				self.teleport.OnHit( vehicle, true )
			else
				self.teleport.ignore[ player ] = true
				player:TeleportToColshape( self.teleport.colshape )
				self.teleport.OnHit( player, true )
			end
		end
		if self.PostJoin then
			self:PostJoin( player )
		end
		if self.teleport or self.PostJoin then
			local old_position = { x = self.x, y = self.y, z = self.z }
			--player.position = Vector3 ( old_position )
			--player.interior = old_interior
			--player.dimension = old_dimension
			--triggerEvent( "onPlayerUseTeleportPoint", player, old_position, old_interior, old_dimension )
		end
	end

	if self.OnLoad then
		self:OnLoad( unpack( self.args or { } ) )
	end

	return self
end