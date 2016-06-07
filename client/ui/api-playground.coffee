Template.apiPlayground.onCreated ->
	@subscribe 'users.current', Meteor.userId()

Template.apiPlayground.events
	'click #logout': (e) ->
		Meteor.logout (error) ->
			if error then throw new (Meteor.Error)('Logout failed')

	'click #google-login': (e) ->
		Meteor.loginWithGoogle 
			requestPermissions: ['https://www.googleapis.com/auth/calendar']
			requestOfflineToken: true
		, (error) ->
			if error
				console.log error
			else
				console.log 'logged in'

	'click #connectionTestButton': (e) ->
		Meteor.call 'conn.test', (error, result) ->

	'click #getCalendarListButton': (e) ->
		Meteor.call 'calendars.list', (error, result) ->
			if error then console.log error
			else console.log result