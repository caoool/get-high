@throwError = (error=null) ->
	meteorError = parseError error
	if Meteor.isClient
		meteorError
	else if Meteor.isServer
		throw meteorError

@parseError = (error=null) ->
	if !error?
		meteorError = new Meteor.Error 500, 'Undefined Error', 'Cannot parse error information.'
	else
		meteorError = new Meteor.Error error

@credentialError = ->
	meteorError = new Meteor.Error 401, 'Not logged in', 'User credential required.'