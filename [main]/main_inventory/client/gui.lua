
openHandler = function()
	showChat( false )

	exports.main_sounds:playSound( 'window_open' )

end

closeHandler = function()

	showChat( true )

	exports.main_sounds:playSound( 'window_close' )

end


hideBackground = true

addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {

	main = {

		{'image',
			0, 'center',
			482, 589,
			'assets/images/bg.png',
			color = {32,35,66,255},

			id = 'inventory',
			define_from = 'inventory',

			sourceElement = localPlayer,

			updateInventory = function(element)
				element.inventory = localPlayer:getData('inventory') or {}
			end,

			addEvent('inventory.sync_callback', true),
			addEventHandler('inventory.sync_callback', resourceRoot, function()

				for _, id in pairs( { 'inventory', 'exchange-inventory' } ) do

					local inventory = gui_get(id)
					inventory.blocked = false
					inventoryRoot.picked_item = false

				end

			end),

			onInit = function(element)
				element[2] = sx - element[4] - 50
				element:updateInventory()
			end,

			elements = {

				{'image',
					-264-10, 0,
					264, 261,
					'assets/images/wbg.png',
					color = {32,35,66,255},

					onPreRender = function(element)

						local alpha = element:alpha()
						local x,y,w,h = element:abs()

						dxDrawImage(
							x + w/2 - 280/2,
							y + h/2 - 277/2 + 5,
							280, 277, 'assets/images/wbg_shadow.png',
							0, 0, 0, tocolor(0,0,0,255*alpha)
						)

					end,

					onInit = function(element)

						local sw,sh = 199, 96
						local padding = 10

						local sCount = 1

						local startY = element[5]/2 - sCount*sh - padding*(sCount-0.5)

						for i = 1, 2 do

							element:addElement(
								{'image',

									'center', startY,
									sw,sh,

									'assets/images/wslot.png',
									define_from = 'inventory_item',
									inventory = 'weapon',

									index = i,

									color = {45,50,90,255},

									onInit = function(element)

										element:addHandler('onRender', function(element)

											local alpha = element:alpha()
											local x,y,w,h = element:abs()

											if not element:getItem() or element:isPicked() then
												dxDrawImage(
													x,y,w,h, 'assets/images/wslot_ph.png',
													0, 0, 0, tocolor(0, 0, 0, 50*alpha)
												)
											end


										end, 1)

									end,

								}
							)

							startY = startY + padding + sh

						end



					end,


				},

				{'element',

					'center', 'center',
					'100%', '90%',
					color = {255,255,255,255},

					variable = 'mainInventory',

					row_size = { 96, 96 },
					row_slots = 4,
					row_padding = 10,

					addRow = function(element)

						local elements = element.elements or {}
						local last_element = elements[#elements]

						local y = last_element and ( last_element[3] + last_element[5] + element.row_padding ) or 0
						local sw,sh = unpack(element.row_size)

						local element_width = element.row_slots * sw + (element.row_slots-1)*element.row_padding

						element:addElement(
							{'element',

								'center', y,
								element_width, sh,
								color = {255,255,255,255},

								row_index = #elements+1,

								onInit = function(element)

									local sw,sh = unpack(element.parent.row_size)
									local padding = element.parent.row_padding

									local startX = 0

									for i = 1, element.parent.row_slots do

										element:addElement(
											{'image',

												startX, 'center', 
												sw,sh,
												'assets/images/slot.png',

												define_from = 'inventory_item',
												inventory = 'inventory',

												index = (element.row_index-1)*element.parent.row_slots + i,

												color = {45,50,90,255},

											}
										)

										startX = startX + sw + padding

									end

								end,

							}	
						)

					end,

					clearRows = function(element)

						for _, c_element in pairs(element.elements or {}) do
							c_element:destroy()
						end

					end,

					addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)
						if dn == 'inventory' then
							mainInventory:update()
						end
					end),

					overflow = 'vertical',

					update = function(element)

						element.parent:updateInventory()

						local visible_rows = 5
						local current_rows = #(element.elements or {})

						local last_index = 0

						for index, item_data in pairs( element.parent.inventory.inventory or {} ) do
							if index > last_index then
								last_index = index
							end
						end

						local total_slots = element.row_slots * visible_rows
						local used_slots = (getTableLength( element.parent.inventory.inventory or {} ) or 0) + 1

						visible_rows = math.max(
							visible_rows + math.max(0, math.ceil( ( last_index - ( visible_rows * element.row_slots ) )/element.row_slots )),
							visible_rows + math.max(0, math.ceil( (used_slots - total_slots)/element.row_slots ))
						)

						if visible_rows ~= current_rows then

							element:clearRows()

							for i = 1, visible_rows do
								element:addRow()
							end

							animate(element.ov_animId, 0)

						end


					end,

					onInit = function(element)

						element:update()

						element:addHandler('onScroll', function(element)
							inventoryRoot:destroyContextMenu()
						end)

					end,

				},

			},

		},

		{'image',
			50, 'center',
			482, 589,
			'assets/images/bg.png',
			color = {32,35,66,255},

			id = 'exchange-inventory',
			define_from = 'inventory',

			noDraw = function(element)
				return currentInventoryMode ~= 'exchange'
			end,

			updateInventory = function(element)

				if not isElement( currentExchangeMarker ) then
					return closeWindow()
				end

				element.sourceElement = currentExchangeMarker
				element.inventory = currentExchangeMarker:getData('inventory') or { inventory = {} }

			end,

			elements = {

				{'element',

					'center', 'center',
					'100%', '90%',
					color = {255,255,255,255},
					
					variable = 'exchangeInventory',

					row_size = { 96, 96 },
					row_slots = 4,
					row_padding = 10,

					addRow = function(element)

						local elements = element.elements or {}
						local last_element = elements[#elements]

						local y = last_element and ( last_element[3] + last_element[5] + element.row_padding ) or 0
						local sw,sh = unpack(element.row_size)

						local element_width = element.row_slots * sw + (element.row_slots-1)*element.row_padding

						element:addElement(
							{'element',

								'center', y,
								element_width, sh,
								color = {255,255,255,255},

								row_index = #elements+1,

								onInit = function(element)

									local sw,sh = unpack(element.parent.row_size)
									local padding = element.parent.row_padding

									local startX = 0

									for i = 1, element.parent.row_slots do

										element:addElement(
											{'image',

												startX, 'center', 
												sw,sh,
												'assets/images/slot.png',

												define_from = 'inventory_item',
												inventory = 'inventory',

												index = (element.row_index-1)*element.parent.row_slots + i,

												color = {45,50,90,255},

											}
										)

										startX = startX + sw + padding

									end

								end,

							}	
						)

					end,

					clearRows = function(element)

						for _, c_element in pairs(element.elements or {}) do
							c_element:destroy()
						end

					end,

					addEventHandler('onClientElementDataChange', root, function(dn, old, new)
						if dn == 'inventory' and source == currentExchangeMarker then
							exchangeInventory:update()
						end
					end),

					overflow = 'vertical',

					update = function(element)

						element.parent:updateInventory()

						local visible_rows = 5
						local current_rows = #(element.elements or {})

						local last_index = 0

						for index, item_data in pairs( element.parent.inventory.inventory or {} ) do
							if index > last_index then
								last_index = index
							end
						end

						local total_slots = element.row_slots * visible_rows
						local used_slots = (getTableLength( element.parent.inventory.inventory or {} ) or 0) + 1

						visible_rows = math.max(
							visible_rows + math.max(0, math.ceil( ( last_index - ( visible_rows * element.row_slots ) )/element.row_slots )),
							visible_rows + math.max(0, math.ceil( (used_slots - total_slots)/element.row_slots ))
						)


						if visible_rows ~= current_rows then

							element:clearRows()

							for i = 1, visible_rows do
								element:addRow()
							end

							animate(element.ov_animId, 0)

						end

					end,

					onInit = function(element)

						openHandlers.update_inventory = function()

							if currentInventoryMode == 'exchange' then
								exchangeInventory:update()
							end

						end

						element:addHandler('onScroll', function(element)
							inventoryRoot:destroyContextMenu()
						end)

					end,

				},

			},

		},

		{'element',

			0, 0, 0, 0,
			color = {255,255,255,255},
			variable = 'inventoryRoot',

			createContextMenu = function(element, inv_item, actions)

				element.cm_animId = element.cm_animId or {}
				setAnimData(element.cm_animId, 0.1)

				element:destroyContextMenu(true)

				local actionw,actionh = 130, 39
				local padding = 15

				local sizeh = padding*(#actions+1) + #actions*actionh
				local sizew = actionw+padding*2

				local cx,cy = getCursorPosition()
				cx,cy = sx*cx, real_sy*cy * sx/real_sx

				element.context_menu = element:addElement(
					{'image',

						math.min(cx,sx-sizew)-element[2],cy-element[3], sizew, sizeh,
						color = {24,30,66,255},
						createTextureSource('bordered_rectangle', 'assets/images/context.png', 22, sizew, sizeh),

						actions = actions,

						padding = padding,
						size = { actionw, actionh },

						onInit = function(element)

							local startY = element.padding

							for _, action in pairs(element.actions) do
								element:addElement(
									{'button',
										'center', startY,
										element.size[1], element.size[2],
										action.name,
										bg = 'assets/images/button_empty.png',
										activeBg = 'assets/images/button.png',

										scale = 0.5,
										font = getFont('montserrat_semibold', 21, 'light'),

										color = {180, 70, 70, 255},
										activeColor = {200, 70, 70, 255},

										onPreRender = function(element)

											local alpha = element:alpha()
											local x,y,w,h = element:abs()

											local shx,shy,shw,shh = x + w/2 - 148/2, y + h/2 - 57/2, 148, 57

											dxDrawImage(
												shx,shy,shw,shh, 'assets/images/button_empty_shadow.png',
												0, 0, 0, tocolor(180, 70, 70, 255*alpha*(1-element.animData))
											)
											dxDrawImage(
												shx,shy,shw,shh, 'assets/images/button_shadow.png',
												0, 0, 0, tocolor(180, 70, 70, 255*alpha*element.animData)
											)

										end,

										gOnPreRender = function(element)

											local x,y,w,h = element:abs(true)

											if isMouseInPosition(x,y,w,h) and handleClick then
												element:onClick()
												handleClick = false
											end

										end,

										action = action,

										onClick = function(element)
											inventoryRoot:destroyContextMenu()
											element.action.action(element.action.element)
										end,

									}
								)
								startY = startY + element.size[2] + element.padding
							end

						end,

						animationAlpha = element.cm_animId,

					}
				)

				animate(element.cm_animId, 1)

			end,

			destroyContextMenu = function(element, no_anim)

				if element.context_menu then

					function _destroy()
						element.context_menu:destroy()
						element.context_menu = nil
					end

					if no_anim then
						_destroy()
					else
						animate(element.cm_animId, 0, _destroy)
					end

				end

			end,

		},

	},

}


-------------------------------------------------------------------

	GUIDefine('inventory_item', {

		getInventory = function(element)
			return element.parent.parent.parent or element.parent.parent
		end,

		getInventorySource = function(element)
			return element:getInventory().sourceElement
		end,

		getItem = function(element)

			local inventory = element:getInventory()

			local items = inventory.inventory[element.inventory or 'inventory'] or {}

			local item, item_config = items[element.index]

			if item then

				item_config = Config.items[ item.item ]
				return item, item_config

			end

			return false


		end,

		isPicked = function(element)
			return inventoryRoot.picked_item == element
		end,

		onRender = function(element)

			if element:isPicked() then
				return
			end

			local x,y,w,h = element:abs(true)

			if isMouseInPosition(x,y,w,h) then

				local inventory = element:getInventory()
				inventory.hint_element = element

			end

			local x,y = element:abs()
			element:draw_item( x,y )

		end,

		draw_item = function(element, x,y, _alpha)

			local item, config = element:getItem()

			if item then

				local alpha = element:alpha()*(_alpha or 1)
				local _,_,w,h = element:abs()

				local d_texture = getDrawingTexture( config.icon )
				local mw,mh = dxGetMaterialSize(d_texture)

				local ix,iy,iw,ih = x,y,w,h

				if w ~= h then

					if w > h then iw = h
					else ih = w end

				end

				ix,iy = x+w/2-iw/2, y+h/2-ih/2

				dxDrawImage(
					ix,iy,iw,ih, d_texture,
					0, 0, 0, tocolor(255,255,255,255*alpha)
				)

				local rw,rh = 43,43
				local rx,ry = x+w-rw,y+h-rh

				if config.type == 'weapon' then

					local data = item.data or {}

					if config.ammo then

						local aw,ah = 15,15
						local ax,ay = x+w-aw-15,y+h-ah-15

						dxDrawImage(
							ax,ay,aw,ah, 'assets/images/ammo.png',
							0, 0, 0, tocolor(255,255,255,255*alpha)
						)

						dxDrawText(string.format('%s / %s',
							data.inClip or 0, (data.ammo or 0) - (data.inClip or 0)
						),
							ax-2, ay,
							ax-2, ay+ah,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_medium', 20, 'light'),
							'right', 'center'
						)
						
					end

					if config.health then


						local hw,hh = w*0.6, 2
						local hx,hy = x+w/2-hw/2, y + 20

						dxDrawRectangle(
							hx,hy,hw,hh, tocolor(21,21,33,100*alpha)
						)
						dxDrawRectangle(
							hx,hy,hw * ( (data.health or 0) / config.health ),hh, tocolor(180,70,70,255*alpha)
						)

					end


				else

					if (item.count or 0) > 1 and not element:isPicked() then

						dxDrawImage(
							rx,ry, rw,rh, 'assets/images/count.png',
							0, 0, 0, tocolor(180, 70, 70, 255*alpha)
						)

						dxDrawText(item.count,
							rx,ry,rx+rw,ry+rh,
							tocolor(255,255,255,255*alpha),
							0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
							'center', 'center'
						)

					end

				end


			end

		end,

		onClick = function(element, pos, button)

			if button == 'left' then

				local item, config = element:getItem()
				local inventory = element:getInventory()

				if inventory.blocked then return end
				if inventoryRoot.context_menu then
					handleClick = true
					return
				end

				if inventoryRoot.picked_item then
					inventory:pickItem( inventoryRoot.picked_item, element )
				else
					inventoryRoot.picked_item = element
				end

			elseif button == 'right' and element:getInventorySource() == localPlayer then

				setTimer(function()
					element:createContextMenu()
				end, 100, 1)

			end


		end,

		getContextActions = function(element)

			local actions = {
				{name = 'Выбросить', action = function(element)
					local inventory = element:getInventory()
					inventory:dropItem(element)
				end},
			}

			local item, config = element:getItem()

			if config.use then
				table.insert(actions, {
					name = 'Использовать',
					action = function(element)
						local inventory = element:getInventory()
						inventory:useItem(element)
					end,
				})
			end

			for _, action in pairs(actions) do
				action.element = element
			end

			return actions
		end,

		createContextMenu = function(element)

			if element:getItem() then
				inventoryRoot:createContextMenu( element, element:getContextActions() )
			end

		end,

	})

-------------------------------------------------------------------

	GUIDefine('inventory', {

		onPreRender = function(element)

			local alpha = element:alpha()
			local x,y,w,h = element:abs()

			dxDrawImage(
				x + w/2 - 498/2,
				y + h/2 - 605/2 + 5,
				498, 605, 'assets/images/bg_shadow.png',
				0, 0, 0, tocolor(0,0,0,255*alpha)
			)

			element:updateInventory()

		end,

		pickItem = function( element, item_from, item_to )

			local from_source = item_from:getInventorySource()
			local to_source = item_to:getInventorySource()

			triggerServerEvent(from_source == to_source and
				'inventory.moveItem' or 'inventory.moveElementItem',
				resourceRoot,
				{ section = item_from.inventory, slot = item_from.index, source = from_source },
				{ section = item_to.inventory, slot = item_to.index, source = to_source },
				currentExchangeParams
			)

			element.blocked = true

		end,

		dropItem = function(element, item)

			triggerServerEvent('inventory.dropItem', resourceRoot,
				{ section = item.inventory, slot = item.index }
			)

		end,

		useItem = function(element, item)

			triggerServerEvent('inventory.useItem', resourceRoot,
				{ section = item.inventory, slot = item.index }
			)

		end,

		onPostRender = {

			picked_item = function(element)

				if inventoryRoot.picked_item then

					local cx,cy = getCursorPosition()
					if not cx then return end
					cx,cy = sx*cx, real_sy*cy * sx/real_sx

					local _, _, w,h = inventoryRoot.picked_item:abs()

					inventoryRoot.picked_item:draw_item( cx-w/2,cy-h/2, 0.8 )

				end


			end,

			cancel_context_menu = function(element)
				if handleClick and inventoryRoot.context_menu then
					inventoryRoot:destroyContextMenu()
				end
			end,

			draw_hint = function(element)

				local alpha = element:alpha()

				element.hint_animId = element.hint_animId or {}

				local animData = getAnimData(element.hint_animId)
				if not animData then
					setAnimData(element.hint_animId, 0.2)
					animData = 0
				end

				if element.hint_element and element.hint_element:getItem() then
					element.t_hint_element = element.hint_element
				end

				if not element.t_hint_element then return end

				local item, config = element.t_hint_element:getItem()

				animate(element.hint_animId, (
					item and element.hint_element
					and element.t_hint_element == element.hint_element
					and not inventoryRoot.context_menu
				) and 1 or 0)

				if not item then return end
				if inventoryRoot.context_menu then return end


				local splitted = type(config.title) == 'string' and splitStringWithCount(config.title, 20) or config.title

				local scale, font = 0.5, getFont('montserrat_medium', 20, 'light')
				local fontHeight = dxGetFontHeight(scale, font)

				local h = 90 + (#splitted-1)*fontHeight
				local w = 220

				local img_path = string.format('assets/images/hint_%s_%s.png', w,h)

				if img_path ~= element.hint_bg then
					element.hint_bg = element.hint_bg or createTextureSource('bordered_rectangle', img_path, 22, w,h)
				end

				local cx,cy = getCursorPosition()
				if not cx then return end

				cx,cy = sx*cx, real_sy*cy * sx/real_sx
				cx,cy = cx+10,cy+10

				cx = math.min( sx-w-10, cx )

				dxDrawImage(
					cx-2,cy-2,w+4,h+4, element.hint_bg,
					0, 0, 0, tocolor(0,0,0,50*alpha*animData)
				)
				dxDrawImage(
					cx,cy,w,h, element.hint_bg,
					0, 0, 0, tocolor(45,50,90,255*alpha*animData)
				)

				dxDrawText(config.name,
					cx+15,cy+15,
					cx+15,cy+15,
					tocolor(255,255,255,255*alpha*animData),
					0.5, 0.5, getFont('montserrat_semibold', 26, 'light'),
					'left', 'top'
				)

				dxDrawText(Config.item_types[config.type] or config.type,
					cx+15,cy+35,
					cx+15,cy+35,
					tocolor(170,170,170,255*alpha*animData),
					0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
					'left', 'top'
				)

				dxDrawText(table.concat(splitted, '\n'),
					cx+15,cy+55,
					cx+15,cy+55,
					tocolor(255,255,255,255*alpha*animData),
					0.5, 0.5, getFont('montserrat_medium', 20, 'light'),
					'left', 'top'
				)

				element.hint_element = nil

			end,

		},


	})

-------------------------------------------------------------------

loadGuiModule()


end)

