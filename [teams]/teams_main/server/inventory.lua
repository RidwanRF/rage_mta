


-------------------------------------------------------

	addEventHandler('onElementDataChange', resourceRoot, function(dn, old, new)


		if dn == 'inventory' then

			if client then
				return source:setData(dn, old)
			end

			new = new or {}

			local p_marker = source:getData('mansion.parent_marker')
			if not isElement(p_marker) then return end

			local m_data = p_marker:getData('mansion.data')

			if m_data and m_data.owner then

				local team = getTeamFromId( m_data.owner )
				if team then
					setTeamData( team.data.id, 'inventory', new )
				end

			end

		end


	end)

-------------------------------------------------------

	addEventHandler('onElementDataChange', resourceRoot, function(dn, old, new)

		if dn == 'mansion.inventory' then

			if new then

				local p_marker = source:getData('mansion.parent_marker')

				if isElement(p_marker) then

					local m_data = p_marker:getData('mansion.data') or {}
					
					local team = getTeamFromId( m_data.owner )

					if team then
						source:setData('inventory', team.data.inventory)
					end

				end


			end

		end

	end)

-------------------------------------------------------