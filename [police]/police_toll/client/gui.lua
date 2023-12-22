


openHandler = function()
	ticketsInput[6] = ''
end
closeHandler = function()
end
addEventHandler('onClientResourceStart', resourceRoot, function()

windowModel = {
	main = {
		{'image',
			sx/2 - 456/2, sy/2 - 544/2,
			456, 544,
			'assets/images/main.png',
			color = {255,255,255,255},
		},

		{'button', 
			sx/2 + 456/2 - 70, sy/2 - 544/2 + 20,
			50, 50,
			'',
			bg = closeTexture,
			color = {255,255,255,255},
			font = 'default',
			scale = 1,
			shadowRadius = 0,
			onClick = function(element)
				closeWindow()
			end,
		},

		{'image',
			sx/2 - 247/2, sy/2 + 544/2 - 150 - 95,
			247, 82,
			'assets/images/time_bg.png',
			color = {20,20,20,255},
		},

		{'button', 
			sx/2 - 247/2, sy/2 + 544/2 - 150,
			247, 41,
			'Оплатить проезд',

			color = {14,108,196,255},
			bg = 'assets/images/button.png',

			font = getFont('proximanova_bold', 14, 'light'),
			scale = 15/16,

			onClick = function(element)
				triggerServerEvent('toll.handlePass', resourceRoot, tempToll)
			end,
		},

		{'button', 
			sx/2 - 247/2, sy/2 + 544/2 - 150 + 50,
			247, 41,
			'Купить абонемент',

			color = {14,108,196,255},
			bg = 'assets/images/button.png',

			font = getFont('proximanova_bold', 14, 'light'),
			scale = 15/16,

			onClick = function(element)
				changeWindowSection('buy_tickets')
			end,
		},

		{'text', 
			sx/2 - 456/2 + 50, sy/2 - 544/2 + 40,
			sx/2 - 456/2 + 50, sy/2 - 544/2 + 40,
			'Платная дорога',
			color = {255,255,255,255},
			font = getFont('proximanova_bold', 15, 'bold'),
			scale = 17/18,
			shadowRadius = 0,
			alignY = 'center',
		},

		{'text', 
			0, sy/2 + 544/2 - 25,
			sx, sy/2 + 544/2 - 25,
			'При наличии VIP аккаунта проезды бесплатны',
			color = {70,70,70,255},
			font = getFont('proximanova_bold', 12, 'light'),
			scale = 12/13,
			shadowRadius = 0,
			alignX = 'center',
			alignY = 'bottom',
		},

		{'text', 
			0, sy/2 + 544/2 - 150 - 105,
			sx, sy/2 + 544/2 - 150 - 105,
			'Стоимость проезда:',
			color = {70,70,70,255},
			font = getFont('proximanova_bold', 13, 'light'),
			scale = 12/13,
			shadowRadius = 0,
			alignX = 'center',
			alignY = 'bottom',
		},

	},

	buy_tickets = {
		{'image',
			sx/2 - 322/2, sy/2 - 224/2,
			322, 224,
			'assets/images/tickets.png',
			color = {255,255,255,255},
		},

		{'button', 
			sx/2 + 322/2 - 50, sy/2 - 224/2 + 10,
			40, 40,
			'',
			bg = closeTexture,
			color = {255,255,255,255},
			font = 'default',
			scale = 1,
			shadowRadius = 0,
			onClick = function(element)
				changeWindowSection('main')
			end,
		},

		{'text', 
			sx/2 - 322/2 + 25, sy/2 - 224/2 + 32,
			sx/2 - 322/2 + 25, sy/2 - 224/2 + 32,
			'Покупка абонемента',
			color = {255,255,255,255},
			font = getFont('proximanova_bold', 14, 'bold'),
			scale = 17/18,
			shadowRadius = 0,
			alignY = 'center',
		},

		{'text', 
			sx/2 - 224/2 + 10, sy/2 - 224/2 + 120,
			sx/2 - 224/2 + 10, sy/2 - 224/2 + 120,
			function()
				local count = tonumber(ticketsInput[6]) or 0
				local _, ticket = getCurrentPassCost()
				local sum = count * ticket

				return string.format('Сумма: %s $', splitWithPoints(sum, '.'))
			end,
			color = {255,255,255,255},
			font = getFont('proximanova_bold', 15, 'light'),
			scale = 17/18,
			shadowRadius = 0,
		},

		{'input', 
			sx/2 - 224/2, sy/2 - 224/2 + 65,
			224, 44,
			'',
			placeholder = 'Введите сумму',

			color = {25,25,25,255},
			placeholderColor = {70,70,70,255},
			bg = 'assets/images/input.png',

			onInit = function(element)
				ticketsInput = element
			end,
			needInit = true,

			font = getFont('proximanova_bold', 14, 'light'),
			scale = 15/16,
		},

		{'button', 
			sx/2 - 247/2, sy/2 + 224/2  - 60,
			247, 41,
			'Купить',

			color = {14,108,196,255},
			bg = 'assets/images/button.png',

			font = getFont('proximanova_bold', 14, 'light'),
			scale = 15/16,

			onClick = function(element)

				local count = tonumber(ticketsInput[6]) or 0
				if count <= 0 then return end

				triggerServerEvent('toll.buyTickets', resourceRoot, count)

				changeWindowSection('main')
				ticketsInput[6] = ''

				closeWindow()

			end,
		},
	},
}

----------------------------------------------------------------------

	local startY = sy/2 + 544/2 - 150 - 95 + 10
	local startX = sx/2 - 247/2 + 10

	for i = 1,2 do

		local data = Config.costs[i]

		table.insert(windowModel.main,
			{'image',
				startX, startY,
				30, 30,
				string.format('assets/images/time_%s.png', i),
				color = {255,234,95,255},

				data = data,

				onRender = function(element)
					local alpha = element.color[4]*windowAlpha/255

					dxDrawText(
						string.format('%s:00 - %s:00',
							data.time[1], data.time[2]
						),
						element[2] + element[4] + 5, element[3],
						element[2] + element[4] + 5, element[3] + element[5],
						tocolor(255,255,255,255*alpha),
						13/14, 13/14, getFont('proximanova_bold', 13, 'light'),
						'left', 'center'
					)

					dxDrawImage(
						element[2] + element[4] + 110, element[3] + 2,
						element[4] - 4, element[5] - 4,
						'assets/images/rub.png',
						0, 0, 0, tocolor(255,255,255,255*alpha)
					)

					dxDrawText(
						splitWithPoints(data.cost, '.'),
						element[2] + element[4] + 145, element[3],
						element[2] + element[4] + 145, element[3] + element[5],
						tocolor(255,255,255,255*alpha),
						13/14, 13/14, getFont('proximanova_bold', 13, 'bold'),
						'left', 'center'
					)

				end,
			}
		)

		startY = startY + 33
	end

----------------------------------------------------------------------

loadGuiModule()


end)

