Meteor.methods


	# DESCRIPTION
	# 	Insert a event to selected calendar and sync
	# 	after success.
	# PARAMETERS
	# 	{String} calendarId
	# 	{Object} event
	# 		{String} summary
	# 		{String}? description
	# 		{Date} start.dateTime (format RFC3399)
	# 		{Date} end.dateTime (format RFC3399)
	# 		{String}? location
	# 		{String}? visibility
	# RETURN
	# 	Does not matter
	# 	
	'events.insert': (calendarId, event) ->

		new SimpleSchema
			summary: type: String
			description:
				type: String
				optional: true
			'start.dateTime': type: Date
			'end.dateTime': type: Date
			location:
				type: String
				optional: true
			visibility:
				type: String
				optional: true
		.validate event

		future = new Future()
		future.throw credentialError if !@userId?

		url = "/calendar/v3/calendars/#{calendarId}/events"

		GoogleApi.post url, data: event,
			(error, result) ->
				if error
					future.throw parseError error
				else
					Meteor.call 'calendars.sync', calendarId,
						(error) ->
							if error
								future.throw parseError error
							else
								future.return result

		future.wait()


	# DESCRIPTION
	# 	Delete a event to selected calendar and sync
	# 	after success.
	# PARAMETERS
	# 	{String} eventId
	# RETURN
	# 	Does not matter
	# 	
	'events.delete': (eventId) ->

		new SimpleSchema
			eventId: type: String
		.validate
			eventId: eventId

		future = new Future()
		future.throw credentialError if !@userId?

		event = Events.findOne id: eventId
		url = "/calendar/v3/calendars/#{event.calendarId}/events/#{eventId}"

		GoogleApi.delete url,
			(error, result) ->
				if error
					future.throw parseError error
				else
					Meteor.call 'calendars.sync', event.calendarId,
						(error) ->
							if error
								future.throw parseError error
							else
								future.return result

		future.wait()


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

		new SimpleSchema
			eventId: type: String
			visibility:
				type: String
				allowedValues: [
					'default'
					'public'
					'private'
					'confidential'
				]
		.validate
			eventId: eventId
			visibility: visibility

		future = new Future()
		future.throw credentialError if !@userId?

		event = Events.findOne id: eventId
		data = 
			start: dateTime: event.start
			end: dateTime: event.end
			visibility: visibility
		url = "/calendar/v3/calendars/#{event.calendarId}/events/#{eventId}"

		GoogleApi.put url, data: data,
			(error, result) ->
				if error
					future.throw parseError error
				else
					Meteor.call 'calendars.sync', event.calendarId,
						(error) ->
							if error
								future.throw parseError error
							else
								future.return result
								
		future.wait()