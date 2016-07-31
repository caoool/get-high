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

		event = Events.findOne id: eventId
		if event? and event.attendees?
			for attendee, index in event.attendees
				user = UsersList.findOne googleEmail: attendee.email
				if user?
					event.attendees[index].userId = user.userId
					event.attendees[index].picture = user.picture
			event.attendees

	# DESCRIPTION
	# 	Add a dbAttendee with phone number to a given Event
	# 	Id.
	# REVIEW
	# 	It does not need external APIs so it will work on
	# 	both clients and server. That's why it locates outside
	# 	of server folder.
	# 	
	'attendees.localAdd': (eventId, attendee) ->

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
		attendee.userId = user.userId if user?
		attendee.responseStatus = 'needsAction' if !attendee.responseStatus?

		Events.update {id: eventId}, $push: localAttendees: attendee

	# DESCRIPTION
	# 	Remove a local attendee with phone number to a given Event
	# 	Id.
	# REVIEW
	# 	It does not need external APIs so it will work on
	# 	both clients and server. That's why it locates outside
	# 	of server folder.
	# 	
	'attendees.localRemove': (eventId, phoneNumber) ->

		new SimpleSchema
			eventId: type: String
			phoneNumber: type: String
		.validate
			eventId: eventId
			phoneNumber: phoneNumber

		throwError credentialError if !@userId?

		Events.update {id: eventId},
			$pull: localAttendees: phoneNumber: phoneNumber

	# DESCRIPTION
	# 	Let local user with a phone number to accept an
	# 	event.
	# 	
	'attendees.localAccept': (eventId) ->
		new SimpleSchema
			eventId: type: String
		.validate
			eventId: eventId

		throwError credentialError if !@userId?

		user = UsersList.findOne userId: @userId
		if user? and user.phoneNumber?
			Events.update
				id: eventId
				'localAttendees.phoneNumber': user.phoneNumber
			, $set:
				'localAttendees.$.responseStatus': 'accepted'

	# DESCRIPTION
	# 	Let local user with a phone number to decline an
	# 	event.
	# 	
	'attendees.localDecline': (eventId) ->
		new SimpleSchema
			eventId: type: String
		.validate
			eventId: eventId

		throwError credentialError if !@userId?

		user = UsersList.findOne userId: @userId
		if user? and user.phoneNumber?
			Events.update
				id: eventId
				'localAttendees.phoneNumber': user.phoneNumber
			, $set:
				'localAttendees.$.responseStatus': 'declined'


