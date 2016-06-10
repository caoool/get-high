Accounts.onLogin ->
	# Logs.log Meteor.user().services.google.accessToken

# TODO:
# 	Implement new user validation
# 	-> Check user google scope
# 	-> Check google offlineToken
Accounts.onCreateUser (options, user) ->
	Logs.log 'Creating new user'
	user