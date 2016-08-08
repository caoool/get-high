Meteor.publish 'events.admin', ->
	Events.find()

Meteor.publish 'events.owner', ->
	return @ready() if !@userId?
	Events.find createdBy: @userId

# DESCRIPTION
#   Return all events within user's school scope.
Meteor.publish 'events.school', ->
	return @ready() if !@userId?
	user = Meteor.users.findOne @userId
	Events.find school: user.profile.school

# DESCRIPTION
#   Return only events that intersect the user's
#   tags and visibility is public or default.
# RETURN
#   {Object} qualified events in descending order
# REVIEW
#   'default' visibility can be hidden by default
#   due to future requirements.
Meteor.publishComposite 'events.feeds', ->
	return @ready() if !@userId?
	user = Meteor.users.findOne @userId
	ret =
		find: ->
			query =
				$and: [
					school: user.profile.school
					tags: $in: user.profile.tags
					visibility: $in: ['public']
				]
			options =
				$sort: start: -1
			Events.find query
		children: [
			find: (event) ->
				UsersList.find userId: event.createdBy
		]
	
	# Events.find {
	# 	$and: [
	# 		school: user.profile.school
	# 		tags: $in: user.profile.tags
	# 		visibility: $in: ['public']
	# 	]},
	# 	$sort: start: -1

# DESCRIPTION
# 	Return only user liked events.
# RETURN
# 	{Object} qualified events in descending order
Meteor.publish 'events.likes', ->
	return @ready() if !@userId?
	user = Meteor.users.findOne @userId
	Events.find
		id: $in: user.profile.likes,
		$sort: start: -1