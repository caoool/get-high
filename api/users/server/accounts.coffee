Accounts.onLogin ->
	# Logs.log Meteor.user().services.google.accessToken

# DESCRIPTIONS
# 	TASKS
# 	-> Create default user profile
# 	-> Add new user to usersList
# TODO:
# 	Implement new user validation
Accounts.onCreateUser (options, user) ->
	user.profile =
		name: user.services.google.name
		picture: user.services.google.picture
		tags: []
		excludedClubs: []
	usersListEntry =
		userId: user._id
		name: user.services.google.name
		picture: user.services.google.picture
		googleEmail: user.services.google.email
	UsersList.insert usersListEntry
	user