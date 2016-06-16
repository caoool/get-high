Meteor.methods
	'events.setTags': (eventId, tags) ->
		Events.update {id: eventId},
			$set:
				tags: tags
