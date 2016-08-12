Meteor.methods


	'notifications.test': ->

		return 'Not logged in' if !@userId?

		Push.send
			from: 'Test'
			title: 'Hello'
			text: 'World'
			badge: 12
			query: userId: @userId