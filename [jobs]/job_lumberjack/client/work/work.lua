
--------------------------------------------------------------------------------------

	workMarker = {}

--------------------------------------------------------------------------------------

	function initializeWorkMarker( data )

		workMarker.stage = 'cut'

		workMarker.coords = data.coords

		local x,y,z,rz,fr = unpack( data.coords )

		workMarker.tree_fall_anim = 'tree_fall_anim'
		timed_setAnimData( workMarker.tree_fall_anim, 5000 )

		workMarker.tree = createObject( 1174, x,y,z, 0, 0, rz )
		workMarker.tree_fall_angle = fr

		workMarker.marker = createMarker( x,y,z, 'corona', 5, 0, 0, 0, 0 )
		workMarker.marker:setData('controlpoint.3dtext', '[Срубите дерево]')

		workMarker.blip = createBlipAttachedTo( workMarker.marker, 0 )
		workMarker.blip:setData('icon', 'target')

		workMarker.health = 1000

		workMarker.tree_health_anim = 'tree_health_anim'
		setAnimData( workMarker.tree_health_anim, 0.1, workMarker.health )


		workMarker.slice_markers = {}
		local startZ = 3

		for index = 1,5 do

			local slice_marker = createMarker( x,y,z, 'corona', 4, 0, 0, 0, 0 )

			table.insert( workMarker.slice_markers, { marker = slice_marker, health = 1000, } )
			attachElements( slice_marker, workMarker.tree, 0, 0, startZ )


			startZ = startZ + 3

		end

		workMarker.slice_markers = table.reverse( workMarker.slice_markers )

		workMarker.sliced_objects = {}

		createMarkerHelpHandler( workMarker.marker )

	end

	addEvent('lubmerjack.initializeTreeMarker', true)
	addEventHandler('lubmerjack.initializeTreeMarker', resourceRoot, initializeWorkMarker)

--------------------------------------------------------------------------------------

	function createMarkerHelpHandler( marker )

		addEventHandler('onClientMarkerHit', marker, function( player, mDim )

			if player == localPlayer and mDim and source.interior == player.interior then

				if player.vehicle then
					exports.hud_notify:notify('Для продолжения работы', 'Покиньте автомобиль')
				end

				exports.hud_notify:notify('Зажмите ПКМ', 'Для удара по дереву')
				source:setData('controlpoint.3dtext', nil)

			end

		end)

	end

--------------------------------------------------------------------------------------

	function completeWorkMarker()

		triggerServerEvent('lubmerjack.completeMarker', resourceRoot)
		destroyWorkMarker()

	end

--------------------------------------------------------------------------------------

	function destroyWorkMarker()

		clearTableElements( workMarker )
		workMarker = {}

	end

--------------------------------------------------------------------------------------
	
	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

		if dn == 'work.current' and old == Config.resourceName and not new then
			destroyWorkMarker()
		end

	end)

--------------------------------------------------------------------------------------
