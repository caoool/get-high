{ request } = require 'meteor/froatsnook:request'

Accounts.onLogin ->
	# Logs.log Meteor.user().services.google.accessToken


# DESCRIPTIONS
# 	TASKS
# 	-> Create default user profile
# 	-> Add new user to usersList
# TODO:
# 	Implement new user validation
# 	
Accounts.onCreateUser (options, user) ->

	pictureRequest = request.getSync user.services.google.picture, encoding: null
	buffer = new Buffer pictureRequest.body
	picture = 'data:image/jpeg;base64,' + buffer.toString 'base64'

	user.profile =
		name: user.services.google.name
		picture: picture
		tags: []
		excludedClubs: []

	usersListEntry =
		userId: user._id
		name: user.services.google.name
		picture: picture
		googleEmail: user.services.google.email
	UsersList.insert usersListEntry

	user