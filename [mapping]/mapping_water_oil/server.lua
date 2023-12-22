

---------------------------------------------------------------

	loadstring( exports.core:include('common') )()
	
---------------------------------------------------------------

	function createOilObject( position )
		createCustomChunkedObject( { position = position, objects = _chunked } )
	end

	for _, pos in pairs( _objects ) do
		createOilObject(pos)
	end

---------------------------------------------------------------