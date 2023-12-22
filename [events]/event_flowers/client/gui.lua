
cancelButtons = {
    ['f1'] = true,
    ['f2'] = true,
    ['f3'] = true,
    ['f4'] = true,
    ['f5'] = true,
    ['f7'] = true,
    ['f11'] = true,
    ['f9'] = true,
    ['k'] = true,
    ['i'] = true,
    ['m'] = true,
}

openHandler = function()
end

closeHandler = function()

end

hideBackground = true

addEventHandler('onClientResourceStart', resourceRoot, function()

    windowModel = {

        main = {

            {'image',
                'center', 'center',
                800, 505,
                'assets/images/bg.png',
                color = {25, 24, 38, 255},

                onPreRender = function(element)

                    local alpha = element:alpha()
                    local x, y, w, h = element:abs()

                    dxDrawImage(
                        x + w / 2 - 826 / 2,
                        y + h / 2 - 531 / 2 + 5,
                        826, 531, 'assets/images/bg_shadow.png',
                    0, 0, 0, tocolor(0, 0, 0, 255 * alpha))

                    dxDrawImage(
                        x + w / 2 - 918 / 2,
                        y + h / 2 - 618 / 2,
                        918, 618, 'assets/images/garland.png',
                    0, 0, 0, tocolor(255, 255, 255, 255 * alpha))

                    dxDrawImage(
                        x - 115,
                        y - 75,
                        462, 238, 'assets/images/flower2.png',
                    0, 0, 0, tocolor(255, 255, 255, 255 * alpha))

                end,

                onRender = function(element)

                    local alpha = element:alpha()
                    local x, y, w, h = element:abs()

                    dxDrawImage(
                        x - 30,
                        y + 450,
                        850, 100, 'assets/images/snow.png',
                    0, 0, 0, tocolor(255, 255, 255, 255 * alpha))

                    dxDrawImage(
                        x + 0,
                        y - 180,
                        855, 685, 'assets/images/fon.png',
                    0, 0, 0, tocolor(255, 255, 255, 255 * alpha))

                    dxDrawText('Новогодний сбор',
                        x + 60, y + 30,
                        x + 60, y + 30,
                        tocolor(255, 255, 255, 255 * alpha),
                        0.5, 0.5, getFont('montserrat_bold', 45, 'light'),
                        'left', 'top'
                    )

                    dxDrawText(table.concat({
                        'Собирай игрушки по карте, они нужны для перехода на новый уровень.',
                        'Каждый новый уровень даёт тебе интересные и полезные призы!',
                        'Игрушки обозначаются на миникарте значками, будь внимательнее!',
                    }, '\n'),
                    x + 60, y + 70,
                    x + 60, y + 70,
                    tocolor(255, 255, 255, 255 * alpha),
                    0.5, 0.5, getFont('montserrat_medium', 23, 'light'),
                    'left', 'top'
                )

            end,

            elements = {

                {'button',

                    0, 0, 26, 26,
                    bg = 'assets/images/close.png',
                    activeBg = 'assets/images/close_active.png',
                    define_from = '',

                    '',

                    color = {180, 70, 70, 255},
                    activeColor = {200, 70, 70, 255},

                    onInit = function(element)

                        element[2] = element.parent[4] - element[4] - 20
                        element[3] = 25

                    end,

                    onRender = function(element)

                        local alpha = element:alpha()
                        local x, y, w, h = element:abs()

                        dxDrawImage(
                            x, y, w, h, 'assets/images/close_icon.png',
                        0, 0, 0, tocolor(255, 255, 255, 255 * alpha))

                    end,

                    onClick = closeWindow,

                },

                {'image',
                    50, 180,
                    613, 289,
                    'assets/images/list_bg.png',
                    color = {19, 19, 31, 255},

                    onRender = function(element)

                        local alpha = element:alpha()
                        local x, y, w, h = element:abs()

                        dxDrawText('Прокачивай уровень!',
                            x + 10, y - 23,
                            x + 10, y - 23,
                            tocolor(255, 255, 255, 255 * alpha),
                            0.5, 0.5, getFont('montserrat_semibold', 30, 'light'),
                            'left', 'center'
                        )

                        local lw, lh = 169, 28
                        local lx, ly = x + w - lw - 10, y - 23 - lh / 2

                        dxDrawImage(
                            lx, ly, lw, lh, 'assets/images/level_bg.png',
                        0, 0, 0, tocolor(19, 19, 31, 255 * alpha))

                        dxDrawText(('Уровень #cd4949 %s / %s'):format(
                            (localPlayer:getData('flowers.level') or 0) + 1,
                            #Config.levels
                        ),
                        lx, ly, lx + lw, ly + lh,
                        tocolor(255, 255, 255, 255 * alpha),
                        0.5, 0.5, getFont('montserrat_semibold', 24, 'light'),
                        'center', 'center', false, false, false, true
                    )

                end,

                elements = {

                    {'element',
                        'center', 'center',
                        '95%', '90%',
                        color = {255, 255, 255, 255},

                        overflow = 'vertical',

                        scrollXOffset = 25,
                        scrollHeight = 0.9,
                        scrollBgColor = {19, 19, 31, 255},

                        onInit = function(element)

                            local w, h = 283, 187
                            local padding = element[4] - w * 2
                            local startY = 10

                            for index, level in pairs(Config.levels) do

                                local side = (index % 2 == 0) and 'right' or 'left'

                                element:addElement(
                                    {'image',
                                        side, startY,
                                        w, h,
                                        color = {25, 24, 38, 255},
                                        'assets/images/item_bg.png',

                                        index = index,
                                        level = level,

                                        onInit = function(element)

                                            element.y0 = element[3]

                                        end,

                                        onRender = function(element)

                                            local alpha = element:alpha()
                                            local x, y, w, h = element:abs()

                                            if (element.index - 1) ~= (localPlayer:getData('flowers.level') or 0) then
                                                alpha = 0.3
                                            end

                                            element[3] = element.y0 - 7 * element.animData

                                            local cr, cg, cb = interpolateBetween(25, 24, 38, 28, 27, 41, element.animData, 'InOutQuad')
                                            local cr2, cg2, cb2 = interpolateBetween(22, 21, 35, 25, 24, 38, element.animData, 'InOutQuad')

                                            element.color = {cr, cg, cb, element.color[4]}

                                            drawImageSection(
                                                x, y, w, h, element[6],
                                                {x = 1, y = 0.63}, tocolor(cr2, cg2, cb2, 255 * alpha), 1
                                            )

                                            dxDrawText(('%sур.'):format(element.index),
                                                x + 65, y + 35,
                                                x + 65, y + 35,
                                                tocolor(255, 255, 255, 255 * alpha),
                                                0.5, 0.5, getFont('montserrat_bold', 37, 'light'),
                                                'center', 'center'
                                            )

                                            local progress = 0
                                            local levelProgress = {}

                                            if (element.index - 1) == (localPlayer:getData('flowers.level') or 0) then

                                                levelProgress = localPlayer:getData('flowers.level_progress') or {}

                                                progress = (
                                                    (levelProgress.rose or 0) +
                                                    (levelProgress.camomile or 0) +
                                                    (levelProgress.tulip or 0)) / (
                                                    element.level.requirements.rose +
                                                    element.level.requirements.camomile +
                                                    element.level.requirements.tulip
                                                )

                                            end

                                            local lw, lh = 12, 148
                                            local lx, ly = x + w - lw - 15, y + h / 2 - lh / 2

                                            dxDrawImage(
                                                lx, ly, lw, lh, 'assets/images/progress.png',
                                            0, 0, 0, tocolor(19, 19, 21, 255 * alpha))

                                            drawImageSection(
                                                lx, ly, lw, lh, 'assets/images/progress.png',
                                                {x = 1, y = progress}, tocolor(180, 70, 70, 255 * alpha), 1
                                            )

                                            local blim_anim = getAnimData(element.parent.blim_anim)

                                            drawImageSection(
                                                lx, ly, lw, lh, 'assets/images/progress.png',
                                                {x = 1, y = progress * blim_anim}, tocolor(255, 130, 130, 255 * alpha * (1 - blim_anim)), 1
                                            )

                                            local startX = x + 120

                                            local fw, fh = 24, 24
                                            local fy = y + 30 - fh / 2
                                            local padding = 25

                                            for _, flower_type in pairs({'camomile', 'tulip', 'rose'}) do

                                                dxDrawImage(
                                                    startX, fy,
                                                    fw, fh, ('assets/images/flowers/%s.png'):format(flower_type),
                                                0, 0, 0, tocolor(255, 255, 255, 255 * alpha))

                                                local str = ('%s/%s'):format(
                                                    levelProgress[flower_type] or 0,
                                                    element.level.requirements[flower_type] or 0
                                                )

                                                local scale, font = 0.5, getFont('montserrat_bold', 18, 'light')

                                                if #str > 6 then
                                                    font = getFont('montserrat_bold', 16, 'light')
                                                end

                                                dxDrawText(str,
                                                    startX, fy + fh + 2,
                                                    startX + fw, fy + fh + 2,
                                                    tocolor(200, 200, 200, 255 * alpha),
                                                    scale, scale, font,
                                                    'center', 'top'
                                                )

                                                startX = startX + fw + padding

                                            end

                                            local rw, rh = 45, 45
                                            local padding = 30

                                            dxDrawText('Награда за уровень',
                                                x + 130, y + 78,
                                                x + 130, y + 78,
                                                tocolor(70, 70, 90, 255 * alpha),
                                                0.5, 0.5, getFont('montserrat_semibold', 22, 'light'),
                                                'center', 'top'
                                            )

                                            local sCount = #element.level.rewards / 2
                                            local startX = x + 130 - sCount * rw - padding * (sCount - 0.5)
                                            local startY = y + h - rh - 35

                                            for _, reward in pairs(element.level.rewards) do

                                                dxDrawImage(
                                                    startX, startY,
                                                    rw, rh, reward.icon,
                                                0, 0, 0, tocolor(255, 255, 255, 255 * alpha))

                                                dxDrawText(reward.text,
                                                    startX, startY + rh,
                                                    startX + rw, startY + rh,
                                                    tocolor(255, 255, 255, 255 * alpha),
                                                    0.5, 0.5, getFont('montserrat_semibold', 23, 'light'),
                                                    'center', 'top'
                                                )

                                                startX = startX + rw + padding

                                            end

                                        end,

                                    })

                                    if side == 'right' then
                                        startY = startY + h + padding
                                    end

                                end

                                element.blim_anim = {}
                                setAnimData(element.blim_anim, 0.07, 0)

                                element.blim_timer = setTimer(function()

                                    setAnimData(element.blim_anim, 0.07, 0)
                                    animate(element.blim_anim, 1)

                                end, 2000, 0)

                            end,

                            elements = {

                            },

                        },

                    },

                },

            },

        },

    },

}

loadGuiModule()

end)

