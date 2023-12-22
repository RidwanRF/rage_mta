
----------------------------------------------------------------------

	local shaders = {

	}

----------------------------------------------------------------------

	function clearTeamShaders()

		for _, player in pairs( getElementsByType('player') ) do

			for _, shader in pairs( shaders ) do
				engineRemoveShaderFromWorldTexture( shader, 'body', player )
			end

		end

	end

----------------------------------------------------------------------

	addEventHandler('onClientElementDataChange', localPlayer, function(dn, old, new)

		if dn == 'team.match.data' then

			clearTeamShaders()

			if new then

				for team_name, team in pairs( new.players ) do

					for player in pairs( team ) do

						if isElement(player) then

							engineApplyShaderToWorldTexture(
								shaders[
									new.match_team == team_name and 'team_mate' or 'team_enemy'
								], 'body', player
							)

						end

					end

				end

			end

		end

	end)

----------------------------------------------------------------------

	addEventHandler('onClientResourceStart', resourceRoot, function()

		shaders.team_mate = dxCreateShader( 'assets/shaders/team_mark.fx', 0, 0, true, 'ped' )
		shaders.team_enemy = dxCreateShader( 'assets/shaders/team_mark.fx', 0, 0, true, 'ped' )

		dxSetShaderValue( shaders.team_mate, 'color', { 70/255, 180/255, 70/255, 1 } )
		dxSetShaderValue( shaders.team_enemy, 'color', { 180/255, 70/255, 70/255, 1 } )

	end)

----------------------------------------------------------------------