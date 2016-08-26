bodyParser = require 'body-parser'
Picker.middleware bodyParser.json()
Picker.middleware bodyParser.urlencoded extended: false

postRoutes = Picker.filter (req, res) ->
	req.method == 'POST'

getRoutes = Picker.filter (req, res) ->
	req.method == 'GET'

# DESCRIPTION
# 	Sync calendar when receive update notification
# 	from google notification channel. Parse the
# 	result and get channel id which is just the
# 	_id of the calendar in our database, and use
# 	that id to sync corresponding calendar for the
# 	owner.
postRoutes.route '/notifications',
	(params, req, res, next) ->
		if req.headers['x-goog-channel-id']?
			Logs.log '...PICKER...POST:: /notifications >> Notification received from google (events updated)'
			Logs.log '...PICKER...POST:: /notifications >> ' + req.headers['x-goog-channel-id'] + ' >> ' + req.headers['x-goog-resource-id']
			calendar = Calendars.findOne req.headers['x-goog-channel-id']
			if calendar?
				Meteor.call 'calendars.sync',
					calendar.id,
					calendar.createdBy
			else
				# FIXME:: trouble getting user, reconsider

				# data = 
				# 	id: req.headers['x-goog-channel-id']
				# 	resourceId: req.headers['x-goog-resource-id']
				# url = '/calendar/v3/channels/stop'
				# user = Meteor.users.findOne calendar.createdBy
				# options =
				# 	data: data
				# 	user: user
				# GoogleApi.post url, options
				# Log.log "...PICKER...POST:: /notifications >> Notification channel dismissed for #{req.headers['x-goog-channel-id']} because calendar does not exist (unwatch)"
			res.writeHead 200, 'Content-Type': 'Text/plain'
			res.end 'ok'
		else
			res.writeHead 200, 'Content-Type': 'Text/plain'
			res.end '...PICKER...POST:: /notifications >> Not from google notification channels'

postRoutes.route '/hooks/facebook/events',
	(params, req, res, next) ->
		console.log 'received from facebook post'
		items = req.body.entry
		for item in items
			console.log item
			console.log item.changed_fields
		res.writeHead 200, 'Content-Type': 'Text/plain'
		res.end 'ok'

getRoutes.route '/hooks/facebook/events',
	(params, req, res, next) ->
		console.log 'received from facebook get'
		console.log params
		console.log params.query
		console.log params.query['hub.challenge']
		res.writeHead 200, 'Content-Type': 'Text/plain'
		res.end params.query['hub.challenge']
