
addEvent('returnClipBoardValue',false);
addEvent('onClientPaste',false);

function loadBrowser()

	local jsSource = [[
		var inputElement = document.createElement('input');
		document.body.appendChild(inputElement);
		inputElement.focus();
		setInterval(function(){
			inputElement.focus();
		}, 100);
		inputElement.onpaste = function() {
			inputElement.value = '';
			setTimeout(function() {
				mta.triggerEvent('returnClipBoardValue',inputElement.value);
			}, 10);
		};
	]];

	local browser = createBrowser(1,1,true,false);


	addEventHandler('returnClipBoardValue',browser,function (data)
		triggerEvent('onClientPaste',root,data);
	end);

	addEventHandler("onClientBrowserCreated",browser,function()
		loadBrowserURL(browser,'http://mta/nothing');
		focusBrowser(browser);
	end);

	addEventHandler("onClientBrowserDocumentReady",browser,function()
		executeBrowserJavascript(browser, jsSource);
	end);

	addEventHandler('onClientKey',root,function(key,state)
	    if state then
	        if (getKeyState('rctrl') or getKeyState('lctrl')) and (getKeyState('v') or getKeyState("V")) then
	            cancelEvent();
	        end
	    end
	end);

end

addEventHandler('onClientElementDataChange', localPlayer, function(dn,old,new)
	if exports.acl:isAdmin(localPlayer) and dn == 'unique.login' and not old then
		loadBrowser()
	end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
	if exports.acl:isAdmin(localPlayer) then
		loadBrowser()
	end
end)
