@throwError = (error=null) ->
	if Meteor.isClient
		error
	else if Meteor.isServer
		throw new Meteor.Error error