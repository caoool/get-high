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

