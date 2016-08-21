Meteor.methods


	# DESCRIPTION
	# 	Return a preprocessed array of attendees of a certain
	# 	event, including fields of userId and picture if the
	# 	email address has registered our app before.
	# 	
	'attendees.get': (eventId) ->

		new SimpleSchema
			eventId: type: String
		.validate
			eventId: eventId

		throwError credentialError if !@userId?

		event = Events.findOne _id: eventId
		if event? and event.attendees?
			for attendee, index in event.attendees
				user = UsersList.findOne googleEmail: attendee.email
				if user?
					event.attendees[index].userId = user.userId
					event.attendees[index].picture = user.picture
			if event.localAttendees? and event.localAttendees.length > 0
				event.attendees.concat event.localAttendees
			else
				event.attendees

	# DESCRIPTION
	# 	Add a dbAttendee with phone number to a given Event
	# 	Id.
	# REVIEW
	# 	It does not need external APIs so it will work on
	# 	both clients and server. That's why it locates outside
	# 	of server folder.
	# 	
	'attendees.add.local': (eventId, attendee) ->

		new SimpleSchema
			phoneNumber: type: String
			displayName:
				type: String
				optional: true
			responseStatus:
				type: String
				optional: true
		.validate attendee

		throwError credentialError if !@userId?

		user = UsersList.findOne phoneNumber: attendee.phoneNumber
		attendee.userId = user.userId if user? and user.userId?
		attendee.responseStatus = 'needsAction' if !attendee.responseStatus?

		Events.update eventId, $push: localAttendees: attendee

	# DESCRIPTION
	# 	Remove a local attendee with phone number to a given Event
	# 	Id.
	# REVIEW
	# 	It does not need external APIs so it will work on
	# 	both clients and server. That's why it locates outside
	# 	of server folder.
	# 	
	'attendees.remove.local': (eventId, phoneNumber) ->

		new SimpleSchema
			eventId: type: String
			phoneNumber: type: String
		.validate
			eventId: eventId
			phoneNumber: phoneNumber

		throwError credentialError if !@userId?

		Events.update eventId,
			$pull: localAttendees: phoneNumber: phoneNumber

	# DESCRIPTION
	# 	Let local user with a phone number to accept an
	# 	event.
	# 	
	'attendees.accept.local': (eventId) ->
		new SimpleSchema
			eventId: type: String
		.validate
			eventId: eventId

		throwError credentialError if !@userId?

		user = UsersList.findOne userId: @userId
		if user? and user.phoneNumber?
			Events.update
				_id: eventId
				'localAttendees.phoneNumber': user.phoneNumber
			, $set:
				'localAttendees.$.responseStatus': 'accepted'

	# DESCRIPTION
	# 	Let local user with a phone number to decline an
	# 	event.
	# 	
	'attendees.decline.local': (eventId) ->
		new SimpleSchema
			eventId: type: String
		.validate
			eventId: eventId

		throwError credentialError if !@userId?

		user = UsersList.findOne userId: @userId
		if user? and user.phoneNumber?
			Events.update
				_id: eventId
				'localAttendees.phoneNumber': user.phoneNumber
			, $set:
				'localAttendees.$.responseStatus': 'declined'

	# DESCRIPTION
	# 	Update local attendees to re check each attendee's 
	# 	VZ profile.
	# REVIEW
	# 	Should later be called in events sync or calendar
	# 	sync methods, or somewhere related like when insert
	# 	new item to UsersList. Should be transparent later
	# 	to the clients.
	'attendees.update.local': (eventId) ->
		new SimpleSchema
			eventId: type: String
		.validate
			eventId: eventId

		throwError credentialError if !@userId?

		event = Events.findOne _id: eventId

		if event? and event.localAttendees?
			for attendee in event.localAttendees
				user = UsersList.findOne phoneNumber: attendee.phoneNumber
				if user?
					Events.update
						_id: eventId
						'localAttendees.phoneNumber': user.phoneNumber
					, $set:
						'localAttendees.$.userId': user.userId
				else
					Events.update
						_id: eventId
						'localAttendees.phoneNumber': attendee.phoneNumber
					, $unset:
						'localAttendees.$.userId': 1
						'localAttendees.$.displayName': 1
