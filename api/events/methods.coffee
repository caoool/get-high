Meteor.methods


	'events.setTags': (eventId, tags=null) ->

		new SimpleSchema
			eventId: type: String
			tags: type: [String]
		.validate
			eventId: eventId
			tags: tags

		throwError credentialError if !@userId?

		Events.update {id: eventId},
			$set:
				tags: tags
