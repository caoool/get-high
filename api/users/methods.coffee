Meteor.methods
	'users.setSchool': (user_id, school) ->
		return if !user_id? or !school?
		Meteor.users.update user_id, $set: profile: school: school