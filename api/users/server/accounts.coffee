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

	pictureRequest = HTTP.get user.services.google.picture
	buffer = new Buffer pictureRequest.content, 'binary'
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