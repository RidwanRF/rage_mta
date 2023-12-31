--
-- c_tex_names.lua
--

---------------------------------------
-- Local variables for this file
---------------------------------------
local myShader
local bShowTextureUsage = false
local uiTextureIndex = 1
local m_SelectedTextureName = ""
local scx, scy = guiGetScreenSize ()
local usageInfoList = {}


---------------------------------------
-- Startup
---------------------------------------
addEventHandler( "onClientResourceStart", resourceRoot,
	function()

		-- Version check
		if getVersion ().sortable < "1.1.0" then
			outputChatBox( "Resource is not compatible with this client." )
			return
		end

		-- Create shader
		local tec
		myShader, tec = dxCreateShader ( "tex_names.fx", 9999999999999, 9999999999999, true, "all" )
        dxSetShaderValue(myShader, 'gTexture', dxCreateTexture('a.png'))

		if not myShader then
			outputChatBox( "Could not create shader. Please use debugscript 3" )
		else
			outputChatBox( "Using technique " .. tec )

			outputChatBox( "Utility to help find world texture names", 255, 255, 0 )

			outputChatBox( "Press num_8 to view list", 0, 255, 255 )
			outputChatBox( "Press num_7 and num_9 to step list", 0, 255, 255 )
			outputChatBox( "Press k to copy texture name to clipboard", 0, 255, 255 )
		end
	end
)


---------------------------------------
-- Draw visible texture list
---------------------------------------


local veh = nil
addEventHandler( "onClientRender", root,
	function()
		usageInfoList = engineGetVisibleTextureNames ()
		-- usageInfoList = engineGetVisibleTextureNames ()
        -- veh = getPedOccupiedVehicle(localPlayer)
        -- if not veh then return end
		-- usageInfoList = engineGetModelTextureNames (getElementModel(veh))

		local iXStartPos = scx - 200;
		local iYStartPos = 0;
		local iXOffset = 0;
		local iYOffset = 0;

		if bShowTextureUsage then
			for key, textureName in ipairs(usageInfoList) do

				local bSelected = textureName == m_SelectedTextureName;
				local dwColor = bSelected and tocolor(255,220,128) or tocolor(224,224,224,204)

				if bSelected then
					dxDrawText( textureName, iXStartPos + iXOffset + 1, iYStartPos + iYOffset + 1, 0, 0, tocolor(0,0,0) )
				end
				dxDrawText( textureName, iXStartPos + iXOffset, iYStartPos + iYOffset, 0, 0, dwColor )

				iYOffset = iYOffset + 15
				if iYOffset > scy - 15 then
					iYOffset = 0;
					iXOffset = iXOffset - 200;
				end
			end
		end
	end
)


---------------------------------------
-- Handle keyboard events from KeyAutoRepeat
---------------------------------------
salonTextures = {}

addEventHandler("onClientKeyClick", resourceRoot,
	function(key)
		if key == "num_7" then
			moveCurrentTextureCaret( -1 )
		elseif key == "num_9" then
			moveCurrentTextureCaret( 1 )
		elseif key == "num_8" then
			bShowTextureUsage = not bShowTextureUsage
		elseif key == "k" then
			if m_SelectedTextureName ~= "" then
				setClipboard( m_SelectedTextureName )
				outputChatBox( "'" .. tostring(m_SelectedTextureName) .. "' copied to clipboard" )
			end
		end
	end
)


---------------------------------------
-- Change current texture
---------------------------------------
function moveCurrentTextureCaret( dir )

	if #usageInfoList == 0 then
		return
	end
    -- if not veh then return end

	-- Validate selection in current texture list, or find closest match
	-- for key, textureName in ipairs(usageInfoList) do
		-- if m_SelectedTextureName <= textureName then
			-- uiTextureIndex = key
			-- break
		-- end
	-- end
	-- Move position in the list
	uiTextureIndex = uiTextureIndex + dir
	uiTextureIndex = ( ( uiTextureIndex - 1 ) % #usageInfoList ) + 1

	-- Change highlighted texture
	engineRemoveShaderFromWorldTexture ( myShader, m_SelectedTextureName, veh )
	m_SelectedTextureName = usageInfoList [ uiTextureIndex ]
    -- setClipboard(toJSON(usageInfoList))
	engineApplyShaderToWorldTexture ( myShader, m_SelectedTextureName, veh )
    
    -- salonTextures[getElementModel(veh)] = m_SelectedTextureName
    -- setClipboard(toJSON(salonTextures))

end
