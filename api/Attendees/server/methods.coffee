Meteor.methods


	# !!!
	# 	THE GOOGLE API EVENT.UPDATE WILL OVERWRITE CURRENT
	# 	ATTENDEES OF THIS EVENT. MAKE SURE TO ALWAYS INCLUDE
	# 	CURRENT ATTENDEES OF THE EVENT. (WILL BE DONE INSIDE
	# 	THIS METHOD CALL, CLIENTS NO NEED TO WORRY)
	# DESCRIPTION
	# 	Add attendees to an event.
	# PARAMETERS
	# 	{String} eventId
	# 	{[Object]} attendees
	# 		{String} email
	# 		{String}? displayName
	# 		{String}? responseStatus
	# REVIEW
	# 	Google API event.update can directly set an attendee's
	# 	status to accepted or any, do we accept invitations for
	# 	users automatically or do we put 'needsAction'?
	# 	Current strategy is 'needsAction'.
	# 	
	'attendees.add': (eventId, attendees) ->

		new SimpleSchema
			eventId: type: String
			attendees:
				type: [Object]
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
		.validate
			eventId: eventId
			attendees: attendees

		throwError credentialError if !@userId?

		_event = Events.findOne id: eventId
		throwError notFoundError if !_event?

		data =
			start: dateTime: _event.start.toISOString()
			end: dateTime: _event.end.toISOString()
		data.attendees = []
		data.attendees = _event.attendees if _event.attendees?
		for attendee in attendees
			found = false
			if _event.attendees?
				for _attendee in _event.attendees
					if attendee.email == _attendee.email
						found = true
						break
			data.attendees.push attendee if !found

		Meteor.call 'events.update', eventId, data

	# DESCRIPTION
	# 	Remove attendees to an event.
	# 	Similar to add.
	# PARAMETERS
	# 	{String} eventId
	# 	{[Object]} attendees
	# 		{String} email
	# 	
	'attendees.remove': (eventId, attendees) ->

		new SimpleSchema
			eventId: type: String
			attendees:
				type: [Object]
			'attendees.$.email':
				type: String
		.validate
			eventId: eventId
			attendees: attendees

		throwError credentialError if !@userId?

		_event = Events.findOne id: eventId
		throwError notFoundError if !_event?

		return if !_event.attendees?

		data =
			start: dateTime: _event.start.toISOString()
			end: dateTime: _event.end.toISOString()
		data.attendees = []
		for _attendee in _event.attendees
			found = false
			for attendee in attendees
				if attendee.email == _attendee.email
					found = true
					break
			data.attendees.push _attendee if !found

		Meteor.call 'events.update', eventId, data
