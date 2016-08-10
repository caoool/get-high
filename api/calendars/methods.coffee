Meteor.methods


	'calendars.imported': ->
		
		throwError credentialError if !@userId?

		Calendars.find
			createdBy: @userId
		.fetch()


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
