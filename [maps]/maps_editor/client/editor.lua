
-----------------------------------

	map = {}

-----------------------------------

	selectedEditObject = nil
	selectedMoveObject = nil

	editor_config = {
		default_model = 1000,
	}

	addCommandHandler('me_define', function(_, name, value)
		if editor_config[name] then
			editor_config[name] = tonumber(value) or value
		end
	end)
	
-----------------------------------

	EditorObject_class = {

		init = function( self, data )

			local object = createObject(data.model, data.x, data.y, data.z, data.rx, data.ry, data.rz)

			data.lod = data.model

			if type(data.scale) == 'number' then
				setObjectScale( object, data.scale )
			else
				setObjectScale( object,  unpack(data.scale or {1,1,1} )  )
			end

			self.object = object
			map[self.object] = self

			self.created = data.created or getRealTime().timestamp

			self.name = data.name

			table.insert(objectsList.listElements, self)
			createObjectMarker( self )

			if data.lod then
				self:createLOD( data.lod )
			end

			objectsList:scrollTo(self)

		end,

		isMeta = function( self )
			return self.remove_world_mode
		end,

		getName = function( self )
			return self.name or self.object.model
		end,

		setName = function( self, name )
			self.name = name
		end,

		setValue = function( self, key, axis, value )

			value = math.round( value, 2 )

			if axis then

				local tbl = {
					x = self.object[key].x,
					y = self.object[key].y,
					z = self.object[key].z,
				}
				tbl[axis] = value 

				self.object[key] = Vector3( tbl.x, tbl.y, tbl.z )

			else
				self.object[key] = value
			end

			if self.lod then
				self:updateLOD()
			end

			
		end,

		setModel = function( self, model )

			if isElement(self.object) then
				self.object.model = model
				GUI.input.object_model[6] = tostring(model)
			end

			if isElement(self.lod) then
				self.lod.model = model
				GUI.input.lmd[6] = tostring(model)
			end

		end,

		destroy = function( self )

			if self.remove_world_mode then
				self:toggleRemoveWorldMode()
			end

			if isElement(self.object) then
				self.object:destroy()
			end

			map[self.object] = nil

			if selectedEditObject == self then
				for _, input in pairs( GUI.input ) do
					input[6] = ''
				end
			end

			for index, lElement in pairs( objectsList.listElements ) do
				if lElement == self then

					table.remove(objectsList.listElements, index)

					objectsList.lastSelectedItem = false
					objectsList.selectedItem = false

					break

				end
			end

			for index, element in pairs( windowModel.main ) do
				if element.marker_object == self then
					windowModel.main[index] = nil
				end
			end

			if self.lod then
				self:removeLOD()
			end

		end,

		loadToGUI = function( self )

			GUI.input.object_model[6] = self.object.model
			GUI.input.object_name[6] = self:getName()
			GUI.checkbox.lod.checked = isElement(self.lod)
			GUI.checkbox.col.checked = self.object:getCollisionsEnabled()
			GUI.checkbox.mbr.checked = self.moveByRotation
			GUI.checkbox.rwm.checked = self.remove_world_mode

			local x,y,z = getElementPosition( self.object )
			local rx,ry,rz = getElementRotation( self.object )

			GUI.input.object_x[6] = math.round( x, 2 )
			GUI.input.object_y[6] = math.round( y, 2 )
			GUI.input.object_z[6] = math.round( z, 2 )

			GUI.input.object_rx[6] = math.round( rx, 2 )
			GUI.input.object_ry[6] = math.round( ry, 2 )
			GUI.input.object_rz[6] = math.round( rz, 2 )

			GUI.input.md_azo[6] = math.round( getModelAxisOffset(self.object), 2 )
			-- GUI.input.cds[6] = math.round( self.curve_distance or 0, 2 )

			GUI.input.object_scale[6] = math.round( self.object.scale, 2 )

			local x,y,z = getObjectScale( self.object )
			GUI.input.object_scx[6] = math.round( x, 2 )
			GUI.input.object_scy[6] = math.round( y, 2 )
			GUI.input.object_scz[6] = math.round( z, 2 )

			GUI.input.edit_step[6] = (currentEditStep or 1)
			GUI.input.lmd[6] = isElement(self.lod) and self.lod.model or self.object.model

		end,

		select = function( self )
			selectedEditObject = self
			self:loadToGUI()
		end,

		isSelected = function( self )
			return self == selectedEditObject
		end,

		copy = function( self )

			local object = EditorObject( {
				model = self.object.model,
				x = self.object.position.x,
				y = self.object.position.y,
				z = self.object.position.z,
				rx = self.object.rotation.x,
				ry = self.object.rotation.y,
				rz = self.object.rotation.z,
				scale = { getObjectScale(self.object) },
			} )

			if self.lod then
				object:createLOD( self.lod.model )
			end

			object.moveByRotation = self.moveByRotation

			object:setName( self:getName() .. ' - копия' )

			return object

		end,

		isFreeMoving = function( self )
			return selectedMoveObject == self
		end,

		toggleFreeMove = function( self )

			if self:isFreeMoving() then
				self:finishFreeMove(true)
			else
				self:startFreeMove()
			end

		end,

		startFreeMove = function( self )

			self.freeMove = {
				prev_position = { getElementPosition( self.object ) },
			}

			selectedMoveObject = self
			self.object.collisions = false
			self.object.alpha = 200
		end,

		finishFreeMove = function( self, apply )

			if apply then
				self:loadToGUI()
			else
				setElementPosition( self.object, unpack( self.freeMove.prev_position ) )
			end

			selectedMoveObject = nil
			self.freeMove = nil

			self.object.collisions = true
			self.object.alpha = 255

			if isElement(self.lod) then
				self:updateLOD()
			end

		end,

		createLOD = function( self, lod_model )

			self:removeLOD()

			local x,y,z = getElementPosition(self.object)
			local rx,ry,rz = getElementRotation(self.object)

			local lod = createObject(lod_model or self.object.model, x,y,z, rx,ry,rz, true)
			attachElements(lod, self.object)
			if not lod then return end

			lod.scale = self.object.scale

			setLowLODElement(self.object, lod)
			self.lod = lod

		end,

		removeLOD = function( self )

			if isElement( self.lod ) then
				destroyElement( self.lod )
			end

			self.lod = nil

		end,

		updateLOD = function( self )

			if isElement( self.lod ) then

				local x,y,z = getElementPosition(self.object)
				local rx,ry,rz = getElementRotation(self.object)

				setElementPosition(self.lod, x,y,z)
				setElementRotation(self.lod, rx,ry,rz)
				self.lod.scale = self.object.scale
				self.lod.dimension = self.object.dimension

			end

		end,

		toggleRemoveWorldMode = function( self )

			self.remove_world_mode = not self.remove_world_mode

			self.object.alpha = self.remove_world_mode and 0 or 255

			local x,y,z = getElementPosition( self.object )

			local func = self.remove_world_mode and removeWorldModel or restoreWorldModel

			func(self.object.model, 0.5, x,y,z)
			func(self.world_lod, 0.5, x,y,z)


		end,

	}


	function EditorObject(data)

		local Object = table.copy(EditorObject_class)
		Object:init(data)

		return Object

	end

-----------------------------------

	lastWorldX, lastWorldY, lastWorldZ = 0,0,0

	addEventHandler('onClientCursorMove', root, function(_, _, _, _, x,y,z)

		if windowOpened then

			local cx,cy,cz = getCameraMatrix()
			local hit, x,y,z = processLineOfSight(
				cx,cy,cz, x,y,z,
				true, true, false,
				true, true, false, false, false,
				selectedMoveObject and selectedMoveObject.object or nil
			)

			if hit then
				lastWorldX, lastWorldY, lastWorldZ = x,y,z
			end
			
		end

	end)

	addEventHandler('onClientClick', root, function( button, state, _, _, x,y,z, clickedWorld )

		if windowOpened and button == 'mouse1' then

			if map[clickedWorld] then
				map[clickedWorld]:select()
			end

		end

	end)

-----------------------------------

	function createObjectFromCursor()

		local object = EditorObject({

			model = editor_config.default_model,
			x = lastWorldX,
			y = lastWorldY,
			z = lastWorldZ,

		})

		object:select()

		return object

	end

	function createObjectFromScreen()

		local cx,cy,cz = getCameraMatrix()
		local x,y,z = getWorldFromScreenPosition( sx/2, sy/2, 1000 )

		local hit, hx,hy,hz = processLineOfSight(
			cx,cy,cz, x,y,z,
			true, true, false,
			true, true, false, false, false
		)

		if not hit then hx,hy,hz = x,y,z end

		local object = EditorObject({

			model = editor_config.default_model,
			x = hx,
			y = hy,
			z = hz,

		})

		object:select()

		return object

	end

-----------------------------------


	addEventHandler('onClientRender', root, function()

		if windowOpened and selectedMoveObject then
			local azo = getModelAxisOffset(selectedMoveObject.object)
			setElementPosition( selectedMoveObject.object, lastWorldX, lastWorldY, lastWorldZ - azo )
		end

	end)

-----------------------------------


