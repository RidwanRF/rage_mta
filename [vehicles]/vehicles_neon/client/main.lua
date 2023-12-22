
-- local white = exports.core:getTexture('white')

local texture = dxCreateTexture('assets/images/neon.png')

addEventHandler('onClientPreRender', root, function()

    local mx,my,mz = getElementPosition( localPlayer.vehicle )

    local bx1,by1,bz1 = getVehicleComponentPosition( localPlayer.vehicle, 'wheel_lb_dummy', 'world' )
    local bx2,by2,bz2 = getVehicleComponentPosition( localPlayer.vehicle, 'wheel_rb_dummy', 'world' )

    local fx1,fy1,fz1 = getVehicleComponentPosition( localPlayer.vehicle, 'wheel_lf_dummy', 'world' )
    local fx2,fy2,fz2 = getVehicleComponentPosition( localPlayer.vehicle, 'wheel_rf_dummy', 'world' )

    local x1,y1,z1 = (bx1+bx2)/2, (by1+by2)/2, (bz1+bz2)/2
    local x2,y2,z2 = (fx1+fx2)/2, (fy1+fy2)/2, (fz1+fz2)/2

    local tx,ty,tz = (x1+x2)/2, (y1+y2)/2, (z1+z2)/2

    local z = getGroundPosition( tx,ty,tz ) + 0.01

    local jx1,jy1 = getPointFromDistanceRotation( mx,my, getDistanceBetweenPoints2D(mx,my,x1,y1)+1, -localPlayer.vehicle.rotation.z+180 )
    local jx2,jy2 = getPointFromDistanceRotation( mx,my, getDistanceBetweenPoints2D(mx,my,x2,y2)+1, -localPlayer.vehicle.rotation.z )

    dxDrawMaterialLine3D(
        jx1, jy1, z,
        jx2, jy2, z,
        texture, getDistanceBetweenPoints3D( bx1,by1,bz1, bx2,by2,bz2 )+0.5,
        tocolor(180,70,70,255),
        -- tocolor(255,255,255,255),
        (x1+x2)/2,
        (y1+y2)/2,
        999999
    )


end)