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

	# Link user account if already a logged in user
	if Meteor.userId()?
		if user.services.facebook?
			Meteor.users.update Meteor.userId(),
				$set:
					'services.facebook': user.services.facebook
		if user.services.google?
			Meteor.users.update Meteor.userId(),
				$set:
					'services.google': user.services.google
		return

	user.profile =
			tags: []
			excludedClubs: []
	usersListEntry =
			userId: user._id

	if user.services.google?
		pictureRequest = request.getSync user.services.google.picture, encoding: null
		buffer = new Buffer pictureRequest.body
		picture = 'data:image/jpeg;base64,' + buffer.toString 'base64'

		user.profile.name = user.services.google.name
		user.profile.picture = picture
		usersListEntry.name = user.services.google.name
		usersListEntry.picture = picture
		usersListEntry.googleEmail = user.services.google.email

	if user.services.facebook?
		user.profile.name = user.services.facebook.name
		usersListEntry.name = user.services.facebook.name
		usersListEntry.facebookEmail = user.services.facebook.email
	
	UsersList.insert usersListEntry

	user