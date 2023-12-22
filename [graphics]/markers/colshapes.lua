
local shapes = {}

function renderShape(shape)

	local sizeX, sizeY = getColShapeSize( shape )
	if shape.dimension ~= localPlayer.dimension then return end
	if shape.interior ~= localPlayer.interior then return end

	texture = isElement(texture) and texture or exports.core:getTexture('white')

	local x,y,width
	local color = tocolor(180, 70, 70, 100)

	local cx,cy = getElementPosition(shape)
	local cw,ch = sizeX, sizeY
	local mapBorder = { cx,cy+ch, cw,ch }

    x,y,width = mapBorder[1], mapBorder[2] - mapBorder[4]/2, mapBorder[4]

    local z = shape:getData('z') or -10
    
	dxDrawMaterialLine3D(x,y, z+100, x,y,
		z, texture, width, color, false, 999999, 0, 0)
------------------------------------------------------------------------------------
    x,y,width = mapBorder[1] + mapBorder[3], mapBorder[2] - mapBorder[4]/2, mapBorder[4]
    
	dxDrawMaterialLine3D(x,y, z+100, x,y,
		z, texture, width, color, false, 999999, 0, 0)
------------------------------------------------------------------------------------
    x,y,width = mapBorder[1] + mapBorder[3]/2, mapBorder[2], mapBorder[3]
    
	dxDrawMaterialLine3D(x,y, z+100, x,y,
		z, texture, width, color, false, 0, 999999, 0)
------------------------------------------------------------------------------------
    x,y,width = mapBorder[1] + mapBorder[3]/2, mapBorder[2] - mapBorder[4], mapBorder[3]
    
	dxDrawMaterialLine3D(x,y, z+100, x,y,
		z, texture, width, color, false, 0, 999999, 0)

------------------------------------------------------------------------------------
end

addEventHandler('onClientRender', root, function()

	for _, shape in pairs( getElementsByType('colshape') ) do
		if shape:getData('render') and getColShapeType(shape) == 3 then
		renderShape(shape)
		end
	end

end)
