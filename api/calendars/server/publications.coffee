Meteor.publish 'calendars.admin', ->
		Calendars.find()

Meteor.publish 'calendars.user', (userId) ->
		Calendars.find createdBy: userId