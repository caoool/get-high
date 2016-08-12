Meteor.methods


	'notifications.updateToken': (token) ->

		return 'Not logged in' if !@userId?

		Meteor.call 'raix:push-update',
			token: apn: token
			appName: 'ShoutIt'
			userId: @userId