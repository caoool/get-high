Meteor.publish 'calendars.admin', ->
	Calendars.find()

Meteor.publish 'calendars.owner', ->
	return @ready() if !@userId?
	Calendars.find createdBy: @userId

# DESCRIPTION
#   Return all calendars (clubs) within user's school scope.
Meteor.publish 'calendars.school', ->
	return @ready() if !@userId?
	user = Meteor.users.findOne @userId
	Calendars.find school: user.profile.school

# DESCRIPTION
#   Return only calendars user is following, without
#   the ones that are in user's excluded clubs list
Meteor.publish 'calendars.feeds', ->
	return @ready() if !@userId?
	user = Meteor.users.findOne @userId
	Calendars.find
		$and: [
			school: user.profile.school
			id: $nin: user.profile.excludedClubs
		]