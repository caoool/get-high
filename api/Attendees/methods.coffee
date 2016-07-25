Meteor.methods


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