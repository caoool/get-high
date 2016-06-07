@throwError = (error = null, reason = null, details = null) ->
	meteorError = new Meteor.Error error, reason, details
	if Meteor.isClient then meteorError
	else if Meteor.isServer then throw meteorError