Meteor.publish 'tags.school', (school) ->
	Tags.find school: school