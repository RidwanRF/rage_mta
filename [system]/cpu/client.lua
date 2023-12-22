local sx,sy = guiGetScreenSize()
local resStat = false
local serverStats = nil
local serverColumns, serverRows = {}, {}

function isAllowed()
	return exports.acl:isAdmin(localPlayer)
end

addCommandHandler("stat", function()
	if isAllowed() then
		resStat = not resStat
		if resStat then
			outputChatBox("Resource stats enabled", 0, 255, 0, true)
			addEventHandler("onClientRender", root, resStatRender, true, 'low-200')
			triggerServerEvent("getServerStat", localPlayer)
		else
			outputChatBox("Resource stats disabled", 255, 0, 0, true)
			removeEventHandler("onClientRender", root, resStatRender, true, 'low-200')
			serverStats = nil
			serverColumns, serverRows = {}, {}
			triggerServerEvent("destroyServerStat", localPlayer)
		end
	end
end)

addEvent("receiveServerStat", true)
addEventHandler("receiveServerStat", root, function(stat1,stat2)
	serverStats = true
	serverColumns, serverRows = stat1,stat2
end)

function resStatRender()
	local x = sx-300
	if #serverRows == 0 then
		x = sx-140
	end
	local columns, rows = getPerformanceStats("Lua timing")
	local height = 0
	local hRows = {}
	for i, row in ipairs(rows) do
		if row[2] ~= '-' then
			local _int = row[2]:gsub('%%', '')
			if tonumber(_int) > 0.5 then
				table.insert(hRows, {row[1], row[2]})
				height = height + 15
			end
		end
	end


	local sum = 0
	for k,v in pairs(hRows) do
		local a1 = v[2]:gsub('%%', '')
		sum = sum + tonumber(a1)
	end

	table.sort(hRows, function(a,b)
		local int1 = a[2]:gsub('%%', '')
		local int2 = b[2]:gsub('%%', '')
		return tonumber(int1) > tonumber(int2)
	end)
	local atAll = 0
	for k,v in pairs(hRows) do
		if v[1] ~= 'cpu' then
			local int1 = v[2]:gsub('%%', '')
			atAll = atAll + tonumber(int1) or 0
		end
	end
	table.insert(hRows, 1, {'sum', atAll})
	local y = sy/2-height/2
	if #serverRows == 0 then
		dxDrawText("Client",sx-75,y-20,sx-75,y-20,tocolor(255,255,255,255),1.2,"default_bold","center")
	else
		dxDrawText("Client",sx-235,y-20,sx-235,y-20,tocolor(255,255,255,255),1.2,"default_bold","center")
	end
	dxDrawRectangle(x-10,y,150,height,tocolor(0,0,0,150))
	y = y + 5
	for i, row in ipairs(hRows) do
		if row[2] ~= '-' then
			local text = row[1]:sub(0,15)..": "..row[2]
			dxDrawText(text,x+1,y+1,150,15,tocolor(0,0,0,255),1,"default_bold")
			dxDrawText(text,x,y,150,15,tocolor(255,255,255,255),1,"default_bold")
			y = y + 15
		end
	end
	
	if #serverRows ~= 0 then
		local x = sx-140
		local height = (15*#serverRows)
		local y = sy/2-height/2
		dxDrawText("Server",sx-75,y-20,sx-75,y-20,tocolor(255,255,255,255),1.2,"default_bold","center")
		dxDrawRectangle(x-10,y,150,height+15,tocolor(0,0,0,150))
		y = y + 5
		for i, row in ipairs(serverRows) do
			local text = row[1]:sub(0,15)..": "..row[2]
			dxDrawText(text,x+1,y+1,150,15,tocolor(0,0,0,255),1,"default_bold")
			dxDrawText(text,x,y,150,15,tocolor(255,255,255,255),1,"default_bold")
			y = y + 15
		end
	end
end