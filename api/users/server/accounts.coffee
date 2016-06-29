Accounts.onLogin ->
	# Logs.log Meteor.user().services.google.accessToken

# TODO:
# 	Implement new user validation
Accounts.onCreateUser (options, user) ->
	Logs.log 'Creating new user'
	user.profile =
		tags: []
		excludedClubs: []
	user