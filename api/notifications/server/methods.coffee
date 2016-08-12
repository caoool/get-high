Meteor.methods


	'notifications.test': ->

		return 'Not logged in' if !@userId?

		Push.send
			from: 'ShoutIt'
			title: 'Hello'
			text: 'World'
			badge: 12
			query: userId: @userId


	# DESCRIPTION
	# 	Send push notification to a specific user.
	# PARAMETERS
	# 	{Object}
	# 		{String} from
	# 		{String} title
	# 		{String} text
	# 		{Integer}? badge
	# 		{Object} query
	# 			{String} userId
	# 			
	'notifications.send.user': (notification) ->

		new SimpleSchema
			from: type: String
			title: type: String
			text: type: String
			badge:
				type: Number
				optional: true
			'query.userId': type: String
		.validate notification

		Push.send notification