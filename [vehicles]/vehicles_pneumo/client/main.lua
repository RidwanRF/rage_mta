

------------------------------------------------------------

    local pneumo_anim = {}
    local pneumo_step_anim = {}

    setAnimData( pneumo_anim, 0.2, 0 )
    setAnimData( pneumo_step_anim, 0.1, 0 )

------------------------------------------------------------

    function displayPneumoAnim( step )

        addEventHandler('onClientRender', root, renderPneumoAnim)

        local animData, target = getAnimData( pneumo_anim )

        animate( pneumo_anim, 1 )

        if target > 0 then
            animate( pneumo_step_anim, step )
        else
            setAnimData( pneumo_step_anim, 0.1, step )
        end

        if isTimer( animTimer ) then killTimer( animTimer ) end

        animTimer = setTimer(function()
            animate( pneumo_anim, 0 )
        end, 2000, 1)

    end
    addEvent('pneumo.displayAnim', true)
    addEventHandler('pneumo.displayAnim', resourceRoot, displayPneumoAnim)

------------------------------------------------------------

    function renderPneumoAnim()

        local animData, target = getAnimData( pneumo_anim )

        if animData < 0.01 and target == 0 then

            destroyAllDrawingTextures()
            return removeEventHandler('onClientRender', root, renderPneumoAnim)

        end

        local p_animData, p_target = getAnimData( pneumo_step_anim )
        local i_p_animData = interpolateNumber(p_animData, -Config.pneumoAmplitude, Config.pneumoAmplitude)

        local w,h = 10, 200
        local x,y = sx - 400 - w, ( real_sy - px( h + 250 ) ) * sx/real_sx
        x = x + 50 * ( 1-animData )
        y = y + 50 * ( 1-animData )

        local r,g,b = 0, 0, 0

        dxDrawRectangle(
            x - 40, y,
            44, h, tocolor( 25,24,38, 100*animData )
        )

        mta_dxDrawRectangle(
            px(x - 40), px( y + h - 2 ),
            px(44), 2, tocolor( r,g,b, 255*animData )
        )

        dxDrawText('0.0',
            x - 40, y + h - 2,
            x, y + h - 2,
            tocolor(r,g,b,255*animData),
            0.5, 0.5, getFont('montserrat_bold', 23, 'light'),
            'center', 'bottom'
        )

        mta_dxDrawRectangle(
            px(x - 40), px( y + h/2 ),
            px(44), 2, tocolor( r,g,b, 255*animData )
        )

        dxDrawText('0.5',
            x - 40, y + h/2,
            x, y + h/2,
            tocolor(r,g,b,255*animData),
            0.5, 0.5, getFont('montserrat_bold', 23, 'light'),
            'center', 'bottom'
        )

        mta_dxDrawRectangle(
            px(x - 40), px( y ),
            px(44), 2, tocolor( r,g,b, 255*animData )
        )

        dxDrawText('1.0',
            x - 40, y,
            x, y + h/2,
            tocolor(r,g,b,255*animData),
            0.5, 0.5, getFont('montserrat_bold', 23, 'light'),
            'center', 'top'
        )


        dxDrawImage(
            x,y,w,h, 'assets/images/line.png',
            0, 0, 0, tocolor( 25,24,38,255*animData )
        )

        drawImageSection(
            x,y+1,w,h, 'assets/images/line.png',
            { x = 1, y = i_p_animData }, tocolor( 180,70,70,255*animData ), 1
        )

        local tw,th = 20,20
        local tx,ty = x + w + 5, y+h - h*i_p_animData - th/2

        dxDrawImage(
            tx,ty,tw,th, 'assets/images/tr.png',
            0, 0, 0, tocolor( 180,70,70,255*animData )
        )

    end

------------------------------------------------------------