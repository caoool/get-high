Meteor.publish 'events.admin', ->
	Events.find()

Meteor.publish 'events.user', (userId) ->
	Events.find createdBy: userId