Meteor.methods


	'calendars.setTags': (calendarId, tags) ->

		new SimpleSchema
			calendarId: type: String
			tags: type: [String]
		.validate
			calendarId: calendarId
			tags: tags
			
		Calendars.update {id: calendarId},
			$set:
				tags: tags
