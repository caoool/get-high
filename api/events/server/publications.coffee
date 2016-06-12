Meteor.publish 'events.admin', ->
	Events.find()

Meteor.publish 'events.user', ->
	return @ready() if !@userId?
	Events.find createdBy: @userId