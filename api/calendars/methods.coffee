Meteor.methods
	'calendars.setTags': (calendarId, tags) ->
		Calendars.update {id: calendarId},
			$set:
				tags: tags
