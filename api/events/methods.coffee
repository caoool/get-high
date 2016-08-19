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


	'events.insert.local': (event) ->

		new SimpleSchema
			summary: type: String
			description:
				type: String
				optional: true
			###*
			 * Both dateTime need to be in RFC3399 format
			 * @type {String}
			###
			start: type: String
			end: type: String
			location:
				type: String
				optional: true
			visibility:
				type: String
				allowedValues: [
					'public'
					'private'
				]
				defaultValue: 'private'
				optional: true
			school:
				type: String
			club:
				type: String
			tags:
				type: [String]
				optional: true
			localAttendees:
				type: [Object]
				optional: true
			'localAttendees.$.phoneNumber':
				type: String
			'localAttendees.$.displayName':
				type: String
				optional: true
			'localAttendees.$.responseStatus':
				type: String
				allowedValues: [
					'needsAction'
					'declined'
					'tentative'
					'accepted'
				]
				defaultValue: 'needsAction'
			'localAttendees.$.userId':
				type: String
				optional: true
		.validate event

		throwError credentialError if !@userId?

		event.source = 'ShoutOut'

		Events.insert event


	'events.update.local': (_id, event) ->

		new SimpleSchema
			summary:
				type: String
				optional: true
			description:
				type: String
				optional: true
			###*
			 * Both dateTime need to be in RFC3399 format
			 * @type {String}
			###
			start:
				type: String
				optional: true
			end:
				type: String
				optional: true
			location:
				type: String
				optional: true
			visibility:
				type: String
				allowedValues: [
					'public'
					'private'
				]
				optional: true
			school:
				type: String
				optional: true
			club:
				type: String
				optional: true
			tags:
				type: [String]
				optional: true
			localAttendees:
				type: [Object]
				optional: true
			'localAttendees.$.phoneNumber':
				type: String
			'localAttendees.$.displayName':
				type: String
				optional: true
			'localAttendees.$.responseStatus':
				type: String
				allowedValues: [
					'needsAction'
					'declined'
					'tentative'
					'accepted'
				]
				defaultValue: 'needsAction'
			'localAttendees.$.userId':
				type: String
				optional: true
		.validate event

		throwError credentialError if !@userId?

		Events.update _id, $set: event

		
	'events.delete.local': (_id) ->

		new SimpleSchema
			_id: type: String
		.validate _id: _id

		throwError credentialError if !@userId?

		Events.remove _id


	'events.setVisibility.local': (_id, visibility='private') ->

		new SimpleSchema
			_id: type: String
			visibility:
				type: String
				allowedValues: [
					'public'
					'private'
				]
		.validate
			_id: _id
			visibility: visibility

		throwError credentialError if !@userId?

		Events.update _id, $set: visibility: visibility