Meteor.publish 'calendars.admin', ->
	Calendars.find()