Meteor.publish 'users.current', (id) ->
	Meteor.users.find id,
		fields:
			'services.google.given_name': 1
			'services.google.picture': 1
			'services.google.accessToken': 1
