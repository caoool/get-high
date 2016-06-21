Meteor.methods
	# !!!
	# 	ONLY ['public', 'private', 'confidential']
	# 	CAN BE PASSED AS THE SECOND PARAMETER.
	# DESCRIPTION:
	# 	Set events' visibility, update in google calendar as
	# 	well as updating on our own server ('calenders.sync'
	# 	method call is following google api call).
	# PARAMETERS:
	# 	{String} eventId
	# 	{String} visibility
	# RETURN:
	#   Does not matter
	'events.setVisibility': (eventId, visibility='default') ->
		future = new Future()
		event = Events.findOne id: eventId
		data = 
			start: dateTime: event.start
			end: dateTime: event.end
			visibility: visibility
		url = "/calendar/v3/calendars/#{event.calendarId}/events/#{eventId}"
		GoogleApi.put url, data: data,
			(error, result) ->
				if error
					future.return throwError error
				else
					Meteor.call 'calendars.sync', event.calendarId,
						(error) ->
							if error
								future.return throwError error
							else
								future.return result
		future.wait()