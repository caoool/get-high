postRoutes = Picker.filter (req, res) ->
	req.method == 'POST'

Picker.route '/notifications',
	(params, req, res, next) ->
		Logs.log "Google calendar notifications retrieved"
		Logs.log params
		Logs.log req
		res.writeHead 200, 'Content-Type': 'Text/plain'
		res.end 'ok'