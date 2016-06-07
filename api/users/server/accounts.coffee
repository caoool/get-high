Accounts.onLogin ->
	# Logs.log Meteor.user().services.google.accessToken

Accounts.onCreateUser (options, user) ->
	Logs.log 'Creating new user'
	user