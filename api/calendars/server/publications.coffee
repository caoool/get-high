Meteor.publish 'calendars.admin', ->
	Calendars.find()

Meteor.publish 'calendars.user', ->
	return @ready() if !@userId?
	Calendars.find createdBy: @userId