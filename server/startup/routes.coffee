postRoutes = Picker.filter (req, res) ->
	req.method == 'POST'

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
			Logs.log '...PICKER...POST:: /notifications >> ' + req.headers['x-goog-channel-id']
			calendar = Calendars.findOne req.headers['x-goog-channel-id']
			if calendar?
				Meteor.call 'calendars.sync',
					calendar.id,
					calendar.createdBy
			else
				data = 
					id: req.headers['x-goog-channel-id']
					resourceId: req.headers['x-goog-resource-id']
				url = '/calendar/v3/channels/stop'
				GoogleApi.post url, data: data
				Log.log "...PICKER...POST:: /notifications >> Notification channel dismissed for #{req.headers['x-goog-channel-id']} because calendar does not exist (unwatch)"
			res.writeHead 200, 'Content-Type': 'Text/plain'
			res.end 'ok'
		else
			res.writeHead 200, 'Content-Type': 'Text/plain'
			res.end '...PICKER...POST:: /notifications >> Not from google notification channels'