Meteor.publish 'events.admin', ->
	Events.find()

Meteor.publish 'events.owner', ->
	return @ready() if !@userId?
	Events.find
		createdBy: @userId
		end:
			$gte: fromDate()

# DESCRIPTION
#   Return all events within user's school scope.
Meteor.publish 'events.school', (school=null) ->
	if !school?
		return @ready() if !@userId?
		Events.find
			school: Meteor.user().profile.school
			end:
				$gt: fromDate()
	else
		Events.find
			school: school
			end:
				$gte: fromDate()

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
					end:
						$gte: fromDate()
				]
			options =
				$sort: start: -1
			Events.find query
		children: [
			find: (event) ->
				UsersList.find userId: event.createdBy
		]

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