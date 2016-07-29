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
			###*
			 * Both dateTime need to be in RFC3399 format
			 * @type {String}
			###
			'start.dateTime': type: String
			'end.dateTime': type: String
			location:
				type: String
				optional: true
			visibility:
				type: String
				allowedValues: [
					'default'
					'public'
					'private'
					'confidential'
				]
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
					Meteor.call 'calendars.sync',
						calendarId,
						@userId,
						(error) ->
							if error
								future.throw parseError error
							else
								future.return result

		future.wait()


	# DESCRIPTION:
	# 	Update an event. A sync is followed by method
	# 	call to make sure local db is up to date.
	# PARAMETERS:
	# 	{String} eventId
	# 	{Object} event
	# 		{String} summary
	# 		{String}? description
	# 		{Date} start.dateTime (format RFC3399)
	# 		{Date} end.dateTime (format RFC3399)
	# 		{String}? location
	# 		{String}? visibility
	# RETURN:
	#   Does not matter
	'events.update': (eventId, event) ->

		new SimpleSchema
			summary:
				type: String
				optional: true
			description:
				type: String
				optional: true
			###*
			 * Both dateTime need to be in RFC3399 format
			 * @type {String}
			###
			'start.dateTime':
				type: String
				optional: true
			'end.dateTime':
				type: String
				optional: true
			location:
				type: String
				optional: true
			visibility:
				type: String
				allowedValues: [
					'default'
					'public'
					'private'
					'confidential'
				]
				optional: true
			attendees:
				type: [Object]
				optional: true
			'attendees.$.email':
				type: String
			'attendees.$.displayName':
				type: String
				optional: true
			'attendees.$.responseStatus':
				type: String
				optional: true
				allowedValues: [
					'needsAction'
					'declined'
					'tentative'
					'accepted'
				]
		.validate event

		future = new Future()
		future.throw credentialError if !@userId?

		_event = Events.findOne id: eventId
		future.throw notFoundError if !_event?

		data = 
			summary: _event.summary
			start: dateTime: _event.start
			end: dateTime: _event.end
			visibility: _event.visibility
		if event.summary? and event.summary?.length
			data.summary = event.summary
		if event.description?
			data.description = event.description
		if event.location?
			data.location = event.location
		if event.start? and event.start.dateTime? and event.start.dateTime?.length
			data.start.dateTime = event.start.dateTime
		if event.end? and event.end.dateTime? and event.end.dateTime?.length
			data.end.dateTime = event.end.dateTime
		if event.visibility?
			data.visibility = event.visibility
		if event.attendees?
			data.attendees = event.attendees
		url = "/calendar/v3/calendars/#{_event.calendarId}/events/#{eventId}"
		user = Meteor.users.findOne _event.createdBy
		options = 
			data: data
			user: user

		GoogleApi.put url, options,
			(error, result) ->
				if error
					future.throw parseError error
				else
					future.return Meteor.call 'calendars.sync',
						_event.calendarId,
						_event.createdBy
								
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