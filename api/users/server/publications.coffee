Meteor.publish 'users.current', (user_id) ->
	Meteor.users.find user_id,
		profile: 1
		fields:
			'services.google.name': 1
			'services.google.picture': 1
			'services.google.accessToken': 1
			'services.facebook.name': 1
